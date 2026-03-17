%% Setup Data Acquisition
tic;
clc; clear; close all;

s = daq("ni");  % Create NI-DAQ session
s.Rate = 20e3;  % Set data acquisition rate in Hz (20 kHz)

% Add two input channels for voltage measurement
addinput(s, "Dev1", 5, "Voltage");
addinput(s, "Dev1", 6, "Voltage");

T = 200;   % Acquisition duration in seconds
numScans = s.Rate * T; % Number of scans to acquire
dt = 1 / s.Rate;  % Step size of time
t = (0:numScans-1) * dt; % Time array

% Acquire data
data = read(s, numScans, "OutputFormat", "Matrix");

% Extract channel data
ch1 = data(:,1);
ch2 = data(:,2);
normFactor = ch1 + ch2;
sig_x = (ch1 - ch2) ./ normFactor;

x_ss = [t', sig_x];
save('E:\Anita\Non_rotating_dynamics\Beam_intensity_fluctuation\beam_fluctuation_wo_fan_1.dat', 'x_ss', '-ascii');
disp('Data saved');

% Plot Data
figure(1);
subplot(2,2,1);
plot(t, sig_x, 'r');
xlabel('Time (s)');
ylabel('x (Volt)');
title('Displacement');
grid on;

subplot(2,2,2);
histfit(sig_x, 20);
grid on;
xlabel('x (Volt)');
ylabel('Counts');
title('Histogram');

subplot(2,2,3);
for n = 0:1:sqrt(length(sig_x))
    msdx(n+1) = mean((sig_x(n+1:end) - sig_x(1:end-n)).^2);
end
dt_step = dt * (0:1:length(msdx)-1);
loglog(dt_step, msdx, 'mo-');
hold on; loglog(dt_step, 2.*dt_step, 'k-');
axis([min(dt_step) max(dt_step) min(msdx) max(msdx)]);
xlabel('Time (s)');
ylabel('MSD (Volt^2)');
title('MSD');
grid on;

subplot(2,2,4);
[acf, lags] = autocorr(sig_x, 'NumLags', length(sig_x)-1);
lags = dt .* lags;
semilogx(lags, acf);
xlabel('Lag (s)');
ylabel('ACF');
title('Auto-correlation');
grid on;

figure(4);
ftx = fft(sig_x);
nn = length(sig_x);
p2x = abs(ftx / nn);
p1x = p2x(1:nn/2 + 1);
f = s.Rate * ((0:nn/2) / nn);
loglog(f, (p1x .* p1x));
xlim([min(f) max(f)]);
xlabel('f (Hz)');
ylabel('|P1(f)|^2');
title('PSD');
grid on;

toc;
