t = 0:0.001:1;
x = sin(2*pi*5*t);
noise = 0.5 * sin(2*pi*50*t);
x_noisy = x + noise;
N = 10;
h = (1/N)*ones(1, N);
y = conv(x_noisy, h, 'same');

figure;
subplot(3,1,1);
plot(t, x, 'LineWidth', 1.5); grid on;
title('Original Signal (5 Hz)');

subplot(3,1,2);
plot(t, x_noisy, 'r', 'LineWidth', 1.5); grid on;
title('Noisy Signal (with 50 Hz Noise)');

subplot(3,1,3);
plot(t, y, 'g', 'LineWidth', 1.5); grid on;
title('Filtered Signal via Convolution');
xlabel('Time (s)');
ylabel('Amplitude');