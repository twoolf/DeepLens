% Application de l'algo des ncuts sur les superpixels :
clear;
clc;
close all;
addpath('fonctions');
addpath('fonctions/SLIC');
addpath('fonctions/Ncut_9');
addpath('seance4');

ratio = 200;
factor = 20;
radius = 1.;
critere = 'mean';
affichage = 0;

%im = [38 33 37 39 28 32 34 29 35 30 36 31];
%im = [40 5 10 42 43 16]
im = [27 14 9 21 6]
diceKmeans = zeros(1, length(im));
diceNcuts = zeros(1, length(im));

for j = 1:length(im) 
    
    % Num de l'image :
    i = im(j);
    % Chargement des images :
    fichier_image = strcat('data/skinimg/', int2str(i));
    fichier_image = strcat(fichier_image, '.jpg');    
    fichier_segmManuelle = strcat('data/skinimg/', int2str(i));
    fichier_segmManuelle = strcat(fichier_segmManuelle, '_Mask.jpg');

    % Ncuts sur les superpixels :
    [diceNcuts(j), taux_err, segm] = ncutsOnSuperpixels(fichier_image, fichier_segmManuelle, ratio, factor, radius, critere, affichage);
        
    % Avec les kmeans sans superpixels :
    [segmentation, diceKmeans(j), taux_err] = segmentation_kmeans(fichier_image, fichier_segmManuelle, 'AB', affichage);
    
end


diffDice = (diceNcuts-diceKmeans)'.*100
figure()
hold on
plot(diffDice, '+');
plot( [0 length(im)], [0 0])
hold off