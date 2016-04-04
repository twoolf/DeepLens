%% Benchmark GraphCut avec et sans superpixels

clear;
close all; 
clc;

addpath('fonctions');
addpath('seance4/GraphCut');
addpath('fonctions/SLIC');
addpath('fonctions/GCmex2.0');

%% Graph cut sur quelques images

im = [38 33 37 39 28 32 34 29 35 30 36 31];
%im = [40 5 10 42 43 16];
%im = [27 14 9 21 6];
diceKmeans = zeros(1, length(im));
affichage = 0;
diceGcut = zeros(1, length(im));

for i = 1:length(im)   
    % Construction des noms des fichiers :
    fichier_image = strcat('data/skinimg/', int2str(i));
    fichier_image = strcat(fichier_image, '.jpg');    
    fichier_segmManuelle = strcat('data/skinimg/', int2str(i));
    fichier_segmManuelle = strcat(fichier_segmManuelle, '_Mask.jpg');
    
    % Graph cut
    [segmGC] = myGraphCut(fichier_image, affichage);
    
    % Kmeans sans GC
    [segmentation, diceKmeans(i), taux_err] = segmentation_kmeans(fichier_image, fichier_segmManuelle, 'AB', affichage);

    % Stats Gcut
    sz = size(segmGC);
    segmGC(find(segmGC == 0)) = 2;
    [~, diceGcut(i), ~] = statistiques(fichier_segmManuelle, reshape(segmGC, [sz(1)*sz(2), 1]));

    %affichage
%     image = im2double(imread(fichier_image));
%     figure;
%     subplot(2, 2, 1)
%     imshow(image), title('Photo originale');
%     subplot(2, 2, 2)
%     segmManuelle = imread(fichier_segmManuelle);
%     imshow(segmManuelle), title('VÃ©ritÃ© terrain');
%     subplot(2, 2, 3)
%     imshow(image), hold on, PlotLabels(segmGC), title('Contour Gcut');
%     subplot(2, 2, 4)
%     imshow(segmGC), title('Segmentation Gcut');
end

%% Analyse Dice

diffDice = (diceGcut - diceKmeans)'.*100;
figure;
hold on
plot(diffDice, '+');
plot( [0 length(im)], [0 0])
title('Différence dice Kmeans/Gcut');
hold off

%% Graph Cut sur quelques images après superpixels

% Paramètres superpixels :
ratio = 50;
factor = 15;
radius = 1;
critere = 'median';
affichage = 0;

im = [38 33 37 39 28];
%im = [40 5 10 42 43 16];
%im = [27 14 9 21 6];
diceGcutSP = zeros(1, length(im));

for i = 1:length(im)   
    % Construction des noms des fichiers :
    fichier_image = strcat('data/skinimg/', int2str(i));
    fichier_image = strcat(fichier_image, '.jpg');    
    fichier_segmManuelle = strcat('data/skinimg/', int2str(i));
    fichier_segmManuelle = strcat(fichier_segmManuelle, '_Mask.jpg');
    
    % Graph cut
    [segmGC] = graphCutSuperpixelsLight(fichier_image, ratio, factor, radius, critere, affichage);

    % Stats
    % Stats Gcut
    sz = size(segmGC);
    segmGC(find(segmGC == 0)) = 2;
    [~, diceGcutSP(i), ~] = statistiques(fichier_segmManuelle, reshape(segmGC, [sz(1)*sz(2), 1]));
end

%% Analyse Dice

diffDiceGC = (diceGcutSP - diceGC)'.*100;
figure;
hold on
plot(diffDiceGC, '+');
plot( [0 length(im)], [0 0])
title('Différence dice Kmeans/Gcut');
hold off
%% Graph Cut sur quelques images après superpixels
% % On conserve le coeff de Dice ï¿½ chaque fois et aussi les taux d'erreur.
% 
% % Paramètres superpixels :
% ratio = 50;
% factor = 15;
% radius = 1;
% critere = 'median';
% affichage = 1;
% 
% im = [38 33 37 39 28];
% %im = [40 5 10 42 43 16];
% %im = [27 14 9 21 6];
% diceGcutSP = zeros(1, length(im));
% 
% 
% for i = 1:length(im)   
%     % Construction des noms des fichiers :
%     fichier_image = strcat('data/skinimg/', int2str(i));
%     fichier_image = strcat(fichier_image, '.jpg');    
%     fichier_segmManuelle = strcat('data/skinimg/', int2str(i));
%     fichier_segmManuelle = strcat(fichier_segmManuelle, '_Mask.jpg');
%     
%     % Graph cut
%     [segmGC] = graphCutSuperpixels(fichier_image, ratio, factor, radius, critere, affichage);
% 
%     % Stats
%     % Stats Gcut
%     sz = size(segmGC);
%     [~, diceGcutSP(i), ~] = statistiques(fichier_segmManuelle, reshape(segmGC, [sz(1)*sz(2), 1]));
% end




