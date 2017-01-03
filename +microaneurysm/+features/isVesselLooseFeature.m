function [isVesselFeature] = isVesselLooseFeature(inputImage, candidates, vesselMask, varargin)
    import microaneurysm.util.imcropCenter;
    
    % This method calculates the additional feature column
    % 'is_suitable' which determines whether or not a candidate
    % appears to lie within a vessel branching point or within a
    % vessel
    
    p = inputParser();
    addParameter(p, 'subImageWidth', 81);
    addParameter(p, 'subImageHeight', 81);
    % The average diameter of the typical image width in our images
    addParameter(p, 'alpha', 8);
    parse(p, varargin{:});
    
    subImageWidth = p.Results.subImageWidth;
    subImageHeight = p.Results.subImageHeight;
    alpha = p.Results.alpha;
    
    rgpixels = candidates.getCellArray();

    isVesselFeature = zeros(length(rgpixels), 1);

    minEndPoints = [];
    maxEndPoints = [];
    totalValidSegments = 0;
    % For each region grown candidate ...
    for i=1:length(rgpixels)
        % If its not a suitable candidate we don't care about it
        % anyways ..
        
        % Get a subimage of size 81 pixels ..
        % TODO: Replace these three lines with a reusable function
        % as done in FlemingWS.m
        [~, idx] = min( inputImage( rgpixels{i}) );
        minloc = rgpixels{i}(idx); % Getting the minimum location
        q = minloc;

        [qr, qc] = ind2sub( size(inputImage), q);
        [S_sub, minRow_sub, maxRow_sub, minCol_sub, maxCol_sub] = imcropCenter(inputImage, [qr, qc], [subImageWidth, subImageHeight]);
        vesselMask_sub = vesselMask(minRow_sub:maxRow_sub, minCol_sub:maxCol_sub);
        tmp = false(size(inputImage));
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

        % Removing anything smaller than 8 pixels ..
        vesselMask_sub_skel_segments = bwareaopen(vesselMask_sub_skel_segments, 8);

        % Get the connected components
        CC = bwconncomp(vesselMask_sub_skel_segments);

        % First test, we need at least two segments otherwise its
        % not a branchpoint!
        if (CC.NumObjects < 2)
            continue;
        end

        % Second test: 
        % boolean variable initialization
        nValidSegments = 0;
        for cci=1:CC.NumObjects
            segment = false(size(S_sub));
            segment(CC.PixelIdxList{cci}) = 1;
            endpoints = bwmorph(segment, 'endpoints');
            endpoints = find(endpoints);
            if (length(endpoints) < 2)
                continue;
            end

            e1 = endpoints(1);
            e2 = endpoints(2);

            % Subscript indices calculation
            [e1r, e1c] = ind2sub(size(S_sub), e1);
            [e2r, e2c] = ind2sub(size(S_sub), e2);

            % Distances
            d1 = sqrt((e1r - qr_sub)^2 + (e1c - qc_sub)^2);
            d2 = sqrt((e2r - qr_sub)^2 + (e2c - qc_sub)^2);

            % The endpoints should be 
            if (min(d1, d2)>=28 || max(d1, d2)<=35)
                continue;
            end

            % Increment the number of valid segments here
            nValidSegments = nValidSegments + 1;

            totalValidSegments = totalValidSegments +1;
            minEndPoints(totalValidSegments) = min(d1,d2);
            maxEndPoints(totalValidSegments) = max(d1,d2);
        end

        % Did we pass the second test?
        if (nValidSegments >= 2)
            isVesselFeature(i)=1;
        end
    end

    isVesselFeature;
end
