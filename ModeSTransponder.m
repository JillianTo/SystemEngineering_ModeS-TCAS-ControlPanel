classdef ModeSTransponder
    properties (Access = private)
        % Pointer to array of 3 integer coordinates: X, Y, Z
        coords
        % Array of pointers to TA/RA buffers within other control panels
        ext_advisories
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
                obj.coords = init_coords;
                obj.mode = init_mode;
            end
            obj.ext_advisories = [];
        end
        function setCoords(obj, new_coords)
            obj.coords = new_coords
        end
        function curr_coords = getCoords(obj)
            switch obj.mode
                % Stand-by 
                case 0
                    % TODO: squitter capability, set small random probability of sending coords,
                    % else don't send coords 
                    % TODO: respond to discrete interrogation capability
                    curr_coords = []
                % Mode S transponder is fully operational in other modes
                otherwise
                    curr_coords = obj.coords
            end
        end
        function setMode(obj, new_mode)
            obj.mode = new_mode
        end
        function curr_mode = getMode(obj)
            curr_mode = obj.mode
        end
        function addExtCoords(obj, new_coords)
            obj.ext_coords = [obj.ext_coords, new_coords]
        end
    end
end
            
