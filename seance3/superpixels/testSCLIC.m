clear all
clc;
close all;
addpath('fonctions')
addpath('fonctions/SLIC')
addpath('seance3')

% NumÃ©ro de l'image : 
i = 38;
factor = 10;
radius=1;
ratio = 60;

% Chargement des images :
fichier_image = strcat('data/skinimg/', int2str(i));
fichier_image = strcat(fichier_image, '.jpg');    
fichier_segmManuelle = strcat('data/skinimg/', int2str(i));
fichier_segmManuelle = strcat(fichier_segmManuelle, '_Mask.jpg');    
imageRGB = imread(fichier_image);

% Passage en LAB :
img = rgbToLab(imageRGB);

[n, l, dim] = size(img);
nbPixels = n*l;
nbSuperpixels = round(nbPixels/ratio);

%% Calcul des superpixels avec l'algorithme SLIC :
[labels, numlabels] = slic(imageRGB,nbSuperpixels,factor, radius, 'mean');
% 2 ï¿½me paramï¿½tre : nb de superpixels desirï¿½; c'est du ï¿½ la louche...
% 3ï¿½me paramï¿½tre : influence sur la rï¿½gularitï¿½ des superpixels.

%% Affichage
figure(1)
imagesc(drawregionboundaries(labels, imageRGB, [255 255 255]))
title('Decoupage en superpixels')

%% Test sur les superpixels formï¿½es :
nbSupPix = length(unique(labels));

resumeMat = zeros(size(img));

% Calcul de la moyenne sur chaque blocs.

for j= 1:3
    tmp = resumeMat(:, :, j);
    tmpimg = img(:, :, j);
    for i = 1 : nbSupPix
        tmp(labels==i) = mean(tmpimg(labels==i));
    end
    resumeMat(:, :, j)=tmp;
end

figure(2)
subplot(1, 2, 1)
imshow(uint8(resumeMat))
subplot(1, 2, 2)
imshow(img)


%% Segmentation sur les superpixels :

% A dï¿½commenter pour faire apparaitre le petit garï¿½on !
% nbClusters=2;
% X = redimLAB(image, 2);
% [ypred, cluster_center] = kmeans(X, nbClusters, 'distance','sqEuclidean', 'emptyaction','singleton');

% Mais sinon :
nbClusters=2;
X = resumeMat(:, : , 2:3);
[n, p, dim] = size(X);

X = reshape(X, n*p, 2);
display('*** Kmeans sur les superpixels ***');
[ypred, cluster_center] = kmeans(X, nbClusters, 'distance','sqEuclidean', 'emptyaction','singleton');
[segm, coeff_diceSuper, taux_err] = statistiques(fichier_segmManuelle, ypred);
figure (3)
imshow(segm), title('Segmentation Kmeans sur les superpixels')

%% Segmentation sans superpixels :
espaceCouleur = 'AB';
affichage = 1;
[segmentation, coeff_dice, taux_err] = segmentation_kmeans(fichier_image, fichier_segmManuelle, espaceCouleur, affichage);

display('*** Différence de Dice ***')
coeff_diceSuper-coeff_dice