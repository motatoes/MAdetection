function [ features ] = intensityFeatures(  inputChannel, candidates )
    %CALCULATEINTENSITYFEATURES2 receives an input channel and some
    % candidate objects and then calculates some properties for these candidates
    % Features that are calculated by this function:
    % Channel sums: Sum of intensities in the red plane
    % Channel means: mean of intensities in the red plane
    % Channel std: standard deviation of intensities in the red plane
    % Channel range:  the difference between the maximum intensity and the minimum intensity in the R plane
    % Channel Contrasts: The contrasts in the R plane of the RGB model
    
    rgpixels = candidates.getCellArray;
    
    Channelsums = zeros(length(rgpixels), 1);
    
    Channelmeans = zeros(length(rgpixels), 1);
    
    channelStd = zeros(length(rgpixels), 1);
    
    channelRange = zeros(length(rgpixels), 1);
    
    channelContrasts = zeros(length(rgpixels), 1);
    
    for r=1:length(rgpixels)
        
        % == feature extraction == %
        % Sum of intensities
        Channelsums(r) = sum(inputChannel(rgpixels{r}));
        
        % Mean values in different planes
        Channelmeans(r) = mean(inputChannel(rgpixels{r}));
        
        % Standard deviations
        channelStd(r) = std(inputChannel(rgpixels{r}));
        
        % max - min intensity value
        channelRange(r) = max(inputChannel(rgpixels{r})) - min(inputChannel(rgpixels{r}));
        
        % MA contrast
        % Reset the values of the binary image
        tmp(:,:) = 0;
        tmp(rgpixels{r}) = 1;
        tmpDilated = imdilate(tmp, strel('disk', 3));
        tmpDilated = tmpDilated - tmp; % Extracting the boundaries only
        dilatedBoundPixels = find(tmpDilated);
        channelContrasts(r) = Channelmeans(r) - mean(inputChannel(dilatedBoundPixels));
        
    end
    
    % Return the final value
    features = [Channelsums Channelmeans channelStd channelRange channelContrasts];
end
