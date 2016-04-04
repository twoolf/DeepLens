function [image_lab] = rgbToLab(image)
    cform = makecform('srgb2lab');
    image_lab = applycform(image,cform);
end