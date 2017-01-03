function [isVesselFeature] = isVesselQuartzFeature( candidates,  vesselMask)
    % This method calculates the additional feature column
    % 'is_suitable' which determines whether or not a candidate
    % appears to lie within a vessel branching point or within a
    % vessel

    rgpixels = candidates.getCellArray();

    % We initialize the isVesselFeature with the main classification which 
    isVesselFeature = zeros(length(rgpixels), 1);
    
    tmp = false(size(candidates.getBinaryImage));
    
    % For each region grown candidate ...
    for i=1:length(rgpixels)
        tmp(rgpixels{i}) = 1;
        
        if ( isempty(find(tmp & vesselMask)) )
            isVesselFeature(i) = 0;
        else
            isVesselFeature(i) = 1;
        end
        
        % Reset the value of tmp
        tmp = false(size(candidates.getBinaryImage));
    end
    
end
