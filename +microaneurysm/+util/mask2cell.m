function [ cellres ] = mask2cell( maskimg )
%MASK2CELL Converts a mask image to a cell array using connected component
% analysis
%   mask2cell takes as input and image of type logical and returns a cell
%   array 
    p = inputParser();
    addRequired(p, 'maskimg', @(x) validateattributes(x, {'logical'}, {}));
    parse(p, maskimg);
    
    % Extract the connected components from the mask img
    CC = bwconncomp(maskimg);

    % extract individual pixels data from the CC
    cellres = CC.PixelIdxList;
    
end
