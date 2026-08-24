function servoSkyBridge(portName)
% Read Arduino angle output, smooth it, log it, and update the UMBRA site.
% Start the Next app first, then run servoSkyBridge("COM3").

if nargin == 0
    ports = serialportlist("available");
    assert(~isempty(ports), "No serial ports found. Connect the Arduino, then try again.");
    portName = ports(1);
    fprintf("Using %s. Pass a port name to choose another port.\n", portName);
end

endpoint = "http://localhost:3000/api/angle";
smoothThreshold = 3;
publishInterval = 0.08; % seconds: send the newest value at most 12.5 times/sec
logName = "servo-log-" + datestr(now, "yyyymmdd-HHMMSS") + ".csv";
logFile = fopen(logName, "w");
assert(logFile > 0, "Could not create %s", logName);
fprintf(logFile, "timestamp,raw_angle,smoothed_angle\n");
cleanup = onCleanup(@() fclose(logFile)); %#ok<NASGU>

device = serialport(portName, 9600);
configureTerminator(device, "LF");
flush(device);
lastAngle = NaN;
lastPublish = datetime("now") - seconds(publishInterval);
pendingPublish = false;
options = weboptions("MediaType", "application/json", "Timeout", 0.5);
fprintf("Streaming %s to %s. Press Ctrl+C to stop.\n", portName, endpoint);

while true
    rawAngle = str2double(strtrim(readline(device)));
    if ~isfinite(rawAngle), continue, end
    rawAngle = min(180, max(0, rawAngle));
    if isnan(lastAngle) || abs(rawAngle - lastAngle) >= smoothThreshold
        lastAngle = rawAngle;
        timestamp = datetime("now", "Format", "yyyy-MM-dd'T'HH:mm:ss.SSS");
        fprintf(logFile, "%s,%.3f,%.3f\n", string(timestamp), rawAngle, lastAngle);
        pendingPublish = true;
    end
    if pendingPublish && seconds(datetime("now") - lastPublish) >= publishInterval
        try
            webwrite(endpoint, struct("angle", lastAngle, "rawAngle", rawAngle), options);
            lastPublish = datetime("now");
            pendingPublish = false;
        catch error
            warning("Could not publish to the web app: %s", error.message);
            lastPublish = datetime("now");
        end
    end
end
end
