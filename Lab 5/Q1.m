clear; %clear stored values in workspace
clc

%load text file
A = load('test1.txt');
X = A(:,1);
Y = A(:,2);

%choose to do integration or differentiation
selection = input("Select 1 for derivative, 2 for integral: ");
if selection == 1
    derivative(X, Y);
elseif selection == 2
    integral(X,Y);
else
    disp("Invalid selection");
end
