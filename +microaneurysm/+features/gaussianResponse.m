function [gaussImage] = gaussianResponse(inputImage, sigmaValues, gaussWindowSize)
    gaussImage = ones([size(inputImage), length(sigmaValues)]);
    for i = 1:length(sigmaValues)
        sig = sigmaValues(i);
        h = fspecial('gaussian', gaussWindowSize, sig);
        tmp = imfilter(inputImage, h, 'same');
        gaussImage(:,:,i) = tmp;
    end
end

