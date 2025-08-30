clear all;

% ============================================================
%   Daphnia Displacement Analysis
%
%   This script calculates the displacement of each Daphnia 
%   relative to its starting position, averages the displacement 
%   across all individuals, and analyzes scaling trends in time.
%
%   HOW IT FITS IN THE PIPELINE:
%     Step 1: Convert TREX .npz tracking to CSV
%     Step 2A: (THIS SCRIPT) Analyze displacement scaling behavior
%     Step 2B: Cumulative angular dynamics
%     Step 3: CW/CCW classification & handedness
% ============================================================


% ============ USER-DEFINED PARAMETERS =======================

% Dataset base name (e.g., experiment label)
base = 'Green50_1';

% Input directory containing the CSV files
% NOTE: Replace 'path' and 'folder' with your actual location
inputDir = fullfile('path', 'to', 'your', 'csv', 'folder', [base, '_csv']);

% Number of tracked Daphnia
N = 50;

% ============================================================



%% ========= Load Data for All Daphnia =======================

% Initialize cell arrays to store position and time data
X = cell(1, N);
Y = cell(1, N);
Time = cell(1, N);
FPS = cell(1, N);

% Loop over all N tracked Daphnia
for i = 0:N-1
    % Construct file name for each Daphnia
    csvFile = fullfile(inputDir, sprintf('%s_daphnia%d.csv', base, i));

    % Read data
    data = readtable(csvFile);

    % Store in arrays
    X{i+1}    = data.X;
    Y{i+1}    = data.Y;
    Time{i+1} = data.Time;
    FPS{i+1}  = data.fps;
end



%% ========= Find Shortest Common Trajectory =================

% Ensure all datasets are trimmed to same length
minLength = inf;
for i = 1:N
    currentLength = numel(Time{i});
    if currentLength < minLength
        minLength = currentLength;
    end
end

% Define usable range
maxTau = minLength - 1;

% Estimate fps (using last dataset as representative)
fps = mean(cell2mat(FPS(N)));

% Prepare container for summed displacement
displacementSum = zeros(maxTau, 1);

% Cell array for each Daphnia's displacement trajectory
displacement = cell(1, N);



%% ========= Calculate Displacements =========================

for i = 1:N
    % Trim to common length
    X_clean = X{i}(1:minLength);
    Y_clean = Y{i}(1:minLength);

    displacement{i} = zeros(maxTau, 1);

    for j = 1:maxTau
        % Displacement relative to initial position (X(1), Y(1))
        displacement{i}(j) = sqrt((X_clean(j+1) - X_clean(1))^2 + ...
                                  (Y_clean(j+1) - Y_clean(1))^2);

        % Add to running total (for average later)
        displacementSum(j) = displacementSum(j) + displacement{i}(j);
    end
end

% Average displacement across all N individuals
averageDisplacement = displacementSum / N;

% Define time array (in frames → convert to seconds later)
time = 1:maxTau;



%% ========= Plot All Individual Displacements ================

figure;
hold on;
for i = 1:N
    plot(time./fps, displacement{i});
end
hold off;

xlabel('Time (s)');
ylabel('Displacement (cm)');
title('Displacement vs. Time for All Daphnia');
set(gca, 'XMinorTick','on','YMinorTick','on');



%% ========= Plot Average Displacement =======================

figure;
scatter(time./fps, averageDisplacement);

xlabel('Time (s)');
ylabel('|Average Displacement| (cm)');
title('Average Displacement vs. Time');
set(gca, 'XMinorTick','on','YMinorTick','on');



%% ========= Log-Log Scaling Analysis ========================

% Plot log-log relationship (displacement scaling with time)
figure;
scatter(log(time./fps), log(averageDisplacement));

xlabel('ln(Time)');
ylabel('ln(Average Displacement)');
title('Scaling of Displacement: ln-ln Plot');
set(gca, 'XMinorTick','on','YMinorTick','on');



%% ========= Piecewise Linear Fits ===========================

ln_t   = log(time./fps);
ln_disp = log(averageDisplacement);

% Define simple linear function y = ax + b
fun = @(x, xdata) x(1) * xdata + x(2);
init = [1,0];  % initial guess

% Breakpoint at ln(Time) = 1 (≈ t=2.7s)
first_break = find(round(ln_t,2) == 1.00);

% Fit before and after the breakpoint
[x1, ~] = lsqcurvefit(fun, init, ln_t(1:first_break(1))', ln_disp(1:first_break(1)));
[x2, ~] = lsqcurvefit(fun, init, ln_t(first_break(1):end)', ln_disp(first_break(1):end));

% Plot fits
figure;
scatter(ln_t, ln_disp)
hold on;
plot(ln_t(1:first_break(1)), fun(x1, ln_t(1:first_break(1))), '--', 'LineWidth', 2);
plot(ln_t(first_break(1):end), fun(x2, ln_t(first_break(1):end)), '--', 'LineWidth', 2);
plot(ln_t(first_break(1)), ln_disp(first_break(1)), 'k.', 'MarkerSize', 50)
hold off;

% Annotate with equations
dim = [0.55 0.2 0.2 0.1];
str = {
    'Two Fits:', ...
    sprintf('First: y1 = %.3fx + %.3f', x1(1), x1(2)), ...
    sprintf('Second: y2 = %.3fx + %.3f', x2(1), x2(2))
};
annotation('textbox', dim, 'String', str, 'FitBoxToText','on');

xlabel('ln(Time)');
ylabel('ln(Average Displacement)');
set(gca, 'XMinorTick','on','YMinorTick','on');
