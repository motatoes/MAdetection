
classdef (Abstract) Dataset < handle
    
    % Constants ...
    properties (GetAccess=public, SetAccess=protected)
        BasePath = '.' % The base folder path
        
        % Path to the location of the images
        pathImage;
        
        % Image normalisation [new_height, new_width]
        % (Use NaN for resizing to aspect ratio of either dimension)
        normalized_imagesize  = [NaN, 1500 ];
        normalize_images = false;
        
        % Path to the location of the field-of-view images
        pathFOV;
        
        FOVType = 'image';
        
        % path to the groundtruth images
        pathGround;
        
        GroundType = 'image'
        
        % The path to the optic disc mask mask image
        pathOD;
        
        ODType = 'image'
        
       % A string representing the suffix added to the groundtruth files
       % example .png, .mat, .jpg
       groundtruthSuffix
       
       % A Cell array containing links to all the training images in the
       % dataset
       training_files

       %  A cell array containing links to all the test images in the
       %  dataset
       test_files
    end
    
    methods
        
        function obj = Dataset(varargin)
            
            if (nargin == 1)
                obj.BasePath = varargin{1};
            else
                obj.BasePath = '.';
%                 obj.BasePath = 'E:/phd/kingston/fundus_datasets/'; % The base folder path
%                 obj.BasePath = 'C:/Users/k1358020/Dropbox/phd/kingston/fundus_datasets/';
            end
            
            obj.pathImage = strcat(obj.BasePath, '/'); % Path to the location of the images
            obj.pathFOV = strcat(obj.BasePath, '/FOV'); % Path to the location of the field-of-view images
            obj.pathOD = strcat(obj.BasePath, '/OD');
            obj.pathGround = strcat(obj.BasePath, '/groundtruth'); % path to the groundtruth images
        end

        function v = imageAbsName(self, imgName)
            v = strcat(self.pathImage, imgName);
        end
            
        function v = GTImageName(self, imgName)
            v = imgName;
        end
        
        function v = GTImageAbsName(self, imgName)
            v = strcat(self.pathGround, self.GTImageName(imgName));
        end
        
        function v = ODImageName(self, imgName)
            v = imgName;
        end
        
        function v = ODImageAbsName(self, imgName)
            v = strcat(self.pathOD, self.ODImageName(imgName));
        end
        
        function v = FOVImageName(self, imgName)
            v = imgName;
        end
        
        function v = FOVImageAbsName(self, imgName)
            v = strcat(self.pathFOV, self.FOVImageName(imgName));
        end
        
        function normalize_image(self, img)
        end
        
        function img = getImage(self, imgName, varargin)
            % img = imread(strcat(self.pathImage, imgName));
            img = self.absPath2image(strcat(self.pathImage, imgName), 'image');
            % If we need to normalize the images
        end
        
        function img = getFOVImage(self, imgName, varargin)
            img = self.absPath2image(self.FOVImageAbsName(imgName), self.FOVType, varargin{:});
        end
        
        function img = getGTImage(self, imgName, varargin)
            img = self.absPath2image(self.GTImageAbsName(imgName), self.GroundType, varargin{:});
        end
        
        function img = getODImage(self, imgName, varargin)
            img = self.absPath2image(self.ODImageAbsName(imgName), self.ODType, varargin{:});
        end
        
        function [resimg, varargout] = absPath2image(self, absPath, type, varargin)

            p = inputParser();
            addParameter(p, 'markerOptions',  {});
            parse(p, varargin{:});
            markerOptions = p.Results.markerOptions;
            
            if ( strcmp(type, 'image') )
                resimg = imread(absPath);
                % If we need to normalize the result
                if (self.normalize_images == true)
                    resimg = imresize(resimg, self.normalized_imagesize);
                end
            elseif ( strcmp(type, 'markers') )
                % if we need to normalize the result
                if (self.normalize_images == true)
                    markerOptions = [markerOptions {'outputSize', self.normalized_imagesize}];
                end
                [resimg, respixels] = imannotate.util.markers2image(absPath, markerOptions{:});
                if (nargout==2)
                    varargout{1} = respixels;
                end
            end
            
%             resimg = resimg > 0;
            
        end
    end
    
end
