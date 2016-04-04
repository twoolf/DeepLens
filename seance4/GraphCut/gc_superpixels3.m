%% Graph cut sur image approximée par superpixels

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

imgRGB = imread(fichier_image);
segm_Manuelle = imread(fichier_segmManuelle);

% Superpixels :
ratio = 50;
factor = 15;
radius = 1;
critere = 'median';
affichage = 1;

%%
% Calcul du nombre de superpixels nécessaires selon la taille de l'image :
[n, l, ~] = size(imgRGB);

resumeMat = approxSuperpixels(imgRGB, ratio, factor, radius, critere, affichage);

% Segmentation sur l'image résumée sur les composantes AB :
nbClusters=2;
data = resumeMat(:, : , 2:3);
data = reshape(data, n*l, 2);


%% Graph cut

% read an image
im = im2double(imgRGB);

sz = size(im);

% try to segment the image into k different regions
k = 2;

% cluster the image colors into k regions
[ypred, c] = kmeans(data, k, 'distance', 'sqEuclidean','maxiter',200);

%%
% calculate the data cost per cluster center
Dc = zeros([sz(1:2) k],'single');
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


