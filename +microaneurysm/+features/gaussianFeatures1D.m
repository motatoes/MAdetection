function [ features ] = gaussianFeatures1D( inputImage, candidates, varargin )
    %GAUSSIANFEATURES1D Summary of this function goes here
    % features calculated by this function
    % 1- max gaussian response for seed pixel (over all 'thetaValues')
    % 2- min gaussian response for seed pixel (over all 'thetaValues')
    % 3- mean gaussian response for seed pixel (over all 'thetaValues')
    % 4- standard deviation gaussian response for seed pixel (over all 'thetaValues')
    % 5- 1D gaussian response at angle perpindicular to the maximum response (1)
    % 6- max(1,5)
    
    import microaneurysm.features.gaussianResponse1D
    import microaneurysm.candidates.candidatesToSeedLocations
    
    p = inputParser();
    addParameter(p, 'sigma', 1.0);
    addParameter(p, 'thetaValues', 0:10:90);
    addParameter(p, 'windowSize', [15 15]);
    parse(p, varargin{:});
    
    sigma = p.Results.sigma;
    windowSize = p.Results.windowSize;
    thetaValues = p.Results.thetaValues;
    thetaValues90step = floor( (thetaValues(2) - thetaValues(1)) / 90);

    gaussImage1D = gaussianResponse1D(inputImage, thetaValues, sigma(1), windowSize);
    
    rgpixels = candidates.getCellArray();
    rgSeedLocations = candidatesToSeedLocations( inputImage, candidates);
    
    
    %1D
    minGauss1D = min( gaussImage1D, [], 3 );
    [maxGauss1D,maxgauss1D_idx] = max( gaussImage1D, [], 3 );
    avgGauss1D = mean( gaussImage1D, 3 );
    stdGauss1D = std( gaussImage1D, [], 3);
    % To get the responses perpindicular to every max we simply add the
    % value of the perpindicular step to the max index. we take the modulus
    % value to avoid having it overflow 
    perpindicularGauss1D = zeros(size(gaussImage1D,1), size(gaussImage1D,2));
    t = mod( maxgauss1D_idx+thetaValues90step, length(thetaValues))+1;
    for d=1:size(gaussImage1D,3)
        x = gaussImage1D(:,:,d);
        perpindicularGauss1D(t==d) = x(t==d);
    end
    
    features = zeros(0, 6);
    
    rgSeedLocations = candidatesToSeedLocations( inputImage, candidates );
    
    for r = 1:length(rgpixels);
        maxSeeds1D(r) = maxGauss1D(rgSeedLocations{r});
        minSeed1D(r) = minGauss1D(rgSeedLocations{r});
        avgSeed1D(r) = avgGauss1D(rgSeedLocations{r});
        stdSeed1D(r) = stdGauss1D(rgSeedLocations{r});
        perpindicularSeeds(r) = perpindicularGauss1D(rgSeedLocations{r});
        perpindicularSeedsMaxDiff(r) = maxSeeds1D(r) - perpindicularSeeds(r);

        featureRow = [];
        featureRow = [featureRow, maxSeeds1D(r)];
        featureRow = [featureRow, minSeed1D(r)];
        featureRow = [featureRow, avgSeed1D(r)];
        featureRow = [featureRow, stdSeed1D(r)];
        featureRow = [featureRow, perpindicularSeeds(r)];
        featureRow = [featureRow, perpindicularSeedsMaxDiff(r)];

        features = [features; featureRow];
        
    end
    
end

