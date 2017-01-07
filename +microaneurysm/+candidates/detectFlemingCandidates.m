function [candidates, intermediateResults] = detectFlemingCandidates(inputImage, varargin)

    defaultGaussSigma = 1;
    defaultGaussZeroMean = false; % Whether or not we will be using a zero mean gaussian
    defaultGaussWindowSize = [15 15];
    defaultTophatStrelSize = 11;
    defaultExclusionMask = false( size(inputImage,1), size(inputImage,2) );
    defaultThresholdPercentagePixels = 5; % The percentage of pixels that will remain in the image after thresholding

    p = inputParser;
    addParameter(p, 'gaussSigma', defaultGaussSigma);
    addParameter(p, 'gaussZeroMean', defaultGaussZeroMean); % Whether or not we will be using a zero mean gaussian
    addParameter(p, 'gaussWindowSize', defaultGaussWindowSize);
    addParameter(p, 'tophatStrelSize', defaultTophatStrelSize);
    addParameter(p, 'ExclusionMask', defaultExclusionMask );
    addParameter(p, 'thresholdPercentagePixels', defaultThresholdPercentagePixels); % The percentage of pixels that will remain in the image after thresholding

    parse(p, varargin{:});
    gaussSigma = p.Results.gaussSigma;
    gaussWindowSize = p.Results.gaussWindowSize;
    tophatStrelSize = p.Results.tophatStrelSize;
    thresholdPercentagePixels = p.Results.thresholdPercentagePixels;
    exclusionMask = p.Results.ExclusionMask;
    gaussZeroMean = p.Results.gaussZeroMean;

    % Apply tophat for vessel removal
    tophatImage = microaneurysm.candidates.util.tophatVesselRemoval(inputImage, 'tophatStrelSize', tophatStrelSize);

    % Use a gaussian to detect potential candidate images
    % We can have a single sigma, or multiple sigma values
    % In the case of multiple sigma values we simply apply all of
    % them and take the maximum
    h = fspecial('gaussian', gaussWindowSize, gaussSigma);
    gaussImage = imfilter(tophatImage, h, 'same');
    gaussImage(exclusionMask) = 0;

    % Get a suitable threshold
    gaussImage = mat2gray(gaussImage, [0, 1]);
    tau = microaneurysm.candidates.util.percentageToThreshold(gaussImage, thresholdPercentagePixels); 
    
    candidates = microaneurysm.candidates.Candidates();
    candidates.setFromBinaryImage( gaussImage >= (tau*5) );

    % Store intermediate results in th e class variable for later
    % use
    intermediateResults.gaussImage  = gaussImage;
    intermediateResults.tophatImage = tophatImage;
end
