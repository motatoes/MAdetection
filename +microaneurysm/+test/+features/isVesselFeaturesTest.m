classdef isVesselFeaturesTest < matlab.unittest.TestCase

    methods(Test)
        
        function testMainIsVesselFeature(testCase)
            %++++++++++++++++%
            % == | TODO | == %
            % == / TODO \ == %
            % == \______/ == %
            
            testCase.verifyEqual(true, false);
        end
        
        function testThatisVesselQuartzFeatureCanBeGenerated(testCase)
            import microaneurysm.features.isVesselQuartzFeature
            import microaneurysm.candidates.Candidates
            
            inputImage = rand(50);
            candidatesMask = false(50);
            candidatesMask(4:6, 4:6) = true;
            candidates = Candidates();
            candidates.setFromBinaryImage(candidatesMask);
            
            vesselMask = true(50);
            
            isvq = isVesselQuartzFeature( candidates,  vesselMask);
            testCase.verifyEqual(isvq, 1 );
        end
        
        function testThatisVesselLooseFeatureCanBeGenerated(testCase)
            import microaneurysm.features.isVesselLooseFeature
            
            inputImage = rand(50);
            candidatesMask = false(50);
            candidatesMask(4:6, 4:6) = true;
            candidates = microaneurysm.candidates.Candidates();
            candidates.setFromBinaryImage(candidatesMask);
            
            vesselMask = rand(50) > 0.5;
            
            isvq = isVesselLooseFeature(inputImage, candidates,  vesselMask);
            testCase.verifyEqual(numel(isvq), 1);
        end
        
    end
    
end

