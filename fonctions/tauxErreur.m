function [tauxErr, labelAnalogue] = tauxErreur(matConf)
    % Calcule le taux d'erreur entre les labels théoriques et prédits
    labelAnalogue = true;
    tauxErr = (matConf(1,2) + matConf(2,1)) / sum(sum(matConf));
    tauxErr = tauxErr * 100;
    if (tauxErr > 50)
        tauxErr = 100-tauxErr;
        labelAnalogue=false;
    end

end