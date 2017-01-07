classdef DatasetDiaretdb2Messidor < microaneurysm.settings.Dataset
    properties
    end
    
    methods
        function obj = DatasetDiaretdb2Messidor(varargin)
            % Training using Messidor and testing/validation using Diaretdb2
            
            % Call the parent constructor
            obj = obj@microaneurysm.settings.Dataset(varargin{:});
            
            obj.BasePath = strcat(obj.BasePath, '/DIARETDB/v2.1/ddb1_v02_01/');

            % Path to the location of the images
            obj.pathImage = strcat(obj.BasePath, '/images/');
            
            % Path to the location of the field-of-view images
            obj.pathFOV = strcat(obj.BasePath, '/groundtruth_FOV/');
            
            % path to the groundtruth images
            obj.pathGround = strcat(obj.BasePath, '/groundtruth_MA/');
    
            obj.GroundType = 'image';

            % path to the groundtruth images
            obj.pathOD = strcat(obj.BasePath, '/groundtruth_OD/');
            obj.ODType = 'markers';
            
            % A suffix to each groundtruth image (keep .mat if no suffix)
%             obj.groundtruthSuffix = '.mat';
            
            % We will just use the training files from the messidor set
            obj.training_files = {'20051205_32981_0400_PP.tif', '20060411_58718_0200_PP.tif', '20051205_35162_0400_PP.tif', '20060522_45212_0100_PP.tif', '20051020_44400_0100_PP.tif', '20051212_36605_0400_PP.tif', '20060522_45455_0100_PP.tif', '20051020_55701_0100_PP.tif', '20051213_61951_0100_PP.tif', '20060522_45935_0100_PP.tif', '20051216_44066_0200_PP.tif', '20051109_59969_0400_PP.tif', '20051216_44252_0200_PP.tif', '20051109_57843_0400_PP.tif', '20051216_44660_0200_PP.tif', '20051130_54030_0400_PP.tif'};
            obj.test_files = {'diaretdb1_image002.png', 'diaretdb1_image005.png', 'diaretdb1_image006.png', 'diaretdb1_image007.png', 'diaretdb1_image008.png', 'diaretdb1_image012.png', 'diaretdb1_image015.png', 'diaretdb1_image016.png', 'diaretdb1_image017.png', 'diaretdb1_image018.png', 'diaretdb1_image019.png', 'diaretdb1_image021.png', 'diaretdb1_image023.png', 'diaretdb1_image030.png', 'diaretdb1_image031.png', 'diaretdb1_image032.png', 'diaretdb1_image033.png', 'diaretdb1_image034.png', 'diaretdb1_image037.png', 'diaretdb1_image039.png', 'diaretdb1_image040.png', 'diaretdb1_image041.png', 'diaretdb1_image044.png', 'diaretdb1_image043.png', 'diaretdb1_image045.png', 'diaretdb1_image046.png', 'diaretdb1_image047.png', 'diaretdb1_image048.png', 'diaretdb1_image049.png', 'diaretdb1_image050.png', 'diaretdb1_image051.png', 'diaretdb1_image052.png', 'diaretdb1_image054.png', 'diaretdb1_image056.png', 'diaretdb1_image058.png', 'diaretdb1_image059.png', 'diaretdb1_image060.png', 'diaretdb1_image061.png', 'diaretdb1_image062.png', 'diaretdb1_image063.png', 'diaretdb1_image065.png', 'diaretdb1_image066.png', 'diaretdb1_image067.png', 'diaretdb1_image068.png', 'diaretdb1_image069.png', 'diaretdb1_image071.png', 'diaretdb1_image072.png', 'diaretdb1_image073.png', 'diaretdb1_image074.png', 'diaretdb1_image075.png', 'diaretdb1_image076.png', 'diaretdb1_image077.png', 'diaretdb1_image078.png', 'diaretdb1_image080.png', 'diaretdb1_image081.png', 'diaretdb1_image082.png', 'diaretdb1_image083.png', 'diaretdb1_image085.png', 'diaretdb1_image087.png', 'diaretdb1_image088.png', 'diaretdb1_image089.png'};
        end
    end
    
    methods
        
        function v = GTImageName(self, imgName, varargin)
            v = imgName;
        end
        
        function v = ODImageName(self, imgName, varargin)
            v = strcat(imgName, '_markers_new.mat');
        end

        function v = groundImage_count(self, imgName, varargin)
            x = load(strcat(self.pathGround, imgName, '_count.mat'));
            v = x.gtcount;
        end
        
    end
    
end
