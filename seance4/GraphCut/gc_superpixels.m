% Application de l'algo des ncuts sur les superpixels :
clear;
clc;
close all;
addpath('fonctions');
addpath('fonctions/SLIC');
addpath('fonctions/GCmex2.0');

% Num de l'image :
i = 38;
% Chargement des images :
fichier_image = strcat('data/skinimg/', int2str(i));
fichier_image = strcat(fichier_image, '.jpg');    
fichier_segmManuelle = strcat('data/skinimg/', int2str(i));
fichier_segmManuelle = strcat(fichier_segmManuelle, '_Mask.jpg');

X = imread(fichier_image);
segm_Manuelle = imread(fichier_segmManuelle);

% Superpixels :
ratio = 50;
factor = 15;
radius = 1;
critere = 'median';
affichage = 1;
superpixels = superpixelsSlic(X, ratio, factor, radius, critere, affichage);
nbSupPix = length(unique(superpixels));
fprintf('nombre de superpixels : %d\n',nbSupPix);

% Passage en LAB :
cform = makecform('srgb2lab');
Xlab = applycform(X,cform);

%%
% Cr�ation de l'image post superpixels
resumeMat = zeros(size(X));    
for j= 1:3
    tmp = resumeMat(:, :, j);
    tmpimg = X(:, :, j);
    for i = 1 : nbSupPix
        tmp(superpixels==i) = median(tmpimg(superpixels==i));
    end
    resumeMat(:, :, j)=tmp;
end

% Calcul des pixels medians/moyens de chaque superpixels :
m = representantSuperpixels(Xlab, superpixels, critere);

% On garde que les composantes A et B :
%data = m(:, 2:3);

%% Graph cut

% read an image
im = im2double(X);

sz = size(im);

% try to segment the image into k different regions
k = 2;

% Reshape resumeMat
data = resumeMat(:, : , 2:3);
data = reshape(data, sz(1) * sz(2), 2);

% cluster the image colors into k regions
%data = ToVector(im);
[ypred, c] = kmeans(data, k, 'distance', 'sqEuclidean','maxiter',200);

[segm, coeff_dice, taux_err] = statistiques(fichier_segmManuelle, ypred);

% TODO: cr�er la mtrice avec les points approxim�s par super pixels (d�j�
% fait pour la s�ance pr�c�dente ; puis appliquer GC sur cette matrice
%%
% calculate the data cost per cluster center
Dc = zeros([sz(1:2) k],'single');
whos
for ci=1:k
    % use covariance matrix per cluster
    icv = inv(cov(data(ypred==ci,:)));    
    dif = data - repmat(c(ci,:), [size(data,1) 1]);
    % data cost is minus log likelihood of the pixel to belong to each
    % cluster according to its RGB value
    Dc(:,:,ci) = reshape(sum((dif*icv).*dif./2,2),sz(1:2));
end

% cut the graph

% smoothness term: 
% constant part
Sc = ones(k) - eye(k);
% spatialy varying part
% [Hc Vc] = gradient(imfilter(rgb2gray(im),fspecial('gauss',[3 3]),'symmetric'));
[Hc, Vc] = SpatialCues(im);

gch = GraphCut('open', Dc, 10*Sc, exp(-Vc*5), exp(-Hc*5));
[gch, L] = GraphCut('expand',gch);
gch = GraphCut('close', gch);

% show results
imshow(im);
hold on;
PlotLabels(L);


