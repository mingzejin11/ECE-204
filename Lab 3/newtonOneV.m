function newtonOneV(F,initial,sym)

%cacluate derivative
Fd = diff(F);
Xi = initial;
done = false;

counter = 0;
while done == false
    %evaluate function and derivative & find new root
    Xn = Xi - double(subs(F, sym, Xi)/subs(Fd, sym, Xi));
    
    %caclculate relative approximate error
     Error = abs((Xn-Xi)/Xn);
        if(Error < 0.001)
            done = true;
        end
    %update previous
    Xi = Xn;
    counter = counter + 1;
end

%display results
disp("Newton Raphson: " + Xn);
disp("Number of iterations: " + counter);

end