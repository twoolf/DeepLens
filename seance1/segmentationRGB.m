%% K means sur une image RGB

clear;
close all;
clc;
addpath('fonctions')
% Chargement de l'image
image = imread('data/skinimg/31.jpg');
[l, h, nbComp] = size(image);

% Chargement de la verite terrain :
segmManuelle = double(imread('data/skinimg/31_Mask.jpg'));
% Mis a 0 ou 255 de TOUS les pixels de l'image terrain :
segmManuelle = labelSegmManuelle(segmManuelle);

% Affichage de l'image
% figure (1)
% hold on
% subplot(1, 2, 1);
% imagesc(image);
% subplot(1, 2, 2);
% imagesc(segmManuelle);
% hold off


%% On met sous une forme plus pratique :
% ie une matrice = N (nb pixels l*h) * 3 (les 3 dims rgb)

X = redimRGB(image);

%% K-means

fprintf('\n*** Kmeans sur l''image 31 RGB ***\n\n');

[idx,C] = kmeans(X,2, 'MaxIter', 200);






%% Affichage résultat

segmKmeans=reshape(idx, l, h);
figure(2)
subplot(1, 2, 1);
imagesc(segmKmeans);
subplot(1, 2, 2);
imagesc(segmManuelle);
hold off

%% Calcul d'erreur

fprintf('Matrice de confusion');
matConfusion = confusionmat(reshape(segmManuelle, l*h, 1), idx)
[tauxErr, labelAnalogue]  = tauxErreur(matConfusion);
fprintf('Taux d''erreur = %.2f %%\n', tauxErr);

if (~labelAnalogue)
    ypred = inverserLabel(ypred);
end


%% Application du modèle sur une autre image
% Calculer les labels de l'image test à partir des clusters trouvés sur
% l'image précédente


fprintf('\n*** Application du modèle de l''image 31 sur l''image 32 ***\n\n');
% Chargement nouvelle image
photoSkinTest = imread('data/skinimg/32.jpg');
segmManuelleTest = double(imread('data/skinimg/32_Mask.jpg'));
segmManuelleTest = labelSegmManuelle(segmManuelleTest);

% Redimensionnement
[l, h, nbComposantes] = size(photoSkinTest);

Xt = redimRGB(photoSkinTest);

% Détermination des clusters à partir des centres trouvés sur l'image d'app

% Calcul de la distance euclienne avec les 2 centres
D = pdist2(Xt, C);

% Calcul des labels des pixels en fonctions de la distance
ypred = zeros(l*h, 1);
ypred(find(D(:,1) < D(:,2))) = 1;
ypred(find(D(:,1) >= D(:,2))) = 2;


% Ici on travaille sur deux images proches (ressemblantes)
% Mais sinon : De la merde car couleurs des clusters différentes entre les 2 images
fprintf('Matrice de confusion');
matConfusion = confusionmat(reshape(segmManuelleTest, l*h, 1), ypred)
[tauxErr, labelAnalogue]  = tauxErreur(matConfusion);
fprintf('Taux d''erreur = %.2f %%\n', tauxErr);

if (~labelAnalogue)
    ypred = inverserLabel(ypred);
end

segmKmeansTest = reshape(ypred, l, h);

% Affichage du résultat
figure
hold on
subplot(1, 3, 1);
imshow(photoSkinTest,[]), title('Skin image 32');
subplot(1, 3, 2);
imshow(segmManuelleTest,[]), title('Segmentation manuelle');
subplot(1, 3, 3);
imshow(segmKmeansTest,[]), title('Segmentation kmeans');
hold off


% C et Ct sont trop différents
%[idxt,Ct] = kmeans(Xt,2);

%% Calcul du coefficient de Dice :

segmentation = segmKmeansTest;
ground_truth = segmManuelleTest;

segmentation = segmentation - 1;
ground_truth = ground_truth - 1;

coeff_dice = dice(segmentation, ground_truth);
fprintf('Coefficient de Dice : %.2f %%\n', coeff_dice*100)








