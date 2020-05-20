x = input("Enter the value of x: ");

f = 1;
prev = 0;
n = 1;

while (abs(f - prev) >= 10^(-6))
    prev = f;
    f = f + (x^n) / factorial(n);
    n = n + 1;
end

disp("For x = " + x + ", e^x = " + f);
    
