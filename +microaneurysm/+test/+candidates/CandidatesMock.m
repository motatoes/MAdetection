classdef CandidatesMock < microaneurysm.test.MockObject
    %CANDIDATESMOCK Summary of this class goes here
    %   Detailed explanation goes here
    
    properties(GetAccess=public, SetAccess=public)
        binaryImage;
        cellArray;
    end
    
    methods
        function obj = CandidatesMock(varargin)
        end

        function obj = Candidates(varargin)
        end
        
        function setFromBinaryImage(self, binaryImage, varargin)
            self.addToCallStack( {'setFromBinaryImage', varargin{:} });
        end
        
        function setFromCellArray(self, cellArray, imageSize, varargin)
            self.addToCallStack( {'setFromCellArray', varargin{:} });
        end
        
        function binaryImg = getBinaryImage(self, varargin)
            binaryImg = self.binaryImage;
            self.addToCallStack( {'getBinaryImage', varargin{:} });
            self.getReturnValue('binaryImg', {binaryImg});            
        end
        
        function cellArr = getCellArray(self, varargin)   
            cellArr = self.cellArray;
            self.addToCallStack( {'getCellArray', varargin{:} });
            self.getReturnValue('getCellArray', {cellArr});            
        end
        
    end
    
end

