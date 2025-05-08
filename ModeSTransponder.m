%%
%% Models Mode S Transponder
%%
classdef ModeSTransponder
    properties (Access = private)
        squawk_code
    end
    methods
        function obj = ModeSTransponder(squawk_code)
            obj.squawk_code = squawk_code;
        end
        function squawk_code = getSquawkCode(obj)
            squawk_code = obj.squawk_code;
        end
        function coords = getCoords(obj, processor)
            coords = [obj.squawk_code, processor.getCoords(), processor.getAltDir()];
        end
        function advisories = getAdvisories(obj, processor, mode, ext_coords)
            advisories = processor.processAdvisories(mode, ext_coords);
            advisories = advisories(~cellfun('isempty', advisories));
            advisories = [obj.squawk_code, advisories];
        end
    end
end
            
