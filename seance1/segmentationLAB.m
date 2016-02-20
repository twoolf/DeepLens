%%  Kmeans selon les composantes L*a*b*
% idem que "kmoyennes.m" mais selon les composatens L*a*b* au lieu de RGB

clear;
close all;
clc;
addpath('fonctions')
% Lecture image skin
photoSkin = imread('data/skinimg/6.jpg');
[nbLignes, nbCol, nbComp] = size(photoSkin);

% Chargement image segmentation manuelle :
segmManuelle = double(imread('data/skinimg/6_Mask.jpg'));
segmManuelle = labelSegmManuelle(segmManuelle);

%% Kmeans

fprintf('\n*** Kmeans sur l''image 6 L*a*b* ***\n\n');
ab_photo = redimLAB(photoSkin, 2);
nbClusters = 2;
%On répète le Kmeans 3 fois pour éviter les minimums locaux : ne semble pas utile
[ypred, cluster_center] = kmeans(ab_photo,nbClusters,'distance','sqEuclidean', ...
                                      'Replicates',3);
% ypred = 1 ou 2 pour chaque pixel de l'image      

%% Calcul d'erreur

fprintf('Matrice de confusion')
matConfusion = confusionmat(reshape(segmManuelle, nbLignes*nbCol, 1), ypred)
[tauxErr, labelAnalogue]  = tauxErreur(matConfusion);
fprintf('Taux d''erreur = %.2f %%\n', tauxErr);

if (~labelAnalogue)
    ypred = inverserLabel(ypred);
end

%% Affichage résultats
segmKmeans = reshape(ypred,nbLignes,nbCol);

figure
hold on
subplot(1, 3, 1);
imshow(photoSkin,[]), title('Skin image 6');
subplot(1, 3, 2);
imshow(segmManuelle,[]), title('Segmentation manuelle');
subplot(1, 3, 3);
imshow(segmKmeans,[]), title('Segmentation kmeans');
hold off

%% Calcul du coefficient de Dice :

segmentation = segmKmeans;
ground_truth = segmManuelle;

segmentation = segmentation - 1;
ground_truth = ground_truth - 1;

coeff_dice = dice(segmentation, ground_truth);
fprintf('Coefficient de Dice : %.2f %%\n', coeff_dice*100)

%% Application du modèle sur une autre image
% 
% fprintf('\n*** Application du modèle de l''image 6 sur l''image 32 ***\n\n');
% % Chargement nouvelle image
% photoSkinTest = imread('data/skinimg/32.jpg');
% segmManuelleTest = double(imread('data/skinimg/32_Mask.jpg'));
% segmManuelleTest = labelSegmManuelle(segmManuelleTest);
% 
% % On convertit et redimensionne : size = (nbpixels, nbComposantes)
% [nbLignes, nbCol, nbComp] = size(photoSkinTest);
% ab_photo_test = redimLAB(photoSkinTest);
% 
% % Détermination des clusters à partir des centres trouvés sur l'image d'app
% 
% % Calcul de la distance euclienne avec les 2 centres
% D = pdist2(ab_photo_test, cluster_center);
% 
% % Calcul des labels des pixels en fonctions de la distance
% ytpred = zeros(nbLignes*nbCol, 1);
% ytpred(find(D(:,1) < D(:,2))) = 1;
% ytpred(find(D(:,1) >= D(:,2))) = 2;
% 
% 
% fprintf('Matrice de confusion');
% matConfusion = confusionmat(reshape(segmManuelleTest, nbLignes*nbCol, 1), ytpred)
% [tauxErr, labelAnalogue]  = tauxErreur(matConfusion);
% fprintf('Taux d''erreur = %.2f %%\n', tauxErr);
% 
% if (~labelAnalogue)
%     ytpred = inverserLabel(ytpred);
% end
% 
% segmKmeansTest = reshape(ytpred, nbLignes, nbCol);
% 
% % Affichage du résultat
% figure
% hold on
% subplot(1, 3, 1);
% imshow(photoSkinTest,[]), title('Skin image 32');
% subplot(1, 3, 2);
% imshow(segmManuelleTest,[]), title('Segmentation manuelle');
% subplot(1, 3, 3);
% imshow(segmKmeansTest,[]), title('Segmentation kmeans test');
% hold off
% 
% 
% % Bonne prédiction car images ressemblantes
% 
% %% Calcul du coefficient de Dice :
% 
% segmentation = segmKmeansTest;
% ground_truth = segmManuelleTest;
% 
% segmentation = segmentation - 1;
% ground_truth = ground_truth - 1;
% 
% coeff_dice = dice(segmentation, ground_truth);
% fprintf('Coefficient de Dice : %.2f %%\n', coeff_dice*60)
% 
% 
%% Test contour

I = segmKmeans;
[~, threshold] = edge(I, 'sobel');
fudgeFactor = .5;
se90 = strel('line', 3, 90);
se0 = strel('line', 3, 0);

% Détection des contours avec la fonction edge
BWs = edge(I,'sobel', threshold * fudgeFactor);
figure, imshow(BWs), title('binary gradient mask');

% Dilatation des contours
BWsdil = imdilate(BWs, [se90 se0]);
figure, imshow(BWsdil), title('dilated gradient mask');

% Remplit l'intérieur des contours
BWdfill = imfill(BWsdil, 'holes');
figure, imshow(BWdfill);
title('binary image with filled holes');

% Supprime les objets sur les bords (pas à faire dans notre cas)
%BWnobord = imclearborder(BWdfill, 4);
%figure, imshow(BWnobord), title('cleared border image');

% Erosion
seD = strel('diamond',3); % Facteur à modifier si on veut plus ou moins d'érosion
BWfinal = imerode(BWdfill,seD);
BWfinal = imerode(BWfinal,seD);
figure, imshow(BWfinal), title('segmented image');

% Contours sur l'image originale
BWoutline = bwperim(BWfinal);
Segout = photoSkin;
Segout(BWoutline) = 0;
figure, imshow(Segout), title('outlined original image');









