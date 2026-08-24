function analyzeServoLog(logName)
% Plot and quantify servo-angle stability from a bridge CSV log.
if nargin == 0
    [file, path] = uigetfile("servo-log-*.csv", "Choose a servo log");
    if isequal(file, 0), return, end
    logName = fullfile(path, file);
end
data = readtable(logName);
time = datetime(data.timestamp, "InputFormat", "yyyy-MM-dd'T'HH:mm:ss.SSS");
angle = data.smoothed_angle;
figure("Name", "Servo telemetry", "Color", "white");
tiledlayout(2, 1, "TileSpacing", "compact");
nexttile; plot(time, angle, "-", "LineWidth", 1.5); grid on;
ylabel("Angle (degrees)"); title("Smoothed servo angle");
nexttile; histogram(diff(angle), -15:1:15); grid on;
xlabel("Change between accepted samples (degrees)"); ylabel("Count");
title(sprintf("Accepted samples: %d | Standard deviation: %.2f degrees", numel(angle), std(angle)));
end
