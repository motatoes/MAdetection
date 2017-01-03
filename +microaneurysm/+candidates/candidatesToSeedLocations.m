function [ seedLocations ] = candidatesToSeedLocations( inputImage, candidates, varargin )
    %CANDIDATES2SEEDLOCATIONS Summary of this function goes here
    seedLocations = candidates.foreach( @(pixCellArr) getMinLoc(inputImage,pixCellArr) );

    function minloc = getMinLoc(referenceImage, pixelsCellArr)
    % Asigning the minimimum pixel location as the seed pixel
    [~, idx] = min( referenceImage(pixelsCellArr) );
    minloc = pixelsCellArr(idx); % Getting the minimum location

