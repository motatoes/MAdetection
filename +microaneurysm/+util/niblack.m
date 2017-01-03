% The niblack initial candidate detection method uses an
% adaptive thresholding technique where a window (W) of size nxm 
% is used to determine a threshold t. The value of the threshold
% at each pixel is: t = m + sk, where m is mean(window(:)) and 
% s is std(window(:)). k is a constant usually used for candidates
% detection. This technique works were with historical document
% images where the text is much darker than the background
function candidates = niblack(inputImage, varargin)
    p = inputParser();
    addParameter(p, 'windowSize', [101 101]);
    addParameter(p, 'k', 0.18);

    parse(p, varargin{:});
    windowSize = p.Results.windowSize;
    k = p.Results.k;
    m = windowSize(1);
    n = windowSize(2);

%             imageP = padarray(inputImage, [ceil((m+1)/2) ceil((n+1)/2)], 0);

    % Convert the input image to a double image for later filters
    inputImage = double(inputImage);

    % Calculate the mean image
    h = fspecial('average', windowSize);
    averageImage = imfilter(inputImage, h, 'same');

    % Calculate the standard deviation image
    stdImage = stdfilt(inputImage, ones(windowSize));

    % Get the threshould values for each pixel (local thresholding)
    thresholds = k .* stdImage + averageImage;

    candidates = inputImage > thresholds;

end
