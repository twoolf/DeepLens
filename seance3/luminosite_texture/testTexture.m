%% Segmentation selon la texture


addpath('fonctions')
id = 34;

% Construction des noms des fichiers :
fichier_image = strcat('data/skinimg/', int2str(id));
fichier_image = strcat(fichier_image, '.jpg');    
fichier_segmManuelle = strcat('data/skinimg/', int2str(id));
fichier_segmManuelle = strcat(fichier_segmManuelle, '_Mask.jpg');

%% Lecture image

I = imread(fichier_image);
Igray = rgb2gray(I);
figure
imshow(I)

%% Design Array of Gabor Filters
imageSize = size(I);
numRows = imageSize(1);
numCols = imageSize(2);

% These combinations of frequency and orientation are taken from [Jain,1991] cited in the introduction.
wavelengthMin = 4/sqrt(2);
wavelengthMax = hypot(numRows,numCols);
n = floor(log2(wavelengthMax/wavelengthMin));
wavelength = 2.^(0:(n-2)) * wavelengthMin;

deltaTheta = 45;
orientation = 0:deltaTheta:(180-deltaTheta);

g = gabor(wavelength,orientation);
% connaitre la longueur du nombre de caract�ristiques
gabormag = imgaborfilt(Igray,g);

%% Post-process the Gabor Magnitude Images into Gabor Features.

% Application d'un filtre gaussien
for i = 1:length(g)
    sigma = 0.5*g(i).Wavelength;
    K = 3;
    gabormag(:,:,i) = imgaussfilt(gabormag(:,:,i),K*sigma);
end

% Redimentionnement de l'image
X = 1:numCols;
Y = 1:numRows;
[X,Y] = meshgrid(X,Y);
featureSet = cat(3,gabormag,X);
featureSet = cat(3,featureSet,Y);

numPoints = numRows*numCols;
X = reshape(featureSet,numRows*numCols,[]);

X = bsxfun(@minus, X, mean(X));
X = bsxfun(@rdivide,X,std(X));

coeff = pca(X);
feature2DImage = reshape(X*coeff(:,1),numRows,numCols);
% figure
% imshow(feature2DImage,[])


%% Kmeans

% Répété 5 fois
L = kmeans(X,2,'Replicates',5);

L = reshape(L,[numRows numCols]);
% figure
% imshow(label2rgb(L))

A = I;
Aseg1 = zeros(size(A),'like',A);
Aseg2 = zeros(size(A),'like',A);
BW = L == 2;
BW = repmat(BW,[1 1 3]);
Aseg1(BW) = A(BW);
Aseg2(~BW) = A(~BW);
figure
imshowpair(Aseg1,Aseg2,'montage');
