classdef PreprocessorMock < microaneurysm.test.MockObject
    %PREPROCESSORMOCK Summary of this class goes here
    %   Detailed explanation goes here
    
    properties(GetAccess=public, SetAccess=private)
        preprocessedImage = zeros(50);        
    end
    
    methods
        function obj = PreprocessorMock(varargin)
        end
        
        function [preprocessedImage, intermediateResults] = apply(self, varargin)
            p = inputParser();
            addParameter(p, 'returnPreprocessedImage', self.preprocessedImage);
            addParameter(p, 'returnIntermediateResults', {});
            parse(p, varargin{:});
            
            preprocessedImage = p.Results.returnPreprocessedImage;
            intermediateResults = p.Results.returnIntermediateResults;
            
            self.addToCallStack( {'apply', varargin{:} });
            self.getReturnValue('apply', {preprocessedImage, intermediateResults});
            
        end
        
        
        function setPreprocessedImage(self, preprocessedImage)
           self.preprocessedImage = preprocessedImage; 
        end
    end
    
    
    
end

