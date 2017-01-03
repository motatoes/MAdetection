function [Gx, Gy] = gradient(inputImage)
    Gx = zeros(size(inputImage));
    Gy = zeros(size(inputImage));
    for i=1:size(inputImage, 3)
        [a, b] = gradient(inputImage(:,:,i));
        Gx(:,:,i) = a;
        Gy(:,:,i) = b;
    end
    
    
end