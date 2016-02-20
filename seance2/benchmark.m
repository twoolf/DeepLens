clear;
close all; 
clc;
addpath('fonctions')

%% K-means sur toutes les images 
% On conserve le coeff de Dice � chaque fois et aussi les taux d'erreur.
dice = zeros(45, 1);
dice_post = zeros(45, 1);
err_brut = zeros(45, 1);
err_brut_post = zeros(45, 1);

for i = 1:45    
    % Construction des noms des fichiers :
    fichier_image = strcat('data/skinimg/', int2str(i));
    fichier_image = strcat(fichier_image, '.jpg');    
    fichier_segmManuelle = strcat('data/skinimg/', int2str(i));
    fichier_segmManuelle = strcat(fichier_segmManuelle, '_Mask.jpg');
    
    [imSegm, dice(i), err_brut(i)] = segmentation_kmeans(fichier_image, fichier_segmManuelle, 'AB');
    im_post = double(postTraitement(imSegm, imread(fichier_image), 0));
    [~, dice_post(i), err_brut_post(i)] = statistiques(fichier_segmManuelle, reshape(im_post, size(im_post, 1) * size(im_post, 2), 1));
end

%% Analyse statistique des Coeff de Dice :
fprintf('-----------------------------------------------\n')
fprintf('Analyse des coeff de Dice obtenus\n')
fprintf('-----------------------------------------------\n')

fprintf('Coeff de Dice moyen : %.2f ; post_traitement : %.2f\n\n', mean(dice), mean(dice_post));
fprintf('Ecart-type : %.2f ; post_traitement : %.2f\n\n ', std(dice), std(dice_post));
fprintf('Mediane : %.2f et post-traitement : %.2f\n\n', median(dice), median(dice_post))

figure(1)
subplot(2, 1, 1);
plot(dice, '+')
title('Coefficient de Dice pour chaque image')
subplot(2, 1, 2);
plot(dice_post, '+')
title('Coefficient de Dice pour chaque image après traitement')

figure (2)
subplot(1, 2, 1);
hist(dice)
title('Histogramme des coefficient de Dice obtenus')
subplot(1, 2 ,2);
hist(dice_post);
title('Histogramme des coefficient de Dice obtenus après traitement')


%% Analyse statistique des taux d'erreur 'brut' :
fprintf('-----------------------------------------------\n')
fprintf('Analyse des pourcentages d''erreur obtenus\n')
fprintf('-----------------------------------------------\n')
fprintf('Pourcentage d''erreur moyen : %.2f ; post-traitement : %.2f\n\n', mean(err_brut), mean(err_brut_post));
fprintf('Ecart-type :  %.2f ; post-traitement : %.2f\n\n', std(err_brut), std(err_brut_post));
fprintf('Mediane : %.2f ; post-traitement : %.2f\n\n ', median(err_brut), median(err_brut_post));

figure(3)
plot(err_brut, '+')
title('Pourcentages d''erreur pour chaque image')

figure (4)
hist(err_brut)
title('Histogramme des pourcentages d''erreur obtenus')