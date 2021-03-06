classdef Poblacion < handle 
    %Clase Poblacion DE/Best/2/Bin
    
    properties
        % N�mero de habitantes
        totalPopulation;
        
        % Vector donde se guardar� los indiviudos
        population = [ Individuo([1,1,1,1,1]) ]; % lo forzamos para que acepte individuos
        
        % Factor de cruza
        cr = 0.5;
        
        % Factor F
        f = 0.5;
        
    end % End properties
    
    methods
        
        % Constructor
        function obj = Poblacion( totalPopulation )
            obj.totalPopulation = totalPopulation; 
            for j=1:totalPopulation
                i = Individuo();
                obj.population( j ) = i;
            end
        end

        % Get the trial
        function trial = getTrial( obj, target_index )
            target = obj.population( target_index );

            % los indeces usados
            usados = [ target_index ];
            
            % Generamos los r's (r1 ... r5 ) necesarios, sin repetirlos
            for j=1:5
                % Generamos un indice que no este previamente para no
                % repetir los r's
                while 1
                    index = floor( unifrnd(1, obj.totalPopulation + 1) );
                    if ~any( usados == index ) 
                        usados( length(usados) + 1 ) = index;
                        break;
                    end
                end

                rs( j ) = obj.population( index ); 
            end

            % Obtenemos el mejor individo (que es el de menor aptitud)
            best_rs = mini( rs );
            
            % Lo quitamos para poder hacer las restas
            para_ruido = setdiff( rs, best_rs);

            vector_ruido = best_rs.vector + obj.f * ( para_ruido(1).vector - para_ruido(2).vector ) + obj.f * ( para_ruido(3).vector - para_ruido(4).vector );
            
            % Hacemos la cruza
            vector_trial = [];
            jran = randi( 5 );
            
            for j=1:length(target.vector)
                if( rand() < obj.cr || j == jran )
                    vector_trial(j) = vector_ruido(j);
                else
                    vector_trial(j) = target.vector(j);
                end
            end
            
            trial = Individuo( vector_trial );
            
            %Acotamos su vector
            trial.acotarVector()
            
            trial.updAptitud();
 
        end

    end % End methods
    
    
    
end %End class
%{
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
        
        function obtenerMejorIndividuo(obj)
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
            disp(mejorIndividuo.vector);
            disp(mejorIndividuo.fit);
            disp(mejorIndividuo.viorest);
        end

    end
    
end

%}