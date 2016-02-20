function [imSegm, coeff_dice, taux_err] = statistiques(fichier_segmManuelle, ypred)
% Affiche la matrice de confusion, calcule le taux d'erreur et le coef de
% dice
% segmManuelle : image binaire de la segmentation manuelle

% Chargement de l'image v�rit� terrain (not�e segmManuelle):
segmManuelle = double(imread(fichier_segmManuelle));
segmManuelle = labelSegmManuelle(segmManuelle(:, :, 1));
[nbLignes, nbCol, ~] = size(segmManuelle);

% Calcul de l'erreur 'brute' :
fprintf('Matrice de confusion : ')
matConf = confusionmat(reshape(segmManuelle, nbLignes*nbCol, 1), ypred)
[taux_err, labelAnalogue]  = tauxErreur(matConf);
fprintf('Taux d''erreur = %.2f %%\n', taux_err);

% Inversion des labels pr�dits si n�cessaire :
if (~labelAnalogue)
    ypred = inverserLabel(ypred);
end

% Calcul du coefficient de Dice :    
imSegm = reshape(ypred, nbLignes, nbCol);
ground_truth = segmManuelle;
imSegm = imSegm - 1;
ground_truth = ground_truth - 1;

coeff_dice = dice(imSegm, ground_truth);
fprintf('Coefficient de Dice : %.2f %%\n', coeff_dice*100)