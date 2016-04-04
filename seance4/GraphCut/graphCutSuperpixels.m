function [segmGC] = graphCutSuperpixels(fichier_image, ratio, factor, radius, critere, affichage)

imgRGB = imread(fichier_image);

%% Superpixels
% Calcul du nombre de superpixels nécessaires selon la taille de l'image :
[n, l, ~] = size(imgRGB);

resumeMat = approxSuperpixels(imgRGB, ratio, factor, radius, critere, affichage);

%% Segmentation kmeans sur l'image résumée sur les composantes AB :

data = resumeMat(:, : , 2:3);
data = reshape(data, n*l, 2);

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
if (affichage)
    figure;
    imshow(im);
    hold on;
    PlotLabels(L);
    title(fichier_image);
end

segmGC = double(L);


