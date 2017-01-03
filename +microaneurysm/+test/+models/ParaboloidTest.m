classdef ParaboloidTest < matlab.unittest.TestCase
    %PARABOLOIDTEST Summary of this class goes here
    %   Detailed explanation goes here
    
    methods(Test)
        function testTheParaboloidModelClass(testCase)
            import microaneurysm.models.Paraboloid
            
            p = Paraboloid([1 1 1 1 1 1]);
            [aminor, amajor] = p.getMajorMinorAxis(3);
            depth = p.getDepth(2);
            [uplus, uminus] = p.getUPlusMinus();
            z = p.getZ(1,1);
            
            testCase.verifyEqual(depth, 1);
            testCase.verifyEqual(aminor, 2);
            testCase.verifyEqual(amajor, Inf);
            testCase.verifyEqual(uplus, 2)
            testCase.verifyEqual(uminus, 0);
            testCase.verifyEqual(z, 1);
        end
        
        
        function testThefirParaboloidToCandidatesFunction(testCase)
            import microaneurysm.candidates.Candidates
            import microaneurysm.models.fitParaboloidsToCandidates
            
            inputImage = zeros(50);
            
            candidatesMask = false(50);
            candidatesMask(4:6, 4:6) = true;
            candidates = Candidates();
            candidates.setFromBinaryImage(candidatesMask);
            
            res = fitParaboloidsToCandidates(inputImage, candidates);
            
            testCase.verifyEqual(numel(res), 1);
            testCase.verifyEqual(isa(res{1}, 'microaneurysm.models.Paraboloid'), true);
        end
    end
    
end

