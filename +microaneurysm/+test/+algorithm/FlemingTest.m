classdef FlemingTest < matlab.unittest.TestCase
    %FLEMINGTEST Summary of this class goes here
    %   Detailed explanation goes here
    methods
    end
    
    methods(Test)
        
        function testThatFlemingAlgorithmReturnsAnImageOfTheSameSize(testCase)
            import microaneurysm.algorithm.Fleming;
            trainImage = rand(50);
            testImage = rand(50);
            GTImage = true(50);
            
            flem = Fleming();
            
            % Need to train first
            flem.train(trainImage, GTImage);
            candidates = flem.apply(testImage);
            
            testCase.verifyEqual(size(candidates.getBinaryImage()), size(testImage) );
        end

        
        
        
        
        
        
        
        function withCustomRGOptionsReturnsAnImageOfTheSameSize(testCase)
            import microaneurysm.algorithm.Fleming;
            trainImage = rand(50);
            testImage = rand(50);
            GTImage = true(50);
            
            flem = Fleming();
            
            % Need to train first
            flem.regionGrowingOptions = {'maxArea', 100, 'startThreshold', 0, 'endThreshold', 1, 'thresholdInterval', 0.1};
            flem.train(trainImage, GTImage);

    
            candidates = flem.apply(testImage);
        end
        
        function withCustomInitialCandidatesOptionsReturnsAnImageOfTheSameSize(testCase)
            import microaneurysm.algorithm.Fleming;
            trainImage = rand(50);
            testImage = rand(50);
            GTImage = true(50);
            
            flem = Fleming();
            
            flem.candidateDetectionOptions = {'exclusionMask', false(50) };
            % Need to train first
            flem.train(trainImage, GTImage);
            candidates = flem.apply(testImage);
            
            testCase.verifyEqual(size(candidates.getBinaryImage()), size(testImage) );
        end
        
        function withCustomClassificationOptionsReturnsAnImageOfTheSameSize(testCase)
            import microaneurysm.algorithm.Fleming;
            trainImage = rand(50);
            testImage = rand(50);
            GTImage = true(50);
            
            flem = Fleming();
            flem.classifierOptions = {'K', 17, 'KThreshold', 9}; 
            % Need to train first
            flem.train(trainImage, GTImage);
            candidates = flem.apply( testImage );
            
            testCase.verifyEqual(size(candidates.getBinaryImage()), size(testImage));
        end
        
        
        
        
        
        
        
        
        
        
        function testThatFlemingAlgorithmCanTrainOnAnImage(testCase)
            import microaneurysm.algorithm.Fleming;
            inputImage = rand(50);
            groundtruth = ones(50);
            
            flem = Fleming();
            flem.train(inputImage, groundtruth);
            testCase.verifyEqual(size(flem.trainingFeatures,2), 10);
        end
        
        function testThatBuildModelDoesNotThrowExceptionn(testCase)
            import microaneurysm.algorithm.Fleming;
            inputImage = rand(50);
            groundtruth = ones(50);
            
            flem = Fleming();
            flem.train(inputImage, groundtruth);
            flem.buildModel();
        end
        
        
    end
    
end

