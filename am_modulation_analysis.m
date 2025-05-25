Fs = 1e5;
t = 0:1/Fs:0.01;
fm = 1000;
Am = 1;
m_t = Am * cos(2*pi*fm*t);
fc = 20000;
Ac = 1;
carrier = Ac * cos(2*pi*fc*t);
ka = 1;
s_t = (1 + ka * m_t) .* carrier;

figure;
subplot(3,1,1);
plot(t*1000, m_t);
title('Modulating Signal (1 kHz)');
xlabel('Time (ms)');
ylabel('Amplitude');
grid on;


subplot(3,1,2);
plot(t*1000, carrier);
title('Carrier Signal (20 kHz)');
xlabel('Time (ms)');
ylabel('Amplitude');
xlim([0 4]);
grid on;

subplot(3,1,3);
plot(t*1000, s_t);
title('AM Signal');
xlabel('Time (ms)');
ylabel('Amplitude');
grid on;

n = length(s_t);
f = (-n/2:n/2-1)*(Fs/n);
S_f = abs(fftshift(fft(s_t)));

figure;
stem(f/1000, S_f, 'marker','none');
title('Frequency Spectrum of AM Signal');
xlabel('Frequency (kHz)');
ylabel('Magnitude');
grid on;

fprintf('Theoretical Bandwidth = %.2f kHz\n',2*fm/1000);