clf
clear all
close all

% Squawk codes for all units
squawk_codes = containers.Map([1, 2, 3], [1, 2, 3]);

% Set length of every frame in seconds
frametime = 0.02;

% Set number of frames to animate
num_frames = 60/frametime;

% Set number of TCAS-equipped aircraft
num_units = 3;

% Set modes for each unit
% 0 - Stand-by
% 1 - Transponder
% 2 - TA Only
% 3 - TA/RA
modes = zeros(1, num_units);
modes(1) = 2;
modes(2) = 3;
modes(3) = 3;

% Initialize position arrays to zero
pos = zeros(num_units, num_frames, 3);

% Set initial coordinates
pos(1, 1, :) = [33 43 1000];
pos(2, 1, :) = [32 42 1200];
pos(3, 1, :) = [34 44 1700]; 

% Calculate factor for converting nmi/hr to nmi/frame
factor = (1/60/60)*frametime;

% Set velocities of aircraft
% Velocity is ordered as [X, Y, Z] and units are [nmi, nmi, ft/hr]
vel = zeros(num_units, 3);
vel(1, :) = [-136, 124, 100]*factor;
vel(2, :) = [-1000, -1000, 500]*factor;
vel(3, :) = [1000, 1000, -500]*factor;

% Calculate position
for i = 2:num_frames
    for j = 1:num_units
        pos(j, i, :) = pos(j, i-1, :)+vel(j);
    end
end

% Create the figure and initialize the plots
figure('Name', 'RA Display', 'NumberTitle', 'off');
axis equal; % Ensure proper scaling for circles and ellipses
xlabel('X (nmi)'); ylabel('Y (nmi)');

% Create multiple TCAS units
units = cell(1, num_units);
for i = 1:num_units
    units{i} = TCAS(squawk_codes(i), modes(i), squeeze(pos(i, 1, :))', vel(i, 3));
end

% Plot the first frame
h = zeros(1, num_units);
t = zeros(1, num_units-1);
hold on
h(1) = plot(pos(1, 1, 1), pos(1, 1, 2), '^', 'Color', 'k'); 
h(2) = plot(pos(2, 1, 1), pos(2, 1, 2), 'diamond', 'Color', 'k'); 
h(3) = plot(pos(3, 1, 1), pos(3, 1, 2), 'diamond', 'Color', 'k'); 
t(1) = text('Color', 'w');
t(2) = text('Color', 'w');
hold off

% Animate the points
for i = 1:num_frames
    % Get all advisories in airspace not from this unit
    all_advisories = [];
    coords = cell(1, num_units-1);
    curr_coords_idx = 1;   
    for j = 2:num_units
        coords{curr_coords_idx} = units{j}.getCoords();
        curr_coords_idx = curr_coords_idx+1;
    end
    coords = coords(~cellfun('isempty', coords));
    advisories = units{1}.getAdvisories(coords);
    % Update each point's position
    for j = 1:num_units
        % Set coords in unit
        units{j} = units{j}.setCoords(squeeze(pos(j, i, :))');
        % Set coords in plot
        % If not on main unit
        if j > 1
            % Check if advisory was generated for this unit
            found_advisory = 0;
            for k = 2:size(advisories, 2)
                if advisories{k}(1) == squawk_codes(j) && advisories{k}(3) > 0
                    advisory = advisories{k};
                    found_advisory = 1;
                    break
                end
            end
            % No advisory
            if ~found_advisory
                % If coords are transmitting
                if size(units{j}.getCoords(), 2) > 0
                    color = 'k';
                    set(h(j), 'XData', pos(j, i, 1), 'YData', pos(j, i, 2), 'Marker', 'diamond', 'Color', color); 
                else
                    color = 'w';
                    set(h(j), 'Color', color)
                end

            % TA
            elseif advisory(3) == 1
                color = [0.9290 0.6940 0.1250];
                set(h(j), 'XData', pos(j, i, 1), 'YData', pos(j, i, 2), 'Marker', 'o', 'Color', color);
            % RA
            elseif advisory(3) == 2
                color = 'r';
                set(h(j), 'XData', pos(j, i, 1), 'YData', pos(j, i, 2), 'Marker', 'square', 'Color', 'r');
            end
            % Set text
            if size(advisories, 2) > 1
                % Descending
                if advisories{k}(4) < 0
                    str = sprintf('%.0f ft v', advisories{k}(2));
                elseif advisories{k}(4) > 0
                    str = sprintf('%.0f ft ^', advisories{k}(2));
                else
                    str = sprintf('%.0f ft', advisories{k}(2));
                end
                set(t(j-1), 'Position', [pos(j, i, 1)+0.5, pos(j, i, 2), 0], 'String', str, 'Color', color);
            else
                set(t(j-1), 'Color', 'w');
            end
            clear advisory
        else
            set(h(j), 'XData', pos(j, i, 1), 'YData', pos(j, i, 2));
        end
    end
    % Center plot around first unit, change axis relative to that unit
    xlim([pos(1, i, 1)-6, pos(1, i, 1)+6])
    ylim([pos(1, i, 2)-6, pos(1, i, 2)+6])
    xticks(pos(1, i, 1)-6:1:pos(1, i, 1)+6)
    xticklabels({'-6', '-5', '-4', '-3', '-2', '-1', '0', '1', '2', '3', '4', '5', '6'})
    yticks(pos(1, i, 2)-6:1:pos(1, i, 2)+6)
    yticklabels({'-6', '-5', '-4', '-3', '-2', '-1', '0', '1', '2', '3', '4', '5', '6'})
    % Force MATLAB to redraw
    drawnow; 
    % Control the speed of the animation
    pause(frametime); 
end
