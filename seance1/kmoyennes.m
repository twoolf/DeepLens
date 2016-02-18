clear;
close all;
clc;

% Chargement de l'image
image = imread('data/skinimg/12.jpg');
[l, h, rgb] = size(image);
  
% Chargement de la verite terrain :
v_terrain = imread('data/skinimg/12_Mask.jpg');
% Mis a 0 ou 255 de TOUS les pixels de l'image terrain :
ind=find(v_terrain>123);
v_terrain(ind)=255;
ind=find(v_terrain<=123);
v_terrain(ind)=0;
% On met les pixels 255 a 1 : (labels 0 ou 1)

% Affichage de l'image
figure (1)
hold on
subplot(1, 2, 1);
imagesc(image);
subplot(1, 2, 2);
imagesc(v_terrain);
hold off

%% Test découpage en sous-blocs : pour réduire les dimensions...
% Je sais pas si c'est vraiment utile...
n=10;
nbBloc_h=h/n;
nbBloc_l=l/n;

for i = 0:nbBloc_l-2
   for j = 0:nbBloc_h-2
      A = image(i*n+1:i*n+n,  j*n+1:j*n+n, :);
      X(i+1, j+1,:)= mean(mean(A));
      % reste à régler le problème du dernier bloc qui n'est pas pris en compte car la div en blocs ne donne pas un nb entier...
   end
end
figure (3)
imagesc(uint8(X))

%% On met sous une forme plus pratique :
% ie une matrice = N (nb pixels l*h) * 3 (les 3 dims rgb)
[l, h, rgb] = size(X);

Xbis = zeros(l*h, rgb);
Xbis(:, 1) = reshape(X(:, :, 1), l*h, 1);
Xbis(:, 2) = reshape(X(:, :, 2), l*h, 1);
Xbis(:, 3) = reshape(X(:, :, 3), l*h, 1);

%% K-means

[idx,C] = kmeans(Xbis,2, 'MaxIter', 200);
contours=reshape(idx, l, h);
figure(4)
subplot(1, 2, 1);
imagesc(contours);
subplot(1, 2, 2);
imagesc(v_terrain);
hold off



