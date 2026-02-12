clc;
clear;
close all;

% ==========================================================
% MATLAB / Octave Basics - Figures 1 to 7
% This script generates:
% 1) plot (continuous signal)
% 2) stem (discrete signal)
% 3) hold on/off (two curves on same figure)
% 4) subplot (multiple plots in one window)
% 5-7) Sum of sinusoids with 3 execution approaches + timing
% ==========================================================


%% ---------------------------
% Figure 1: Continuous Signal (plot)
% x(t) = sin(2*pi*t)
%% ---------------------------
figure(1)
t = 0:0.01:2;
x = sin(2*pi*t);
plot(t, x, 'b')
xlabel('t (sec)')
ylabel('x(t)')
title('Figure 1: Continuous Signal  x(t) = sin(2\pi t)')


%% ---------------------------
% Figure 2: Discrete Signal (stem)
% x[n] = sin(0.1*pi*n)
%% ---------------------------
figure(2)
n = 0:40;
x = sin(0.1*pi*n);
stem(n, x, 'filled')
xlabel('n')
ylabel('x[n]')
title('Figure 2: Discrete Signal  x[n] = sin(0.1\pi n)')


%% ---------------------------
% Figure 3: hold on / hold off
% Plot sin and cos on the same figure
%% ---------------------------
figure(3)
t = 0:0.01:1;
plot(t, sin(2*pi*t), 'b')
hold on
plot(t, cos(2*pi*t), 'r')
hold off
legend('sin(2\pi t)', 'cos(2\pi t)')
xlabel('t (sec)')
ylabel('Amplitude')
title('Figure 3: hold on/off (Two signals together)')


%% ---------------------------
% Figure 4: subplot example
%% ---------------------------
figure(4)

subplot(2,2,1)
plot(sin(0:0.1:2*pi))
title('sin')

subplot(2,2,2)
plot(cos(0:0.1:2*pi))
title('cos')

subplot(2,2,3)
plot(exp(-0.5:0.1:2))
title('exp')


%% ==========================================================
% Figures 5-7: Sum of Sinusoids (3 execution approaches)
% x(t) = sum_{k=1,3,5} (1/k) * sin(2*pi*k*t)
%% ==========================================================
t = 0:0.01:1;


%% ---------------------------
% Figure 5: Approach 1 (Two loops)
%% ---------------------------
tic
xt1 = zeros(1, length(t));

for i = 1:length(t)
    for k = 1:2:5
        xt1(i) = xt1(i) + (1/k)*sin(2*pi*k*t(i));
    end
end

time1 = toc;

figure(5)
plot(t, xt1, 'b')
xlabel('t (sec)')
ylabel('x(t)')
title(['Figure 5: Approach 1 (Two loops) | Time = ' num2str(time1) ' s'])


%% ---------------------------
% Figure 6: Approach 2 (One loop)
%% ---------------------------
tic
xt2 = zeros(1, length(t));

for k = 1:2:5
    xt2 = xt2 + (1/k)*sin(2*pi*k*t);
end

time2 = toc;

figure(6)
plot(t, xt2, 'r')
xlabel('t (sec)')
ylabel('x(t)')
title(['Figure 6: Approach 2 (One loop) | Time = ' num2str(time2) ' s'])


%% ---------------------------
% Figure 7: Approach 3 (No loops - Vectorized)
%% ---------------------------
tic
k = (1:2:5)';                    % column vector
xt3 = sum((1./k).*sin(2*pi*k*t), 1);
time3 = toc;

figure(7)
plot(t, xt3, 'k')
xlabel('t (sec)')
ylabel('x(t)')
title(['Figure 7: Approach 3 (Vectorized) | Time = ' num2str(time3) ' s'])
