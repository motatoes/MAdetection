function [ features ] = shapeFeatures( candidates )
%CALCULATEPIXELFEATURES Summary of this function goes here
%   Detailed explanation goes here
    
    rgPixels = candidates.getCellArray();
    
    tmp = zeros(size(candidates.getBinaryImage()));
    
    majorAxisLengths = zeros(length(rgPixels), 1);
    minorAxisLengths = zeros(length(rgPixels), 1);
    aspectRatios = zeros(length(rgPixels), 1);
    perimiters = zeros(length(rgPixels), 1);
    areas = zeros(length(rgPixels), 1);
    eccentricities = zeros(length(rgPixels), 1);
    compactnesses = zeros(length(rgPixels), 1);

    for i=1:length(rgPixels)
        tmp(rgPixels{i}) = 1;
        stats = regionprops(tmp, 'Area', 'Perimeter', 'Centroid', 'MajorAxisLength', 'MinorAxisLength');
        boundaryPixels = bwboundaries(tmp, 'noholes');
        % we only have one object ..
        boundaryPixels = boundaryPixels{1};
        
        % major axis length
        majorAxisLengths(i) = stats.MajorAxisLength;
        
        % minor axis length
        minorAxisLengths(i) = stats.MinorAxisLength;        
        
        % Perimiter
        perimiters(i) = stats.Perimeter;
        
        % Area
        areas(i) = stats.Area;
        
        % Shape complexity (eccentircity/circularity)
        eccentricities(i) = perimiters(i).^2 / (4 * pi * areas(i));
        
        % compactness sqrt(averagedistance from centroidsto each boundary
        % pixel)
        distances = sqrt((stats.Centroid(1) - boundaryPixels(:,2)).^2 + (stats.Centroid(2) - boundaryPixels(:,1)).^2);
        compactnesses(i) = sqrt(mean(distances));
        
        % Reset the values of tmp for the next iteration
        tmp = zeros(size(candidates.getBinaryImage()));
    end
    
    % Adding one in the denominator to avoid infinite values
    aspectRatios = majorAxisLengths ./ (minorAxisLengths+1);
    
    % Aspect ratio (adding one to avoid infinite values)
    features = [aspectRatios, majorAxisLengths, minorAxisLengths, perimiters, areas, eccentricities, compactnesses];
end
