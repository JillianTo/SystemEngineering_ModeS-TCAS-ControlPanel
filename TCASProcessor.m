classdef TCASProcessor
    properties (Access = private)
        % Pointer to array of 3 integer coordinates and an integer
        % representing the direction of altitude movement: X, Y, Z, Z'
        % Z' integer can take on 3 values:
        %   0 = Maintaining altitude
        %   1 = Ascending
        %   2 = Descending
        coords    
        % Array of pointers to coordinate arrays received from other 
        % control panels
        ext_coords
        % Array of pointers to buffers that store TA/RAs for other control
        % panels
        advisories
        % Pointer to integer that represents mode: 
        %   0 = Stand-by, 
        %   1 = Transponder 
        %   2 = TA Only
        %   3 = TA/RA
        mode
        % Threshold in feet for sending TA
        ta_threshold
        % Threshold in feet for sending TA
        ra_threshold
    end
    methods
        function obj = TCASProcessor(coords, mode)
            obj.coords = coords;
            obj.mode = mode;
            obj.ext_coords = [];
            obj.ta_threshold = 900;
            obj.ra_threshold = 500;
        end
        function addExtCoords(obj, new_coords)
            obj.ext_coords = [obj.ext_coords, new_coords]
        end
        function processAdvisories(obj)
            if obj.mode.Value > 1
                num_ext_coords = size(obj.ext_coords,2);
                for i = num_ext_coords
                    % Calculate difference in altitude between another
                    % aircraft and ours
                    alt_diff = obj.ext_coords.Value(i,1:3)-obj.coords.Value(1:3);
                    % If the ohter aircraft is above ours, but a distance 
                    % less than TA threshold 
                    if alt_diff < obj.ta_threshold
                        % If distance is less than RA threshold, and set to
                        % transmit RAs
                        if mode_val > 2 & alt_diff < obj.ra_threshold
                            % Set advisory to altitude difference, and
                            % advisory to RA
                            advisories[i].Value = [alt_diff, 2];
                        else
                            % Set advisory to altitude difference, and 
                            % advisory to TA 
                            advisories[i].Value = [alt_diff, 1];
                        end
                    end
                end
            end
        end
    end
end
            
