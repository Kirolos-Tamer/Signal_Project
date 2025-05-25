function ECG_Analysis_GUI
    % Create main figure window
    fig = figure('Name', 'ECG Analysis System', ...
                'Position', [100 100 1000 700], ...
                'NumberTitle', 'off', ...
                'MenuBar', 'none', ...
                'ToolBar', 'none', ...
                'Color', [0.95 0.95 0.95]);
            
    % Initialize parameters as persistent variables
    fs = 360;
    t = 0:1/fs:10;
    scenario = "normal";
    ecg = [];
    ecg_noisy = [];
    ecg_filtered = [];
    R_locs = [];
    HR = [];
    RR_intervals = [];  % Initialize RR_intervals here
    
    % Create UI controls
    uicontrol('Style', 'text', ...
              'String', 'ECG Analysis System', ...
              'Position', [350 650 300 30], ...
              'FontSize', 16, ...
              'FontWeight', 'bold', ...
              'BackgroundColor', [0.95 0.95 0.95]);
          
    % Scenario selection
    uicontrol('Style', 'text', ...
              'String', 'Select Heart Condition:', ...
              'Position', [50 600 150 20], ...
              'HorizontalAlignment', 'left', ...
              'BackgroundColor', [0.95 0.95 0.95]);
          
    scenarioDropdown = uicontrol('Style', 'popupmenu', ...
                               'String', {'Normal (60 BPM)', 'Bradycardia (40 BPM)', ...
                                         'Tachycardia (120 BPM)', 'Arrhythmia'}, ...
                               'Position', [200 600 200 20], ...
                               'Value', 1, ...
                               'Callback', @updateScenario);
    
    % Analysis buttons
    uicontrol('Style', 'pushbutton', ...
              'String', 'Generate ECG', ...
              'Position', [50 550 120 30], ...
              'Callback', @generateECG);
          
    uicontrol('Style', 'pushbutton', ...
              'String', 'Analyze ECG', ...
              'Position', [200 550 120 30], ...
              'Callback', @analyzeECG, ...
              'Enable', 'off');
          
    uicontrol('Style', 'pushbutton', ...
              'String', 'Generate Report', ...
              'Position', [350 550 120 30], ...
              'Callback', @generateReport, ...
              'Enable', 'off');
    
    % Create axes for plots
    ax1 = axes('Parent', fig, 'Position', [0.1 0.4 0.4 0.4]);
    ax2 = axes('Parent', fig, 'Position', [0.55 0.4 0.4 0.4]);
    ax3 = axes('Parent', fig, 'Position', [0.1 0.1 0.4 0.2]);
    ax4 = axes('Parent', fig, 'Position', [0.55 0.1 0.4 0.2]);
    
    % Results display
    resultsText = uicontrol('Style', 'text', ...
                          'String', '', ...
                          'Position', [500 550 450 30], ...
                          'HorizontalAlignment', 'left', ...
                          'FontSize', 12, ...
                          'BackgroundColor', [0.95 0.95 0.95]);
    
    % Report display
    reportPanel = uipanel('Title', 'Cardiac Health Report', ...
                         'Position', [0.5 0.05 0.45 0.45], ...
                         'BackgroundColor', 'white', ...
                         'Visible', 'off');
    
    reportText = uicontrol('Parent', reportPanel, ...
                         'Style', 'edit', ...
                         'String', '', ...
                         'Max', 100, ...
                         'Position', [10 10 430 300], ...
                         'HorizontalAlignment', 'left', ...
                         'FontSize', 10, ...
                         'BackgroundColor', 'white');
    
    % Callback functions
    function updateScenario(~, ~)
        scenarios = ["normal", "brady", "tachy", "arrhythmia"];
        scenario = scenarios(get(scenarioDropdown, 'Value'));
    end

    function generateECG(~, ~)
        % Generate ECG signal based on selected scenario
        [ecg, ecg_noisy, ~] = generate_ecg_signal(t, fs, scenario);
        
        % Focus on first 5 seconds
        analysis_window = t <= 5;
        ecg_noisy = ecg_noisy(analysis_window);
        t_short = t(analysis_window);
        
        % Plot raw ECG
        cla(ax1); cla(ax2); cla(ax3); cla(ax4);
        plot(ax1, t_short, ecg_noisy, 'Color', [0.7 0.7 0.7]);
        title(ax1, 'Raw ECG Signal');
        xlabel(ax1, 'Time (s)');
        ylabel(ax1, 'Amplitude (mV)');
        grid(ax1, 'on');
        
        % Enable Analyze button
        set(findobj('String', 'Analyze ECG'), 'Enable', 'on');
        set(resultsText, 'String', 'ECG signal generated. Click "Analyze ECG" to process.');
    end

    function analyzeECG(~, ~)
        % Process the generated ECG
        analysis_window = t <= 5;
        ecg_noisy_short = ecg_noisy(analysis_window);
        t_short = t(analysis_window);
        
        % Bandpass filter
        [b, a] = butter(3, [0.5 40]/(fs/2), 'bandpass');
        ecg_filtered = filtfilt(b, a, ecg_noisy_short);
        
        % Frequency analysis
        n = length(ecg_noisy_short);
        n_fft = 2^nextpow2(n);
        f = (0:n_fft-1)*(fs/n_fft);
        fft_ecg = abs(fft(ecg_noisy_short, n_fft));
        
        % Peak detection
        [~, R_locs] = findpeaks(ecg_filtered, 'MinPeakHeight', 0.8, 'MinPeakDistance', round(0.3*fs));
        RR_intervals = diff(R_locs)/fs;
        HR = 60 ./ RR_intervals;
        
        % Update plots
        plot(ax1, t_short, ecg_noisy_short, 'Color', [0.7 0.7 0.7]);
        hold(ax1, 'on');
        plot(ax1, t_short, ecg_filtered, 'b');
        scatter(ax1, t_short(R_locs), ecg_filtered(R_locs), 'vr', 'filled');
        title(ax1, 'Filtered ECG with R Peaks');
        legend(ax1, 'Raw', 'Filtered', 'R-peaks');
        
        % Frequency spectrum
        plot(ax2, f(1:n_fft/2), fft_ecg(1:n_fft/2), 'k');
        title(ax2, 'Frequency Spectrum');
        xlabel(ax2, 'Frequency (Hz)');
        ylabel(ax2, 'Magnitude');
        xline(ax2, 50, '--r', '50Hz Noise');
        grid(ax2, 'on');
        xlim(ax2, [0 100]);
        
        % Heart rate variability
        plot(ax3, HR, '-o', 'Color', [0.85 0.33 0.1]);
        title(ax3, 'Heart Rate Variability');
        xlabel(ax3, 'Beat Number');
        ylabel(ax3, 'HR (BPM)');
        yline(ax3, 60, '--g', 'Bradycardia');
        yline(ax3, 100, '--r', 'Tachycardia');
        grid(ax3, 'on');
        
        % RR interval analysis
        if length(RR_intervals) > 1
            plot(ax4, RR_intervals(1:end-1), RR_intervals(2:end), 'o', ...
                 'MarkerFaceColor', [0.3 0.75 0.9]);
            title(ax4, 'RR Interval Poincaré Plot');
            xlabel(ax4, 'RR_n (s)');
            ylabel(ax4, 'RR_{n+1} (s)');
            grid(ax4, 'on');
        else
            text(ax4, 0.5, 0.5, 'Not enough beats for Poincaré plot', ...
                 'HorizontalAlignment', 'center');
            axis(ax4, 'off');
        end
        
        % Enable report generation
        set(findobj('String', 'Generate Report'), 'Enable', 'on');
        set(resultsText, 'String', sprintf('Analysis complete. Average HR: %.1f BPM', mean(HR)));
    end

    function generateReport(~, ~)
        % Check if RR_intervals exists and has enough values
        if isempty(RR_intervals) || length(RR_intervals) < 2
            errordlg('Not enough data to generate report. Please analyze ECG first.', 'Data Error');
            return;
        end
        
        % Generate comprehensive report
        avg_hr = mean(HR);
        hr_std = std(HR);
        rr_variability = std(RR_intervals)/mean(RR_intervals)*100;
        
        reportStr = sprintf('CARDIAC HEALTH REPORT\n\n');
        reportStr = [reportStr sprintf('Date: %s\n', datestr(now))];
        reportStr = [reportStr sprintf('Condition: %s\n\n', upper(scenario))];
        
        reportStr = [reportStr sprintf('HEART RATE ANALYSIS:\n')];
        reportStr = [reportStr sprintf('• Average: %.1f ± %.1f BPM\n', avg_hr, hr_std)];
        reportStr = [reportStr sprintf('• Beat-to-beat variability: %.1f%%\n\n', rr_variability)];
        
        if avg_hr < 60
            reportStr = [reportStr sprintf('⚠️ Bradycardia detected\n\n')];
        elseif avg_hr > 100
            reportStr = [reportStr sprintf('⚠️ Tachycardia detected\n\n')];
        else
            reportStr = [reportStr sprintf('✅ Normal heart rate\n\n')];
        end
        
        if rr_variability > 15
            reportStr = [reportStr sprintf('⚠️ Abnormal rhythm variability\n\n')];
        else
            reportStr = [reportStr sprintf('✅ Regular rhythm\n\n')];
        end
        
        reportStr = [reportStr sprintf('RECOMMENDATIONS:\n')];
        if avg_hr < 60
            reportStr = [reportStr sprintf('- Consult a cardiologist\n')];
        elseif avg_hr > 100
            reportStr = [reportStr sprintf('- Reduce caffeine intake\n')];
        end
        reportStr = [reportStr sprintf('- Maintain healthy lifestyle\n')];
        reportStr = [reportStr sprintf('- Regular exercise (30 mins/day)\n')];
        reportStr = [reportStr sprintf('- Adequate sleep (7-8 hours)\n')];
        
        % Display report
        set(reportText, 'String', reportStr);
        set(reportPanel, 'Visible', 'on');
        
        % Save report to file
        report_filename = sprintf('Cardiac_Report_%s.txt', datestr(now,'yyyy-mm-dd_HH-MM'));
        fid = fopen(report_filename, 'w');
        fprintf(fid, '%s', reportStr);
        fclose(fid);
        
        set(resultsText, 'String', sprintf('Report generated and saved as %s', report_filename));
    end

    % ECG Generation Function (nested)
    function [ecg, ecg_noisy, beat_times] = generate_ecg_signal(t, fs, scenario)
        switch scenario
            case "normal"
                RR = 1;                % 60 BPM
            case "brady"
                RR = 1.5;              % 40 BPM
            case "tachy"
                RR = 0.5;              % 120 BPM
            case "arrhythmia"
                rr_values = [1 1.2 0.6 0.9 1.5 0.7 1.1 0.8]; % Irregular intervals
        end

        ecg = zeros(size(t));
        
        if strcmp(scenario, "arrhythmia")
            beat_times = cumsum(rr_values);
            beat_times = beat_times(beat_times <= t(end));
        else
            beat_times = 0:RR:t(end);
        end

        % Generate ECG waveform components
        for bt = beat_times
            idx = find(t >= bt-0.3 & t <= bt+0.5);
            for i = idx
                tau = t(i) - bt;
                P = 0.1 * exp(-((tau+0.2)/0.03)^2);   % P wave
                Q = -0.3 * exp(-((tau+0.05)/0.01)^2); % Q wave
                R = 1.5 * exp(-(tau/0.02)^2);         % R wave
                S = -0.3 * exp(-((tau-0.05)/0.02)^2); % S wave
                T = 0.3 * exp(-((tau-0.25)/0.07)^2);  % T wave
                ecg(i) = ecg(i) + P + Q + R + S + T;
            end
        end

        % Add realistic noise
        noise = 0.05 * randn(size(ecg));              % White noise
        baseline = 0.3 * sin(2*pi*0.15*t);           % Baseline wander
        powerline = 0.2 * sin(2*pi*50*t + pi/3);     % 50Hz interference
        ecg_noisy = ecg + noise + baseline + powerline;
    end
end