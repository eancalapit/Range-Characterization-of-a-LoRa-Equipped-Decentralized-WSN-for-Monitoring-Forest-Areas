%% Load data
data = readtable('data-2-node-setup.csv');

%% Basic Statistics
fprintf('\n=== DATA STATISTICS ===\n');
fprintf('Dataset size: %d observations, %d variables\n', size(data));
fprintf('Variables: %s\n', strjoin(data.Properties.VariableNames, ', '));
fprintf('RSSI range: %.2f to %.2f dBm\n', min(data.RSSI), max(data.RSSI));
fprintf('SNR range: %.2f to %.2f dB\n', min(data.SNR), max(data.SNR));
fprintf('Distance range: %.2f to %.2f m\n', min(data.Distance), max(data.Distance));
fprintf('Foliage range: %.2f to %.2f\n', min(data.Foliage), max(data.Foliage));

%% Feature Engineering
fprintf('\n=== FEATURE ENGINEERING ===\n');

% Basic polynomial terms
data.Distance2 = data.Distance.^2;
data.Height2 = data.Height.^2;
data.Distance3 = data.Distance.^3;
data.Height3 = data.Height.^3;

% Interaction terms
data.Distance_Height = data.Distance .* data.Height;
data.Distance_Foliage = data.Distance .* data.Foliage;
data.Height_Foliage = data.Height .* data.Foliage;
data.DistHeight_Foliage = data.Distance .* data.Height .* data.Foliage;

% Safe transformations (no complex numbers)
data.log_Distance = log(data.Distance + 0.1);  % +0.1 to avoid log(0)
data.log_Height = log(data.Height + 0.1);
data.sqrt_Foliage = sqrt(data.Foliage);

% Physics-based wireless propagation features
data.FSPL = 20*log10(data.Distance) + 20*log10(433) - 27.55;

% Two-ray ground reflection model approximation
data.two_ray = 40*log10(data.Distance) - 20*log10(data.Height);

% Environmental attenuation factor
data.env_attenuation = data.Foliage .* data.Distance;

% For negative RSSI values, use absolute value or offset
data.RSSI_positive = -data.RSSI;  % Convert to positive values
data.log_RSSI_positive = log(data.RSSI_positive);

% Alternative: Use inverse RSSI (often works well for signal strength)
data.inv_RSSI = 1 ./ data.RSSI_positive;

% Signal quality combinations
data.RSSI_SNR_ratio = data.RSSI ./ data.SNR;

%% RSSI Model
fprintf('\n--- RSSI MODEL ---\n');

% Model 1C: Comprehensive model
mdl_RSSI3 = fitlm(data, 'RSSI ~ Distance + Height + Foliage + Distance2 + Height2 + FSPL + two_ray + Distance_Height + Distance_Foliage + Height_Foliage');
fprintf('Model 1C (Comprehensive): R² = %.4f, Adj R² = %.4f\n', mdl_RSSI3.Rsquared.Ordinary, mdl_RSSI3.Rsquared.Adjusted);

SE = mdl_RSSI3.RMSE;
anovaTable = anova(mdl_RSSI3);
Fstat = anovaTable.F(1);
pF = anovaTable.pValue(1);
nObs = mdl_RSSI3.NumObservations;

fprintf('SE = %.4f\n', SE);
fprintf('F = %.2f, Significance F = %.3e, Observations = %d\n', Fstat, pF, nObs);

disp(mdl_RSSI3.Coefficients)

%% SNR Model
fprintf('\n--- SNR MODEL ---\n');

mdl_SNR1 = fitlm(data, 'SNR ~ Distance + Height + Foliage + Distance2 + Height2 + Distance:Foliage + Height:Foliage');
fprintf('Model 1A (Basic+Interactions): R² = %.4f, Adj R² = %.4f\n',mdl_SNR1.Rsquared.Ordinary, mdl_SNR1.Rsquared.Adjusted);

SE = mdl_SNR1.RMSE;
anovaTable = anova(mdl_SNR1);
Fstat = anovaTable.F(1);
pF = anovaTable.pValue(1);
nObs = mdl_SNR1.NumObservations;

fprintf('SE = %.4f\n', SE);
fprintf('F = %.2f, Significance F = %.3e, Observations = %d\n', Fstat, pF, nObs);

disp(mdl_SNR1.Coefficients)