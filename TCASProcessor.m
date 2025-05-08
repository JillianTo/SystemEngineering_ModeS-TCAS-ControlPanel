%%
%% Models TCAS computer unit
%%

classdef TCASProcessor
    properties (Access = private)
        % Array of 3 integer coordinates: X, Y, Z
        coords    
        % Integer representing altitude direction change
        dir
        % Threshold in feet for sending TA
        ta_threshold
        % Threshold in feet for sending TA
        ra_threshold
    end
    methods
        % Constructor
        function obj = TCASProcessor(coords, alt_vel)
            obj.coords = coords;
            obj.ta_threshold = 900;
            obj.ra_threshold = 500;
            if alt_vel < 0
                obj.dir = -1;
            elseif alt_vel > 0
                obj.dir = 1;
            else
                obj.dir = 0;
            end
        end
        % Set coordinates
        function obj = setCoords(obj, coords)
            obj.coords = coords;
        end
        % Get coordinates
        function coords = getCoords(obj)
            coords = obj.coords;
        end
        % Get direction of altitude change
        function dir = getAltDir(obj)
            dir = obj.dir;
        end
        % Determine TAs/RAs from this and other TCAS units' coordinates
        function advisories = processAdvisories(obj, mode, ext_coords)
            if mode < 1
                advisories = cell(1);
            else
                num_ext_coords = size(ext_coords,2);
                advisories = cell(1, num_ext_coords);
                for i = 1:num_ext_coords
                    % If other TCAS unit is within 6 nmi
                    if sqrt((ext_coords{i}(2)-obj.coords(1))^2+(ext_coords{i}(3)-obj.coords(2))^2) < 6
                        % Save current device ID
                        squawk_code = ext_coords{i}(1);
                        % Save altitude direction
                        if ext_coords{i}(5) < 0
                            dir = -1;
                        elseif ext_coords{i}(5) > 0
                            dir = 1;
                        else
                            dir = 0;
                        end
                        % Calculate difference in altitude between another
                        % aircraft and ours
                        alt_diff = ext_coords{i}(4)-obj.coords(3);
                        % Don't transmit TAs or RAs
                        if mode < 2
                            advisories{i} = [squawk_code, alt_diff, 0, dir];
                        % Transmit TAs or RAs
                        else
                            % If the other aircraft is above ours, but a distance 
                            % less than TA threshold 
                            if abs(alt_diff) < obj.ta_threshold
                                % If distance is less than RA threshold, and set to
                                % transmit RAs
                                if mode > 2 && abs(alt_diff) < obj.ra_threshold
                                    % Set advisory to altitude difference, and
                                    % advisory to RA
                                    advisories{i} = [squawk_code, alt_diff, 2, dir];
                                else
                                    % Set advisory to altitude difference, and 
                                    % advisory to TA 
                                    advisories{i} = [squawk_code, alt_diff, 1, dir];
                                end
                            end
                        end
                    end
                end
            end
        end
        % Get advisories sent from other transponders to this
        function filtered_advisories = filterIncomingAdvisories(obj, advisories, squawk_code)
            num_advisories = size(advisories,2);
            filtered_advisories = cell(1);
            for i = num_advisories
                if advisories{i}(1) == squawk_code
                    filtered_advisories = [filtered_advisories, advisories{i}(2:4)];
                end
            end
            % Remove first index in cell array because it's empty
            filtered_advisories = filtered_advisories(2:size(filtered_advisories,2));
        end
    end
end
            
