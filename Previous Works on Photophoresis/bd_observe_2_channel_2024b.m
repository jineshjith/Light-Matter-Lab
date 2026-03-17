%% Setup Data Acquisition
s = daq("ni");  % Create NI-DAQ session
s.Rate = 20e3;  % Set data acquisition rate in Hz (10 kHz)

% Add two input channels for voltage measurement
addinput(s, "Dev1", 5, "Voltage");
addinput(s, "Dev1", 6, "Voltage");

t1 = 1;   % Acquisition duration in seconds
numScans = s.Rate * t1; % Number of scans to acquire

%% Live Data Acquisition and Plotting
figure;
while true
    % Acquire data
    data = read(s, numScans, "OutputFormat", "Matrix");
    
    % Extract time and channel data
    time = (0:numScans-1)' / s.Rate;  % Generate time array
    ch1 = data(:,1);
    ch2 = data(:,2);
    norm = ch1 + ch2;
    x = (ch1 - ch2) ./ norm;  % X variation

    % FFT & Power Spectral Density Calculation
    N = length(x);
    Fs = s.Rate;  % Correct sampling rate
    FFT = fft(x);
    FFT = FFT(1:N/2+1);
    PSD = (1/(N)) * abs(FFT).^2;
    PSD = smooth(PSD);  % Ensure smooth PSD calculation
    freq = Fs * (0:N/2) / N;

    % Plot Data
    subplot(2,2,[1,2]);
    plot(time, ch1, 'k', time, ch2, 'b');
    legend('Ch1', 'Ch2');
    xlabel('Time (s)');
    ylabel('PD Signal (V)');
    title('Two Channel Data with Time');

    subplot(2,2,3);
    plot(time, x, 'b');
    legend('x');
    xlabel('Time (s)');
    ylabel('Displacement (V)');
    title('X Displacement with Time');

    subplot(2,2,4);
    loglog(freq, PSD);
    xlim([5, 500]);
    xlabel('Frequency (Hz)');
    ylabel('Power Spectral Density');
    title('Power Spectral Density');

    pause(0.001);  % Small pause to allow visualization updates
end
