function [rgbImage] = remove_flash(fichier_image)

format long g;
format compact;
fontSize = 18;

%===============================================================================

rgbImage = imread(fichier_image);
[rows, columns, numberOfColorBands] = size(rgbImage);
% Affichage image originale
subplot(2, 3, 1);
imshow(rgbImage);
axis on;
title('Image originale', 'FontSize', fontSize);
% Agrandissement de l'image
set(gcf, 'units','normalized','outerposition',[0 0 1 1]);

% Conversion en niveau de gris
grayImage = rgb2gray(rgbImage);
subplot(2, 3, 2);
imshow(grayImage);
axis on;
title('Image niveau de gris', 'FontSize', fontSize);

% Histogramme de l'intensité des poxels
[pixelCount, grayLevels] = imhist(grayImage);
subplot(2, 3, 3); 
bar(grayLevels, pixelCount);
grid on;
title('Histogramme intensité des pixels', 'FontSize', fontSize);
xlim([0 grayLevels(end)]); % Scale x axis manually.

% Création de l'image binaire grâce à un seuil
% Si l'intensité est supérieure au seuil 225 => pixel blanc; noir sinon
% Le blanc représente les zones de flash
binaryImage = grayImage > 225;
subplot(2, 3, 4);
imshow(binaryImage);
axis on;
title('Image binaire', 'FontSize', fontSize);

% Dilatation de l'image binaire pour agrandir la zone de flash
binaryImage = imdilate(binaryImage, true(11));
subplot(2, 3, 5);
imshow(binaryImage);
axis on;
title('Image binaire dilatée', 'FontSize', fontSize);
drawnow;


% Exctraction des composantes r, g et b
redChannel = rgbImage(:, :, 1);
greenChannel = rgbImage(:, :, 2);
blueChannel = rgbImage(:, :, 3);
% Remplissage des trous
redChannel = regionfill(redChannel, binaryImage);
greenChannel = regionfill(greenChannel, binaryImage);
blueChannel = regionfill(blueChannel, binaryImage);

% On rassemble les couleurs pour obtenir l'image RGB retouchée.
rgbImage = cat(3, redChannel, greenChannel, blueChannel);
subplot(2, 3, 6);
imshow(rgbImage);
axis on;
title('Image sans flash', 'FontSize', fontSize);

end
