function [ features ] = morphologyFeatures( inputImage, candidates, varargin)
%CALCULATEMORPHOLOGYFEATURES Summary of this function goes here
%   Detailed explanation goes here

    p = inputParser();
    
    addParameter(p, 'thetaRange', 0:22.5:180);
    addParameter(p, 'tophatStrelSize', 15);
    parse(p, varargin{:});
    
    thetaRange = p.Results.thetaRange;
    strel_size = p.Results.tophatStrelSize;

    rgpixels = candidates.getCellArray();
    
    % The maximum morphology template resoponse
    mmtf = microaneurysm.features.morphologyLineStrel(inputImage, thetaRange, strel_size);
    
    mmtf_max = zeros(length(rgpixels), 1);
    mmtf_min = zeros(length(rgpixels), 1);
    mmtf_mean = zeros(length(rgpixels), 1);
    
    for r=1:length(rgpixels)
        mmtf_max(r) = max(mmtf(rgpixels{r}));
        mmtf_min(r) = min(mmtf(rgpixels{r}));
        mmtf_mean(r) = mean(mmtf(rgpixels{r}));
    end
    
    features = [mmtf_max mmtf_min mmtf_mean];
 
