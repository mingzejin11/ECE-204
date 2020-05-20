function regression(number, X, Y)

%%%%%%%%%%%%%%%%%%%%%   Linear   %%%%%%%%%%%%%%%%%%%
if(number == 1)
    %get the sums, products and square of the values
    SumX = double(sum(X));
    SumY = double(sum(Y));
    XY = double(sum(X.*Y));
    X2 = double(sum(X.^2));

    n = size(X,1);
    %calculate the coefficients
    a2 = (n*XY - SumX*SumY)/(n*X2 - (SumX)^2);
    a1 = SumY/n - a2*(SumX/n);
    
    %calculate the sum of residuals and r^2
    St = sum((Y - SumY/n).^2);
    Sr = sum((Y - a1 - a2.*X).^2);
    
    r2 = (St-Sr)/St;
    
    %create the fucntion and plot it
    syms f(x)
    f(x) = a1 + a2*x;
    fplot(f)
    hold on
    title("y = " + a1 + "+" + a2 + "x" + '   ' + "R^2 = " + r2);
    scatter(X,Y);
    hold off
    
    disp("R^2 = " + r2);
    disp("Y = " + a1 + "+" + a2 + "X"); 


%%%%%%%%%%%%%%%%%%%%%   Polynomial   %%%%%%%%%%%%%%%%%%%
elseif(number == 2)
    %get degree of polynomial
    degree = input("Enter the degree of polynomial ");
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
    
    %create function and display it
    fprintf('Y = ');
    fprintf('%f ', Coeffs(1));
    for i = 1:degree
        fprintf('+ %f*x^%i', Coeffs(i+1), i);
    end
    fprintf('\n');
    
    syms f(x)
    f(x) = double(Coeffs(1));
    for i = 1:degree
        f(x) = f(x) + double(Coeffs(i+1))*(x^i);
    end
    
   
    XPows = X.^k;
    YSol = XPows*Coeffs;
    n = M(1);
    
    %calculate the R^2
    St = sum((Y - B(1)/n).^2);
    Sr = sum((Y - YSol).^2);
    r2 = (St-Sr)/St;
    
    disp("R^2 = " + r2);
    %plot the function
    fplot(f);
    hold on
    scatter(X, Y);
    title("Order of the polynomial: " + degree + '   ' + "R^2 = " + r2);
    hold off

%%%%%%%%%%%%%%%%%%%%%   Exponential   %%%%%%%%%%%%%%%%%%%    
elseif (number == 3)
    
    removeZeroY = find(Y == 0);%remove any 0 values of Y
    for i = 1:size(removeZeroY)
        disp("Warning: log(0) DNE, point " + i + " will be ignored");
        X(removeZeroY(i)) = [];
        Y(removeZeroY(i)) = [];
    end
    
    %calculate required values
    sumX = sum(X);
    sumY = sum(Y);
    lnY = sum(log(Y));
    xlnY = sum(X.*log(Y));
    X2 = sum(X.^2);
    n = size(X,1);
    
    %calculate coefficients
    a1 = (n*xlnY - lnY*sumX)/(n*X2 - sumX^2);
    a0 = lnY/n - a1*(sumX/n);
    
    %calculate r^2 value
    St = sum((Y - sumY/n).^2);
    Sr = sum((Y - (exp(a0))*exp((a1.*X))).^2);
    R2 = (St-Sr)/St;
    
    %create function and plot it
    syms f(x)
    f(x) = exp(a0)*exp(a1*x);
    fplot(f);
    hold on
    title("y = " + exp(a0) + "*" + "e" + "\^" + a1 + "x   R^2 = " + R2);
    scatter(X,Y);
    hold off
    
    disp("R^2 = " + R2);
    disp("Y = " + exp(a0) + "*" + "e" + "^" + a1 + "x");

%%%%%%%%%%%%%%%%%%%%%   Power   %%%%%%%%%%%%%%%%%%%
elseif (number == 4)
    removeZeroX = find(X == 0);%remove any 0 vaules of X
    for i = 1:size(removeZeroX)
        disp("Warning: log(0) DNE, point " + i + " will be ignored");
        X(removeZeroX(i)) = [];
        Y(removeZeroX(i)) = [];
    end
    
    removeZeroY = find(Y == 0);%remove any 0 values of Y
    for i = 1:size(removeZeroY)
        disp("Warning: log(0) DNE, point " + i + " will be ignored");
        X(removeZeroY(i)) = [];
        Y(removeZeroY(i)) = [];
    end
    
    %calculate required values
    sumX = double(sum(X));
    sumY = double(sum(Y));
    logX = double(sum(log10(X)));
    logY = double(sum(log10(Y)));
    XY = double(sum(log10(X).*log10(Y)));
    X2 = double(sum(log10(X).^2));
    n = size(X,1);
    
    %calculate coefficients
    a1 = double((n*XY - logX*logY)/(n*X2 - logX^2));
    a0 = double(logY/n - a1*(logX/n));
    
    YSol = (10^a0).*(X.^a1);
        
    %calculate R^2 value
    St = sum((Y - sumY/n).^2);
    Sr = sum((Y - YSol).^2);
    R2 = (St-Sr)/St;

    %create function and plot it
    syms f(x)
    f(x) = (10^a0)*(x^a1);
    fplot(f);
    hold on
    title("y = " + 10^(a0) + "x" + "\^" + (a1) + "   R^2 = " + R2);
    scatter(X,Y);
    hold off

    disp("R^2 = " + R2);
    disp("Y = " + 10^(a0) + "X" + "^" + (a1));

end

