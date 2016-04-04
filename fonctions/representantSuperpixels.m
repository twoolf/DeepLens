function m = representantSuperpixels(X, superpixels, critere)
% Calcule le pixel moyen ou median de chaque superpixel.

% X : l'image (n*l*3)
% superpixels : matrice n*l qui repr�sente l'affectation des pixels de
% l'image � un superpixel.
% critere : 'mediane' ou 'moyenne'

% m : matrice de taille (k = nb de superpixels) * 3 : les pixels
% moyens/medians de chaque superpixels.

    nbSupPix = length(unique(superpixels));
    m = zeros(nbSupPix, 3);    
    for j= 1:3
        tmp = X(:, :, j);
        for i = 1 : nbSupPix
            if (strcmp(critere, 'median'))
                m(i, j) = median(tmp(superpixels==i));
            elseif (strcmp(critere, 'mean'))
                m(i, j) = mean(tmp(superpixels==i));
            else
                error('Critere inconnu')
        end
    end
end