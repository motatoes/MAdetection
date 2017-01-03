function [subimage, varargout] = imcropCenter(inputImg, centerCoords, subImageSize)
% imcropCenter: This function is similar to imcrop but uses the center coordinates as input rather than 
% the corner coordinates.
% Use:   subimage = imcropCenter(myImage, [centerRow, centerCol], [subImageWidth, subImageHeight]])
%
% Input:  The input image of which the subimage will be extracted
%
% Input:  coords - a 2x1 vector with the format [row coolumn] that
%         specifies the center coorrdinates of the image to be extracted
%
% Input:  subImageSize: The size of the subimage that will be extracted. This
%         is a 2x1 vector with the format [subWidth, subHeight]. If the
%         width and the height are odd, center coordinates will lie on the
%         exact center of the extracted subimage. If any dimension is even
%         the center coordinate will lie closer to the start of the image.
%         For example, if the width is 6,  the center width will lie at 3,
%         which is closer to the left of the image.
%
% output: An cropped image of size
%
% Example : 
%     % Read a 500x500 image
%     ix = imread('myimage.png');
%     % Crop a 51x51 subimage centered arround ix(20,30)
%     ixc = imcropCenter(ix, [20, 30], [51 51]);
%     figure; imshow(ixc);
% 
    
    % inputImg, centerCoords, subImageSize
    
    imgSize = size(inputImg);
    centerRow = centerCoords(1);
    centerCol = centerCoords(2);
    
    subImageW = subImageSize(1);
    subImageH = subImageSize(2);
    
    halfWidth =  floor(subImageW / 2);
    halfHeight = floor(subImageH / 2);
    
    if (centerRow > (halfWidth)) minRow = centerRow-halfWidth; else minRow=1; end;
    if (centerCol > (halfHeight)) minCol = centerCol-halfHeight; else minCol=1; end;
    if (centerRow+halfWidth <= imgSize(1)) maxRow = centerRow+halfWidth; else maxRow=imgSize(1); end;
    if (centerCol+halfHeight <= imgSize(2)) maxCol = centerCol+halfHeight; else maxCol=imgSize(2); end;
    
    if (mod(subImageH,2) == 0) 
        minRow = (minRow+1);
    end
    
    if (mod(subImageW,2) == 0)
        minCol = (minCol+1);
    end
    
    subimage = inputImg(minRow:maxRow, minCol:maxCol, :);
    
    % Return also the bounding coordinates
    if (nargout == 5)
        varargout{1} = minRow;
        varargout{2} = maxRow;
        varargout{3} = minCol;
        varargout{4} = maxCol;
    end
    