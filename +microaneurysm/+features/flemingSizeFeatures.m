function [features, varargout] = flemingSizeFeatures( preprocessedImage, grayImage, bgEstimageImage, candidates, paraboloidParams, npeaks )
%% CalculateSizeFeatures: Enter function description here

    import microaneurysm.candidates.candidatesToBoundaryPixels
    import microaneurysm.candidates.candidatesToSeedLocations
    
    
    rgpixels = candidates.getCellArray();
    rgBoundaryPixels = candidatesToBoundaryPixels( candidates );
    rgSeedLocations = candidatesToSeedLocations( preprocessedImage, candidates );

    
    if (isempty(rgpixels))
        % Bye
        features = zeros(length(rgpixels), 5);
        return;
    end
    

%     upluses = paraboloidParams.get_upluses();
%     uminuses = paraboloidParams.get_uminuses();
%     zmeans = paraboloidParams.get_zmeans(rgBoundaryPixels);
%     % Passing the zmeans as a parameter to avoid recomputation
%     depths = paraboloidParams.get_depths('zmeans', zmeans);
%     a_majors = paraboloidParams.get_amajoraxes('zmeans', zmeans, 'uminuses', uminuses);

    
    zmeans = cellfun(@(x) mean(grayImage(x)), rgBoundaryPixels);
    zmeans_cell = mat2cell(zmeans, size(zmeans,1), ones(size(zmeans,2),1) );
    [upluses, uminuses] = cellfun(@(p) p.getUPlusMinus(), paraboloidParams);
    upluses_cell = mat2cell(upluses, size(upluses,1), ones(size(upluses,2),1) );
    uminuses_cell = mat2cell(uminuses, size(uminuses,1), ones(size(uminuses, 2),1) );
    depths_fn = @(p, zmean, uplus, uminus) p.getDepth(zmean);
    depths = cellfun(depths_fn, paraboloidParams, zmeans_cell);
    axes_fn = @(p, zmean, uplus, uminus) p.getMajorMinorAxis(zmean, 'uplus', uplus, 'uminus', uminus);
    [a_minors, a_majors] = cellfun(axes_fn, paraboloidParams, zmeans_cell, upluses_cell, uminuses_cell);
    
    
    % .. calculating the depth of each MA candidate
    depths_originalImage = zeros(length(rgSeedLocations), 1);
    for i=1:length(depths_originalImage)
        px = rgSeedLocations{i};
        depths_originalImage(i) = abs( double(grayImage(px)) - double(bgEstimageImage(px)) );
    end

    % Now calculating the fsize features
    features = zeros(length(rgpixels), 5);
    
    % 1- number of peaks
    features(:,1) = npeaks;
    % 2- major axis length
    features(:,2) = a_majors;

    % 3- geometric mean of major and minor axis
    tmp = uminuses .* upluses;
    features(:,3) = 2 ./ ( tmp .^(1/4) );

    % 4- Eccentricity of elliptic/al corss-section
    tmp = 1 - (uminuses(i) / upluses(i));
    features(:,4) = sqrt(tmp);

    % 5- Depth of the candidate measuerd in the original image 
    features(:,5) = depths_originalImage;

    
end

