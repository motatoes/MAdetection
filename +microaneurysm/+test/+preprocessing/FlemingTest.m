classdef FlemingTest < matlab.unittest.TestCase
    % FLEMINGTEST Summary of this class goes here
    
    methods ( Test )
        function testThatFlemingPreprocessorWorksWithGreenChannelImage(testCase) 
            import microaneurysm.preprocessing.preprocessFleming;
            
            preprocessedImage = preprocessFleming( ones(50) );
            
            testCase.verifyEqual( size(preprocessedImage), [50 50] );
        end
        
        
        function testThatFlemingPreprocessorThrowsErrorWithImageOfWrongSize(testCase)
            
        end
        
    end
    
end

