classdef BaseTest < matlab.unittest.TestCase
    
    methods (Test)
        
        function testThatAGreenChannelCanBeExtractedFromAColourImage(testCase)
            import microaneurysm.util.color2green;
            colorimg = cat(3, ones(5), ones(5), ones(5));
            res = color2green(colorimg);
            testCase.verifyEqual(res, ones(5));
        end
        
        function testThatAGreenChannelCanBeExtractedIfItsASingleChannelImage(testCase)
            
        end
        
        function testThatAnErrorIsThrownWhenAnInvalidImageSizeIsPassedToTheColor2GreenFunction(testCase)
            
        end
    end
end

