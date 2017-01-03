function th = tophatVesselRemoval(img, varargin)

    if (size(img,3) ~= 1)
        throw( microaneurysm.exception.InvalidArgument('img') );
    end

    p = inputParser();
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