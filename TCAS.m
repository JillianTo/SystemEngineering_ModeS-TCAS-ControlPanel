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
        function obj = TCAS(device_id, coords, mode)
            processor = TCASProcessor(coords);
            transponder = ModeSTransponder(device_id);
            obj.mode = mode;
        end
        % Set coordinates in TCAS processor
        function setCoords(obj, coords);
            obj.processor.setCoords(coords);
        end
        % Transmit processed advisories from TCAS processor
        function advisories = getAdvisories(obj, ext_coords)
            advisories = processor.processAdvisories(ext_coords);
        end
        % Filter all incoming advisories to just the ones meant for this
        % TCAS unit
        function filtered_advisories = filterIncomingAdvisories(obj, advisories)
            if mode > 1
                filtered_advisories = transponder.filterIncomingAdvisories(advisories);
            else
                filtered_advisories = [];
            end
        end

    end
end
            
