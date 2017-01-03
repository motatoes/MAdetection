function grads = calculate_gradient(img)
    % Horizontal
    sh = fspecial('sobel'); 
    % Vertical
    sv = sh';

    dx = conv2( img, sh, 'same');
    dy = conv2( img, sv, 'same');

    grads = sqrt(dx.^2 + dy.^2);            
end
