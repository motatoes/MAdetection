function [ gaussResponse ] = gaussianResponse1D( inputImage, thetaValues, sigma, gaussWindowSize )
%GAUSSIMAGE1D Summary of this function goes here
%   Detailed explanation goes here

    if ( numel(gaussWindowSize) == 1 ) 
       gaussWindowSize = [gaussWindowSize gaussWindowSize] ;
    end

    gaussResponse = zeros([size(inputImage), length(thetaValues)]);

    for i=1:length(thetaValues)
        % Generating a linear mask at every direction in order to apply it
        % to the gaussian filter matrix            
        theta = thetaValues(i);
        x = floor((gaussWindowSize(1)-1)/2 * cosd(theta));
        y = -floor((gaussWindowSize(2)-1)/2 * sind(theta));
        M = 2*max(abs(y)) + 1;
        N = 2*max(abs(x)) + 1;            
        [xx, yy] = iptui.intline(-x,x,-y,y);
        idx = sub2ind([M,N], yy + max(abs(yy)) + 1, xx + max(abs(xx)) + 1);
        mask = zeros([M N]);
        mask(idx) = 1;

        h = fspecial('gaussian', [M,N], sigma);
        % Apply the mask to turn the gaussian filter to a 1D filter
        h = h .* mask;
        tmp = imfilter(inputImage, h, 'same');
        gaussResponse(:,:,i) = tmp;
    end

end

