%% Load data
data = readtable('data-2-node-setup.csv');
fprintf('Dataset size: %d observations, %d variables\n', size(data));
fprintf('Variables: %s\n', strjoin(data.Properties.VariableNames, ', '));

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
% Free Space Path Loss 
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

fprintf('Added %d new features\n', width(data) - 5); % Subtract original 5 columns

%% Basic Statistics
fprintf('\n=== DATA STATISTICS ===\n');
fprintf('RSSI range: %.2f to %.2f dBm\n', min(data.RSSI), max(data.RSSI));
fprintf('SNR range: %.2f to %.2f dB\n', min(data.SNR), max(data.SNR));
fprintf('Distance range: %.2f to %.2f m\n', min(data.Distance), max(data.Distance));
fprintf('Foliage range: %.2f to %.2f\n', min(data.Foliage), max(data.Foliage));

%% MODEL 1: Enhanced Linear Regression with Feature Selection
fprintf('\n=== MODEL 1: ENHANCED LINEAR REGRESSION ===\n');

% RSSI Models
fprintf('\n--- RSSI MODELS ---\n');

% Model 1A: Basic with interactions
mdl_RSSI1 = fitlm(data, 'RSSI ~ Distance + Height + Foliage + Distance2 + Height2 + Distance:Foliage + Height:Foliage');
fprintf('Model 1A (Basic+Interactions): R² = %.4f, Adj R² = %.4f\n', ...
        mdl_RSSI1.Rsquared.Ordinary, mdl_RSSI1.Rsquared.Adjusted);

% Model 1B: With physics-based features
mdl_RSSI2 = fitlm(data, 'RSSI ~ Distance + Height + Foliage + FSPL + two_ray + env_attenuation + Distance:Foliage');
fprintf('Model 1B (Physics-based): R² = %.4f, Adj R² = %.4f\n', ...
        mdl_RSSI2.Rsquared.Ordinary, mdl_RSSI2.Rsquared.Adjusted);

% Model 1C: Comprehensive model
mdl_RSSI3 = fitlm(data, 'RSSI ~ Distance + Height + Foliage + Distance2 + Height2 + FSPL + two_ray + Distance_Height + Distance_Foliage + Height_Foliage');
fprintf('Model 1C (Comprehensive): R² = %.4f, Adj R² = %.4f\n', ...
        mdl_RSSI3.Rsquared.Ordinary, mdl_RSSI3.Rsquared.Adjusted);

% Model 1D: Using positive-transformed RSSI
mdl_RSSI4 = fitlm(data, 'RSSI_positive ~ log_Distance + Height + sqrt_Foliage + FSPL + two_ray');
fprintf('Model 1D (Positive RSSI): R² = %.4f, Adj R² = %.4f\n', ...
        mdl_RSSI4.Rsquared.Ordinary, mdl_RSSI4.Rsquared.Adjusted);

% Convert R-squared back to original scale for interpretation
y_pred_pos = predict(mdl_RSSI4);
y_pred_original = -y_pred_pos;  % Convert back to original RSSI scale
rsq_original = 1 - sum((data.RSSI - y_pred_original).^2) / sum((data.RSSI - mean(data.RSSI)).^2);
fprintf('Model 1D (Original RSSI scale): R² = %.4f\n', rsq_original);

% SNR Models
fprintf('\n--- SNR MODELS ---\n');

mdl_SNR1 = fitlm(data, 'SNR ~ Distance + Height + Foliage + Distance2 + Height2 + Distance:Foliage + Height:Foliage');
fprintf('Model 1A (Basic+Interactions): R² = %.4f, Adj R² = %.4f\n', ...
        mdl_SNR1.Rsquared.Ordinary, mdl_SNR1.Rsquared.Adjusted);

mdl_SNR2 = fitlm(data, 'SNR ~ Distance + Height + Foliage + FSPL + two_ray + env_attenuation');
fprintf('Model 1B (Physics-based): R² = %.4f, Adj R² = %.4f\n', ...
        mdl_SNR2.Rsquared.Ordinary, mdl_SNR2.Rsquared.Adjusted);

%% MODEL 2: Stepwise Regression for Automated Feature Selection
fprintf('\n=== MODEL 2: STEPWISE REGRESSION ===\n');

% For RSSI
predictors_RSSI = {'Distance', 'Height', 'Foliage', 'Distance2', 'Height2', ...
                  'FSPL', 'two_ray', 'env_attenuation', 'Distance_Height', ...
                  'Distance_Foliage', 'Height_Foliage'};
X_RSSI = data{:, predictors_RSSI};
y_RSSI = data.RSSI;

mdl_step_RSSI = stepwiselm(X_RSSI, y_RSSI, 'linear', 'Criterion', 'rsquared', 'Verbose', 0);
fprintf('Stepwise RSSI Model R² = %.4f\n', mdl_step_RSSI.Rsquared.Ordinary);

% For SNR
X_SNR = data{:, predictors_RSSI};  % Same predictors
y_SNR = data.SNR;

mdl_step_SNR = stepwiselm(X_SNR, y_SNR, 'linear', 'Criterion', 'rsquared', 'Verbose', 0);
fprintf('Stepwise SNR Model R² = %.4f\n', mdl_step_SNR.Rsquared.Ordinary);

%% MODEL 3: Non-linear approaches
fprintf('\n=== MODEL 3: NON-LINEAR TRANSFORMATIONS ===\n');

% Try different response transformations
try
    % Using squared terms only (safe)
    mdl_poly_RSSI = fitlm(data, 'RSSI ~ Distance + Height + Foliage + Distance2 + Height2 + Distance3 + Height3 + Distance:Foliage:Height');
    fprintf('Polynomial RSSI Model R² = %.4f\n', mdl_poly_RSSI.Rsquared.Ordinary);
catch ME
    fprintf('Full polynomial model failed, trying reduced model...\n');
    % Reduced model
    mdl_poly_RSSI = fitlm(data, 'RSSI ~ Distance + Height + Foliage + Distance2 + Height2 + Distance_Foliage');
    fprintf('Reduced Polynomial RSSI Model R² = %.4f\n', mdl_poly_RSSI.Rsquared.Ordinary);
end

% Try exponential model form: RSSI = a * exp(b*Distance) + ...
data.exp_Distance = exp(-0.1 * data.Distance);  % Exponential decay term
mdl_exp_RSSI = fitlm(data, 'RSSI ~ exp_Distance + Height + Foliage + Distance_Foliage');
fprintf('Exponential Decay RSSI Model R² = %.4f\n', mdl_exp_RSSI.Rsquared.Ordinary);

%% Cross-Validation
fprintf('\n=== CROSS-VALIDATION ASSESSMENT ===\n');

% Simple 70-30 split
rng(42); % For reproducibility
cv = cvpartition(height(data), 'HoldOut', 0.3);
idx_train = training(cv);
idx_test = test(cv);

% Train best RSSI model on training data
mdl_final_RSSI = fitlm(data(idx_train,:), 'RSSI ~ Distance + Distance2 + Foliage + FSPL + Distance_Foliage');
y_pred_test = predict(mdl_final_RSSI, data(idx_test,:));
rsq_test = 1 - sum((data.RSSI(idx_test) - y_pred_test).^2) / sum((data.RSSI(idx_test) - mean(data.RSSI(idx_test))).^2);
fprintf('Final RSSI Model - Train R² = %.4f, Test R² = %.4f\n', ...
        mdl_final_RSSI.Rsquared.Ordinary, rsq_test);

%% Summary of Best Models
fprintf('\n=== BEST MODELS SUMMARY ===\n');
fprintf('RSSI Models:\n');
models_rssi = [mdl_RSSI1.Rsquared.Ordinary, mdl_RSSI2.Rsquared.Ordinary, ...
               mdl_RSSI3.Rsquared.Ordinary, rsq_original, ...
               mdl_step_RSSI.Rsquared.Ordinary];
model_names = {'Basic+Interact', 'Physics-based', 'Comprehensive', 'Positive Transform', 'Stepwise'};

[best_rssi_r2, best_idx] = max(models_rssi);
fprintf('  Best RSSI Model: %s with R² = %.4f\n', model_names{best_idx}, best_rssi_r2);

fprintf('\nSNR Models:\n');
models_snr = [mdl_SNR1.Rsquared.Ordinary, mdl_SNR2.Rsquared.Ordinary, mdl_step_SNR.Rsquared.Ordinary];
snr_names = {'Basic+Interact', 'Physics-based', 'Stepwise'};

[best_snr_r2, best_snr_idx] = max(models_snr);
fprintf('  Best SNR Model: %s with R² = %.4f\n', snr_names{best_snr_idx}, best_snr_r2);

%% Feature Importance Analysis
fprintf('\n=== FEATURE IMPORTANCE ===\n');
fprintf('Top features for RSSI prediction:\n');
[~, idx] = sort(abs(corr(X_RSSI, data.RSSI)), 'descend');
for i = 1:min(5, length(predictors_RSSI))
    feat_idx = idx(i);
    fprintf('  %s: correlation = %.3f\n', predictors_RSSI{feat_idx}, corr(X_RSSI(:,feat_idx), data.RSSI));
end

fprintf('\n=== ANALYSIS COMPLETE ===\n');