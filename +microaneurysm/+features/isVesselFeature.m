function [isVesselFeature] = isVesselFeature(inputImage, paraboloid, candidates, is_suitable, vesselMask, varargin)
    % This method calculates the additional feature column
    % isVessel which determines whether or not a candidate
    % appears to lie within a vessel branching point or within a
    % vessel. The isVessel feature was documented in (Fleming, 2006)
    
    p = inputParser();
    addParameter(p, 'subImageWidth', 81);
    addParameter(p, 'subImageHeight', 81);
    % The average diameter of the typical image width in our images
    addParameter(p, 'alpha', 8);
    parse(p, varargin{:});
    
    subImageWidth = p.Results.subImageWidth;
    subImageHeight = p.Results.subImageHeight;
    alpha = p.Results.alpha;
    
    rgpixels = candidates.regionGrownPixels;
    rgBoundaryPixels = candidates.get_boundaryPixels();
    
    preproImg = inputImage.preprocessedImage;

    upluses = paraboloid.get_upluses();
    zmeans = paraboloid.get_zmeans(rgBoundaryPixels);
    a_minors = paraboloid.get_aminoraxes('zmeans', zmeans, 'upluses', upluses);

    % We initialize the isVesselFeature with the main classification which 
    % we get from the '_loose' function 
    isVesselFeature = microaneurysm.features.isVesselLooseFeature(inputImage, candidates, is_suitable, vesselMask);
    
    % For each region grown candidate ...
    for i=1:length(rgpixels)

        % If its not a suitable candidate we don't care about it
        % anyways ..
        % Or if the vessel feature from the '_loose' classification
        if (is_suitable(i) == 0 || isVesselFeature(i) == 0)
            continue;
        end

        % Get a subimage of size 81 pixels ..
        % TODO: Replace these three lines with a reusable function
        % as done in FlemingWS.m
        [~, idx] = min( preproImg( rgpixels{i}) );
        minloc = rgpixels{i}(idx); % Getting the minimum location
        q = minloc;

        [qr, qc] = ind2sub( size(preproImg), q);
        [S_sub, minRow_sub, maxRow_sub, minCol_sub, maxCol_sub] = helpers.imcropCenter(preproImg, [qr, qc], [subImageWidth, subImageHeight]);
        vesselMask_sub = vesselMask(minRow_sub:maxRow_sub, minCol_sub:maxCol_sub);
        tmp = false(size(preproImg));
        tmp(rgpixels{i}) = 1;
        MA_sub = tmp(minRow_sub:maxRow_sub, minCol_sub:maxCol_sub);

        qr_sub = (qr-minRow_sub);
        qc_sub = (qc-minCol_sub);
        % Skeletonisation (TODO 'thin' Vs 'skel' ?? )
        vesselMask_sub_skel = bwmorph(vesselMask_sub, 'thin', Inf);

        % Spur removal (n=5 set experimentally but may require
        % further investigation)
        vesselMask_sub_skel = bwmorph(vesselMask_sub_skel, 'spur', 8);
        % Removing verry small skeleton parts (usually spur ..)
        vesselMask_sub_skel = bwareaopen(vesselMask_sub_skel, 5);
        % Extract the boundaries of the vessel
        vesselMask_sub_bounds = bwmorph(imreconstruct(vesselMask_sub_skel, vesselMask_sub ), 'remove', Inf);
        vesselMask_sub_bounds = bwmorph(vesselMask_sub_bounds, 'spur', 10);

        % branchpoint removal
        vesselMask_sub_skel_segments = vesselMask_sub_skel & ~imdilate(MA_sub, ones(3));

        % Removing anything smaller than 5 pixels ..
        vesselMask_sub_skel_segments = bwareaopen(vesselMask_sub_skel_segments, 8);

        % Get the connected components
        CC = bwconncomp(vesselMask_sub_skel_segments);

        % First test, we need at least two segments otherwise its
        % not a branchpoint!
        if (CC.NumObjects < 2)
            continue;
        end

        % So .. we passed the second test on endpoints \m/
        % We now check that the MA was not just really close to a
        % vessel , something like:
        %           MA candidate
        %                ||
        %                \/
        %                __
        % ______________/  \____________
        %               \__/        
        % ______________________________
        %                ^
        %                |
        %            A vessel

        a_minor = a_minors(i);
        skel_inds = find(vesselMask_sub_skel);
        [skel_rows, skel_cols] = ind2sub(size(S_sub), skel_inds);

        distances = sqrt((qr_sub-skel_rows).^2 + (qc_sub-skel_cols).^2);
        min_dist = min(distances(:));

        % The minimum distance between the skeleton and the MA
        % candidate center needs to be less than the value of a_minor
        if (min_dist > a_minor)
            continue;
        end

        % == well well well, so its not just an MA close to a
        % vessel, its time to do our FINAL check to classify it as
        % truly a dark region within a vessel or an actual MA ...

        % We make three final checks to make the final
        % classification, if any of these checks passes we classify
        % it as part of a vessel and move on to the next candidate
        % ... i.e. :
        % Candidate = 1, if is_junction or E(W)>2Ev or W>1.5Wv
        % Candidate = 0, otherwise

        % Condition 1: is_junction
        %-------------------------%
        % There are two cases for a junction:
        % 1- two vessel crossing like so
        %           | |
        %           | |
        %           | |
        %  _________| |____________
        % __________   ____________
        %           | |
        %           | |
        %           | |
        %           | |
        % This is considered when we have two 
        % 2. a vessel splitting like so
        %  \ \
        %   \ \
        %    \ \_________
        %       ________
        %    / /
        %   / /
        %  / /
        % / /

        % The paper description is not very clear so we are gonna
        % ignore this part for now
        is_junction = false;
        % We define a junction as where more than 2 vessel segments
        % meet (also as in fleming)
        is_junction = CC.NumObjects > 2;

        if (is_junction == true)
            isVesselFeature(i) = 1;
            continue;
        end

        % Condition 2: E(W) > 2Ev
        %--------------------------%
        % Where E(W) is the energy of the MA candidate and
        % Ev is the is energy of the vessel and
        % Energy is defined as the average gradient around the
        % boundary of an object

        % Calculating the gradient image ..
        grads = microaneurysm.util.calculate_gradient(S_sub);
        % Calculating the mean gradient around the vessel
        Ev = mean(grads(find(vesselMask_sub_bounds)));

        % Ev needs to be greater than 3 otherwise we will not
        % proceed
        % if (Ev <= 3)
        %     continue;
        % end

        % Calculating the mean gradient around the MA candidate
        MA_grad = mean( grads(find(MA_sub)));

        MA_grad_greater_than_vess_grad = MA_grad > 2*Ev;

        if (MA_grad_greater_than_vess_grad)
            isVesselFeature(i) = 1;
            continue;
        end

        % Condition 3: W < 1.5(Wv)
        %-------------------
        % Where Wv is the average vessel width and
        % W is the width of the MA candidate

        % calculating average vessel width
        inds = find(vesselMask_sub_skel);
        vessel_bound_inds = find(vesselMask_sub_bounds);
        [vessel_bound_rows, vessel_bound_cols] = ind2sub(size(S_sub), vessel_bound_inds );

        totalw = 0;
        for k=1:length(inds)
            ind = inds(k);
            [r,c] = ind2sub(size(S_sub), ind);
            distances = sqrt( (r - vessel_bound_rows).^2 + (c - vessel_bound_cols).^ 2 );
            % Half of the width is assumed to be the distance between the 
            % skeleton pixel and the nearest boundary pixel ..
            %(see Roshan's phd thesis for details on this vessel width
            % estimation method)
            lw = min(distances(:));
            totalw = totalw + lw * 2;
        end
        Wv = totalw/length(inds);

        % calculating the MA width width perpindicular to the vessel 


        % Calculating the distances between the MA cenetr and each
        % vessel boundary pixel
        distances = sqrt( (qr_sub - vessel_bound_rows).^2 + (qc_sub - vessel_bound_cols) .^ 2);
        % Finding the minimum distance between the MA candidate
        % center and the vessel boundary (skeleton). We assume that
        % the line connecting the MA center and the closes pixel on
        % the vessel boundary will form a cross section of the
        % vessel.
        [~, min_bound_idx_p] = min(distances);
        min_bound_row = vessel_bound_rows(min_bound_idx_p);
        min_bound_col = vessel_bound_cols(min_bound_idx_p);

        % Finding the angle between the center pixel and the neares
        %t vessel boundary pixel
        btheta = atan( (min_bound_row - qr_sub) / (min_bound_col - qc_sub));

        % meshgrid of points
        [rr cc] = meshgrid(1:subImageHeight , 1:subImageWidth);
        % Make the center of the coordinates around the center of
        % the MA candidate
        rrc = rr - qr_sub;
        ccc = cc - qc_sub;

        % Convert the coordinates to polar form ..
        [thetac, rhoc] = cart2pol(rrc, ccc);

        % Find the minimum theta difference

        % These are the theta values of the MA boundary
        % Finding the bound pixels around the MA candidate
        MA_sub_bounds = bwmorph(MA_sub, 'remove');

        % Finding subscript indices of MA_sub_bounds
        [MA_bounds_r, MA_bounds_c] = ind2sub(size(S_sub), find(MA_sub_bounds));                
        bound_thetas = thetac( sub2ind(size(S_sub), MA_bounds_r, MA_bounds_c));
        [ ~, min_bound_idx_p] = min( abs(bound_thetas -   btheta) );

        % In order to avoid having the same negative and positive
        % match for the MA candidate boundary (especialy when theta
        % value is zero), we copy the values to a new variable and
        % then set a high value to the minimum positive index
        bound_thetasn = bound_thetas;
        bound_thetasn(min_bound_idx_p) = 999;

        % Performing the match for the negative angle (oposite
        % direction)
        [ ~, min_bound_idx_n] = min( abs(bound_thetasn - (-btheta)) );

        % Find the MA boundary points that intersect
        % ....

        % min_bound_theta

        % Calculate the width of the MA candidate perpindicular to
        % the vessel boundary
        W = sqrt((MA_bounds_r(min_bound_idx_n)-MA_bounds_r(min_bound_idx_p)).^2 + (MA_bounds_c(min_bound_idx_n)-MA_bounds_c(min_bound_idx_p)).^2);

        MA_width_greater_than_vess_width = W > 1.5 * Wv;

        % An MA candidate is considered part of a vessel if it is
        % NOT much larger than the vessel
        if ( ~MA_width_greater_than_vess_width  )
            isVesselFeature(i) = 1;
            continue;
        end

    end

    % Store the result
    isVesselFeature;


end
