t = -5:0.01:5;
x = (t >= 0 & t <= 2);  
h = exp(-t) .* (t >= 0);
dt = t(2) - t(1);
y = conv(x, h) * dt;
t_conv = 2*t(1):dt:2*t(end);

figure;
subplot(3,1,1);
plot(t, x, 'LineWidth', 2); grid on;
title('Square Wave x(t)'); xlabel('Time'); ylabel('Amplitude');

subplot(3,1,2);
plot(t, h, 'LineWidth', 2); grid on;
title('Impulse Response h(t) = e^{-t}'); xlabel('Time'); ylabel('Amplitude');

subplot(3,1,3);
plot(t_conv, y, 'LineWidth', 2); grid on;
title('Convolution y(t) = x(t) * h(t)'); xlabel('Time'); ylabel('Amplitude');
