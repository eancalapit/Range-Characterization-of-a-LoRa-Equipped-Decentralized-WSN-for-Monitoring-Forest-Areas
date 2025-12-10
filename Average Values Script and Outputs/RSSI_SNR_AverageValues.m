%% 2 Node Setup
% Load CSV
data = readtable('data-2-node-setup.csv');

%% Filter LOS (Foliage = 0)
data_LOS = data(data.Foliage == 0, :);

% Define distance and height bins
distances = 10:10:70;
heights = 1:0.5:2.5;

% Preallocate tables
rssi_summary = array2table(NaN(length(distances), length(heights)), ...
    'VariableNames', strcat('Height_', strrep(string(heights), '.', '_')));
rssi_summary.Distance = distances';

snr_summary = array2table(NaN(length(distances), length(heights)), ...
    'VariableNames', strcat('Height_', strrep(string(heights), '.', '_')));
snr_summary.Distance = distances';

% Compute averages for each distance-height combination
for i = 1:length(distances)
    for j = 1:length(heights)
        mask = data_LOS.Distance == distances(i) & data_LOS.Height == heights(j);
        if any(mask)
            rssi_summary{i, j} = mean(data_LOS.RSSI(mask));
            snr_summary{i, j}  = mean(data_LOS.SNR(mask));
        end
    end
end

% Write to CSV
writetable(rssi_summary, 'RSSI_LOS_summary.csv');
writetable(snr_summary,  'SNR_LOS_summary.csv');

% Count total number of samples used for averaging
total_samples = sum(data_LOS.Distance >= 10 & data_LOS.Distance <= 70 & ...
                    data_LOS.Height >= 1 & data_LOS.Height <= 2.5);

disp(['Total number of samples used for LOS averaging (2 nodes): ', num2str(total_samples)]);

%% Filter only foliage measurements (Foliage ~= 0)
foliageData = data(data.Foliage ~= 0, :);

% Define distances and heights
distances = [9.67, 31.82, 53.58, 61.01, 80, 80.78, 83.19];
heights = 1:0.5:2.5; 

% Initialize tables
rssi_summary = table();
snr_summary = table();

for i = 1:length(distances)
    dist = distances(i);
    rssi_row = zeros(1, length(heights));
    snr_row  = zeros(1, length(heights));
    
    for j = 1:length(heights)
        h = heights(j);
        subset = foliageData(foliageData.Distance == dist & foliageData.Height == h, :);
        
        if ~isempty(subset)
            rssi_row(j) = mean(subset.RSSI);
            snr_row(j)  = mean(subset.SNR);
        else
            rssi_row(j) = NaN;  % mark missing data
            snr_row(j)  = NaN;
        end
    end
    
    % Append to summary tables
    rssi_summary = [rssi_summary; array2table(rssi_row)];
    snr_summary  = [snr_summary; array2table(snr_row)];
end

% Add Distance column
rssi_summary = addvars(rssi_summary, distances', 'Before', 1, 'NewVariableNames', 'Distance');
snr_summary  = addvars(snr_summary,  distances', 'Before', 1, 'NewVariableNames', 'Distance');

% Rename RSSI/SNR columns by height
rssi_summary.Properties.VariableNames(2:end) = strcat("RSSI_h", string(heights));
snr_summary.Properties.VariableNames(2:end)  = strcat("SNR_h",  string(heights));

% Write to CSV
writetable(rssi_summary, 'RSSI_Foliage_Summary.csv');
writetable(snr_summary,  'SNR_Foliage_Summary.csv');

% Count total number of samples used
totalSamples = height(foliageData);
disp(['Total number of samples used for Foliage averaging (2 nodes): ', num2str(totalSamples)]);

%% 4 Node Setup
% Load CSV
data = readtable('data-4-node-setup.csv');

%% Filter LOS (Foliage = 0)
data_LOS = data(data.Foliage == 0, :);

% Define distance and height bins
distances = [108,110];
heights = [1.5,2.0];

% Preallocate tables
rssi_summary = array2table(NaN(length(distances), length(heights)), ...
    'VariableNames', strcat('Height_', strrep(string(heights), '.', '_')));
rssi_summary.Distance = distances';

snr_summary = array2table(NaN(length(distances), length(heights)), ...
    'VariableNames', strcat('Height_', strrep(string(heights), '.', '_')));
snr_summary.Distance = distances';

% Compute averages for each distance-height combination
for i = 1:length(distances)
    for j = 1:length(heights)
        mask = data_LOS.Distance == distances(i) & data_LOS.Height == heights(j);
        if any(mask)
            rssi_summary{i, j} = mean(data_LOS.RSSI(mask));
            snr_summary{i, j}  = mean(data_LOS.SNR(mask));
        end
    end
end

% Write to CSV
writetable(rssi_summary, 'RSSI_LOS_summary_4_nodes.csv');
writetable(snr_summary,  'SNR_LOS_summary_4_nodes.csv');

% Count total number of samples used for averaging
total_samples = height(data_LOS);

disp(['Total number of samples used for LOS averaging (4 nodes): ', num2str(total_samples)]);

%% Filter only foliage measurements (Foliage ~= 0)
foliageData = data(data.Foliage ~= 0, :);

% Define distances and heights
distances = [82,94,126,148];
heights = [1.5,2.0]; 

% Initialize tables
rssi_summary = table();
snr_summary = table();

for i = 1:length(distances)
    dist = distances(i);
    rssi_row = zeros(1, length(heights));
    snr_row  = zeros(1, length(heights));
    
    for j = 1:length(heights)
        h = heights(j);
        subset = foliageData(foliageData.Distance == dist & foliageData.Height == h, :);
        
        if ~isempty(subset)
            rssi_row(j) = mean(subset.RSSI);
            snr_row(j)  = mean(subset.SNR);
        else
            rssi_row(j) = NaN;  % mark missing data
            snr_row(j)  = NaN;
        end
    end
    
    % Append to summary tables
    rssi_summary = [rssi_summary; array2table(rssi_row)];
    snr_summary  = [snr_summary; array2table(snr_row)];
end

% Add Distance column
rssi_summary = addvars(rssi_summary, distances', 'Before', 1, 'NewVariableNames', 'Distance');
snr_summary  = addvars(snr_summary,  distances', 'Before', 1, 'NewVariableNames', 'Distance');

% Rename RSSI/SNR columns by height
rssi_summary.Properties.VariableNames(2:end) = strcat("RSSI_h", string(heights));
snr_summary.Properties.VariableNames(2:end)  = strcat("SNR_h",  string(heights));

% Write to CSV
writetable(rssi_summary, 'RSSI_Foliage_Summary_4_nodes.csv');
writetable(snr_summary,  'SNR_Foliage_Summary_4_nodes.csv');

% Count total number of samples used
totalSamples = height(foliageData);
disp(['Total number of samples used for Foliage averaging (4 nodes): ', num2str(totalSamples)]);
