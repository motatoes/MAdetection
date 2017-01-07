classdef DatasetROC < microaneurysm.settings.Dataset
    properties
    end
    
    methods
        function obj = DatasetROC(varargin)
            
            % Call the parent constructor
            obj = obj@microaneurysm.settings.Dataset(varargin{:});
            
            
            obj.BasePath = strcat(obj.BasePath, '/RetinopathyOnlineChallenge/ROCtraining/');

            % Path to the location of the images
            obj.pathImage = strcat(obj.BasePath, '/normalized_1058/');
            
            % Path to the location of the field-of-view images
            obj.pathFOV = strcat(obj.BasePath, '/FOV_1058/');
            obj.ODType = 'markers';
            
            % path to the groundtruth images
            obj.pathGround = strcat(obj.BasePath, '/groundtruths_1058/');

            % path to the groundtruth images
            obj.pathOD = strcat(obj.BasePath, '/OD_1058/');
            
            % A suffix to each groundtruth image (keep .mat if no suffix)
            obj.groundtruthSuffix = '.jpg';
            
            obj.training_files = {'image0_training.jpg', 'image1_training.jpg', 'image2_training.jpg', 'image3_training.jpg', 'image4_training.jpg', 'image5_training.jpg', 'image6_training.jpg', 'image7_training.jpg', 'image8_training.jpg', 'image9_training.jpg', 'image10_training.jpg', 'image11_training.jpg', 'image12_training.jpg', 'image13_training.jpg', 'image14_training.jpg', 'image15_training.jpg', 'image16_training.jpg', 'image17_training.jpg', 'image18_training.jpg', 'image19_training.jpg', 'image20_training.jpg', 'image21_training.jpg', 'image22_training.jpg', 'image23_training.jpg', 'image24_training.jpg'};
            obj.test_files = {'image25_training.jpg', 'image26_training.jpg', 'image27_training.jpg', 'image28_training.jpg', 'image29_training.jpg', 'image30_training.jpg', 'image31_training.jpg', 'image32_training.jpg', 'image33_training.jpg', 'image34_training.jpg', 'image35_training.jpg', 'image36_training.jpg', 'image37_training.jpg', 'image38_training.jpg', 'image39_training.jpg', 'image40_training.jpg', 'image41_training.jpg', 'image42_training.jpg', 'image43_training.jpg', 'image44_training.jpg', 'image45_training.jpg', 'image46_training.jpg', 'image47_training.jpg', 'image48_training.jpg', 'image49_training.jpg'};
        end
    end
    
    methods
        function x = ODImageName(self, imgName)
            x =  strcat(imgName, '_markers_new.mat');
        end

        function v = GTImageName(self, imgName)
            v = strcat(imgName, '.tif');
        end
        
        function count = groundImage_count(self, imgName)
            x = load(strcat(self.pathGround, 'counts/', imgName, '_count.mat' ));
            count = x.microaneurysms_count; 
        end
    end
    
end
