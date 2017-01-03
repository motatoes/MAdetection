function th = tophatVesselRemoval(img, varargin)

    if (size(img,3) ~= 1)
        throw( microaneurysm.exception.InvalidArgument('img') );
    end

    p = inputParser();
    % We only need to specify a degree range from 0 to 180 degrees since
    % the line strel is symmetrical. Note however, that the `strel`
    % function does not seem to produce symmetrical results. More info here
    % http://stackoverflow.com/q/41442596/1765562
    addParameter(p, 'degreeRange', 0:15:180);
    addParameter(p, 'tophatStrelSize', 15);
    parse(p, varargin{:});
    degrees = p.Results.degreeRange;
    strel_size = p.Results.tophatStrelSize;

    min_c = ones( size(img)) * 9999;
    for deg=degrees
        str_el = strel('line', strel_size, deg);
        % c = prepro.morph_close(str_el).getImage();
        c = imclose(img, str_el);
        min_c = min(c, min_c);
    end

    th = min_c - img;
end