% Hartree orbitals in the trap plane

% Spectral matrix from Program 8 of 2000-Trefethen-Spectral

prinax, [x, y, z, K] = loadk(0, U, r0);
x = x(26:end-25);  K = K(26:end-25, :, :);

% interpolate through lowest 3 points along y to find trap bottom
[~,j0] = min(K, [], 2);  j0 = repmat(j0, [1,3,1]);  d = size(j0);
[i,j,k] = ndgrid(1:d(1), 1:d(2), 1:d(3));
K3 = K(sub2ind(size(K), i(:), j(:)+j0(:), k(:)));  K3 = reshape(K3,d);
K2 = K3(:,2,:) + (K3(:,1,:)-K3(:,3,:)).^2/8./(2*K3(:,2,:)-K3(:,1,:)-K3(:,3,:));
K2 = squeeze(K2);

function D2=ssd(N,L)		% spectral second derivative
	h = 2*pi./N;  L = L*N/(N-1);	% adjust to periodic grid
	column = [-pi^2/(3*h^2)-1/6 ...
		-0.5*(-1).^(1:N-1)./sin(h*(1:N-1)/2).^2];
	D2 = (pi/L)^2*toeplitz(column);
endfunction

dxx = ssd(length(x), range(x)/2);  Dxx = kron(eye(length(z)), dxx);
dzz = ssd(length(z), range(z)/2);  Dzz = kron(dzz, eye(length(x)));
LAP = Dxx + Dzz;
q = zeros(numel(K2(:)), 5);
for l = 2:5
	HAM = 0.5*(-LAP+diag(K2(:)+0.283*abs(q(:,l-1)).^2));
	[Q, ks] = eig(HAM);
	[k,i] = min(diag(ks));
	q(:,l) = sqrt(7000)*Q(:,i);
endfor

figure
for l = 1:5
	subplot(1,5,l), zplot(x,z,q(:,l)), hold on
	contour(x, z, squeeze(K2).', (0:0.1:1).^2, '-w')
endfor
title 'Too wide on x due to pixelation, interpolate'