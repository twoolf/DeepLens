function img_redim = redimHSV(image)

image=rgb2hsv(image);
[l, h, dim] = size(image);

img_redim = zeros(l*h, dim);
img_redim(:, 1) = reshape(image(:, :, 1), l*h, 1);
img_redim(:, 2) = reshape(image(:, :, 2), l*h, 1);
img_redim(:, 3) = reshape(image(:, :, 3), l*h, 1);
end