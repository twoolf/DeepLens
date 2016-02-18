clear;
clc;
close all;
addpath('fonctions')

%% Concat�nation des matrices images :

image = imread('data/skinimg/14.jpg'); 
X = redimRGB(image);
image = imread('data/skinimg/15.jpg'); 
X = [X; redimRGB(image)]; 
image = imread('data/skinimg/18.jpg'); 
X = [X; redimRGB(image)];
image = imread('data/skinimg/19.jpg'); 
X = [X; redimRGB(image)];
image = imread('data/skinimg/17.jpg'); 
X = [X; redimRGB(image)];

%% Apprentissage des centres des clusters :

fprintf('*** Kmeans à partir de 5 images RGB d''apprentissage ***\n\n');
[idx, C] = kmeans(X, 2);

%% Chargement Image Test :
image = imread('data/skinimg/42.jpg');
[l, h, rgb] = size(image);
Xt = redimRGB(image);
segmManuelleTest = double(imread('data/skinimg/42_Mask.jpg'));
segmManuelleTest = labelSegmManuelle(segmManuelleTest(:, :, 1));
Yt = reshape(segmManuelleTest, l*h, 1);

% Pr�diction sur l'image Test :
D = pdist2(Xt, C);
ypred = zeros(l*h, 1);
ypred(find(D(:,1) < D(:,2))) = 1;
ypred(find(D(:,1) >= D(:,2))) = 2;



% Taux d'erreur :
%tauxErr = tauxErreur(segmManuelleTest, segmKmeansTest);

fprintf('Matrice de confusion');
matConfusion = confusionmat(Yt, ypred)
[tauxErr, labelAnalogue]  = tauxErreur(matConfusion);
fprintf('Taux d''erreur = %.2f %%\n', tauxErr);
if (~labelAnalogue)
    ypred = inverserLabel(ypred);
end

segmKmeansTest = reshape(ypred, l, h);

% Affichage :
figure (1)
subplot(1, 3, 1)
imagesc(image);
subplot(1, 3, 2)
imagesc(segmManuelleTest);
subplot(1, 3, 3)
imagesc(segmKmeansTest);

fprintf('Observations : Le RGB donne des résultats trop loin de la réalité\n ');

%% Calcul du coefficient de Dice :

segmentation = segmKmeansTest;
ground_truth = segmManuelleTest;

segmentation = segmentation - 1;
ground_truth = ground_truth - 1;

coeff_dice = dice(segmentation, ground_truth);
fprintf('Coefficient de Dice : %.2f %%\n', coeff_dice*100)




