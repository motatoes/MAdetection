classdef FlemingFeaturesTest < matlab.unittest.TestCase
    %FLEMINGFEATURESTEST

    methods(Test)
        
        function testFlemingSizeFeatures(testCase)
            import microaneurysm.features.flemingSizeFeatures
            import microaneurysm.models.fitParaboloidsToCandidates
            import microaneurysm.candidates.Candidates
            
            preproImage = ones(50) * 0.2;
            grayImage = ones(50) * 0.1;
            bgEstimateImage = rand(50);
            npeaks = [1];
            
            candidatesMask = false(50);
            candidatesMask(4:6, 4:6) = true;
            candidates = Candidates();
            candidates.setFromBinaryImage(candidatesMask);
            
            paraboloids = fitParaboloidsToCandidates(grayImage, candidates);
        
            features = flemingSizeFeatures( preproImage, grayImage, bgEstimateImage, candidates, paraboloids, npeaks );
            
            testCase.verifyEqual(size(features), [1,5] );
            testCase.verifyEqual(isreal(features), true);
        end
        
        function testFlemingIntensityFeatures(testCase)
            import microaneurysm.features.flemingIntensityFeatures
            import microaneurysm.models.fitParaboloidsToCandidates
            import microaneurysm.candidates.Candidates
            
            inputImage = ones(50) * 0.1;
            
            candidatesMask = false(50);
            candidatesMask(2:9, 4:9) = true;
            candidates = Candidates();
            candidates.setFromBinaryImage(candidatesMask);
            
            paraboloids = fitParaboloidsToCandidates(inputImage, candidates);
            
            features = flemingIntensityFeatures( inputImage, candidates, paraboloids);
            testCase.verifyEqual(size(features), [1, 4]);
            testCase.verifyEqual(isreal(features), true);
        end
        
    end
    
end

