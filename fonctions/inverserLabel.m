function y = inverserLabel(y)
% y : vecteur de label 1 ou 2
% Inverse les labels 1 et 2 pour correspondre avec les labels de l'image
% vérité terrain
    y(y==1) = 0;
    y(y==2) = 1;
    y(y==0) = 2;
end
