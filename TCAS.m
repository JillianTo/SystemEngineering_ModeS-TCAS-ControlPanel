%%
%% Models TCAS II
%%

classdef TCAS
    properties (Access = private)
        processor
        transponder
        mode
    end
    methods
        % Constructor
        function obj = TCAS(device_id, coords, mode)
            processor = TCASProcessor(coords);
            transponder = ModeSTransponder(device_id);
            obj.mode = mode;
        end

        % TODO: function for setting coordinates in processor
        % TODO: function for getting coordinates from transponder
        % TODO: function for getting advisories from transponder after 
        % processing TAs/RAs in processor 

    end
end
            
