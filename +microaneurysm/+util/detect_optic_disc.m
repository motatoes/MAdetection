function [OP_seg] = detect_optic_disc(img, varargin)
    % Detect the optic disc in a retinal image using akara mathematical
    % morphology technique

    
    p = inputParser();
    
    addOptional(p, 'Alpha1', 0.7);
    parse(p, varargin{:});
    
    alpha1 = p.Results.Alpha1;
    
    
    %Preprocessing
    I = img;
    [v h n]=size(I);

    % resize image 
    J=imresize(I, [NaN 500]); %0.25image size is 500*752
    [vj hj nj]=size(J);

    % seperate RGB plane
    red=J(:,:,1);
    green=J(:,:,2);
    blue=J(:,:,3);

    % convert RGB to HSV
    JH=rgb2hsv(J);
    H=JH(:,:,1);
    S=JH(:,:,2);
    V=JH(:,:,3);

    % apply median filtering to I band
    Vfilter = medfilt2(V);

    % apply Contrast-Limited Adaptive Histogram Equalization to I band.
    Vadapt=adapthisteq(Vfilter);    
    
    %%                  OPTIC_CLOSING.M
    % 1. detect optic disc by closing (strel=7)
    % 2. find 1st pixel
    % 3. find area of every region which contains 1st value
    % 4. remove all area except the largest area
    
    % Closing
    se=strel('disk',7);
    OP1 =imclose(Vadapt, se);
    
%     alpha1 = 0.6;
    OP1_thresh = OP1>=alpha1;
    
    % fill the holes in any contours
    OP1_thresh = imfill(OP1_thresh, 'hole');
    OP2 = Vadapt;
    OP2(OP1_thresh) = 0;
    
    OP3 = imreconstruct(OP2, Vadapt);
    
    alpha2_offset = 0.2;
    alpha2 = graythresh(Vadapt) - alpha2_offset;
    OP4 = (Vadapt - OP3) > alpha2;
    
    %Find the largest circular region in the max;
    [labels, n] = bwlabel(OP4);
    max_circularity = 0;
    max_circularity_index = 1;
    for i=1:n
        region = labels==i;
        current_area = bwarea(region);
        % The perimiter of the region
        current_perim = bwarea(bwperim(region));
        % This is the value of "Compactness" or 'M' as mentioned in the paper
        current_circularity = 4 * pi * (current_area / current_perim^2);
        % Giving more weight to the current area to make sure that a single ...
        % ... pixel does not end up being the most 'circular' object in the image
        current_circularity = current_circularity * current_area;
        if (current_circularity > max_circularity) 
            max_circularity= current_circularity;
            max_circularity_index = i;
        end
    end

    % Extract the optic disc, which is the region of maximum area
    optic_disc = (labels==max_circularity_index);

    OP_seg = optic_disc;
   
    
end