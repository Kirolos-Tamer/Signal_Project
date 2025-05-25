clc;
clear;

T = 2;
Fs = 1000;
t = 0:1/Fs:8;
x = square(2*pi*(1/T)*t, 50);   
x = (x + 1)/2;

subplot(2,1,1);
plot(t, x, 'LineWidth', 2);
xlabel('Time (t)');
ylabel('Amplitude');
title('Time Domain: Periodic Square Wave');
axis([0 8 -0.2 1.2]);
grid on;


s_real = linspace(0.01,10,1000);
X_mag = zeros(size(s_real));
dt = 1/Fs;

for k = 1:length(s_real)
    s = s_real(k);
    X = sum(x .* exp(-s*t)) * dt;
    X_mag(k) = abs(X);
end

subplot(2,1,2);
plot(s_real, X_mag, 'r', 'LineWidth', 2);
xlabel('Re(s)');
ylabel('|X(s)|');
title('Laplace Transform Magnitude |X(s)|');
grid on;