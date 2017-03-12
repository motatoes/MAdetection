classdef Candidates < handle
    %CANDIDATES Summary of this class goes here
    %   Detailed explanation goes here
    
    properties(GetAccess=private, SetAccess=private)
        binaryImage;
        cellArray;
    end
    
    methods
        function obj = Candidates(varargin)
            
        end
        
        function setFromBinaryImage(self, binaryImage, varargin)
            self.binaryImage = binaryImage;
            self.cellArray = ria.util.mask2cell(binaryImage);
        end
        
        function setFromCellArray(self, cellArray, imageSize, varargin)
            self.cellArray = cellArray;
            self.binaryImage = ria.util.cell2mask(cellArray, imageSize);
        end
        
        function binaryImg = getBinaryImage(self, varargin)
            binaryImg = self.binaryImage;
        end
        
        function cellArr = getCellArray(self, varargin)   
            cellArr = self.cellArray;
        end
        
        function filteredCandidates = filter(self, filterVector)
            import microaneurysm.candidates.Candidates
            
            filteredCellArray = self.getCellArray();
            filteredCellArray = filteredCellArray( logical(filterVector) );
            filteredCandidates = Candidates();
            filteredCandidates.setFromCellArray(filteredCellArray, size(self.getBinaryImage) );
            
        end
        
        function res = foreach(self, fn)
            res = {};
            for i=1:length(self.cellArray)
               res = [res; fn(self.cellArray{i})];
            end
        end
        
        function imshow(self)
           imshow(self.getBinaryImage) 
        end
        
        function s = size(self)
           s = size(self.getCellArray());
        end
        
        function l = length(self)
           l = length(self.getCellArray());
        end
    end
    
end
