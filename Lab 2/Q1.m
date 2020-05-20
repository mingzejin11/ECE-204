clear; %clear stored values in workspace

A = load('A.txt'); %load the text files for matrix & vector B
B = load('B.txt');

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% USING MATRIX INVERSION %%%%%

Ainv = inv(A); %Get the inverse of the matrix
X = round(Ainv*B,3); %Solve for X 

disp("Using Matrix Inversion:");
disp(X);



%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% USING GAUSSIAN ELIMINATION %%%%%

C = [A, B]; %Concatenate the matrix A and B
R = round(rref(C), 3); %Perform gaussian elimination
disp("Using Gaussian Elimination:");
disp(R(:,7));%Display only the last column

N = A*1.05;
Q = [N, B]; %Concatenate the matrix N and B
Z = round(rref(Q), 3); %Perform gaussian elimination
disp("Using Gaussian Elimination for 5% increase:");
disp(Z(:,7));%Display only the last column




%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% USING LU FACTORIZATION %%%%%

[L, U] = lu(A); %Perform LU factorization to get L & U

F = round(U\(L\B), 3);
disp("Using LU factorization");
disp(F);


%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% USING GAUSS SEIDEL ITERATION %%%%%

%Error values
Err1 = 0.01;
Err2 = 0.005;
Err3 = 0.001;
Err4 = 0.0001;

%Conditions for each error value
done1 = false;
done2 = false;
done3 = false;
done4 = false;

numIterations = 0;

size = size(A);
n = size(1);

S = B*0; %Vector to hold guesses from iteration

%Loop until the error is less than 0.01%
while done4 == false 
    S_prev = S; %Save the previous results
    
    for i = 1:n %Loop n times (equal to number of equations)
        x = 0;
        for j = 1:i - 1 %For each variable, iterate up to the most recent guess 
                x = x + A(i, j) * S(j);
        end
        for j = i + 1:n %For the remaining variables, use the previous guess
                x = x + A(i,j) * S_prev(j);
        end
        S(i) = (1 / A(i, i)) * (B(i) - x); %Solve each equation to get the new guess
    end
    
    numIterations = numIterations+1; %increment number of iterations
    
    Error = [100 100 100 100 100 100]';
    
    for k = 1:n
        Error(n) = (S(n)-S_prev(n))/S(n); %Calculate the relative approximate error for each
    end
        
    %Iterate until the largerst error is less than the predefined values
    if(max(Error(n)) < Err1 && done1 == false)
            done1 = true;
            disp("For error < 1%):");
            disp("Number of iterations:" + numIterations); 
            disp(round(S,3));
    end
    
    if(max(Error(n)) < Err2 && done2 == false)
            done2 = true;
            disp("For error < 0.5%):");
            disp("Number of iterations:" + numIterations); 
            disp(round(S, 3));
    end
    
     if(max(Error(n)) < Err3 && done3 == false)
            done3 = true;
            disp("For error < 0.1%):");
            disp("Number of iterations:" + numIterations); 
            disp(round(S, 3));
    end
    
    
    if(max(Error(n)) < Err4)
            done4 = true;
            disp("For error < 0.01%):");
            disp("Number of iterations:" + numIterations); 
            disp(round(S, 3));
    end

    
    
end

        
        
    
    
    
