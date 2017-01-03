function [preprocessedImage, intermetiateResults] = preprocessFleming(grayImage, varargin)
    

    % backgorundFilterSize
    bgFilterSize = [68 68];

    % Median filtering, to remove noise
    intermetiateResults.noSPnoiseImage = medfilt2(grayImage, [3, 3]);

    % Histogram equalisation
    intermetiateResults.histeqImage = adapthisteq(intermetiateResults.noSPnoiseImage);

    % S&P noise removal
    % gaussImage = histeqImage.gaussian([3,3], 2, 'same');
    intermetiateResults.gaussImage = imgaussfilt( double(intermetiateResults.histeqImage), 2, 'FilterSize', [3 3]);

    % medianImage for background estimation (very large median
    % filter)
    intermetiateResults.bgEstimateImage = medfilt2( uint8(intermetiateResults.gaussImage), bgFilterSize);

    % Store this as the background image

    intermetiateResults.shadecorrectedImage = intermetiateResults.gaussImage ./ double(intermetiateResults.bgEstimateImage+1);
    preprocessedImage = intermetiateResults.shadecorrectedImage / (std2(intermetiateResults.shadecorrectedImage)+1);
end