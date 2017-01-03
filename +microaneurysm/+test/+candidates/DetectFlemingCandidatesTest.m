classdef DetectFlemingCandidatesTest <  matlab.unittest.TestCase
    %FLEMINGTEST Summary of this class goes here
    
    properties
       preprocessor 
    end
    
    methods(TestClassSetup)
        
        function initpreprocessor(testCase)
            testCase.preprocessor = microaneurysm.test.preprocessing.PreprocessorMock;
            testCase.preprocessor.setPreprocessedImage(ones(50));
        end
    end
    
    methods(Test)
        
        function testThatABasicCandidatesDetectionStepWorks(testCase)
            import microaneurysm.candidates.detectFlemingCandidates
            candidates = detectFlemingCandidates(ones(50));
            testCase.verifyEqual( size( candidates.getBinaryImage() ), [50 50] );
        end
        
    end
    
end

