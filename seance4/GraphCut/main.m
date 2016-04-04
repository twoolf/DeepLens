%% Main graph cut
% Graphcut apr�s superpixel sur une image
clear;
clc;
close all;
addpath('fonctions');
addpath('fonctions/SLIC');
addpath('fonctions/GCmex2.0');

% Num de l'image :
i = 28;
% Chargement des images :
fichier_image = strcat('data/skinimg/', int2str(i));
fichier_image = strcat(fichier_image, '.jpg');    
fichier_segmManuelle = strcat('data/skinimg/', int2str(i));
fichier_segmManuelle = strcat(fichier_segmManuelle, '_Mask.jpg');

imgRGB = imread(fichier_image);
segm_Manuelle = imread(fichier_segmManuelle);

[segm] = myGraphCut(fichier_image, 0);

[segmentation, ~, ~] = segmentation_kmeans(fichier_image, fichier_segmManuelle, 'AB', 0);

% Affichage

    image = im2double(imread(fichier_image));
    figure;
    subplot(2, 2, 1)
    imshow(image), title('Photo originale');
    subplot(2, 2, 2)
    segmManuelle = imread(fichier_segmManuelle);
    imshow(segmManuelle), title('Vérité terrain');
    subplot(2, 2, 3)
    imshow(image), hold on, PlotLabels(segm), title('Contour Gcut');
    subplot(2, 2, 4)
    imshow(segm), title('Segmentation Gcut');
    hold off

%% Param�tres superpixels :
ratio = 50;
factor = 15;
radius = 1;
critere = 'median';
affichage = 1;

% Graph cut
[segmGC] = graphCutSuperpixelsLight(fichier_image, ratio, factor, radius, critere, affichage);

% Affichage

image = im2double(imread(fichier_image));
figure;
subplot(2, 4, 1)
imshow(image), title('Photo originale');
subplot(2, 4, 5)
segmManuelle = imread(fichier_segmManuelle);
imshow(segmManuelle), title('Vérité terrain');
subplot(2, 4, 8)
imshow(segmentation), title('Segmentation Kmeans');
subplot(2, 4, 2)
imshow(image), hold on, PlotLabels(segm), title('Contour Gcut');
subplot(2, 4, 6)
imshow(segm), title('Segmentation Gcut');
subplot(2, 4, 3)
imshow(image), hold on, PlotLabels(segmGC), title('Contour Gcut superpixels');
subplot(2, 4, 7)
imshow(segmGC), title('Segmentation Gcut superpixels');
