%%
%% Models TCAS computer unit
%%

classdef TCASProcessor
    properties (Access = private)
        % Array of 3 integer coordinates and an integer
        % representing the direction of altitude movement: X, Y, Z, Z'
        % Z' integer can take on 3 values:
        %   0 = Maintaining altitude
        %   1 = Ascending
        %   2 = Descending
        coords    
        % Threshold in feet for sending TA
        ta_threshold
        % Threshold in feet for sending TA
        ra_threshold
    end
    methods
        % Constructor
        function obj = TCASProcessor(coords)
            obj.coords = coords;
            obj.ta_threshold = 900;
            obj.ra_threshold = 500;
        end
        % Set coordinates
        function obj = setCoords(obj, coords)
            obj.coords = coords;
        end
        % Get coordinates
        function coords = getCoords(obj)
            coords = obj.coords;
        end
        % Determine TAs/RAs from this and other TCAS units' coordinates
        function advisories = processAdvisories(obj, mode, ext_coords)
            if mode < 1
                advisories = cell(1)
            else
                num_ext_coords = size(ext_coords,2);
                advisories = cell(1, num_ext_coords);
                for i = num_ext_coords
                    % Save current device ID
                    device_id = ext_coords{i}(1);
                    % Calculate difference in altitude between another
                    % aircraft and ours
                    alt_diff = ext_coords{i}(4)-obj.coords(3);
                    % If theob ohter aircraft is above ours, but a distance 
                    % less than TA threshold 
                    if alt_diff < obj.ta_threshold
                        % If distance is less than RA threshold, and set to
                        % transmit RAs
                        if mode > 2 && alt_diff < obj.ra_threshold
                            % Set advisory to altitude difference, and
                            % advisory to RA
                            advisories{i} = [device_id, alt_diff, 2];
                        else
                            % Set advisory to altitude difference, and 
                            % advisory to TA 
                            advisories{i} = [device_id, alt_diff, 1];
                        end
                    elseif -alt_diff < obj.ta_threshold
                        % If distance is less than RA threshold, and set to
                        % transmit RAs
                        if mode > 2 && -alt_diff < obj.ra_threshold
                            % Set advisory to altitude difference, and
                            % advisory to RA
                            advisories{i} = [device_id, alt_diff, 2];
                        else
                            % Set advisory to altitude difference, and 
                            % advisory to TA 
                            advisories{i} = [device_id, alt_diff, 1];
                        end
                    end
                end
            end
        end
    end
end
            
