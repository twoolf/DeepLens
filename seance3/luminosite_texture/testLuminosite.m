%% Test d'amélioration de luminosité
% TODO: essayer avec LAB

addpath('fonctions')
addpath('seance3')
id = 37;

% Construction des noms des fichiers :
fichier_image = strcat('data/skinimg/', int2str(id));
fichier_image = strcat(fichier_image, '.jpg');    
fichier_segmManuelle = strcat('data/skinimg/', int2str(id));
fichier_segmManuelle = strcat(fichier_segmManuelle, '_Mask.jpg');

I = imread(fichier_image);
% [IND,map] = rgb2ind(I,64);
% J = imadjust(IND); 

%% histeq sur chaque composante RGB

% for i=1:3
%     I(:,:,i)=histeq(I(:,:,i));
% end
% imshow(I)

% % Accentuation des couleurs

%% Histeq LAB


cform = makecform('srgb2lab');
imlab = applycform(I,cform);
figure
subplot(1,2,1)
imshow(imlab), title('Image LAB')
imleq = imlab;
imleq(:,:,1)=histeq(imlab(:,:,1));
subplot(1,2,2)
imshow(imleq), title('apres histeq')

% Kmeans sans histeq
[imSegm, coeff_dice, taux_erreur] = segmentation_kmeans(fichier_image, fichier_segmManuelle, 'AB', 1);

% Kmeans sur l'image X :
nbClusters=2;
nbLignes = size(I,1);
nbCol = size(I,2);
X = reshape(double(imleq), nbLignes*nbCol, 3);
[ypred, cluster_center] = kmeans(X, nbClusters, 'distance','sqEuclidean', 'emptyaction','singleton');

[segmentation, coeff_dice, taux_err] = statistiques(fichier_segmManuelle, ypred);
figure, imshow(segmentation), title('Kmeans après histeq L')
    
figure
imlabeq = zeros(size(imlab));
for i=1:3
    imlabeq(:,:,i)=histeq(imlab(:,:,i));
end
imshow(imlabeq), title('Histeq sur chaque composante LAB');

% Kmeans sur l'image X :
X = reshape(double(imlabeq), nbLignes*nbCol, 3);
[ypred, cluster_center] = kmeans(X, nbClusters, 'distance','sqEuclidean', 'emptyaction','singleton');

[segmentation, coeff_dice, taux_err] = statistiques(fichier_segmManuelle, ypred);
figure, imshow(segmentation), title('Kmeans après histeq LAB')



%% En passant en image indexée

[IND,map] = rgb2ind(I,64);
figure('Name','Indexed image with 64 Colors')
imagesc(IND)
colormap(map)
axis image
figure; imhist(IND,64)
J = histeq(IND);
figure; imhist(J,64)
RGB = ind2rgb(J,map);

% Histeq donne une nouvelle map qu'on applique à J : accentue trop les
% contrastes
NEWMAP = histeq(IND,map);
J = ind2rgb(IND,NEWMAP);

%% Affichage
figure
subplot(1,3,1)
imshow(I), title('image originale')
subplot(1,3,2)
imshow(J), title('image indexée post histeq')


[imSegm, coeff_dice, taux_erreur] = segmentation_kmeans(fichier_image, fichier_segmManuelle, 'AB', 0);
[~, coeff_dice_post, taux_err_post] = statistiques(fichier_segmManuelle, reshape(imSegm, size(imSegm, 1) * size(imSegm, 2), 1));


% Kmeans sur l'image X :
nbClusters=2;
nbLignes = size(I,1);
nbCol = size(I,2);
X = reshape(double(J), nbLignes*nbCol, 3);
[ypred, cluster_center] = kmeans(X, nbClusters, 'distance','sqEuclidean', 'emptyaction','singleton');

[segmentation, coeff_dice, taux_err] = statistiques(fichier_segmManuelle, ypred);
subplot(1,3,3)
imshow(segmentation), title('Kmeans après histeq image indexée')
 

[imSegm, coeff_dice, taux_erreur] = segmentation_kmeans(fichier_image, fichier_segmManuelle, 'AB', 0);
[~, coeff_dice_post, taux_err_post] = statistiques(fichier_segmManuelle, reshape(imSegm, size(imSegm, 1) * size(imSegm, 2), 1));


