classdef Fleming < microaneurysm.algorithm.Base
    %FLEMING Summary of this class goes here
    %   Detailed explanation goes here
    
    properties( GetAccess=public, SetAccess=private )
        classifier;
        trainingFeatures = [];
    end
    
    properties(GetAccess=public, SetAccess=public)
        preprocessingOptions = {}
        candidateDetectionOptions = {}
        regionGrowingOptions = {}
        classifierOptions = {}
    end
    
    methods
        
        function obj = Fleming(varargin)
        end
        
        function [candidates, intermediateResults] = apply(self, inputImage, varargin)
            import microaneurysm.classification.KNNClassify
            
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
            
            classifications = KNNClassify( self.trainingFeatures, testFeatures, self.classifierOptions{:} );
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
            self.trainingFeatures = [self.trainingFeatures; trainingFeatures];
        end
        
        function buildModel(self)
            % Build the model from the training features
            % We don't need to do anything because its a KNN classifier :)
            self.trainingFeatures;
        end
        
        function [realFeatures, intermediateResults] = generateFeatures(self, inputImage, varargin) 
            import microaneurysm.features.flemingSizeFeatures
            import microaneurysm.features.flemingIntensityFeatures
            import microaneurysm.models.fitParaboloidsToCandidates
            
            [candidates, intermediateResults] = self.generateCandidates(inputImage, varargin{:});
            
            % Appending the training data
            preprocessedImage = intermediateResults.preprocessing.preprocessedImage;
            grayImage = intermediateResults.preprocessing.grayImage;
            bgEstimateImage = intermediateResults.preprocessing.bgEstimateImage;
            npeaks = intermediateResults.regionGrowing.rgNpeaks;
            paraboloidParams = fitParaboloidsToCandidates(preprocessedImage, candidates);
            
            features_fint = flemingIntensityFeatures( preprocessedImage, candidates, paraboloidParams);
            features_fsize = flemingSizeFeatures( preprocessedImage, grayImage, bgEstimateImage, candidates, paraboloidParams, npeaks );
            featuresAll = [features_fint, features_fsize];
            
            
            % Filtering out complex features that appeared as a result of
            % paraboloid fitting and feature computation ..
            realFeatures = zeros(0, size(featuresAll,2));
            isRealFeatures = false(size(featuresAll,1), 1);
            for i=1:size(featuresAll,1)
                if ( isreal(featuresAll(i,:)) )
                    realFeatures = [realFeatures; featuresAll(i, :)];
                    isRealFeatures(i) = true;
                end
            end

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
        
        % == Setters == %
        function setTrainingFeatures(self, newTrainingFeatures)
            % newTrainingFeatures is the required siz
            self.trainingFeatures = newTrainingFeatures;
        end
        
    end
    
end

