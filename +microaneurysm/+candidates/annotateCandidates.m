function img_annotated = annotateCandidates(imageToAnnotate, candidates, labels, varargin)
    % Returns an image with all the shapes annotated.
    
    p = inputParser();
    addParameter(p, 'shape', 'circle');
    addParameter(p, 'radius', 15);
    addParameter(p, 'fontsize', 12);
    
    parse(p, varargin{:});
    shape = p.Results.shape;
    radius = p.Results.radius;
    fontsize = p.Results.fontsize;

    
    img_annotated = imageToAnnotate;
    ca = candidates.getCellArray;
    for aa=1:length(labels)
        
        tmp = false(size(candidates.getBinaryImage));
        tmp(ca{aa}) = true;
        centroid = regionprops(tmp, 'centroid');
        if (~isempty(centroid))
            centroid = [centroid.Centroid(1,1), centroid.Centroid(1,2)];
            img_annotated = annotate(img_annotated, centroid, radius, shape, labels{aa}, fontsize);
        end
    end

    function img = annotate(img, centroid, radius, shape, label, fontsize)
        
        if (strcmp(shape, 'circle'  ))
            img = insertObjectAnnotation(img, shape, [centroid radius], label, 'fontsize', fontsize);
        elseif (strcmp(shape, 'rectangle'))
            img = insertObjectAnnotation(img, shape, [centroid radius radius], label, 'fontsize', fontsize);
        else
            error('unknown shape');
        end
        