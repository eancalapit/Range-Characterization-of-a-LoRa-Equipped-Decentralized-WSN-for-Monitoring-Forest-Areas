%% Load data
data = readtable('data-2-node-setup.csv');

%% Extract data subsets
los_data = data(data.Foliage == 0, :);
foliage_data = data(data.Foliage == 1, :);

%% RSSI
figure('Position', [100 100 800 600], 'Name', 'Figure 1');

% Top-left: RSSI vs Distance (LOS)
subplot(2,2,1);
scatter(los_data.Distance, los_data.RSSI, 40, [0 0.447 0.741], 'filled', 'MarkerFaceAlpha', 0.6);
xlabel('Distance (m)'); ylabel('RSSI (dB)');
title('LOS: RSSI vs Distance'); grid on;
p = polyfit(los_data.Distance, los_data.RSSI, 1);
xlim([0 100]);
hold on; plot(xlim, polyval(p, xlim), 'k-', 'LineWidth', 0.75);

slope = p(1);
text(0.05, 0.05, sprintf('Slope = %.2f', slope), ...
     'Units', 'normalized', 'FontSize', 6);

% Top-right: RSSI vs Distance (Foliage)
subplot(2,2,2);
scatter(foliage_data.Distance, foliage_data.RSSI, 40, [0.85 0.325 0.098], 'filled', 'MarkerFaceAlpha', 0.6);
xlabel('Distance (m)'); ylabel('RSSI (dB)');
title('Foliage: RSSI vs Distance'); grid on;
p = polyfit(foliage_data.Distance, foliage_data.RSSI, 1);
xlim([0 100]);
hold on; plot(xlim, polyval(p, xlim), 'k-', 'LineWidth', 0.75);

slope = p(1);
text(0.05, 0.05, sprintf('Slope = %.2f', slope), ...
     'Units', 'normalized', 'FontSize', 6);

% Bottom-left: RSSI vs Height (LOS)
subplot(2,2,3);
scatter(los_data.Height, los_data.RSSI, 40, [0 0.447 0.741], 'filled', 'MarkerFaceAlpha', 0.6);
xlabel('Height (m)'); ylabel('RSSI (dB)');
title('LOS: RSSI vs Height'); grid on;
p = polyfit(los_data.Height, los_data.RSSI, 1);
xlim([0 3]);
hold on; plot(xlim, polyval(p, xlim), 'k-', 'LineWidth', 0.75);

slope = p(1);
text(0.05, 0.05, sprintf('Slope = %.2f', slope), ...
     'Units', 'normalized', 'FontSize', 6);

% Bottom-right: RSSI vs Height (Foliage)
subplot(2,2,4);
scatter(foliage_data.Height, foliage_data.RSSI, 40, [0.85 0.325 0.098], 'filled', 'MarkerFaceAlpha', 0.6);
xlabel('Height (m)'); ylabel('RSSI (dB)');
title('Foliage: RSSI vs Height'); grid on;
p = polyfit(foliage_data.Height, foliage_data.RSSI, 1);
xlim([0 3]);
hold on; plot(xlim, polyval(p, xlim), 'k-', 'LineWidth', 0.75);

slope = p(1);
text(0.05, 0.05, sprintf('Slope = %.2f', slope), ...
     'Units', 'normalized', 'FontSize', 6);

% Adjust layout
sgtitle('RSSI vs Distance and Height Under Different Conditions (2 Nodes)');
set(gcf, 'Color', 'w'); % White background

exportgraphics(gcf, 'RSSI vs Distance and Height 2 Nodes.png', 'Resolution', 600);

%% SNR
figure('Position', [100 100 800 600], 'Name', 'Figure 2');

% Top-left: SNR vs Distance (LOS)
subplot(2,2,1);
scatter(los_data.Distance, los_data.SNR, 40, [0 0.447 0.741], 'filled', 'MarkerFaceAlpha', 0.6);
xlabel('Distance (m)'); ylabel('SNR (dB)');
title('LOS: SNR vs Distance'); grid on;
p = polyfit(los_data.Distance, los_data.SNR, 1);
xlim([0 100]);
hold on; plot(xlim, polyval(p, xlim), 'k-', 'LineWidth', 0.75);

slope = p(1);
text(0.05, 0.05, sprintf('Slope = %.2f', slope), ...
     'Units', 'normalized', 'FontSize', 6);

% Top-right: SNR vs Distance (Foliage)
subplot(2,2,2);
scatter(foliage_data.Distance, foliage_data.SNR, 40, [0.85 0.325 0.098], 'filled', 'MarkerFaceAlpha', 0.6);
xlabel('Distance (m)'); ylabel('SNR (dB)');
title('Foliage: SNR vs Distance'); grid on;
xlim([0 100]);
p = polyfit(foliage_data.Distance, foliage_data.SNR, 1);
hold on; plot(xlim, polyval(p, xlim), 'k-', 'LineWidth', 0.75);

slope = p(1);
text(0.05, 0.05, sprintf('Slope = %.2f', slope), ...
     'Units', 'normalized', 'FontSize', 6);

% Bottom-left: SNR vs Height (LOS)
subplot(2,2,3);
scatter(los_data.Height, los_data.SNR, 40, [0 0.447 0.741], 'filled', 'MarkerFaceAlpha', 0.6);
xlabel('Height (m)'); ylabel('SNR (dB)');
title('LOS: SNR vs Height'); grid on;
p = polyfit(los_data.Height, los_data.SNR, 1);
xlim([0 3]);
hold on; plot(xlim, polyval(p, xlim), 'k-', 'LineWidth', 0.75);

slope = p(1);
text(0.05, 0.05, sprintf('Slope = %.2f', slope), ...
     'Units', 'normalized', 'FontSize', 6);

% Bottom-right: SNR vs Height (Foliage)
subplot(2,2,4);
scatter(foliage_data.Height, foliage_data.SNR, 40, [0.85 0.325 0.098], 'filled', 'MarkerFaceAlpha', 0.6);
xlabel('Height (m)'); ylabel('SNR (dB)');
title('Foliage: SNR vs Height'); grid on;
p = polyfit(foliage_data.Height, foliage_data.SNR, 1);
xlim([0 3]);
hold on; plot(xlim, polyval(p, xlim), 'k-', 'LineWidth', 0.75);

slope = p(1);
text(0.05, 0.05, sprintf('Slope = %.2f', slope), ...
     'Units', 'normalized', 'FontSize', 6);

% Adjust layout
sgtitle('SNR vs Distance and Height Under Different Conditions (2 Nodes)');
set(gcf, 'Color', 'w'); % White background

exportgraphics(gcf, 'SNR vs Distance and Height 2 Nodes.png', 'Resolution', 600);