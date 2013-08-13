function [ mejor_ind, pos ] = mini( individuos )
%Regresa el minimo de individuos, regresa la referencia, no es una copia
%   Detailed explanation goes here
    %Generamos el  peor individuo imaginable
    mejor_ind = Individuo( [ 100, 100, 100, 100, 100 ]);
    mejor_ind.updAptitud();
    
    % Recorremos todos los individuos para obtener el mejor
    for j=1:length(individuos)
        % Individuo a checar 
        ind_check = individuos(j);
        pos = j;
        % Si los dos tienen la misma aptitud ->
        if mejor_ind.aptitud ~= 1000 && ind_check.aptitud ~= 1000
            % De acuerdo a la aptitud actualizamos
            if ind_check.aptitud < mejor_ind.aptitud
                mejor_ind = ind_check; 
            end
        % Si el nuevo individuo tiene una aptitud diferente de 1000
        elseif mejor_ind.aptitud == 1000 && ind_check.aptitud ~= 1000
            mejor_ind = ind_check;
        else
            % De acuerdo a la violación de restricciones
            if ind_check.viorest < mejor_ind.viorest
                mejor_ind = ind_check;
            end
        end
    end
end



