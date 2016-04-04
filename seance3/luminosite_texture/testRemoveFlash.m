%% Test des Kmeans apr�s application de remove_fash

clear;
close all; 
clc;
addpath('fonctions')

%% K-means sur toutes les images 

id = 9;
% Construction des noms des fichiers :
fichier_image = strcat('data/skinimg/', int2str(id));
fichier_image = strcat(fichier_image, '.jpg');    
fichier_segmManuelle = strcat('data/skinimg/', int2str(id));
fichier_segmManuelle = strcat(fichier_segmManuelle, '_Mask.jpg');

[imSegm, coeff_dice, taux_erreur] = segmentation_kmeans(fichier_image, fichier_segmManuelle, 'AB', 1);

figure
I = remove_flash(fichier_image);

    % Kmeans sur l'image X :
nbClusters=2;
nbLignes = size(I,1);
nbCol = size(I,2);
X = redimLAB(I, 2);
[ypred, cluster_center] = kmeans(X, nbClusters, 'distance','sqEuclidean', 'emptyaction','singleton');

[segmentation, coeff_dice, taux_err] = statistiques(fichier_segmManuelle, ypred);
figure, 
imshow(segmentation), title('Segmentation Kmeans')
  