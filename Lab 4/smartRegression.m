function smartRegression(X, Y)

%%%%%%%%%%%%%%%%%%%%%   Linear   %%%%%%%%%%%%%%%%%%%
    %calculate required values
    SumX = double(sum(X));
    SumY = double(sum(Y));
    XY = double(sum(X.*Y));
    X2 = double(sum(X.^2));

    n = size(X,1);
    %calculate coefficients
    a2 = (n*XY - SumX*SumY)/(n*X2 - (SumX)^2);
    a1 = SumY/n - a2*(SumX/n);
    LinearCoeffs = [a1, a2];
    
    %calculate r^2
    St = sum((Y - SumY/n).^2);
    Sr = sum((Y - a1 - a2.*X).^2);
    LinearR2 = (St-Sr)/St;
    

%%%%%%%%%%%%%%%%%%%%%   Polynomial   %%%%%%%%%%%%%%%%%%%
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

        for i = 1:(2*degree+1) %calculate the sum of x^i up to twice the degree-1
            P(i) = double(sum(X.^(i-1)));
        end

        for i = 1:degree+1 %put the powers of x into the original matrix
            M(i,:) = P((i):(i+degree));
        end

        for i = 0:degree %calculate B matrix (Y*X^i)
            B(i+1) = double(sum(Y.*(X.^i))); 
        end
        
        %solve to get coefficients
        Coeffs = inv(M)*B;
        
        XPows = X.^k;
        YSol = XPows*Coeffs;

        n = M(1);
        
        %calculate r^2 value
        St = sum((Y - B(1)/n).^2);
        Sr = sum((Y - YSol).^2);
        r2prev = r2cur;
        r2cur = (St-Sr)/St;
    end
    
    %save the most recent r^2 value
    Polyr2 = r2cur;
    

%%%%%%%%%%%%%%%%%%%%%   Exponential   %%%%%%%%%%%%%%%%%%% 
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
    
    %calculate coeffs
    a1 = (n*xlnY - lnY*sumX)/(n*X2 - sumX^2);
    a0 = lnY/n - a1*(sumX/n);
    
    ExpCoeffs = [a0, a1];
    
    %calculate r^2
    St = sum((Y - sumY/n).^2);
    Sr = sum((Y - (exp(a0))*exp((a1.*X))).^2);
    ExpR2 = (St-Sr)/St;
    

%%%%%%%%%%%%%%%%%%%%%   Power   %%%%%%%%%%%%%%%%%%%
    removeZeroX = find(X == 0);%remove any 0 vaules of X
    for i = 1:size(removeZeroX)
        X(removeZeroX(i)) = [];
        Y(removeZeroX(i)) = [];
    end
    
    removeZeroY = find(Y == 0);%remove any 0 values of Y
    for i = 1:size(removeZeroY)
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
    
    %calculate coeffs
    a1 = double((n*XY - logX*logY)/(n*X2 - logX^2));
    a0 = double(logY/n - a1*(logX/n));
    PowerCoeffs = [a0, a1];
    
    %calculate r^2
    YSol = (10^a0).*(X.^a1);
    St = sum((Y - sumY/n).^2);
    Sr = sum((Y - YSol).^2);
    PowerR2 = (St-Sr)/St;
    
    
    n = [LinearR2, Polyr2, ExpR2, PowerR2];
%compare the r^2 for each regression type and choose the largest (best fit)
    if max(n) == LinearR2
        %plot linear if its the best
        disp("Linear is the best fit");
        syms f(x)
        f(x) = LinearCoeffs(1) + LinearCoeffs(2)*x;
        fplot(f)
        hold on
        title("y = " + LinearCoeffs(1) + "+" + LinearCoeffs(2) + "x" + '   ' + "R^2 = " + LinearR2);
        scatter(X,Y);
        hold off

        disp("R^2 = " + LinearR2);
        disp("Y = " + LinearCoeffs(1) + "+" + LinearCoeffs(2) + "X");
        
    elseif max(n) == Polyr2
        %plot polynomial if its the best
        disp("Polynomial is the best fit");
        syms Pf(x)
        Pf(x) = double(Coeffs(1));
        for i = 1:degree
            Pf(x) = Pf(x) + double(Coeffs(i+1))*(x^i);
        end
        
        fprintf('Y = ');
        fprintf('%f ', Coeffs(1));
        for i = 1:degree
            fprintf('+ %f*x^%i', Coeffs(i+1), i);
        end
        fprintf('\n');
        
        disp("R^2 = " + Polyr2);
        fplot(Pf);
        hold on
        scatter(X, Y);
        title("Order of the polynomial: " + degree + '   ' + "R^2 = " + Polyr2);
        hold off
        
    elseif max(n) == ExpR2
        %plot exponential if its the best
        disp("Exponential is the best fit");
        syms f(x)
        f(x) = exp(ExpCoeffs(1))*exp(ExpCoeffs(2)*x);

        fplot(f);
        hold on
        title("y = " + exp(ExpCoeffs(1)) + "*" + "e" + "\^" + ExpCoeffs(2) + "x   R^2 = " + ExpR2);
        scatter(X,Y);
        hold off

        disp("R^2 = " + ExpR2);
        disp("Y = " + exp(ExpCoeffs(1)) + "*" + "e" + "^" + ExpCoeffs(2) + "x");
        
    elseif max(n) == PowerR2
        %plot power if its the best
        disp("Power is the best fit");
        syms f(x)
        f(x) = (10^PowerCoeffs(1))*(x^PowerCoeffs(2));
        fplot(f);
        hold on
        title("y = " + 10^(PowerCoeffs(1)) + "x" + "\^" + (PowerCoeffs(2)) + "   R^2 = " + PowerR2);
        scatter(X,Y);
        hold off

        disp("R^2 = " + PowerR2);
        disp("Y = " + 10^(PowerCoeffs(1)) + "X" + "^" + (PowerCoeffs(2)));
    end
end


