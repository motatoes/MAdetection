function greenChannel = color2green(colorImage)
% COLOR2GREEN. Extracts the green channel from a color image. If a color
% image is 
   if (size(colorImage,3) == 3)
       greenChannel = colorImage(:, :, 2);
   elseif (size(colorImage,3) == 1)
       greenChannel = colorImage;
   else
       throw(microaneurysm.exception.InvalidArgument);
   end
end