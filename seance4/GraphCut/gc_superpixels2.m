function [segmGC] = graphCutSuperpixelsLight(fichier_image, ratio, factor, radius, critere, affichage)

fprintf('\n *** Gcut sur les superpixels sur l''image %s ***\n\n', fichier_image);
X = imread(fichier_image);
segm_Manuelle = imread(fichier_segmManuelle);

% Superpixels :
[superpixels] = superpixelsSlic(X, ratio, factor, radius, critere, affichage);
nbSupPix = length(unique(superpixels));

% Passage en LAB :
cform = makecform('srgb2lab');
Xlab = applycform(X,cform);

% Calcul des pixels medians/moyens de chaque superpixels :
m = representantSuperpixels(Xlab, superpixels, critere);

% On garde que les composantes A et B :
data(:,1,:) = m(:, 2:3);

%% Algo Gcuts :
% cluster the image colors into k regions

k = 2;
sz = size(data);
data = reshape(data, sz(1)*sz(2), 2);
[ypred, c] = kmeans(data, k, 'distance', 'sqEuclidean','maxiter',200);

%% Graph cut sur vecteur superpixels
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
% Termes pour une représentation spaciale impossible dans notre cas
% [Hc Vc] = gradient(imfilter(rgb2gray(im),fspecial('gauss',[3 3]),'symmetric'));
% [Hc, Vc] = SpatialCues(data);

gch = GraphCut('open', Dc, 10*Sc);
[gch, L] = GraphCut('expand',gch);
gch = GraphCut('close', gch);

% show results
% imshow(X);
% hold on;
% PlotLabels(L);

%% Creation de la segmentation predite :
[h, l, ~] = size(X);
segm = zeros(h, l);
% Assignation des labels en fonction du superpixel correspondant
for i = 1: nbSupPix 
   segm(superpixels==i) = L(i); 
end
segm(segm==0)=2;

if affichage
    figure
    subplot(1, 2, 1)
    imshow(segm), title('Gcut sur superpixels')
    subplot(1, 2, 2)
    imshow(segm_Manuelle), title('Segmentation manuelle')
end

% Calcul des erreurs :
%[~, coeff_dice, taux_err] = statistiques(fichier_segmManuelle, reshape(segm, h*l, 1));
