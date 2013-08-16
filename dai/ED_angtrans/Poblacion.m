classdef Poblacion<handle
    %Clase Poblacion DE/Rand/2/Bin
    
    properties
        numInvitados = 5;
        poblacion
    end
    
    methods
        function obj = Poblacion(numPobladores)
            for i=1:numPobladores
                ind = Individuo();
                ind.actualizarAptitud();
                obj.poblacion{i} = ind;
            end
        end
        
        function generarInvitados(obj)
           
           for i=1:length(obj.poblacion)
               obj.poblacion{i}.invitadosTarget = [];
               poblacionCopy = obj.poblacion;
               poblacionCopy(i) = [];
               for j=1:obj.numInvitados
                   posInvitado = randi(length(poblacionCopy));
                   obj.poblacion{i}.invitadosTarget = [obj.poblacion{i}.invitadosTarget; poblacionCopy{posInvitado}.vector];
                   poblacionCopy(posInvitado) = [];
               end
           end
        end
        
        function calcularVectoresRuido(obj,f)
            for i=1:length(obj.poblacion)
                obj.poblacion{i}.calcularVectorRuido(f);
            end
        end
        
        function recombinar(obj,CR)
            for i=1:length(obj.poblacion)
                obj.poblacion{i}.recombinacion(CR);
            end
        end
        
        function reemplazar(obj)
            for i=1:length(obj.poblacion)
                obj.poblacion{i}.remplazo();
            end
        end
        
        function aptitud = obtenerMejorIndividuo(obj)
            mejorIndividuo = Individuo();
            mejorIndividuo.actualizarAptitud();
            for i=1:length(obj.poblacion)
                if obj.poblacion{i}.fit < 1000 && mejorIndividuo.fit < 1000
                    if obj.poblacion{i}.fit < mejorIndividuo.fit
                        mejorIndividuo = obj.poblacion{i};
                    end             
                elseif obj.poblacion{i}.fit < 1000 && mejorIndividuo.fit == 1000
                        mejorIndividuo = obj.poblacion{i};
                elseif obj.poblacion{i}.fit == 1000 && mejorIndividuo.fit < 1000
                        %mejorIndividuo = obj.poblacion{i};
                else
                    if obj.poblacion{i}.viorest < mejorIndividuo.viorest
                        mejorIndividuo = obj.poblacion{i};
                    end
                end
            end
            aptitud = mejorIndividuo.fit;
            disp(['Rest: ' num2str(mejorIndividuo.viorest, '%6.20f'), ' ** Aptitud: ', num2str(mejorIndividuo.fit, '%6.20f'), ' ** Vector: ', num2str(mejorIndividuo.vector, '%6.20f')]);
        end

    end
    
end

