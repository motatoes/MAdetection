% The result of the closing operator at variance angles
function mmtf = morphologyLineStrel(inputImage, thetaRange, strel_size)

    min_c = ones( size(inputImage)) * 9999; % sentinal value
    max_c = ones( size(inputImage)) * -9999; % sentinal value
    for deg=thetaRange
        str_el = strel('line', strel_size, deg);
        % c = prepro.morph_close(str_el).getImage();
        c = imclose(inputImage, str_el);
        min_c = min(c, min_c);
        max_c = max(c, max_c);
    end

    % Review this! ?!?!? why max/min?
    mmtf = max_c./min_c;