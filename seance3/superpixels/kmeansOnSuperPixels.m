function [segm, coeff_dice, taux_err] = kmeansOnSuperPixels(fichier_image, fichier_segmManuelle, ratio, factor, radius, affichage)
% INPUTS :
% imgRGB : image à segmenter en RGB (n*l*3)
% fichier_segmManuelle : le nom du fichier qui contient la segmentation
% manuelle (ie vérité terrain)
% ratio : le nb de pixels par superpixels
% factor : paramètre de l'algo SLIC : 5 -> superpixels irréguliers; 40 ->
% superpixels réguliers
% radius : paramètre de l'algo SLIC : >1 pour fusionner les régions trop petites. 0 pour désactiver
% affichage : 1 pour afficher les images obtenues, 0 sinon.
% _________________________________________________________________________
% OUTPUT:
% segm : image binaire (0-1) de la segmentation
% coeff_dice : coefficient de Dice obtenu avec la segmentation manuelle
% taux_err : taux d'erreur pixel par pixel obtenu avec la segmentation manuelle
    
    imgRGB = imread(fichier_image);
    fprintf(' *** Segmentation avec superpixels sur %s ***\n', fichier_image);

    % Calcul du nombre de superpixels nécessaires selon la taille de l'image :
    [n, l, ~] = size(imgRGB);
    nbPixels = n*l;
    ratio = 50;
    nbSuperpixels = round(nbPixels/ratio);
    
    % Calcul des superpixels avec l'algorithme SLIC
    [labels, numlabels] = slic(imgRGB,nbSuperpixels,factor, radius, 'median');
    
    if (affichage==1)
        figure()
        imagesc(drawregionboundaries(labels, imgRGB, [255 255 255]))
        title('Découpage en superpixels')
        
    end
    
    % Passage dans l'espace LAB.
    img = rgbToLab(imgRGB);
    
    % Création d'une matrice qui attribue à chaque pixel la valeur de la
    % moyenne/médianne des pixels de son superpixel :
    
    % Nombre de superspixels réellement formés :
    nbSupPix = length(unique(labels));
    
    resumeMat = zeros(size(img));    
    for j= 1:3
        tmp = resumeMat(:, :, j);
        tmpimg = img(:, :, j);
        for i = 1 : nbSupPix
            tmp(labels==i) = median(tmpimg(labels==i));
        end
        resumeMat(:, :, j)=tmp;
    end
    
    
    % Segmentation sur l'image résumée sur les composantes AB :
    nbClusters=2;
    X = resumeMat(:, : , 2:3);
    X = reshape(X, n*l, 2);
    [ypred, ~] = kmeans(X, nbClusters, 'distance','sqEuclidean', 'emptyaction','singleton');
    [segm, coeff_dice, taux_err] = statistiques(fichier_segmManuelle, ypred);
    
    if (affichage==1)
        figure()
        imshow(segm)
        title('Segmentation obtenue sur les superpixels')
    end


end