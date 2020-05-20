clear; %clear stored values in workspace
clc

%load text file and call smart regression function
A = load('test1.txt');
X = A(:,1);
Y = A(:,2);

smartRegression(X, Y);