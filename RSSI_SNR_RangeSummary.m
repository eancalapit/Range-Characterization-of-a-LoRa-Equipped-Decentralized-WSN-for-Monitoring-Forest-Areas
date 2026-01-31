clc;
clear;

%% Read datasets
data2 = readtable('data-2-node-setup.csv');
data4 = readtable('data-4-node-setup.csv');

%% Initialize result structure
Summary = {};

row = 1;

%% Helper functions for range extraction and averages
getRange = @(x) sprintf('%g – %g', min(x,[],'omitnan'), max(x,[],'omitnan'));
getAverage = @(x) sprintf('%.1f', mean(x, 'omitnan'));  % Average function with 1 decimal place

%% 2-NODE SETUP
% --- 2-node LOS, 10–30 m ---
idx = (data2.Foliage == 0) & data2.Distance >= 10 & data2.Distance <= 30;
Summary(row,:) = {'2-Node','LOS','10–30','1.0–2.5', ...
    getRange(data2.RSSI(idx)), getRange(data2.SNR(idx)), ...
    getAverage(data2.RSSI(idx)), getAverage(data2.SNR(idx))};
row = row + 1;

% --- 2-node LOS, 40–70 m ---
idx = (data2.Foliage == 0) & data2.Distance >= 40 & data2.Distance <= 70;
Summary(row,:) = {'2-Node','LOS','40–70','1.0–2.5', ...
    getRange(data2.RSSI(idx)), getRange(data2.SNR(idx)), ...
    getAverage(data2.RSSI(idx)), getAverage(data2.SNR(idx))};
row = row + 1;

% --- 2-node Foliage, 9.67–31.82 m ---
idx = (data2.Foliage == 1) & data2.Distance >= 9.67 & data2.Distance <= 31.82;
Summary(row,:) = {'2-Node','Foliage','9.67–31.82','1.0–2.5', ...
    getRange(data2.RSSI(idx)), getRange(data2.SNR(idx)), ...
    getAverage(data2.RSSI(idx)), getAverage(data2.SNR(idx))};
row = row + 1;

% --- 2-node Foliage, 53.58–80 m ---
idx = (data2.Foliage == 1) & data2.Distance >= 53.58 & data2.Distance <= 80;
Summary(row,:) = {'2-Node','Foliage','53.58–80','1.0–2.5', ...
    getRange(data2.RSSI(idx)), getRange(data2.SNR(idx)), ...
    getAverage(data2.RSSI(idx)), getAverage(data2.SNR(idx))};
row = row + 1;

% --- 2-node Foliage, 80.78-83.19 m ---
idx = (data2.Foliage == 1) & data2.Distance >= 80.78 & data2.Distance <= 83.19;
Summary(row,:) = {'2-Node','Foliage','80.78-83.19','1.0–2.5', ...
    getRange(data2.RSSI(idx)), getRange(data2.SNR(idx)), ...
    getAverage(data2.RSSI(idx)), getAverage(data2.SNR(idx))};
row = row + 1;

%% 4-NODE SETUP

% --- 4-node LOS, 108–110 m ---
idx = (data4.Foliage == 0) & data4.Distance >= 108 & data4.Distance <= 110;
Summary(row,:) = {'4-Node','LOS','108–110','1.5–2.0', ...
    getRange(data4.RSSI(idx)), getRange(data4.SNR(idx)), ...
    getAverage(data4.RSSI(idx)), getAverage(data4.SNR(idx))};
row = row + 1;

% --- 4-node Foliage, 82–94 m ---
idx = (data4.Foliage == 1) & data4.Distance >= 82 & data4.Distance <= 94;
Summary(row,:) = {'4-Node','Foliage','82–94','1.5–2.0', ...
    getRange(data4.RSSI(idx)), getRange(data4.SNR(idx)), ...
    getAverage(data4.RSSI(idx)), getAverage(data4.SNR(idx))};
row = row + 1;

% --- 4-node Foliage, 126–148 m ---
idx = (data4.Foliage == 1) & data4.Distance >= 126 & data4.Distance <= 148;
Summary(row,:) = {'4-Node','Foliage','126–148','1.5–2.0', ...
    getRange(data4.RSSI(idx)), getRange(data4.SNR(idx)), ...
    getAverage(data4.RSSI(idx)), getAverage(data4.SNR(idx))};

%% Convert to table

SummaryTable = cell2table(Summary, ...
    'VariableNames', {'Network Setup','Environment','Distance Range (m)', ...
    'Antenna Height Range (m)', 'RSSI Range (dBm)','SNR Range (dB)', ...
    'Average RSSI (dBm)', 'Average SNR (dB)'});

disp(SummaryTable);

%% Export to CSV
writetable(SummaryTable,'RSSI_SNR_Range_Summary.csv');