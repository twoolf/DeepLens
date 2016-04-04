function [superpixels] = superpixelsSlic(X, ratio, factor, radius, critere, affichage)

% INPUTS :
% X : image à segmenter en RGB (n*l*3)
% ratio : le nb de pixels par superpixels
% factor : paramètre de l'algo SLIC : 5 -> superpixels irréguliers; 40 ->
% superpixels réguliers
% radius : paramètre de l'algo SLIC : >1 pour fusionner les régions trop petites. 0 pour désactiver
% affichage : 1 pour afficher les images obtenues, 0 sinon.
% _________________________________________________________________________
% OUTPUT:
% superpixels : matrice n*l avec les num�ro de superpixels attribu� pour
% chaque pixel.
    [n, l, ~] = size(X);
    nbPixels = n*l;
    nbSuperpixels = round(nbPixels/ratio);
    
    [superpixels] = slic(X,nbSuperpixels,factor, radius, critere);
    
    if (affichage==1)
        figure()
        imagesc(drawregionboundaries(superpixels, X, [255 255 255]))
        title('Découpage en superpixels')        
    end
    
end