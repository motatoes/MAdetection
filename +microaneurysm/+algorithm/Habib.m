classdef Habib < microaneurysm.detector.Base
    %HABIB Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        
        function [candidates, intermediateResults] = apply(self, inputImage, varargin)
            
            p = inputParser();
            addParameter(p, 'preprocessingOptions', {});
            addParameter(p, 'candidateDetectionOptions', {});
            parse( p, varargin{:} );
            preprocessingOptions = p.Results.preprocessingOptions;
            candidateDetectionOptions = p.Results.candidateDetectionOptions;
            
            greenChannel = microaneurysm.preprocessing.util.color2green(inputImage);
            
            [preprocessedImage, intermediateResults.preprocessing] = microaneurysm.preprocessing.preprocessFleming( greenChannel, preprocessingOptions{:} );
            [initialCandidates, intermediateResults.candidates] = microaneurysm.candidates.detectFlemingCandidates( preprocessedImage, candidateDetectionOptions{:} );
            intermediateResults.preprocessedImage = preprocessedImage;
            intermediateResults.initialCandidates = initialCandidates;
            
            [regionGrownCandidates, intermediateResults.regionGrowing] = microaneurysm.regionGrowing.flemingRegionGrow(preprocessedImage, initialCandidates);
            intermediateResults.regionGrownCandidates = regionGrownCandidates;
            
            candidates = regionGrownCandidates;
        end    
    
    end
    
end

