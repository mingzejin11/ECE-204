function newtonRaphson(A,initial,symbols)

n = size(symbols, 2);
Error(1,1:n) = 100; %vector for error
S = zeros(n,1); %Vector to hold guesses from iteration

done = false;

%compute jacobian
J = jacobian(A, symbols); 

count = 0;

X = initial;
 
while done == false
   if(count ~= 0) 
      S_prev = S;
   end
  
   %for the first iteration set prev guess to initial
  if(count == 0)
    S_prev = X;
    count = 1;
  end
  
  
  F = subs(A, symbols, S_prev);%evaluate functions
  G = subs(J, symbols, S_prev);%evaluate Jacobian
  H = inv(G); %Inverse of jacobian
  
  S = S_prev - double((H*F')');
   
  for k = 1:n

    Error(k) = abs((S(k)-S_prev(k))/S(k)); %Calculate the relative approximate error for each
  end
  
  if(max(Error) < 0.005)
    done = true;
  end
    
end
%display results
for i = 1:n
    fprintf('%c = %f \n', symbols(i), S(i));
end

end