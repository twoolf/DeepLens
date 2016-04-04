function resumeMat = approxSuperpixels(imgRGB, ratio, factor, radius, critere, affichage)

% INPUTS :
% imgRGB : image à segmenter en RGB (n*l*3)
% ratio : le nb de pixels par superpixels
% factor : paramètre de l'algo SLIC : 5 -> superpixels irréguliers; 40 ->
% superpixels réguliers
% radius : paramètre de l'algo SLIC : >1 pour fusionner les régions trop petites. 0 pour désactiver
% critere : {'median', ...}
% affichage : 1 pour afficher les images obtenues, 0 sinon.
% _________________________________________________________________________
% OUTPUT:
% resumeMat : matrice n*l où chaque pixel est approximé par le pixel médian
% de son superpixel

labels = superpixelsSlic(imgRGB, ratio, factor, radius, critere, affichage);

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

end
