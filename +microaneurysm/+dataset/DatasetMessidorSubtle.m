classdef DatasetMessidorSubtle < microaneurysm.settings.DatasetMessidor
    
    methods
        function obj = DatasetMessidorSubtle(varargin)
            % Call the parent constructor
            obj = obj@microaneurysm.settings.DatasetMessidor(varargin{:});            
        end
        
        function v = groundImage_count(self, imgName, varargin)

            absPath = self.GTImageAbsName(imgName);
            [resimg, respixels] = imannotate.util.markers2image(absPath, 'tagsFilter', struct('microaneurysm', {{'subtle'}}), varargin{:});
            v = length(respixels.microaneurysm);
        end
        
        function img = getGTImage(self, imgName, varargin)
            img = self.absPath2image(self.GTImageAbsName(imgName), self.GroundType, ...
                'markerOptions', {'tagsFilter', struct('microaneurysm', {{'obvious'}})}, varargin{:});
        end
    end
    
end
