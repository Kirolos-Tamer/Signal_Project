T = 2*pi;
Fs = 1000;
t = -2*T:1/Fs:2*T;
x = square(t);

figure;
plot(t, x, 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('Amplitude');
title('Square Wave in Time Domain');
grid on;

n = length(x);
X_f = fftshift(fft(x));
f = (-n/2:n/2-1)*(Fs/n);

figure;
plot(f, abs(X_f)/n, 'r', 'LineWidth', 1.5);
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('Fourier Transform of Square Wave');
grid on;