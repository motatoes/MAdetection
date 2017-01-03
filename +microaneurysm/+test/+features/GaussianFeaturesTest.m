classdef GaussianFeaturesTest < matlab.unittest.TestCase
    %GAUSSIANFEATURESTEST Summary of this class goes here
    %   Detailed explanation goes here

    methods( Test )
        
        function testThatMultigaussResponseWorks(testCase)
            import microaneurysm.features.gaussianResponse
            inputImage = zeros(50);
            sigmaValues = 1:2:16;
            windowSize = 15;
            gr = gaussianResponse(inputImage, sigmaValues, windowSize);

            testCase.verifyEqual(size(gr), [50 50 length(sigmaValues)] );
        end
        
        function testThat1DgaussResponseWorks( testCase )
            import microaneurysm.features.gaussianResponse1D
            inputImage = zeros(50);
            sigmaValue = 1;
            thetaValues = 0:10:180;
            windowSize = 15;
            gr = gaussianResponse1D(inputImage, thetaValues, sigmaValue, windowSize);
            testCase.verifyEqual(size(gr), [50 50 length(thetaValues)] );
            gr = gaussianResponse1D(inputImage, thetaValues, sigmaValue, [15 15]);
            testCase.verifyEqual(size(gr), [50 50 length(thetaValues)] );
        end
        
        function testGaussian1DFeatures(testCase)
            import microaneurysm.candidates.Candidates
            import microaneurysm.features.gaussianFeatures1D
            
            inputImage = zeros(50);
            
            candidatesMask = false(50);
            candidatesMask(4:6, 4:6) = true;
            candidates = Candidates();
            candidates.setFromBinaryImage(candidatesMask);
            
            features = gaussianFeatures1D( inputImage, candidates, 'thetaValues', 0:10:90, 'windowSize', [15 15] );
            % 6 features are being calculated in this function
            testCase.verifyEqual(size(features), [1 6]);
        end
        
        function testGaussianFeatures(testCase)
            import microaneurysm.candidates.Candidates
            import microaneurysm.features.gaussianFeatures
            
            inputImage = zeros(50);
            
            candidatesMask = false(50);
            candidatesMask(4:6, 4:6) = true;
            candidates = Candidates();
            candidates.setFromBinaryImage(candidatesMask);
            
            features = gaussianFeatures( inputImage, candidates, 'sigmaValues', [1 2 4 8 16 32], 'windowSize', [15 15] );
            % 26 features are being calculated in this function
            
            testCase.verifyEqual(size(features), [1 26]);
        end
        
    end
    
end

