clear; %clear stored values in workspace
clc

%Values of constants
A = 3.9083e-3;
B = -5.775e-7;
C = -4.183e-12;

%get reistance
Value = "Enter the resistance: ";
R = input(Value);

%define symbols and equations
syms T
f = 100*(1 + A*T + B*T^2 +C*(T-100)*T^3) - R;
g = 100*(1 + A*T + B*T^2) - R;

%choose which equation to use depending on resistance entered
if(R <= 100)
    left = -200;
    right = 0;
    %evaluate using both bisection and newston raphson
    bisection(f, left, right, T);
    newtonOneV(f, -100, T);

    
else
    left = 0;
    right = 850;
    %evaluate using both bisection and newton raphson
    bisection(g, left, right, T);
    newtonOneV(g, 425, T);
end