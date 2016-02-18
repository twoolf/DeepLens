function img_redim = redimRGB(image)

[l, h, rgb] = size(image);

img_redim = zeros(l*h, rgb);
img_redim(:, 1) = reshape(image(:, :, 1), l*h, 1);
img_redim(:, 2) = reshape(image(:, :, 2), l*h, 1);
img_redim(:, 3) = reshape(image(:, :, 3), l*h, 1);


end