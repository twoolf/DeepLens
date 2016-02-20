function imgOut = postTraitement(I, photo, affichage)
% Amélioration de la détection de plaque grâce à différents traitements
% I : image segmentée après Kmeans
% photo : photo originale
% affichage : 1 pour afficher

if nargin < 3
    affichage=0;
end

[~, threshold] = edge(I, 'sobel');
fudgeFactor = .5;
se90 = strel('line', 3, 90);
se0 = strel('line', 3, 0);


% Détection des contours avec la fonction edge
BWs = edge(I,'sobel', threshold * fudgeFactor);
%figure, imshow(BWs), title('binary gradient mask');

% Dilatation des contours
BWsdil = imdilate(BWs, [se90 se0]);



%% Prise en compte des plaques touchant les bords
% (Sinon ces plaques sont supprimées avec imfill)

bw = BWsdil;
% Création de lignes blanches sur les bords haut et gauche
bw_a = padarray(bw,[1 1],1,'pre');
bw_a_filled = imfill(bw_a,'holes');
bw_a_filled = bw_a_filled(2:end,2:end);
%imshow(bw_a_filled)


% Idem haut et droit

bw_b = padarray(padarray(bw,[1 0],1,'pre'),[0 1],1,'post');
bw_b_filled = imfill(bw_b,'holes');
bw_b_filled = bw_b_filled(2:end,1:end-1);
%imshow(bw_b_filled);


% Idem droit et bas

bw_c = padarray(bw,[1 1],1,'post');
bw_c_filled = imfill(bw_c,'holes');
bw_c_filled = bw_c_filled(1:end-1,1:end-1);
%imshow(bw_c_filled)


% Idem bas et gauche

bw_d = padarray(padarray(bw,[1 0],1,'post'),[0 1],1,'pre');
bw_d_filled = imfill(bw_d,'holes');
bw_d_filled = bw_d_filled(1:end-1,2:end);
%imshow(bw_d_filled)


% "OU" logique sur toutes ces images pour le résultat final

bw_filled = bw_a_filled | bw_b_filled | bw_c_filled | bw_d_filled;



%% Erosion

seD = strel('diamond',2); % Facteur à modifier si on veut plus ou moins d'érosion
imgOut = imerode(bw_filled,seD);
imgOut = imerode(imgOut,seD);


% Contours sur l'image originale
% TODO: Essayer d'épaissir le contour
BWoutline = bwperim(imgOut);
Segout = photo;
Segout(BWoutline) = 0;


%% Affichage

if (affichage)
    figure
    hold on
    subplot(2, 2, 1);
    imshow(BWsdil), title('Contours des plaques');
    subplot(2, 2, 2);
    imshow(bw_filled)
    title('Plaques segmentées')
    subplot(2, 2, 3);
    imshow(imgOut), title('Plaques segmentées après érosion');
    subplot(2, 2, 4);
    imshow(Segout), title('Contours des plaques sur la photo originale');
    hold off

end








