Data = load('data.txt');

c = 0;
for n = 1:numel(Data)
    if(Data(n) > 2)
       c = c+1;
    end
end

disp("The number of elements is: " + numel(Data));
disp("The number of elements more than 2 is: " + c);