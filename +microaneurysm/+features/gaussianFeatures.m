function [features] = gaussianFeatures( inputImage, candidates, varargin )
    % GAUSSIANFEATURES
    % Features calculated by this function (for each candidate):
    % 1- max gauss response at seed pixel (responses at 'sigmaValues')
    % 2- min gauss response at seed pixel (responses at 'sigmaValues')
    % 3- mean gauss response at seed pixel (responses at 'sigmaValues')
    % 4- gauss response at seed pixel*
    % 5- mean gauss response for each candidate at all sigma*
    % 6- mean gauss response for each candidate at all sigma*
    % 7- Difference of gaussians for each consecutive pair of sigma values**
    % * = multiple feautes, count = length(sigmaValues)
    % ** multiple feautres, count = length(sigmaValues) - 1
    
    import microaneurysm.features.gaussianResponse
    import microaneurysm.features.gaussianResponse1D
    import microaneurysm.candidates.candidatesToSeedLocations
    
    p = inputParser();
    addParameter(p, 'sigmaValues', 1.0);
    addParameter(p, 'windowSize', [15 15]);
    parse(p, varargin{:});
    
    sigmaValues = p.Results.sigmaValues;
    windowSize = p.Results.windowSize;
    % Given thetaValue idx How much to incriment to get the perpindicular
    % degree?
    
    gaussImage = gaussianResponse(inputImage, sigmaValues, windowSize);
    
    minGauss = min( gaussImage, [], 3 );
    maxGauss = max( gaussImage, [], 3 );
    avgGauss = mean( gaussImage, 3 );
    
    rgpixels = candidates.getCellArray();
    rgSeedLocations = candidatesToSeedLocations( inputImage, candidates);
    
    % variable initialization
    seedIntensityGauss = zeros(length(rgpixels), length(sigmaValues));
    meanCandGauss = zeros(length(rgpixels), length(sigmaValues));
    stdCandGauss = zeros(length(rgpixels), length(sigmaValues));
    DifferenceOfGaussians = zeros(length(rgpixels), length(sigmaValues)-1);
    maxSeeds = zeros(1, length(rgpixels));
    minSeeds = zeros(1, length(rgpixels));
    avgSeeds = zeros(1, length(rgpixels));

    for r = 1:length(rgpixels);
        tmp = false(size(inputImage));
        tmp(rgpixels{r}) = 1;
        
        maxSeeds(r) = maxGauss(rgSeedLocations{r});
        minSeeds(r) = minGauss(rgSeedLocations{r});
        avgSeeds(r) = avgGauss(rgSeedLocations{r});
        
        % Multiscale gaussian features
        for i=1:size(gaussImage, 3)
            gi = gaussImage(:,:,i);
            
            seedIntensityGauss(r,i) = gi(rgSeedLocations{r});
            meanCandGauss(r,i) =  mean(gi(rgpixels{r}));
            stdCandGauss(r,i) =  std(gi(rgpixels{r}));
            
            % mean value of difference of Gaussians
            if (i>1)
                dog = gaussImage(:,:,i) - gaussImage(:,:,i-1);
                DifferenceOfGaussians(r,i-1) = mean(dog(rgpixels{r}));
            end
        end
    end
    
    % == appending all the features == %
    features = zeros(0, 23);
    
    for r=1:length(rgpixels)
        featureRow = [];
        featureRow = [featureRow, maxSeeds(r)];
        featureRow = [featureRow, minSeeds(r)];
        featureRow = [featureRow, avgSeeds(r)];

        featureRow = [featureRow, seedIntensityGauss(r,:)];
        featureRow = [featureRow, meanCandGauss(r,:)];
        featureRow = [featureRow, stdCandGauss(r,:)];
        featureRow = [featureRow, DifferenceOfGaussians(r,:)];
        
        features = [features; featureRow];
    end

    