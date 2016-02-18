clear;
close all; 
clc;
addpath('fonctions')

%% K-means sur toutes les images dans l'espace AB (sans L).
% On conserve le coeff de Dice � chaque fois.
dice = zeros(45, 1);

for i = 1:45    
    % Construction des noms des fichiers :
    fichier_image = strcat('data/skinimg/', int2str(i));
    fichier_image = strcat(fichier_image, '.jpg');    
    fichier_segmManuelle = strcat('data/skinimg/', int2str(i));
    fichier_segmManuelle = strcat(fichier_segmManuelle, '_Mask.jpg');
    
    [matConf, dice(i)] = segmentation_kmeans(fichier_image, fichier_segmManuelle, 'RGB');    
end

%% Analyse statistique des Coeff de Dice :
fprintf('-----------------------------------------------\n')
fprintf('Analyse des coeff de Dice obtenus\n')
fprintf('-----------------------------------------------\n')
fprintf('Coeff de Dice moyen :')
mean(dice)
fprintf('Ecart-type : ')
std(dice)
fprintf('Mediane :')
median(dice)

figure(1)
plot(dice, '+')
title('Coefficient de Dice pour chaque image')

figure (2)
hist(dice)
title('Histogramme des coefficient de Dice obtenus')