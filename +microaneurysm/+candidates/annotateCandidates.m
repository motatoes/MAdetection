function img_annotated = annotateCandidates(imageToAnnotate, candidates, labels, shape, radius)
    % Returns an image with all the shapes annotated.

    if (nargin == 3) 
        shape ='circle';
        radius = 15;
    end
    
    img_annotated = imageToAnnotate;
    ca = candidates.getCellArray;
    for aa=1:length(labels)
        
        tmp = false(size(candidates.getBinaryImage));
        tmp(ca{aa}) = true;
        centroid = regionprops(tmp, 'centroid');
        if (~isempty(centroid))
            centroid = [centroid.Centroid(1,1), centroid.Centroid(1,2)];
            img_annotated = annotate(img_annotated, centroid, radius, shape, labels{aa});
        end
    end

    function img = annotate(img, centroid, radius, shape, label)
        
        if (strcmp(shape, 'circle'  ))
            img = insertObjectAnnotation(img, shape, [centroid radius], label);
        elseif (strcmp(shape, 'rectangle'))
            img = insertObjectAnnotation(img, shape, [centroid radius radius], label);
        else
            error('unknown shape');
        end
        