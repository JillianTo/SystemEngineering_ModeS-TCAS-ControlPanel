%%
%% Models TCAS II
%%

classdef TCAS
    properties (Access = private)
        processor
        transponder
        % Pointer to integer that represents mode: 
        %   0 = Stand-by, 
        %   1 = Transponder 
        %   2 = TA Only
        %   3 = TA/RA
        mode
    end
    methods
        % Constructor
        function obj = TCAS(device_id, mode, coords, alt_vel)
            obj.processor = TCASProcessor(coords, alt_vel);
            obj.transponder = ModeSTransponder(device_id);
            obj.mode = mode;
        end
        % Set coordinates in TCAS processor
        function obj = setCoords(obj, coords)
            if obj.mode > 1
                obj.processor = obj.processor.setCoords(coords);
            end
        end
        % Get coordinates from Mode S transponder
        function coords = getCoords(obj)
            if obj.mode > 0
                coords = obj.transponder.getCoords(obj.processor);
            else
                coords = [];
            end
        end
        % Set mode for TCAS
        function obj = setMode(obj, mode)
            obj.mode = mode;
        end
        % Transmit processed advisories from TCAS processor
        function advisories = getAdvisories(obj, ext_coords)
            if obj.mode > 1
                advisories = obj.transponder.getAdvisories(obj.processor, obj.mode, ext_coords);
            else
                advisories = [];
            end
        end
        % Filter all incoming advisories to just the ones meant for this
        % TCAS unit
        function filtered_advisories = filterIncomingAdvisories(obj, advisories)
            if obj.mode > 1
                filtered_advisories = obj.processor.filterIncomingAdvisories(advisories, obj.transponder.getSquawkCode());
            else
                filtered_advisories = [];
            end
        end

    end
end
            
