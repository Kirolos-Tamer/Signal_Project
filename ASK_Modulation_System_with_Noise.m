clc; clear; close all;

bit_seq = [1 0 1 1 0 0 1];
bit_rate = 1;
Tb = 1/bit_rate;
Fs = 1000;
Fc = 10;
t = 0:1/Fs:length(bit_seq)-1/Fs;

digital_signal = repelem(bit_seq, Fs);
carrier = cos(2*pi*Fc*t);
ask_modulated = digital_signal .* carrier;
noisy_signal = ask_modulated + 0.5*randn(size(t));
demodulated = noisy_signal .* carrier;
LPF_order = 100;
lpf = ones(1, LPF_order)/LPF_order;
filtered_signal = filter(lpf, 1, demodulated);

figure;

subplot(5,1,1);
plot(t, digital_signal, 'b');
title('Digital Signal');
ylim([-0.5 1.5]);

subplot(5,1,2);
plot(t, ask_modulated, 'k');
title('ASK Modulated Signal');
ylim([-1.5 1.5]);

subplot(5,1,3);
plot(t, noisy_signal, 'r');
title('Received Signal (With Noise)');
ylim([-2 2]);

subplot(5,1,4);
plot(t, demodulated, 'm');
title('After Demodulation (Noisy)');
ylim([-2 2]);

subplot(5,1,5);
plot(t, filtered_signal, 'g');
title('After Low-Pass Filter');
xlabel('Time (s)');
ylim([-0.5 1.5]);