classdef IntensityFeaturesTest < matlab.unittest.TestCase
    %INTENSITYFEATURESTEST Summary of this class goes here

    
    methods(Test)
        
        function testIntesityFeatures(testCase)
            import microaneurysm.candidates.Candidates
            import microaneurysm.features.intensityFeatures
            
            inputImage = rand(50);
            
            candidatesMask = false(50);
            candidatesMask(4:6, 4:6) = true;
            candidates = Candidates();
            candidates.setFromBinaryImage(candidatesMask);
            
            features = intensityFeatures(inputImage, candidates);

            testCase.verifyEqual(size(features), [1 5]);
        end
        
    end
    
end

