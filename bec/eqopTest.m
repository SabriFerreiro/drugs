clear notrap hmtrap box

notrap.name = 'no trap';
notrap.a.gamma = 1;
notrap.a.N = 1;
notrap.points = [49 70];
notrap.ranges = [10 nan];
notrap.steps = 30;
notrap = trap(notrap);

% watch out: the large potential, combined with XSPDE's invisible extrapolation, can give bizarre results when the fine grid has converged but the coarse one is unstable.

box.name = 'unit length box';
box.a.g = 0;
box.a.K = @(r) 1e3*(abs(r.x)>1/2);
box.a.N = 1;
box.points = [49 70];
box.ranges = [10 2];
box.steps = 60;
box = trap(box);

hmtrap.name = 'harmonic with l_0 = 1';
hmtrap.a.g = 0;
hmtrap.a.K = @(r) r.x.^2;
hmtrap.a.N = 1;
hmtrap.points = [49 70];
hmtrap.ranges = [10 20];
hmtrap.steps = 30;
hmtrap = trap(hmtrap);

notrap = eqop(notrap, 'debug');

hmtrap = eqop(hmtrap, 'debug');

box = eqop(box, 'debug');

%% potential energy is small in a box

assert(abs(box.a.K - 0) < 10);

%% kinetic energy for the box ground state

assert(abs(box.a.T - pi^2) < 1)

%% potential energy for harmonic

assert(abs(hmtrap.a.K - 0.5) < 1e-3);

%% kinetic energy for harmonic

assert(abs(hmtrap.a.T - 0.5) < 1e-3);
