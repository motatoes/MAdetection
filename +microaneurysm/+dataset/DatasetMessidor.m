classdef DatasetMessidor < microaneurysm.dataset.Dataset
    properties
    end
    
    methods
        function obj = DatasetMessidor(varargin)
            
            % Call the parent constructor
            obj = obj@microaneurysm.dataset.Dataset(varargin{:});
            
            obj.BasePath = strcat(obj.BasePath, '/Messidor_Habib/');

            % Path to the location of the images
            obj.pathImage = strcat(obj.BasePath, '/unpublished/all_images/');
            
            % Path to the location of the field-of-view images
            obj.pathFOV = strcat(obj.BasePath, 'groundtruth/FOV/');
            
            % path to the groundtruth images
            obj.pathGround = strcat(obj.BasePath, 'groundtruth/MA/markers/');
    
            obj.GroundType = 'markers';

            % path to the groundtruth images
            obj.pathOD = strcat(obj.BasePath, 'unpublished/OD/markers/');
            obj.ODType = 'markers';
            
            % A suffix to each groundtruth image (keep .mat if no suffix)
            obj.groundtruthSuffix = '_markers_new.mat';

            obj.training_files = {'20051205_32981_0400_PP.tif', '20060411_58718_0200_PP.tif', '20051205_35162_0400_PP.tif', '20060522_45212_0100_PP.tif', '20051020_44400_0100_PP.tif', '20051212_36605_0400_PP.tif', '20060522_45455_0100_PP.tif', '20051020_55701_0100_PP.tif', '20051213_61951_0100_PP.tif', '20060522_45935_0100_PP.tif', '20051216_44066_0200_PP.tif', '20051109_59969_0400_PP.tif', '20051216_44252_0200_PP.tif', '20051109_57843_0400_PP.tif', '20051216_44660_0200_PP.tif', '20051130_54030_0400_PP.tif'};
            obj.test_files = {'20051020_57566_0100_PP.tif', '20051216_44221_0200_PP.tif', '20060523_43016_0100_PP.tif', '20051021_39661_0100_PP.tif', '20060407_44304_0200_PP.tif', '20060523_45812_0100_PP.tif', '20051110_38111_0400_PP.tif', '20060407_45592_0200_PP.tif', '20051116_44750_0400_PP.tif', '20060410_44224_0200_PP.tif', '20051216_45499_0200_PP.tif', '20060407_39687_0200_PP.tif', '20051117_37100_0400_PP.tif', '20051117_37042_0400_PP.tif', '20051216_45076_0200_PP.tif', '20051117_37130_0400_PP.tif'};
  
%             obj.training_files = {'20051205_32981_0400_PP.tif', '20060411_58718_0200_PP.tif', '20051205_35162_0400_PP.tif', '20060522_45212_0100_PP.tif', '20051020_44400_0100_PP.tif', '20051212_36605_0400_PP.tif', '20060522_45455_0100_PP.tif', '20051020_55701_0100_PP.tif', '20051213_61951_0100_PP.tif', '20060522_45935_0100_PP.tif'};
%             obj.test_files = {'20051020_57566_0100_PP.tif', '20051216_44221_0200_PP.tif', '20060523_43016_0100_PP.tif', '20051021_39661_0100_PP.tif', '20060407_44304_0200_PP.tif', '20060523_45812_0100_PP.tif', '20051110_38111_0400_PP.tif', '20060407_45592_0200_PP.tif', '20051116_44750_0400_PP.tif', '20060410_44224_0200_PP.tif'};
        end
    end
    
    methods
        
        function v = GTImageName(self, imgName, varargin)
            v = strcat(imgName, '_markers_new.mat');
        end
        
        function v = ODImageName(self, imgName, varargin)
            v = strcat(imgName, '_markers_new.mat');
        end

        function v = groundImage_count(self, imgName, varargin)

            absPath = self.GTImageAbsName(imgName);
            [resimg, respixels] = imannotate.util.markers2image(absPath, varargin{:});
            v = length(respixels.microaneurysm);
        end
        
%         function img = getGTImage(self, imgName, varargin)
%             img = self.absPath2image(self.GTImageAbsName(imgName), self.GroundType, ...
%                 'markerOptions', {'tagsFilter', struct('microaneurysm', {{}})}, varargin{:});
%         end
    end
    
end
