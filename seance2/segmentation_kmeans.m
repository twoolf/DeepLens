function [matConf, coeff_dice] = segmentation_kmeans(fichier_image, fichier_segmManuelle, espaceCouleur, affichage)
% Effectue l'algorithme des K-means sur l'image de psoriasis pass�e en
% entr�e.
% Calcule le taux d'erreur obtenue par cette m�thode de segmentation, la
% matrice de Confusion, ainsi que le coefficient de Dice.

% fichier_image : le nom du fichier de l'image � tester
% fichier_segmManuelle : le nom du fichier contenant l'image de
% segmentation manuelle (v�rit� terrain)
% Espace Couleur = {RGB, LAB, AB}
% affichage : pr�ciser cette valeur � 1 si un affichage des images
% r�sultats est souhait�.

    if nargin < 4
        affichage=0;
    end
    
    fprintf('\n*** Kmeans sur l''image %s en %s ***\n\n', fichier_image, espaceCouleur);

    % Chargement des donn�es (image de peau) not�es X :
    image = imread(fichier_image);
    [nbLignes, nbCol, ~] = size(image);

    if strcmp(espaceCouleur, 'AB')
        X = redimLAB(image, 2);
    elseif strcmp(espaceCouleur, 'LAB')
        X = redimLAB(image, 3);
    elseif strcmp(espaceCouleur, 'RGB')
        X = redimRGB(image);
    else
        fprintf('Erreur : Espace couleur inconnu (RGB, LAB ou AB)');
    end

    % Chargement de l'image v�rit� terrain (not�e segmManuelle):
    segmManuelle = double(imread(fichier_segmManuelle));
    segmManuelle = labelSegmManuelle(segmManuelle(:, :, 1));

    % Kmeans sur l'image X :
    nbClusters=2;
    [ypred, cluster_center] = kmeans(X, nbClusters, 'distance','sqEuclidean');
    
    % Calcul de l'erreur 'brute' :
    fprintf('Matrice de confusion : ')
    matConf = confusionmat(reshape(segmManuelle, nbLignes*nbCol, 1), ypred)
    [tauxErr, labelAnalogue]  = tauxErreur(matConf);
    fprintf('Taux d''erreur = %.2f %%\n', tauxErr);
    
    % Inversion des labels pr�dits si n�cessaire :
    if (~labelAnalogue)
        ypred = inverserLabel(ypred);
    end
    
    % Calcul du coefficient de Dice :    
    segmentation = reshape(ypred, nbLignes, nbCol);
    ground_truth = segmManuelle;
    segmentation = segmentation - 1;
    ground_truth = ground_truth - 1;

    coeff_dice = dice(segmentation, ground_truth);
    fprintf('Coefficient de Dice : %.2f %%\n', coeff_dice*100)
    
    % Affichage si demand� :
    if (affichage==1)
        figure (1)
        subplot(1, 3, 1)
        imagesc(image)
        subplot(1, 3, 2)
        imagesc(segmManuelle)
        subplot(1, 3, 3)
        imagesc(segmentation)
    end
    
    

end