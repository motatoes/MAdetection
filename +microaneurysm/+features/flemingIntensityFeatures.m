function [features, intermediateResults] = flemingIntensityFeatures( preprocessedImage, candidates, paraboloidParams)
    %% CalculateIntensityFeatures: Enter function description here
    
    import microaneurysm.candidates.candidatesToBoundaryPixels
    
    % For shorter reference ....
    rgpixels = candidates.getCellArray();
    boundaryPixels = candidatesToBoundaryPixels(candidates);
    
    if (isempty(rgpixels))
        % Bye
        features = zeros(length(rgpixels), 4);
        return;
    end
    
    % Calculating the energy values for each grown MA candidate
    energies = zeros(size(rgpixels));
    grad = microaneurysm.util.calculate_gradient(preprocessedImage);
    for i=1:length(rgpixels)
        region = microaneurysm.util.cell2mask({rgpixels{i}}, size(candidates.getBinaryImage));
        energies(i) = microaneurysm.util.calculate_energy(region, preprocessedImage, 'gradient2' , grad.^2);
    end
    
    zmeans = cellfun(@(x) mean(preprocessedImage(x)), boundaryPixels);
    zmeans_cell = mat2cell(zmeans, size(zmeans,1), ones(size(zmeans,2), 1) );
    depths = cellfun(@(p, zmean) p.getDepth(zmean), paraboloidParams, zmeans_cell);
    [a_minors, a_majors] = cellfun(@(p, zmean) p.getMajorMinorAxis(zmean), paraboloidParams, zmeans_cell);
    
    intermediateResults.zmeans = zmeans;
    intermediateResults.depths = depths;
    intermediateResults.a_minors = a_minors;
    intermediateResults.a_majors = a_majors;
    
    % == Canculting feautures == %
    features_fint_local = zeros(length(rgpixels), 4);

    % 1- Depth of MA candidate measured in S using depth of the paraboloid
    features_fint_local(:,1) = zmeans;
    
    % 2- Energy in preprocessed image (S)
    features_fint_local(:,2) = energies;
    
    % 3- The depth of the MA candidate divided by itsmean diameter
    features_fint_local(:,3) = features_fint_local(:,1) ./ sqrt(a_majors' .* a_minors');

    % 4- The energy of the boundary of the MA candidate w/ depth correction
    features_fint_local(:,4) = features_fint_local(:,2) ./ sqrt(features_fint_local(:,1));

    features = features_fint_local;
    
%     upluses = paraboloidParams.get_upluses();
%     uminuses = paraboloidParams.get_uminuses();
%     zmeans = paraboloidParams.get_zmeans(rgBoundaryPixels);
%     a_minors = paraboloidParams.get_aminoraxes('zmeans', zmeans, 'upluses', upluses);
%     a_majors = paraboloidParams.get_amajoraxes('zmeans', zmeans, 'uminuses', uminuses);
    
%     for i=1:length(rgpixels)
%         % Now calculating the fint features
%         paraboloid =  paraboloidParams{i};
%         
%         % [u_plus, u_minus] = paraboloid.getUPlusUMinus();
%         [a_major, a_minor] = paraboloid.getAMajorMinor(zmean);
% 
%         % 1- Depth of MA candidate measured in S using depth of the paraboloid
%         features_fint_local(i,1) = paraboloid.getDeptph(zmean); %depths_originalImage;
%         
% 
%         % 3- The depth of the MA candidate divided by itsmean diameter
%         tmp = a_major*a_minor;
%         if ( tmp > 0 )
%             features_fint_local(i,3) = features_fint_local(i,1)/sqrt(tmp);
%         else
%             is_suitable(i) = false;
%         end
% 
%         % 4- The energy of the boundary of the MA candidate w/ depth correction
%         if (features_fint_local(i,1) > 0)
%             features_fint_local(i,4) = features_fint_local(i,2)/sqrt(features_fint_local(i,1));
%         else
%             is_suitable(i) = false;
%         end
%     end
end