T = 6;                     
t = linspace(0, 7, 1000);   
N = 7;                     
f = @(t) (mod(t, T) < T/2)*1 + (mod(t, T) >= T/2)*-1;
original = f(t);
a0 = 0;
f_series = a0 / 2 * ones(size(t));  

figure;
plot(t, original, 'LineWidth', 1);
axis([0 7 -1.5 1.5]);
xlabel('Time (s)');
ylabel('Amplitude');
title('Original Wave');
grid on;


figure;
hold on;
for n = 1:2:N  
    bn = (4 / pi) * (1/n);
    component = bn * sin(2*pi*n*t/T);
    f_series = f_series + component;
    plot(t, component, '--');  
end

plot(t, f_series, 'r', 'LineWidth', 1.5);  
axis([0 7 -1.5 1.5]);
xlabel('Time (s)');
ylabel('Amplitude');
title(['Fourier Series(', num2str(N), ' Harmonics)']);
grid on;
hold off;