clear; %clear stored values in workspace
clc

%load the desired text file
A = load('test2.txt');
X = A(:,1);
Y = A(:,2);

%prompt to select a regression type
select = input("Select the function to fit your data: \n 1.Linear: y = a0 + a1x \n 2.Polynomial: y = a0 + a1x + .. +amx^m \n 3.Exponential: y = ae^bx \n 4.Power: y = ax^b \n");

%call regression function with desired input
if select == 1
    regression(1, X, Y);
elseif select == 2
    regression(2, X, Y);
elseif select == 3
    regression(3, X, Y);
elseif select == 4
    regression(4, X, Y);
else
    disp("A valid number was not entered!");
end

%smartRegression(X, Y);