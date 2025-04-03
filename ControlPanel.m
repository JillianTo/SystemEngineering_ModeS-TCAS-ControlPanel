classdef ControlPanel
    properties
        % Array of 3 integer coordinates: X, Y, Z
        coords
        % Integer that represents mode: 
        %   0 = Stand-by, 
        %   1 = Transponder 
        %   2 = TA Only
        %   3 = TA/RA
        mode
    end
    methods
        function obj = ControlPanel(init_coords, init_mode)
            if nargin == 0
                obj.coords = [0, 0, 0];
                obj.mode = 0;
            elseif nargin == 1
                obj.coords = init_coords;
                obj.mode = 0;
            else
                obj.coords = init_coords
                obj.mode = init_mode
            end
        end
    end
end
            