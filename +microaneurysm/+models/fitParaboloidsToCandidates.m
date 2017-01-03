function [ paraboloids ] = fitParaboloidsToCandidates( inputImage, inputCandidates, varargin )
%FITPARABOLOIDSTOCANDIDATES Summary of this function goes here
% Uses Levenberg marquard optimisation in order to fit a paraboloid to
% pixel regions
%   S: The input image
%   pixels: a cell array which contains the pixel locations of each region
    import microaneurysm.models.Paraboloid
    
    rgpixels = inputCandidates.getCellArray();
    
    paraboloids = cell(1, length(rgpixels));
    
    for j=1:length(rgpixels)

        % There needs to be at least 6 pixels in each region grown MA
        if ( length(rgpixels{j}) >= 1 )
            region_pixels = rgpixels{j};

            region_mask = false(size(inputImage));
            region_mask(region_pixels) = 1;

            % The local minima of the gaussian curve is taken as the minimum
            % intensity pixel n the region
            [val, idx] = min( inputImage(rgpixels{j}) );
            minloc = rgpixels{j}(idx); % Getting the minimum location
            [ centerRow, centerCol ] = ind2sub( size(inputImage), minloc);

            % Use Levenberg-Marquardt algorithm to fit a gaussian curve in the
            % detected regions
%             A_optimum_values(j,:) = fminsearch(@(A) lm_gauss_fit_error2(A, S, centerCol, centerRow, region_mask), [0 0 0 0 0 0]);
            inputImage = double(inputImage);
            region_pixels = find(region_mask);
            optimalParameters =  lsqnonlin( @(A) lm_gauss_fit_error(A, inputImage, centerCol, centerRow, region_pixels), ...
                                   [1 1 1 1 1 1], [], [], ...  
                                   optimoptions(@lsqnonlin, 'Algorithm', 'levenberg-marquardt', 'Display', 'final', 'MaxFunEvals', 1200));
                               
            paraboloids{j} = Paraboloid(optimalParameters);
        end
    end



function [ err_values ] = lm_gauss_fit_error( A, img, centerC, centerR, region_pixels )
%LM_GAUSS_FIT_ERROR Summary of this function goes here
%   Detailed explanation goes here
%     err = double(0);

    % convert the image to double

    err_values = double(zeros(size(region_pixels)));

    z_actual = img( region_pixels );
    [yi, xi] = ind2sub( size(img), region_pixels);

    xi = xi - centerC;
    yi = yi - centerR;

    z_expected = A(3) .* (xi - A(1)).^2 + 2 .* A(4) .* (xi - A(1)) .* (yi - A(2)) + A(5) .* (yi - A(2)).^2 + A(6);

    err_values = z_actual - z_expected;

    % == for plotting surface plots and debugging umcomment the
    % lines bellow == %
    % [xx,yy] = meshgrid( min(xi):max(xi), min(yi):max(yi));
    % zz = A(3) .* (xx - A(1)).^2 + 2 .* A(4) .* (xx - A(1)) .* (yy - A(2)) + A(5) .* (yy - A(2)).^2 + A(6);
    % figure(1);
    % subplot(1, 2, 1);
    % surf(zz);
    % subplot(1, 2, 2);
    % surf(img(min(yi+centerR):max(yi+centerR), min(xi+centerC):max(xi+centerC)));
    % drawnow;
    % sum(err_values.^2)
