R = 10;
L = 0.1;
C = 10e-6;

s = tf('s');
H = 1 / (L * C * s^2 + R * C * s + 1);
disp('Transfer Function H(s):');
H

figure;
step(H);
title('Step Response of RLC Circuit');
grid on;

poles = pole(H);
disp('Poles of the Transfer Function:');
disp(poles);

if all(real(poles) < 0)
    disp('The system is Stable (All poles are negative).');
elseif any(real(poles) > 0)
    disp('The system is Unstable (One or more poles are positive).');
else
    disp('The system is Marginally Stable (Poles on the imaginary axis).');
end

figure;
impulse(H);
title('Impulse Response of RLC Circuit (Natural Response)');
grid on;