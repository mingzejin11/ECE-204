Data = load('data_2.txt');

plot(Data(:, 1),Data(:, 2));
hold on
plot(Data(:, 1),Data(:, 3), 'r');
xlabel('time (sec)');
ylabel('magnitude (meter)');
legend('First data set', 'Second data set');
hold off

disp("The maximum is: " + max(Data(:, 2)));
disp("The minimum is: " + min(Data(:, 2)));
disp("The mean is: " + mean(Data(:, 2)));
disp("The standard deviation is: " + std(Data(:, 2)));
disp("The median is: " + median(Data(:, 2)));
disp("The mode is: " + mode(Data(:, 2)));
disp("The number of elements is: " + numel(Data(:, 2)));
