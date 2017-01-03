classdef MomentFeaturesTest < matlab.unittest.TestCase
    
    methods(Test)
        function testThatMomentFeaturesCanBeComputed(testCase)
            import microaneurysm.candidates.Candidates
            candidatesMask = false(50);
            candidatesMask(4:6, 4:6) = true;
            candidatesMask(4, 4) = false;
            candidates = Candidates();
            candidates.setFromBinaryImage(candidatesMask);

            momentFeatures = microaneurysm.features.momentFeatures(candidates);
            
            testCase.verifyEqual( size(momentFeatures), [1, 7] );
        end
    end
    
end

