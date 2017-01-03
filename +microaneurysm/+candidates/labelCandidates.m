function [ labels ] = labelCandidates( candidates, groundtruthMask )
%LABELCANDIDATES Summary of this function goes here
%   Detailed explanation goes here
    candidatespixels = candidates.getCellArray();
    labels = zeros(length(candidatespixels), 1);
    for i=1:length(candidatespixels)
        pixels = candidatespixels{i};
        
        tmp = false(size(groundtruthMask));
        tmp(pixels) = true;
        isMatch = numel(find(tmp & groundtruthMask)) > 0;
        if (isMatch)
            labels(i) = 1;
        else
            labels(i) = 0;
        end
    end
    