function bisection(F, left, right, sym)

mid = (left + right)/2;

done = false;
first = true;
counter = 0;

while done == false
%evaluate the funciton at the end /mid points
Fleft = double(subs(F, sym, left));
Fright = double(subs(F, sym, right));
Fmid = double(subs(F, sym, mid));

%update previous midpoint
prevMid = mid;

%check where the root lies 
    if(Fleft*Fmid < 0)
        %if between left and mid, right is now the previous midpoint
        mid = (left + mid)/2;
        right = prevMid;

    elseif(Fright*Fmid < 0)
        %if between right and mid, left is now the previous midpoint
        mid = (right + mid)/2;
        left = prevMid;
    end

    if(first ~= true)
        %calculate relative approximate error
        Error = abs((mid-prevMid)/mid);
        if(Error < 0.001)
            done = true;
        end
    end
first = false;
counter = counter + 1;
end
%display results
disp("Bisection: " + mid);
disp("Number of iterations: " + counter);

end