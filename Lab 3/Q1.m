clear; % Clear stored values in workspace
clc

% Define symbols and equations
syms x y
f = 4 * x^2 + y^2 - 13;
g = x^2 + y^2 - 10;

h = 2 * x - y - exp(-x);
k = -x + 2 * y - exp(-y);

X = [1, 1]; % Initial guess
W = [x, y]; % Symbols matrix
A = [f, g]; % Matrix with fucntions
Q = [h, k];

fprintf('For f=');
disp(A);
newtonRaphson(A, X, W); % Solution for first set of equations
fprintf('For f=');
disp(Q);
newtonRaphson(Q, X, W); % Solution for second set of equations
