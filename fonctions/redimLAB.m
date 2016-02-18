function img_redim = redimLAB(imgRGB, nbComp)

% Convertit une image RGB en L*a*b* et redimensionne en vecteur
% nbComp = 3 si LAB ou 2 si AB

% Conversion de la photo dans l'espace l*a*b
% Espace plus approprié, se renseigner pour justifier ce choix
% Wikipédia :
% L* : la clarté, qui va de 0 (noir) à 100 (blanc).
% a* : gamme de 600 niveaux sur un axe rouge (+299) → vert (-300) 
% en passant par le gris (0).
% b* : idem avec bleu/jaune
cform = makecform('srgb2lab');
lab_photo = applycform(imgRGB,cform);
nbLignes = size(lab_photo,1);
nbCol = size(lab_photo,2);

% On récupère seulement les composantes de couleur ie a* et b*
% Chaque pixel a ainsi 2 composantes
if nbComp == 2
    img_redim = double(lab_photo(:,:,2:3));
elseif nbComp == 3
    img_redim = double(lab_photo);
else
    fprintf('Erreur : nombre de composantes = 2 ou 3\n');
end

% On redimensionne : size = (nbpixels, nbComposantes)
img_redim = reshape(img_redim, nbLignes*nbCol, nbComp);

end