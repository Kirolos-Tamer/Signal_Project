t = linspace(0, 5, 1000);
x = sin(2*pi*t) + 0.5*sin(10*pi*t);
h = exp(-t);
dt = t(2) - t(1);
y = conv(x, h) * dt;
ty = linspace(0, 2*max(t), length(y));


figure;
subplot(3,1,1);
plot(t, x);
title('Original Signal x(t)');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

subplot(3,1,2);
plot(t, h);
title('Impulse Response h(t)');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

subplot(3,1,3);
plot(ty, y);
title('Output Signal y(t) = x(t) * h(t)');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;