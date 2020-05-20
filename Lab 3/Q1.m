clear; %clear stored values in workspace
clc

%define symbols and equations
syms x y
f = 4*x^2 + y^2-13;
g = x^2+y^2-10;

h = 2*x-y-exp(-x);
k = -x+2*y-exp(-y);

X = [1, 1]; %initial guess
W = [x, y];%symbols matrix

A = [f, g]; %matrix with fucntions
Q = [h, k];

fprintf('For f=');
disp(A);
newtonRaphson(A, X, W); %solution for first set of equations
fprintf('For f=');
disp(Q);
newtonRaphson(Q, X, W); %solution for second set of equations