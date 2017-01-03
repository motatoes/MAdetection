       function e = calculate_energy( region, img, varargin)
            % The gradient can be passed to the function in order to avoid
            % calculating it at each function call
            
            p = inputParser();
            addParameter(p, 'gradient2', false);
            parse(p, varargin{:});
            
            if (p.Results.gradient2 == false)
                grads = microaneurysm.util.calculate_gradient(img);
                grads2 = grads .^ 2;
            else
                grads2 = p.Results.gradient2;
            end
            
            % region is a binary image that represents the region to calculate the
            % enrgy for
            % img: the original image (S)

            % tmp = bwboundaries(region, 'noholes');
            % tmp = tmp{1};
            % pixel_locs = sub2ind(size(img), tmp(:,1), tmp(:,2) );
            
            boundaries = bwmorph(region, 'remove');
            pixel_locs = find(boundaries);
            
            
            % Note: The size now is [maxrow maxcol]
            % indeces = sub2ind(size(grads), tmp(:,1)-minrow+1, tmp(:,2)-mincol+1);
            boundary_grads2 = grads2(pixel_locs);
            e = mean( boundary_grads2(:) );
        end