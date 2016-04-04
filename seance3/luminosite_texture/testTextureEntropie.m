%% Segmentation selon la texture


addpath('fonctions')
id = 4;

% Construction des noms des fichiers :
fichier_image = strcat('data/skinimg/', int2str(id));
fichier_image = strcat(fichier_image, '.jpg');    
fichier_segmManuelle = strcat('data/skinimg/', int2str(id));
fichier_segmManuelle = strcat(fichier_segmManuelle, '_Mask.jpg');

%% Lecture image

I = imread(fichier_image);
figure
imshow(I)

%% Entropie

E = entropyfilt(I);

Eim = mat2gray(E);
% figure
% imshow(Eim);


%% Segmentation

BW1 = im2bw(Eim, .7);
figure, imshow(BW1);

%% Dice

imres = postTraitement(BW1, I, 1);
coeff_dice = dice(imres, imread(fichier_segmManuelle));



