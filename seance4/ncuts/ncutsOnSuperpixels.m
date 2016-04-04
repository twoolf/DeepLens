function [coeff_dice, taux_err, segm] = ncutsOnSuperpixels(fichier_image, fichier_segmManuelle, ratio, factor, radius, critere, affichage)

    fprintf('\n *** Ncuts sur les superpixels sur l''image %s ***\n\n', fichier_image);
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
    data = m(:, 2:3);

    % Algo ncuts :
    [W,Dist] = compute_relation(data');
    nbCluster = 2;
    [NcutDiscrete,~ , ~] = ncutW(W,nbCluster);

    % Creation de la segmentation predite :
    [h, l, ~] = size(X);
    segm = zeros(h, l);
    for i = 1: nbSupPix 
       segm(superpixels==i) = NcutDiscrete(i, 1); 
    end
    segm(segm==0)=2;
    
    % Calcul des erreurs :
    [imSegm, coeff_dice, taux_err] = statistiques(fichier_segmManuelle, reshape(segm, h*l, 1));
    
    if (affichage==1)
        figure()
        subplot(1, 2, 1)
        imagesc(imSegm), title('Ncuts sur superpixels')
        subplot(1, 2, 2)
        imagesc(segm_Manuelle), title('Segmentation manuelle')
    end
end