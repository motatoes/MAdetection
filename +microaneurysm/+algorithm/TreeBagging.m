classdef TreeBagging < microaneurysm.algorithm.Base
    %TREEBAGGING Summary of this class goes here
    %   Detailed explanation goes here
    properties( GetAccess=public, SetAccess=private )
        classifier;
        trainingFeatures = [];
        classificationModel;
    end
    
    properties(GetAccess=public, SetAccess=public)
        preprocessingOptions = {}
        candidateDetectionOptions = {}
        regionGrowingOptions = {}
        classifierOptions = {}
    end
    
    methods
        
        function [candidates, intermediateResults] = apply(self, inputImage, varargin)
            import microaneurysm.classification.ensemble_classification
            
            p = inputParser();
            addParameter(p, 'preprocessingOptions', {});
            addParameter(p, 'candidateDetectionOptions', {});
            addParameter(p, 'regionGrowingOptions', {});
            addParameter(p, 'classifierOptions', {});
            parse( p, varargin{:} );
            preprocessingOptions = p.Results.preprocessingOptions;
            candidateDetectionOptions = p.Results.candidateDetectionOptions;
            classifierOptions = p.Results.classifierOptions;
            regionGrowingOptions = p.Results.regionGrowingOptions;

            [testFeatures, intermediateResults] = generateFeatures(self, inputImage, varargin);
            
            [classifications, scores] = predict( self.classificationModel, testFeatures, self.classifierOptions{:} );
            intermediateResults.classifications = classifications;
            
            candidates = intermediateResults.regionGrowing.regionGrownCandidates;
            candidates = candidates.filter(classifications);
        end
        
        function [trainingFeatures, intermediateResults] = train(self, inputImage, groundtruthImage, varargin)
            
            import microaneurysm.candidates.labelCandidates
            
            [features, intermediateResults] = generateFeatures(self, inputImage, varargin{:});
            
            % 'labeling the features'
            candidates = intermediateResults.regionGrowing.regionGrownCandidates;
            
            labels = labelCandidates(candidates, groundtruthImage);
            
            self.generateFeatures(inputImage, varargin{:});
            featuresFilter = intermediateResults.features.realFeaturesFilter;
            
            trainingFeatures = [intermediateResults.features.all  labels];
            trainingFeatures = trainingFeatures(featuresFilter, :);
            
            trainingFeatures = [self.trainingFeatures; trainingFeatures];
        end
        
        function buildModel(self, varargin)
            trainingFeatures = self.trainingFeatures(:, 1:end-1);
            trainingFeatureLabels = self.trainingFeatures(:, end);
            
            self.classificationModel = fitensemble(trainingFeatures, trainingFeatureLabels, 'Bag', ...
                      40, 'Tree', ...
                      'type', 'classification', ...
                      'nprint', 5);
        end
        
        function [realFeatures, intermediateResults] = generateFeatures(self, inputImage, varargin) 
            import microaneurysm.features.flemingSizeFeatures
            import microaneurysm.features.flemingIntensityFeatures
            import microaneurysm.models.fitParaboloidsToCandidates
            import microaneurysm.features.extractRealFeatures
            
            [candidates, intermediateResults] = self.generateCandidates(inputImage, varargin{:});
            
            % Appending the training data
            preprocessedImage = intermediateResults.preprocessing.preprocessedImage;
%             grayImage = intermediateResults.preprocessing.grayImage;
            bgEstimateImage = intermediateResults.preprocessing.bgEstimateImage;
            npeaks = intermediateResults.regionGrowing.rgNpeaks;
%             paraboloidParams = fitParaboloidsToCandidates(preprocessedImage, candidates);            tophatImage = intermediateResultsRG.candidates.tophatImage;
            tophatImage = intermediateResults.candidates.tophatImage;

%             features_fint = flemingIntensityFeatures( preprocessedImage, candidates, paraboloidParams);
%             features_fsize = flemingSizeFeatures( preprocessedImage, grayImage, bgEstimateImage, candidates, paraboloidParams, npeaks );
%             featuresAll = [features_fint, features_fsize];
            featuresAll = self.computeFeatures( inputImage, bgEstimateImage, preprocessedImage, tophatImage, npeaks, candidates);
            
            % Filtering out complex features that appeared as a result of
            % paraboloid fitting and feature computation ..
            [realFeatures, isRealFeatures] = extractRealFeatures(featuresAll);

            % Entire feature set (include complex values!)
            intermediateResults.features.all = featuresAll;            
            intermediateResults.features.realFeaturesFilter = isRealFeatures;
            
        end

        function [candidates, intermediateResults] = generateCandidates(self, inputImage, varargin)
            
            greenChannel = microaneurysm.util.color2green(inputImage);
            
            [preprocessedImage, intermediateResults.preprocessing] = microaneurysm.preprocessing.preprocessFleming( greenChannel, self.preprocessingOptions{:} );
            [initialCandidates, intermediateResults.candidates] = microaneurysm.candidates.detectFlemingCandidates( preprocessedImage, self.candidateDetectionOptions{:} );
            intermediateResults.preprocessing.preprocessedImage = preprocessedImage;
            intermediateResults.preprocessing.grayImage = greenChannel;
            intermediateResults.candidates.initialCandidates = initialCandidates;
            
            [regionGrownCandidates, intermediateResults.regionGrowing] = microaneurysm.regionGrowing.flemingRegionGrow(preprocessedImage, initialCandidates, self.regionGrowingOptions{:});
            intermediateResults.regionGrowing.regionGrownCandidates = regionGrownCandidates;
            
            candidates = regionGrownCandidates();
            
        end
        
        function resetTrainingFeatures(self)
            self.trainingFeatures = [];
        end        
       
    end
    
    methods(Static)
      
      function [featuresAll] = computeFeatures( colourImage, bgEstimateImage, preprocessedImage, tophatImage, npeaks, RGcandidates)
            import microaneurysm.features.flemingSizeFeatures
            import microaneurysm.features.flemingIntensityFeatures
            import microaneurysm.features.momentFeatures
            import microaneurysm.features.gaussianFeatures
            import microaneurysm.features.gaussianFeatures1D
            import microaneurysm.features.intensityFeatures
            import microaneurysm.features.shapeFeatures
            import microaneurysm.features.morphologyFeatures
            import microaneurysm.models.fitParaboloidsToCandidates
            
            grayImage = microaneurysm.util.color2green(colourImage);            

            paraboloidParams = fitParaboloidsToCandidates(preprocessedImage, RGcandidates);

            hsv_image = rgb2hsv(colourImage);
            
            % == fleming features == %
            features_fint = flemingIntensityFeatures( preprocessedImage, RGcandidates, paraboloidParams);
            features_fsize = flemingSizeFeatures( preprocessedImage, grayImage, bgEstimateImage, RGcandidates, paraboloidParams, npeaks );
            features_moments = momentFeatures( RGcandidates );
            features_shape = shapeFeatures( RGcandidates );
            features_gauss = gaussianFeatures( tophatImage , RGcandidates );
            %%%%%%%%%%%%
            %features_gauss = [features_gauss(:,1), features_gauss(:,5:6)];
            features_gauss1D = gaussianFeatures1D( tophatImage, RGcandidates);
            features_intensity_R = intensityFeatures( colourImage(:,:,1), RGcandidates );
            features_intensity_G = intensityFeatures( colourImage(:,:,2), RGcandidates );
            features_intensity_B = intensityFeatures( colourImage(:,:,3), RGcandidates );
            features_intensity_H = intensityFeatures( hsv_image(:,:,1), RGcandidates );
            features_intensity_S = intensityFeatures( hsv_image(:,:,2), RGcandidates );
            features_intensity_V = intensityFeatures( hsv_image(:,:,3), RGcandidates );
            features_intensity_PP = intensityFeatures( preprocessedImage, RGcandidates );
            features_morph = morphologyFeatures( preprocessedImage, RGcandidates);
            
            featuresAll = [features_fint, features_fsize features_moments features_shape, .... 
                           features_gauss features_gauss1D features_intensity_R, ...
                           features_intensity_G features_intensity_B features_intensity_H, ...
                           features_intensity_S features_intensity_V features_intensity_PP, ...
                           features_morph];
            

        end
          
        
    end
    
end

