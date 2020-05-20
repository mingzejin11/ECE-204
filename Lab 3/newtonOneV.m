function newtonOneV(F, initial,sym)

% Calculate derivative
Fd = diff(F);
Xi = initial;
done = false;

counter = 0;
while done == false
    % Evaluate function and derivative & find new root
    Xn = Xi - double(subs(F, sym, Xi) / subs(Fd, sym, Xi));
    
    % Calculate relative approximate error
     Error = abs((Xn - Xi) / Xn);
        if(Error < 0.001)
            done = true;
        end
    % Update previous
    Xi = Xn;
    counter = counter + 1;
end

% Display results
disp("Newton Raphson: " + Xn);
disp("Number of iterations: " + counter);

end
