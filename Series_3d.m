clc; clear; close all;

T = 2*pi;
t = linspace(0, 2*T, 1000);
N = 6;
frequencies = (1:2:(2*N-1)) / T;
square_wave = zeros(size(t));

colors = lines(N);
figure;
hold on;
grid on;

for k = 1:N
    n = 2*k - 1;
    fn = n / T;          
    harmonic = (4/pi)*(1/n)*sin(n*t);
    plot3(t, fn*ones(size(t)), harmonic, 'Color', colors(k,:), 'LineWidth', 1.2);
    square_wave = square_wave + harmonic;
end

plot3(t, zeros(size(t)), square_wave, 'b', 'LineWidth', 2);

xlabel('Time t [s]');
ylabel('Frequency f_n [1/s]');
zlabel('Amplitude');
title('Fourier Series in 3D: Time vs Frequency vs Amplitude');
view(40, 30);
legend('Harmonics', 'Square wave');