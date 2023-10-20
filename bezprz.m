% Tower coordinates
tower_x = 140; % x coordinate of the tower in meters
tower_y = 50; % y coordinate of the tower in meters

% Object initial coordinates and speed
object_start_x = 30; % initial x coordinate of the object in meters
object_start_y = 10; % initial y coordinate of the object in meters
object_end_x = 30; % final x coordinate of the object in meters
object_end_y = 130; % final y coordinate of the object in meters
speed = 20; % speed of the object in m/s

% Given parameters
power = 5; % power in Watts
frequency = 2e9; % frequency in Hz
lambda = 3e8/frequency; % wavelength in meters

% Time parameters
t = 0:0.01:6; % Time array from 0 to 6 seconds with a step of 10 ms

% Wall coordinates
wall1_start_x = 60; % wall 1 start x coordinate in meters
wall1_end_x = 200; % wall 1 end x coordinate in meters
wall1_y = 40; % wall 1 y coordinate in meters
wall2_start_x = 70; % wall 2 start x coordinate in meters
wall2_end_x = 180; % wall 2 end x coordinate in meters
wall2_y = 90; % wall 2 y coordinate in meters

% Reflectivity
reflectivity = 0.7;

% Calculate position of the object over time
object_x = object_start_x * ones(size(t));
object_y = object_start_y + ((object_end_y - object_start_y) / 6) * t; % Assuming constant acceleration

% Calculate signal strength over time considering reflection
signal_strength = zeros(size(t));
for i = 1:length(t)
    distance1 = sqrt((object_x(i) - tower_x)^2 + (object_y(i) - tower_y)^2); % distance to object
    distance_wall1 = abs(object_y(i) - wall1_y); % distance to wall 1
    distance_wall2 = abs(object_y(i) - wall2_y); % distance to wall 2

    % Signal bounces off the first wall
    distance_refl_1 = sqrt((object_x(i) - wall1_start_x)^2 + (object_y(i) - wall1_y)^2) + sqrt((wall1_end_x - tower_x)^2 + (wall1_y - tower_y)^2);
    signal_refl_1 = reflectivity * power * (lambda / (4 * pi * distance_refl_1))^2;

    % Signal bounces off the second wall
    distance_refl_2 = sqrt((object_x(i) - wall2_start_x)^2 + (object_y(i) - wall2_y)^2) + sqrt((wall2_end_x - tower_x)^2 + (wall2_y - tower_y)^2);
    signal_refl_2 = reflectivity * power * (lambda / (4 * pi * distance_refl_2))^2;

    signal_strength(i) = power * (lambda / (4 * pi * distance1))^2 + signal_refl_1 + signal_refl_2;
end

% Display results
disp('Time (s)     Signal Strength (Watts)');
disp([t', signal_strength']);

% Plotting the signal strength over time
figure;
plot(t, signal_strength, 'b', 'LineWidth', 2);
xlabel('Time (s)');
ylabel('Signal Strength (Watts)');
title('Signal Strength Analysis over Time with Reflections');

% Plotting the signal strength over time with the walls, object, and tower
figure;
plot(t, signal_strength, 'b', 'LineWidth', 2);
hold on;
plot([tower_x, object_end_x], [tower_y, object_end_y], 'r--', 'LineWidth', 1.5); % plot tower to object path
plot([wall1_start_x, wall1_end_x], [wall1_y, wall1_y], 'g', 'LineWidth', 2); % plot wall 1
plot([wall2_start_x, wall2_end_x], [wall2_y, wall2_y], 'm', 'LineWidth', 2); % plot wall 2
plot(object_x, object_y, 'k', 'LineWidth', 2); % plot object path
plot(tower_x, tower_y, 'ro', 'MarkerSize', 10, 'LineWidth', 2); % plot tower

xlabel('X-coordinate (in meters)');
ylabel('Y-coordinate (in meters)');
title('Signal Strength Analysis over Time with Reflections');

legend('Signal Strength', 'Tower to Object Path', 'Wall 1', 'Wall 2', 'Object Path', 'Tower');
