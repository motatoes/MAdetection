function boundaryPixels = candidatesToBoundaryPixels(candidates)
    
    boundaryPixels = {};
    
    rgpixels = candidates.getCellArray();
    for i=1:length(rgpixels)
        tmp = false(size(candidates.getBinaryImage));
        tmp(rgpixels{i}) = 1;
        bounds_mask = bwboundaries(tmp, 'noholes');

        % The following line is to avoid out of bounds exception while 
        % running the code but is this the right thing to do???????
        if (isempty(bounds_mask))
            boundaryPixels{i} = [];
            warning('No boundary pixels found at index %d ... assining []', i);
        else
            % There is only one boundary .. extract it's pixels
            bound_pixels = bounds_mask{1};
            % bound_pixels is nx2 subscript index matrix, now converting to
            % linear index
            bound_pixels = sub2ind(size(candidates.getBinaryImage), bound_pixels(:,1), bound_pixels(:,2) );
            boundaryPixels{i} = bound_pixels;                    
        end

    end
    
end
