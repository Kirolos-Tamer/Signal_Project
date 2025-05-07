t = -2:0.01:2;
x = sin(2*pi*t);

subplot(3,2,1);

plot(t, x); 
title('Original Signal');
subplot(3,2,2);
plot(t, sin(2*pi*(t-1)));
title('Time Shifted: x(t-1)');
subplot(3,2,3); 
plot(t, sin(2*pi*(2*t)));
title('Time Scaled: x(2t)');
subplot(3,2,4);
plot(t, sin(2*pi*(0.5*t)));
title('Time Scaled: x(0.5t)');
subplot(3,2,5); 
plot(t, 2*sin(2*pi*t));
title('Amplitude Scaled: 2x(t)');
subplot(3,2,6); 
plot(t, 0.5*sin(2*pi*t));
title('Amplitude Scaled: 0.5x(t)');

