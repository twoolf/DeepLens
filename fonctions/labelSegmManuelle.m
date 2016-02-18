function label = labelSegmManuelle(label)

% label : image de la segmentation manuelle d'une photo de peau
% On assigne le label 1 ou 2 selon la couleur du pixel

label(find(label > 127)) = 255;
label(find(label <= 127)) = 1;
label(find(label == 255)) = 2;

end