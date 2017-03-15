function [ matches ] = matchCandidates( candidates, candidatesToMatch, radius )
%LABELCANDIDATES associates candidates together by matching the nearby
%canadidates with their closest match. 
%   Detailed explanation goes here
    
    candidatespixels = candidates.getCellArray();
    cmatchPixels = candidatesToMatch.getCellArray();
    
    matches = ones(length(candidatespixels), 1) * -1;

    centroidsToMatch = findCentroids(candidatesToMatch);
    
    for i=1:length(candidatespixels)        
        tmp = false(size(candidates.getBinaryImage));
        tmp(candidatespixels{i}) = true;
        
        centroid = regionprops(tmp, 'Centroid');
        if (isempty(centroid))
            matches(i) = -1;
            continue;
        end
            
        centroid = [centroid(1).Centroid(1), centroid(1).Centroid(2)];
        
        [closestDist, closestIdx] = findClosest(centroid, centroidsToMatch);
        closestCoords = centroidsToMatch(closestIdx, :);
        
        % check that its within tolerance range (circular around the radius
        % TTTTTTTTTTTTTTTTTTTTTTTT---
        % -----T------------T--------
        % ---T---------------T-------
        % --T---------x-------T------
        % ---T----------------T------
        % ----T--------------T-----N-
        % TTTTTTTTTTTTTTTTTTTTTTTT---
        %if (  centroid(1) - radius <= closestCoords(1) && centroid(1) + radius >= closestCoords(1)...
        %   && centroid(2) - radius <= closestCoords(2) && centroid(2) + radius >= closestCoords(2))
        if ( closestDist <= radius)
            matches(i) = closestIdx;
        else
            matches(i) = -1;
        end
    end
    
    function centroids= findCentroids(candidates)
        pixels = candidates.getCellArray();
        centroids = zeros(length(pixels), 2);
        for i=1:length(pixels)
            tmp = false(size(candidates.getBinaryImage()));
            tmp(pixels{i}) = true;
            
            centroid = regionprops(tmp, 'centroid');
            centroids(i,:) = [centroid.Centroid(1,1), centroid.Centroid(1,2)];
        end
        
    function [closestDistance, closestIdx] = findClosest(centroid, centroidsToMatch)
        distances = zeros(size(centroidsToMatch, 1), 1);
        
        for j=1:size(centroidsToMatch, 1)
            distances(j) = sqrt((centroidsToMatch(j,1) - centroid(1)).^2 + (centroidsToMatch(j,2) - centroid(2)).^2);
        end
        [closestDistance, closestIdx] = min(distances);
        