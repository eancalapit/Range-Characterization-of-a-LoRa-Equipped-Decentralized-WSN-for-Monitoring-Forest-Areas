%% Define distances and heights to evaluate
distances = 10:10:150;    % meters
heights = 1:0.5:2.5;      % meters
foliage_values = [0 1];   % 0 = LOS, 1 = Foliage

%% Preallocate arrays to store results
num_entries = length(distances) * length(heights) * length(foliage_values);
Distance_col = zeros(num_entries,1);
Height_col = zeros(num_entries,1);
Foliage_col = zeros(num_entries,1);
Predicted_RSSI_col = zeros(num_entries,1);
Predicted_SNR_col = zeros(num_entries,1);

idx = 1;
for f = 1:length(foliage_values)
    for d = distances
        for h = heights
            Distance = d;
            Height = h;
            Foliage = foliage_values(f);
            Distance2 = Distance^2;
            Height2 = Height^2;
            FSPL = 20*log10(Distance) + 20*log10(433) - 27.55;
            two_ray = 40*log10(Distance) - 20*log10(Height);
            Distance_Height = Distance * Height;
            Distance_Foliage = Distance * Foliage;
            Height_Foliage = Height * Foliage;

            % RSSI prediction using the comprehensive model coefficients
            y_RSSI = -411.27 + 2.059*Distance -164.76*Height -18.571*Foliage -0.016559*Distance2 + 25.521*Height2 +0.10518*Distance_Height +0.22763*Distance_Foliage +0.30469*Height_Foliage +22.621*FSPL -13.736*two_ray + 4.3297;

            % SNR prediction using basic+interact model coefficients
            y_SNR = 13.338 +0.090909*Distance -3.419*Height -1.3876*Foliage -0.0012105*Distance2 +1.0859*Height2 -0.020823*Distance_Foliage +1.0641*Height_Foliage;

            % Store values
            Distance_col(idx) = Distance;
            Height_col(idx) = Height;
            Foliage_col(idx) = Foliage;
            Predicted_RSSI_col(idx) = y_RSSI;
            Predicted_SNR_col(idx) = y_SNR;
            idx = idx + 1;
        end
    end
end

%% Create CSV
table = table(Distance_col, Height_col, Foliage_col, Predicted_RSSI_col, Predicted_SNR_col,...
    'VariableNames', {'Distance', 'Height', 'Foliage', 'Predicted_RSSI', 'Predicted_SNR'});
writetable(table, 'RSSI_SNR_Predictions.csv');
fprintf('CSV file "RSSI_SNR_Predictions.csv" created with %d rows.\n', height(table));