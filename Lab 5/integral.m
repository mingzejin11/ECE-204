function integral(X, Y)

a = input("Enter the first limit: ");
b = input("Enter the second limit: ");
n = input("Enter the number of segments: ");

sizex = size(X);

%check if limits are within X bounds
if(a < X(1) || a > X(sizex(1)-1) || b < X(1) || b > X(sizex(1)-1))
    disp("Error, the point is outside the range");
    return;
end

ainX = false;
binX = false;
equalSpc = true;
aloc = 0;
bloc = 0;

%check if limits are in the dataset
for i = 1:size(X)
    if a == X(i)
        ainX = true;
        aloc = i;
    end
    if b == X(i)
        binX = true;
        bloc = i;
    end
    
end

%check if equal spacing
for i = 2:size(X)-1
      if (X(i) - X(i-1)) ~= (X(i+1) - X(i))
        equalSpc = false;
      end
end

h = (b - a) / n;

%if equal spacing and in dataset, calculate integral with Trapezoidal
%method
if(equalSpc && ainX && binX && floor(h)== h)
    
    %find the sum with increments of h
    h = (b - a) / n;
    Ysum = 0;
    for i = 1:n-1
        Ysum = Ysum + Y(aloc + i*h);
    end
    
    %calculate integral
    integral =(((b-a)/(2*n)) * (Y(aloc) + 2*Ysum + Y(bloc)));
    disp("Answer: " + integral);
    
%otherwise perform regression
else

    h = (b - a) / n;
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
    l = M(1);
    
    %calculate the R^2
    St = sum((Y - B(1)/l).^2);
    Sr = sum((Y - YSol).^2);
    r2prev = r2cur;
    r2cur = (St-Sr)/St;
    r2 = (St-Sr)/St;
    end
    
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
    
    disp("R^2 = " + r2);
    %plot the function
    fplot(f);
    hold on
    scatter(X, Y);
    title("Order of the polynomial: " + degree + '   ' + "R^2 = " + r2);
    hold off
    
    %find the sum from regression equation with increments of h 
    Ysum = 0;
    for i = 1:n-1
        Ysum = Ysum + double(f(a + i*h));
    end
    
    %calculate integral
    integral =(((b-a)/(2*n)) * (double(f(a)) + 2*Ysum + double(f(b))));

    disp("Answer: " + integral);
end

end