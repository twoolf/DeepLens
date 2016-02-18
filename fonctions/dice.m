function [dice] = dice(segmentation, segmManuelle)

% PROBLEME : Pour que la mesure soit int�ressante, il faut s'assurer que
% les 1 dans les matrices correspondent � la t�che. Sinon on mesure un taux
% de recouvrement pour la peau normale...
    % segmentation et ground_truth doivent être des 0 et 1 ?
    % coeff = 2|X.Y|/(|X|+|Y|)
    num = 2*nnz(segmentation&segmManuelle);
    denom = nnz(segmentation) + nnz(segmManuelle);
    dice = num/denom;
end
