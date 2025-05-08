% Set number of frames to animate
num_frames = 200;

% Set length of every frame in seconds
frametime = 0.02;

% Set number of TCAS-equipped aircraft
num_units = 3;

% Initialize position arrays to zero
pos = zeros(num_units, num_frames, 3);

% Set initial coordinates
pos(1, 1, :) = [30 40 14000];
pos(2, 1, :) = [35 45 13500];
pos(3, 1, :) = [60 80 10500]; 

% Calculate factor for converting nmi/hr to nmi/frame
factor = (1/60/60)*frametime;

% Set velocities of aircraft
vel = zeros(num_units, 3);
vel(1, :) = [136, 124, 1]*factor;
vel(2, :) = [150, 178, 1]*factor;
vel(3, :) = [191, 110, 1]*factor;

% Calculate position
for i = 2:num_frames
    for j = 1:num_units
        pos(j, i, :) = pos(j, i-1, :)+vel(j);
    end
end

% Create the figure and initialize the plots
figure;
axis equal; % Ensure proper scaling for circles and ellipses
xlabel('X (nmi)'); ylabel('Y (nmi)');

% Plot the first frame
h = zeros(1, num_units);
hold on
h(1) = plot(pos(1, 1, 1), pos(1, 1, 2), '^', 'Color', [0,0,0]); 
h(2) = plot(pos(2, 1, 1), pos(2, 1, 2), 'go'); 
h(3) = plot(pos(3, 1, 1), pos(3, 1, 2), 'bo'); 
hold off

% Animate the points
for i = 1:num_frames
    % Update each point's position
    for j = 1:num_units
        set(h(j), 'XData', pos(j, i, 1), 'YData', pos(j, i, 2));
    end
    drawnow; % Force MATLAB to redraw
    pause(frametime); % Control the speed of the animation
end
