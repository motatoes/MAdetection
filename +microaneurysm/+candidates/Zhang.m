classdef Zhang < microaneurysm.candidatesDetector.Fleming
    %ZHANG Summary of thi0s class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
                
        function candidates = apply()
            % Use a gaussian to detect potential candidate images
            % We can have a single sigma, or multiple sigma values
            % In the case of multiple sigma values we simply apply all of
            % them and take the maximum
            gaussImage = ones([size(tophatImage), length(self.gaussSigma)]);
%             for i = 1:length(gaussSigma)
%                 sig = gaussSigma(i);
                h = fspecial('gaussian', gaussWindowSize, gaussSigma);
                if (gaussZeroMean)
                   h = h - mean(h(:));
                end
                tmp = imfilter(tophatImage, h, 'same');
                % Remove the areas outside the region
                tmp(~exclusionMask) = 0;
                gaussImage(:,:,i) = tmp;
%             end
            
        end
    end
    
end

