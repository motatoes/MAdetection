function [ maskImg ] = cell2mask( cellArray, resSize, varargin )
%CELL2MASK Converts a cell array of pixel locations to a mask image
%   This function takes a pixel array of type cell and a vector of size
% [1x2] which specifies the size of the resulting image
% Examples:
% cell2mask({[1,2,3], [5,5]}
    
    p = inputParser();
    addRequired(p, 'cellarray', @(x) validateattributes(x, {'cell'}, {}));
    addRequired(p, 'resSize', @(x) validateattributes(x, {'numeric'}, {'size', [1 2]}));
    addParameter(p, 'indexType', 'ind');
    parse(p, cellArray, resSize, varargin{:});
    indexType = p.Results.indexType;
    
    maskImg = false(resSize);
    
    for i=1:length(cellArray)
        indeces = cellArray{i};
        if (strcmp(indexType, 'sub'));
            indeces = sub2ind(resSize, indeces(:,1), indeces(:,2));
        end
        maskImg(indeces) = 1;
    end
    
    