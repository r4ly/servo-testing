function createServoModel
% Create a starter Simulink model for testing the 3-degree deadband.
model = "servoSmoothingModel";
if bdIsLoaded(model), close_system(model, 0), end
new_system(model); open_system(model);
add_block("simulink/Sources/Signal Builder", model + "/Noisy angle");
add_block("simulink/Discontinuities/Dead Zone", model + "/3 degree deadband", "LowerValue", "-3", "UpperValue", "3");
add_block("simulink/Discrete/Discrete-Time Integrator", model + "/Held angle", "gainval", "1", "SampleTime", "0.03");
add_block("simulink/Sinks/Scope", model + "/Scope");
add_line(model, "Noisy angle/1", "3 degree deadband/1");
add_line(model, "3 degree deadband/1", "Held angle/1");
add_line(model, "Held angle/1", "Scope/1");
set_param(model, "StopTime", "10");
save_system(model);
fprintf("Created %s.slx. Add a noisy test signal in Signal Builder, then run it.\n", model);
end
