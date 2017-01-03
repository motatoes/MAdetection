% Validate that the input is an image as expected
function validateAsImage(input)
    % The image to set needs to be a 2x2 matrix
    if ( ~ismatrix(input) )
        error('The input image must be an nxm matrix, input argument had %s dimensions', num2str(ndims(input)) );
    end
end