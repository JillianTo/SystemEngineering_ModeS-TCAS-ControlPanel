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
        function coords = getCoords(obj, in_coords)
            coords = [device_id, in_coords];
        end
        function advisories = getAdvisories(obj, in_advisories)
            advisories = [device_id, in_advisories];
        end
    end
end
            
