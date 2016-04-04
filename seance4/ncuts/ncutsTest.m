% Ce code test l'algorithme 'normalized cut' appliqu� diectement � une
% photo.
% Il faut prendre une photo pas trop grande car l'algo est long.

clear;
clc;
close all;

addpath('fonctions/')
addpath('fonctions/Ncut_9/')

fichier_image = 'data/skinimg/33.jpg';
image = imread(fichier_image);
data = redimLAB(image, 2)';

%% compute similarity matrix
[W,Dist] = compute_relation(data);

%% clustering graph in 2 :
nbCluster = 2;
tic;
[NcutDiscrete,NcutEigenvectors,NcutEigenvalues] = ncutW(W,nbCluster);
disp(['The computation took ' num2str(toc) ' seconds']);
figure(3);
plot(NcutEigenvectors);
%% display clustering result

[n, l, ~] = size(image);
pred = reshape(NcutDiscrete(:, 1), n, l);
imagesc(pred);

%% Calcul d'erreur :
fichier_segmManuelle = 'data/skinimg/33_Mask.jpg';
% Attention aux labels (0-1) et (1-2)
NcutDiscrete(NcutDiscrete==0)=2;
[imSegm, coeff_dice, taux_err] = statistiques(fichier_segmManuelle, NcutDiscrete(:, 1));

%% Erreur avec les kmeans :
[segmentation, coeff_dice, taux_err] = segmentation_kmeans(fichier_image, fichier_segmManuelle, 'AB', 1);