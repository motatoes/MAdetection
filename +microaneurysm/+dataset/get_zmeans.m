function [  ] = get_zmeans( input_args )
%GET_ZMEANS Summary of this function goes here
%   Detailed explanation goes here
            % Calculating the zmeans values which are the mean intensity
            % around (in the preprocessed image)
            S = self.preprocessedImage;
            rgpixels = self.regionGrowingPixels;
            
            zmeans = zeros(length(rgpixels), 1);
            for i=1:length(rgpixels)
                tmp = false(size(S));
                tmp(rgpixels{i}) = 1;
                bounds_mask = bwboundaries(tmp);
                
                % The following line is to avoid out of bounds exception while 
                % running the code but is this the right thing to do???????
                if (isempty(bounds_mask))
                    continue;
                end
                
                bound_pixels = bounds_mask{1}; % extracting the first matrx of the cell
                % bound_pixels is nx2 subscript index matrix, now converting to
                % linear index
                bound_pixels = sub2ind(size(S), bound_pixels(:,1), bound_pixels(:,2) );
                zmeans(i) = mean(S(bound_pixels));
            end
end

