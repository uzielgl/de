classdef Individuo < handle
    properties
        % Está será la lista de variables, las 4 longitudes y un ángulo.
        vector
        
        % Este es el límite inferior de la longitud.
        lim_inf_lon = 0.05
        
        % Este es el límite superior de la longitud.
        lim_sup_lon = 0.5
        
        % Límite superior del ángulo.
        lim_sup_ang = 45
        
        % Límite inferior del ángulo
        lim_inf_ang = -45
        
        % Variable de aptitud
        aptitud
        
        % Violación de restricciones
        viorest
        
        % Bandera que indica si es una solución factible de grashof
        grashof
        
    end %end properties
    
    methods
        %Constructor. Podra ser sin parámetros, o con un array de vectores
        %para inicalizarlo
        function obj = Individuo( vector )
            if nargin == 0
                for i=1:1:4
                    obj.vector(i) = unifrnd(obj.lim_inf_lon, obj.lim_sup_lon);         
                end
                obj.vector(5) =  unifrnd(obj.lim_inf_ang, obj.lim_sup_ang);
                obj.updAptitud()
            else 
                obj.vector = vector;
            end
        end%end constructor
        
        % Funcion que actualiza la aptitud, el viorest y esSolucion en base
        % a la función merito2din
        function updAptitud(obj)
            [obj.aptitud, obj.viorest, obj.grashof] = merito1din(obj.vector);
            obj.grashof = ~obj.grashof;
        end
        
        function acotarVector(obj)
            vector = obj.vector;
            for i=1:length(vector)
                if i == 1 || i == 2 || i == 3 || i == 4
                    if vector(i) < obj.lim_inf_lon
                        vector(i) = 2 * obj.lim_inf_lon -  vector(i);
                    else if vector(i) > obj.lim_sup_lon
                        vector(i) = 2 * obj.lim_sup_lon -  vector(i);
                        end
                    end
                else if vector(i) < obj.lim_inf_ang
                        vector(i) = 2 * obj.lim_inf_ang -  vector(i);
                    else if vector(i) > obj.lim_sup_ang
                        vector(i) = 2 * obj.lim_sup_ang -  vector(i);
                        end
                    end
                end
            end
            obj.vector = vector;
        end
        
        
        
        
        
        %{
        function text=  display(obj)
            obj.lim_inf_lon
        end
        %}
        
    end %end methods
    
end %end Individuo

%{
    %Clase Individuo DE/Rand/2/Bin    
    properties
        % Está será la lista de variables, las 4 longitudes y un ángulo.
        vector
        % Este es el límite inferior de la longitud.
        lim_inf_lon = 0.05
        % Este es el límite superior de la longitud.
        lim_sup_lon = 0.5
        % Límite superior del ángulo.
        lim_sup_ang = 45
        % Límite inferior del ángulo
        lim_inf_ang = -45
        %Variable de aptitud
       % aptitud
        %variables que regresa la funcion merito2din
        fit
        viorest
        bandera
        %Vectores invitados target
        invitadosTarget = []
        r0
        r1
        r2
        r3
        r4
        
        %Vector de Ruido
        vectorRuido
        
        %Vector del Trial
        vectorTrial
        
    end
    
    methods
        function obj = Individuo()
            for i=1:1:4
                obj.vector(i) = unifrnd(obj.lim_inf_lon, obj.lim_sup_lon);         
            end
            obj.vector(5) =  unifrnd(obj.lim_inf_ang, obj.lim_sup_ang);
        end
        
        function actualizarAptitud(obj)
            [obj.fit, obj.viorest, obj.bandera] = merito2din(obj.vector);
            %obj.aptitud = obj.fit;
        end
        
       % function aptitud = getAptitud(obj)
        %    aptitud = obj.aptitud;
       % end
        
        function setVector(obj, newVector)
            obj.vector = newVector;
            obj.actualizarAptitud();
            obj.invitadosTarget = [];
        end
        
        function calcularVectorRuido(obj, f)
            invitadosCopy = obj.invitadosTarget;
            a = size(invitadosCopy);
            posBase = randi(a(1));
            obj.r0 = invitadosCopy(posBase,:);
            invitadosCopy(posBase,:) = [];
            obj.r1 = invitadosCopy(1,:);
            obj.r2 = invitadosCopy(2,:);
            obj.r3 = invitadosCopy(3,:);
            obj.r4 = invitadosCopy(4,:);
            
            obj.vectorRuido = obj.r0 + f*(obj.r1 - obj.r2) + f*(obj.r3 - obj.r4);
            obj.vectorRuido = obj.acotar(obj.vectorRuido);
            obj.invitadosTarget = [];
        end
        
        function vectorAcotado = acotar(obj,vector)
            for i=1:length(vector)
                if i == 1 || i == 2 || i == 3 || i == 4
                    if vector(i) < obj.lim_inf_lon
                        vector(i) = 2 * obj.lim_inf_lon -  vector(i);
                    else if vector(i) > obj.lim_sup_lon
                        vector(i) = 2 * obj.lim_sup_lon -  vector(i);
                        end
                    end
                else if vector(i) < obj.lim_inf_ang
                        vector(i) = 2 * obj.lim_inf_ang -  vector(i);
                    else if vector(i) > obj.lim_sup_ang
                        vector(i) = 2 * obj.lim_sup_ang -  vector(i);
                        end
                    end
                end
            end
            vectorAcotado = vector;
        end
        
        function recombinacion(obj,CR)
            trial = zeros(1,5);
            jRand = randi(length(obj.vector));
            for j=1:length(obj.vector)
                if rand < CR || j == jRand
                    trial(j) = obj.vectorRuido(j);
                else
                    trial(j) = obj.vector(j);
                end
            end
            obj.vectorTrial = trial;
            %obj.vectorTrial = obj.acotar(trial);
            % obj.vectorTrial = trial;
        end
        
        function remplazo(obj)
            [f,v,b] = merito2din(obj.vectorTrial);
            if obj.fit < 1000 && f < 1000
                if obj.fit > f
                    obj.setVector(obj.vectorTrial);
                end             
            elseif obj.fit == 1000 && f < 1000
                obj.setVector(obj.vectorTrial);
            elseif obj.fit < 1000 && f == 1000
                %obj.setVector(obj.vectorTrial);
            else
                if obj.viorest > v
                    obj.setVector(obj.vectorTrial);
                end
            end
        end
        
    end
    
end
%}
