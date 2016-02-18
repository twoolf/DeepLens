clear;
clc;
close all;

addpath('fonctions')

%% Concaténation des matrices images :


image = imread('data/skinimg/14.jpg'); 
X = redimLAB(image);
image = imread('data/skinimg/15.jpg'); 
X = [X; redimLAB(image)]; 
image = imread('data/skinimg/18.jpg'); 
X = [X; redimLAB(image)];
image = imread('data/skinimg/19.jpg'); 
X = [X; redimLAB(image)];
image = imread('data/skinimg/17.jpg'); 
X = [X; redimLAB(image)];

%% Apprentissage des centres des clusters :

fprintf('*** Kmeans à partir de 5 images L*a*b* d''apprentissage ***\n\n');
[idx, C] = kmeans(X, 2);

%% Chargement Image Test :
image = imread('data/skinimg/32.jpg');
[l, h, rgb] = size(image);
Xt = redimLAB(image);
segmManuelleTest = double(imread('data/skinimg/32_Mask.jpg'));
segmManuelleTest = labelSegmManuelle(segmManuelleTest(:, :, 1));
Yt = reshape(segmManuelleTest, l*h, 1);

% Pr�diction sur l'image Test :
D = pdist2(Xt, C);
ypred = zeros(l*h, 1);
ypred(find(D(:,1) < D(:,2))) = 1;
ypred(find(D(:,1) >= D(:,2))) = 2;



% Taux d'erreur :
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

fprintf('Observations : Le RGB donne des plaques trop grosses, L*a*b* trop\n ');
fprintf('petites. Dans les deux cas le taux d''erreur est élevé.\n');
fprintf('Le résultat est très variable selon l''image de test\n');

%% Calcul du coefficient de Dice :

segmentation = segmKmeansTest;
ground_truth = segmManuelleTest;

segmentation = segmentation - 1;
ground_truth = ground_truth - 1;

coeff_dice = dice(segmentation, ground_truth);
fprintf('Coefficient de Dice : %.2f %%\n', coeff_dice*100)



