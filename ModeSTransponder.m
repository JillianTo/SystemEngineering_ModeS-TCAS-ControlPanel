%%
%% Models Mode S Transponder
%%
classdef ModeSTransponder
    properties (Access = private)
        device_id
    end
    methods
        function obj = ModeSTransponder(device_id)
            obj.device_id = device_id;
        end
        function coords = getCoords(obj, processor)
            coords = [obj.device_id, processor.getCoords()];
        end
        function advisories = getAdvisories(obj, processor)
            advisories = [obj.device_id, processor.processAdvisories()];
        end
        % Get advisories sent from other transponders to this
        function filtered_advisories = filterIncomingAdvisories(obj, advisories)
            num_advisories = size(advisories,2);
            filtered_advisories = cell(1);
            for i = num_advisories
                if advisories{i}(1) == obj.device_id
                    filtered_advisories = [filtered_advisories, advisories{i}(2:3)];
                end
            end
            % Remove first index in cell array because it's empty
            filtered_advisories = filtered_advisories(2:size(filtered_advisories,2));
        end
    end
end
            
