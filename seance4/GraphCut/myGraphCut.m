function [segm] = myGraphCut(fichier_image, affichage)
% Graph cut sur une image SANS superpixels

% An example of how to segment a color image according to pixel colors.
% First stage identifies k distinct clusters in the color space of the
% image. Then the image is segmented according to these regions; each pixel
% is assigned to its cluster and the GraphCut poses smoothness constraint
% on this labeling.

% read an image
im = im2double(imread(fichier_image));
sz = size(im);

%% cluster the image colors into k regions
k = 2;
%data = ToVector(im);
data = redimLAB(im, 2);
%dataAB = data(:, :, 2:3);
[ypred, c] = kmeans(data, k, 'distance', 'sqEuclidean','maxiter',200);

%% calculate the data cost per cluster center
Dc = zeros([sz(1:2) k],'single');
%Dc(ligne, col, label) : cout d'assigner ce label au pixel (ligne, col)
for ci=1:k
    % use covariance matrix per cluster
    icv = inv(cov(data(ypred == ci,:)));    
    % Calcul de la distance pixel - cluster
    dif = data - repmat(c(ci,:), [size(data,1) 1]);
    % data cost is minus log likelihood of the pixel to belong to each
    % cluster according to its RGB value
    Dc(:,:,ci) = reshape(sum((dif*icv).*dif./2,2),sz(1:2));
end

%% cut the graph

% smoothness term: 
% constant part
% 'Proba' de chaque cluster (égaux ici)
Sc = ones(k) - eye(k);
% spatialy varying part (variation du smoothness cost en fonction de la
% position spatiale, à approfondir
% [Hc Vc] = gradient(imfilter(rgb2gray(im),fspecial('gauss',[3 3]),'symmetric'));
[Hc, Vc] = SpatialCues(im);

% création d'un nouvel objet Graph
gch = GraphCut('open', Dc, 10*Sc, exp(-Vc*5), exp(-Hc*5));
% Expansion
[gch, L] = GraphCut('expand',gch);
% Fermeture de désallocation
gch = GraphCut('close', gch);
segm = double(L);

if affichage
    figure;
    imshow(im);
    hold on;
    PlotLabels(L);
    title(fichier_image);
end

end
