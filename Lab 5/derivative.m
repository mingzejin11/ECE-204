function derivative(X, Y)

p = input("Select which point to perform derivative at: ");

inX = false;
equalSpc = true;
loc = 0;

sizex = size(X);

%check if point within x bounds
if(p < X(1) || p > X(sizex(1)-1))
    disp("Error, the point is outside the range");
    return;
end

%check if the point is in the data
for i = 1:size(X)
    if p == X(i)
        inX = true;
        loc = i;
    end
    
end

%check if equal spacing
for i = 2:size(X)-1
      if (X(i) - X(i-1)) ~= (X(i+1) - X(i))
        equalSpc = false;
      end
end

if((loc == 1) | (loc == size(X)-1))
    equalSpc = false;
end

%if equal spacing and point in dataset calculate using CDD
if(equalSpc && inX)
        h = X(loc) - X(loc-1);
     
    %calculate using CDD
    derivative = (Y(loc+1) - Y(loc-1))/(2*h);
    disp("Answer: " + derivative);

    %otherwise do regression
else
    
%find the smallest spacing between points  
smallestSpc = 100000;
for i = 1:size(X)-1
    if smallestSpc > X(i+1) - X(i)
        smallestSpc = X(i+1) - X(i);
    end
end
    degree = 1;
    r2cur = 0.1;
    r2prev = 0;
    
    %continue increasing polynomial order until change in degree is < 0.01
    while(abs(r2cur - r2prev) > 0.01)
    degree = degree+1;
    M = zeros(degree+1, degree+1);
    B = zeros(degree+1,1);
    
    P = zeros(2*degree + 1, 1);
    k = 0:degree;
    
    for i = 1:(2*degree+1) %calculate the x^i up to twice the degree-1
        P(i) = double(sum(X.^(i-1)));
    end
    
    for i = 1:degree+1 %put the powers of x into the original matrix
        M(i,:) = P((i):(i+degree));
    end
    
    for i = 0:degree %calculate the B matrix (Y*x^i)
        B(i+1) = double(sum(Y.*(X.^i))); 
    end

    %solve the equations to get the coefficient matrix
    Coeffs = inv(M)*B;

    XPows = X.^k;
    YSol = XPows*Coeffs;
    n = M(1);
    
    %calculate the R^2
    St = sum((Y - B(1)/n).^2);
    Sr = sum((Y - YSol).^2);
    r2prev = r2cur;
    r2cur = (St-Sr)/St;
    r2 = (St-Sr)/St;
    end
    
    syms f(x)
    f(x) = double(Coeffs(1));
    for i = 1:degree
        f(x) = f(x) + double(Coeffs(i+1))*(x^i);
    end
    
    %create function and display it
    fprintf('Y = ');
    fprintf('%f ', Coeffs(1));
    for i = 1:degree
        fprintf('+ %f*x^%i', Coeffs(i+1), i);
    end
    fprintf('\n');
    disp("R^2 = " + r2);
    
    %plot the function
    fplot(f);
    hold on
    scatter(X, Y);
    title("Order of the polynomial: " + degree + '   ' + "R^2 = " + r2);
    hold off
    
    %calculate the derivative using CDD from regression function
    a = double(f(p+smallestSpc));
    b = double(f(p-smallestSpc));
    
    regDerivative = (a - b)/(2*smallestSpc);
    disp("Answer: " + regDerivative(1));
end

end
        

    
    
    


    