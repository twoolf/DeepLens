% Application de l'algo des ncuts sur les superpixels :
clear;
clc;
close all;
addpath('fonctions');
addpath('fonctions/SLIC');
addpath('fonctions/Ncut_9');
addpath('seance4');

% Num de l'image :
i = 6;
% Chargement des images :
fichier_image = strcat('data/skinimg/', int2str(i));
fichier_image = strcat(fichier_image, '.jpg');    
fichier_segmManuelle = strcat('data/skinimg/', int2str(i));
fichier_segmManuelle = strcat(fichier_segmManuelle, '_Mask.jpg');

ratio = 200;
factor = 10;
radius = 1.5;
critere = 'median';
affichage = 1;

[coeff_dice, taux_err, segm] = ncutsOnSuperpixels(fichier_image, fichier_segmManuelle, ratio, factor, radius, critere, affichage);

% Avec les kmeans sans superpixels :
[segmentation, coeff_dice, taux_err] = segmentation_kmeans(fichier_image, fichier_segmManuelle, 'AB', 1);