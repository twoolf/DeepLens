function imgOut = postTraitement(I, photo, affichage)
% Amélioration de la détection de plaque grâce à différents traitements
% Prend en entree une matrice de segmentation avec de labels 0-1
% Donne en sortie l'image apr�s traitement, avec des labels 1-2

% ENTREES :
% I : image segmentée après Kmeans BINAIRE (0-1)
% photo : photo originale
% affichage : 1 pour afficher

% SORTIES :
% imgOut : Image post traitement, avec des 1 et des 2 comme labels !!

if nargin < 3
    affichage=0;
end

% retourne le contour et le "seuil" associé
[~, threshold] = edge(I, 'sobel');
fudgeFactor = .5;

% Détection des contours avec la fonction edge
% On fixe le seuil : en "tunant" le précédant (baisse du seuil...)
BWs = edge(I,'sobel', threshold * fudgeFactor);
%figure, imshow(BWs), title('binary gradient mask');

% Dilatation des contours
% Création d'éléments structuraux sous forme de ligne pour dilater les
% lignes du contour
se90 = strel('line', 3, 90); % ligne verticale
se0 = strel('line', 3, 0); % ligne horizontale

BWsdil = imdilate(BWs, [se90 se0]);



%% Prise en compte des plaques touchant les bords
% (Sinon ces plaques sont supprimées avec imfill)

bw = BWsdil;
% Création de lignes blanches sur les bords haut et gauche
% Ajout de "1" avant la première ligne et la 1ere colonne
bw_a = padarray(bw,[1 1],1,'pre');
bw_a_filled = imfill(bw_a,'holes');
% suppression des lignes ajoutées
bw_a_filled = bw_a_filled(2:end,2:end);

% Idem haut et droit

bw_b = padarray(padarray(bw,[1 0],1,'pre'),[0 1],1,'post');
bw_b_filled = imfill(bw_b,'holes');
bw_b_filled = bw_b_filled(2:end,1:end-1);


% Idem droit et bas

bw_c = padarray(bw,[1 1],1,'post');
bw_c_filled = imfill(bw_c,'holes');
bw_c_filled = bw_c_filled(1:end-1,1:end-1);


% Idem bas et gauche

bw_d = padarray(padarray(bw,[1 0],1,'post'),[0 1],1,'pre');
bw_d_filled = imfill(bw_d,'holes');
bw_d_filled = bw_d_filled(1:end-1,2:end);


% "OU" logique sur toutes ces images pour le résultat final

bw_filled = bw_a_filled | bw_b_filled | bw_c_filled | bw_d_filled;



%% Erosion

% érosion : ET logique entre l'élément structurel et l'image (parcours sur
% toute l'image)
seD = strel('diamond',1); % Facteur à modifier si on veut plus ou moins d'érosion
imgOut = imerode(bw_filled,seD);
%imgOut = imerode(imgOut,seD);


% Contours sur l'image originale
% TODO: Essayer d'épaissir le contour
BWoutline = bwperim(imgOut);
Segout = photo;
Segout(BWoutline) = 0;


%% Affichage

if (affichage)
    figure
    hold on
    subplot(2, 2, 2);
    imshow(BWsdil), title('Contours des plaques');
    subplot(2, 2, 1);
    imshow(I), title('Avant traitement');
    %imshow(bw_filled)
    %title('Plaques segmentées')
    subplot(2, 2, 3);
    imshow(imgOut), title('Plaques segmentées après érosion');
    subplot(2, 2, 4);
    imshow(Segout), title('Contours des plaques sur la photo originale');
    hold off

end

%% On modifie la matrice de segmentation finale pour qu'elle soit avec de 1 et des 2 (et non des 0 et 1)
imgOut=double(imgOut);
imgOut=imgOut+1;








