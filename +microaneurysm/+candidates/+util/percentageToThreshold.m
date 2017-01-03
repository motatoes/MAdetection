% Returns the threshold T Such that X% of the pixels in
% the image will have intensity value greater than T
function result_threshold = percentageToThreshold(inputImage, percent, varargin)
    ratio_included = percent/100;
    img = inputImage;
    img = double( img );
    img = mat2gray( img, [0, 1] );
    interval = -0.001;
    thresholds = 1:interval:0.001;
    result_threshold = thresholds(1);
    for t=thresholds
        if ( length(find(img>t)) > (ratio_included*length(img(:))) )
            % Subtracting 0.01 because we want -at most- 5% of pixels
            result_threshold = t - interval;
            break;
        end
    end
end