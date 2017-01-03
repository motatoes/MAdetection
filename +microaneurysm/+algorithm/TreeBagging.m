classdef TreeBagging
    %TREEBAGGING Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        
        
        
        function train(self)
            
            [features_moments] = helpers.calculateMomentFeatures( regionGrowing );
            features_isSuitable = features_fsize_issuitable | features_fint_issuitable;
            [feature_isVessel] = helpers.calculateVesselFeatures(preprocessor, pfit, regionGrowing, features_isSuitable, vesselMask);
            [feature_isVessel_loose] = helpers.calculateVesselFeatures_loose(preprocessor, regionGrowing, features_isSuitable, vesselMask);
            [feature_isVessel_quartz] = helpers.calculateVesselFeatures_quartz(preprocessor, regionGrowing, vesselMask);
            features_pixels = helpers.calculatePixelFeatures(regionGrowing);
            features_gaussian = helpers.calculateGaussianFeatures( candidatesDetector.tophatImage , regionGrowing , 'sigmaValues', [1 2 4 8 16 32], 'windowSize', [96 96]);
            features_int2 = helpers.calculateIntensityFeatures2(originalImage, preprocessor, regionGrowing);
            features_morph = helpers.calculateMorphologyFeatures( preprocessor.preprocessedImage, regionGrowing, 'tophatStrelSize', TOPHAT_STREL_SIZE);
            
        end
    end
    
end

