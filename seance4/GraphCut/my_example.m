function [segm, ypred] = graphCut(fichier_image, affichage)
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
data = ToVector(im);
[idx, c] = kmeans(data, k, 'distance', 'sqEuclidean','maxiter',200);

%% calculate the data cost per cluster center
Dc = zeros([sz(1:2) k],'single');
for ci=1:k
    % use covariance matrix per cluster
    icv = inv(cov(data(idx==ci,:)));    
    dif = data - repmat(c(ci,:), [size(data,1) 1]);
    % data cost is minus log likelihood of the pixel to belong to each
    % cluster according to its RGB value
    Dc(:,:,ci) = reshape(sum((dif*icv).*dif./2,2),sz(1:2));
end

%% cut the graph

% smoothness term: 
% constant part
Sc = ones(k) - eye(k);
% spatialy varying part
% [Hc Vc] = gradient(imfilter(rgb2gray(im),fspecial('gauss',[3 3]),'symmetric'));
[Hc, Vc] = SpatialCues(im);

gch = GraphCut('open', Dc, 10*Sc, exp(-Vc*5), exp(-Hc*5));
[gch, L] = GraphCut('expand',gch);
gch = GraphCut('close', gch);
segm = L;

if affichage
    imshow(im);
    hold on;
    PlotLabels(L);
end

end
