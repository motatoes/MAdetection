function [regionGrownCandidates, intermediateResults]  = flemingRegionGrow(referenceImage, candidates, varargin)
%Fleming Region growing class Implements the region growing technique documented in fleming, 2006
%   Detailed explanation goes here
    
    p = inputParser();
    addParameter( p, 'maxArea', 100 );
    addParameter( p, 'startThreshold', 0 );
    addParameter( p, 'endThreshold', max(referenceImage(:)) );
    addParameter( p, 'thresholdInterval', 0.1);
    parse(p, varargin{:})
    MAX_AREA = p.Results.maxArea;
    THRESHOLD_START = p.Results.startThreshold;
    THERSHOLD_END = p.Results.endThreshold;
    THERSHOLD_INTERVAL = p.Results.thresholdInterval;
    
    % The threshold values that we are going to test on
    referenceImage = double(referenceImage);

    % extract individual pixels data from the CC
    region_pixels = candidates.getCellArray;
    S1 = zeros(1, length(region_pixels));
    J = zeros(1, length(region_pixels));
    seed_locations = getCandidateSeedLocations(referenceImage, region_pixels );

    for i=1:length(region_pixels)
        J(i) = seed_locations{i};
        S1(i) = referenceImage(seed_locations{i}); 
    end

    rgMask = false(size(referenceImage));    %just means an array of zeros the size of f.

    thresholds = THRESHOLD_START : THERSHOLD_INTERVAL : THERSHOLD_END;

    energies = zeros(length(S1), length( thresholds )+1);
    grad = microaneurysm.util.calculate_gradient(referenceImage);
    grad2 = grad .^ 2;
    
    % Note: its better to prealocate these but there's something i need to
    % think about in the for loop since we end up with empty matrices at the
    % end and it causes problems during the feature calculation
    npeaks = [];%zeros(1, length(S1));
    seed_locs_final = {};
    rgpixels = {};

    % region growing is performed in this loop using image reconstruction
    % technique after thresholding the input image f.
    count = 1;

    kidx = 1;
    for K = 1:length(region_pixels)    %length corresponds to amount of seed points, and hence will be used to call each seed point to get seed value (next line)
        seedvalue = S1(K);

        for t = thresholds

            g1 = grown_region(seedvalue, t, J(K), referenceImage);
            % if the are of the reconstructed region is greater than MAX_AREA we
            % stop and get out of the loop to go to the next MA candidate and
            % repeat the process..

            % calculate the energy at this interval
            energies(K, count) = microaneurysm.util.calculate_energy(g1, referenceImage, 'gradient2' , grad2);

            if ( length(find(g1)) >  MAX_AREA )
                if (count > 1)
                    % we're not considering anything that's >
                    % MAX_AREA while finding peaks
                    g1 = old_g1; % Using the previous RG region
                    count = count - 1 ; % not considering last one
                end
                break;
            end
            % storing the old g1 value since we may need it in the next loop
            % iteration (if the length of the reconstructed image turns out
            % being greater than 3000 (see if statement above)
            old_g1 = g1;

            % Increment the count value
            count = count + 1;
        end

        % convolve the energies by a 0.2 gaussian filter

        h = fspecial('gaussian', [1, 7], 0.2);
        energies(K,1:count) = conv(energies(K,1:count), h, 'same');

    %     figure; plot(energies);

        % Now find the region where the peak is located (see flemming paper
        % p.1225)


        % We can't find a peak if there arent at least three energy values
        if (count<3)
            % just use the initial candidate pixels ...
            final_g = zeros(size(referenceImage));
            final_g( region_pixels{K}) = 1;

            % We can't find any peaks anyway ..
            current_npeaks = 0;

            % Store the pixel values
            current_pixels = find(final_g);

        else
            [peaks, peaksloc] = findpeaks(energies(K,1:count));
            % if there are no peaks we skip
            if ~isempty(peaks)
                % get the final grown region at the selected thershold
                final_g = grown_region(seedvalue, thresholds(peaksloc(1)), J(K), referenceImage );
            else
                % just use the initial candidate pixels ...
                final_g = zeros(size(referenceImage));
                final_g( region_pixels{K}) = 1;

            end

            current_npeaks = length(peaks);

            % Store the pixel values
            current_pixels = find(final_g);

        end

        % store the peaks count
        npeaks(kidx) = current_npeaks;

        % Store the pixel values
        rgpixels{kidx} = current_pixels;
        % Increment this counter ...
        kidx = kidx+1;                    

        % Add them all to the final region grown image
         rgMask = rgMask|final_g;


        % Reset the count value
        count = 1;
    end

    intermediateResults.rgEnergies = energies;
    intermediateResults.rgNpeaks = npeaks;
    intermediateResults.rgSeedLocations = seed_locations;

    regionGrownCandidates = microaneurysm.candidates.Candidates();
    regionGrownCandidates.setFromCellArray(rgpixels, size(referenceImage));




    function g = grown_region( seedvalue, thershold, seed_location, img )
        S = abs(seedvalue + thershold)>=img;
        % MH:
        marker = false(size(img));
        marker(seed_location) = 1;
        g = imreconstruct(marker,S);
    end

    % Takes in any location as an "ind" subscript and
    % Searches for the index of self.regionPixels where
    % that location lies .. if its not found it returns -1
    function idx = loc2regionGrownIdx(loc, regionGrownPixels, varargin)
        p = inputParser;
        addParameter(p, 'pixelsFilter', ones(length(regionGrownPixels), 1) );
        parse(p, varargin{:});

        regionsFilter = p.Results.pixelsFilter;
        rgpixels = regionGrownPixels(regionsFilter);

        if (regionGrownCandidates(loc) == 0)
            idx = -1;
        else
            for i=1:length(rgpixels)
                % if ~isempty(find(loc == self.regionGrownPixels{i}))
                if ~isempty(find(ismember(loc, rgpixels{i})))
                    idx = i;
                    break;
                end
            end
        end

    end

end


% candidate in the cell array. Pixel seed locations are simply the
% minimum pixel in the candidate region
function seed_locations = getCandidateSeedLocations(referenceImage, regionPixels)
    seed_locations = {};

    for i=1:length(regionPixels)
        % Asigning the minimimum pixel location and seed value to the variables
        % J and SI
        [~, idx] = min( referenceImage(regionPixels{i}) );
        minloc = regionPixels{i}(idx); % Getting the minimum location
        J(i) = minloc;
        seed_locations{i} = minloc;
    end
end
