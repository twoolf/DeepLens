clear all
clc;
close all;
addpath('fonctions')
addpath('fonctions/SLIC')
addpath('seance3')

% Numéro des images à tester
im = [38 33 37 39 28 32 34 29 35 30 36 31];
%im = [38 33 37]

ratioRange = [5 7 10 20 25 30 50 80 100 150 200];

dice = zeros(length(im), length(ratioRange));
diceSuper = zeros(length(im), length(ratioRange));


erreur = zeros(length(im), length(ratioRange));
erreurSuper = zeros(length(im), length(ratioRange));


for k=1:length(ratioRange)  
    


    % Paramètre à tester pour la méthodes avec superpixels
    ratio = ratioRange(k);
    factor = 10;
    radius = 1;

    % Paramètre pour les kmeans normaux
    espaceCouleur = 'AB';
    affichage = 0;

    % Test sur chaque image :
    for j =  1:length(im)

        i = im(j);

        % Chargement des images :
        fichier_image = strcat('data/skinimg/', int2str(i));
        fichier_image = strcat(fichier_image, '.jpg');    
        fichier_segmManuelle = strcat('data/skinimg/', int2str(i));
        fichier_segmManuelle = strcat(fichier_segmManuelle, '_Mask.jpg');    


        [segm, diceSuper(j, k), erreurSuper(j, k)] = kmeansOnSuperPixels(fichier_image, fichier_segmManuelle, ratio, factor, radius, affichage);


        [segmentation, dice(j, k), erreur(j, k)] = segmentation_kmeans(fichier_image, fichier_segmManuelle, espaceCouleur, affichage);

    end

    % Résultats :

%     figure()
%     hold on
%     plot(dice, '+r')
%     plot(diceSuper, '+b');
%     hold off
%     legend('Sans superpixels', 'Avec superpixels')
% 
%     figure()
% 
%     hold on
%     plot(erreur, '+r')
%     plot(erreurSuper, '+b');
%     hold off
%     legend('Sans superpixels', 'Avec superpixels')

    

end

fprintf('Différence entre les dice : Dice avec superpixels -dice sans : ')
diffdice = diceSuper-dice
fprintf('Différence entre les taux erreur : erreur avec superpixels -dice sans : ')
differr = erreurSuper-erreur

fprintf('Moyenne des différence de dice entre sans et avec : ')
meanDice = mean(diffdice, 1)

fprintf('Moyenne des différence d erreur entre sans et avec : ')
meanErr = mean(differr, 1)

