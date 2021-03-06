classdef Individuo<handle
    %Clase Individuo DE/Rand/2/Bin
    
    properties
        % Est� ser� la lista de variables, las 4 longitudes y un �ngulo.
        vector
        % Este es el l�mite inferior de la longitud.
        lim_inf_lon = 0.05
        % Este es el l�mite superior de la longitud.
        lim_sup_lon = 0.5
        % L�mite superior del �ngulo. 
        lim_sup_ang = 45
        % L�mite inferior del �ngulo
        lim_inf_ang = -45
        %Variable de aptitud
       % aptitud
        %variables que regresa la funcion merito1din
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
            for i=1:4
                obj.vector(i) = unifrnd(obj.lim_inf_lon, obj.lim_sup_lon);         
            end
            obj.vector(5) =  unifrnd(obj.lim_inf_ang, obj.lim_sup_ang);
        end
        
        function actualizarAptitud(obj)
            [obj.fit, obj.viorest, obj.bandera] = merito1din(obj.vector);
            %obj.aptitud = obj.fit;
        end
        
       % function aptitud = getAptitud(obj)
        %    aptitud = obj.aptitud;
       % end
        
        function setVector(obj, newVector, fit, viorest, bandera)
            obj.vector = newVector;
            obj.fit = fit;
            obj.viorest = viorest;
            obj.bandera = bandera;
            %obj.actualizarAptitud();
            obj.invitadosTarget = [];
            obj.vectorRuido = [];
            obj.vectorTrial = [];
            obj.r0 = [];
            obj.r1 = [];
            obj.r2 = [];
            obj.r3 = [];
            obj.r4 = [];
        end
        
        function calcularVectorRuido(obj, f)
            invitadosCopy = obj.invitadosTarget;
            obj.invitadosTarget = [];
            a = size(invitadosCopy);
            posBase = randi(a(1));
            obj.r0 = invitadosCopy(posBase,:);
            invitadosCopy(posBase,:) = [];
            obj.r1 = invitadosCopy(1,:);
            obj.r2 = invitadosCopy(2,:);
            obj.r3 = invitadosCopy(3,:);
            obj.r4 = invitadosCopy(4,:);
            %obj.vectorRuido = obj.r0 + f*(obj.r1 - obj.r2);
            obj.vectorRuido = obj.r0 + f *(obj.r1 - obj.r2) + f* (obj.r3 - obj.r4);
            %obj.vectorRuido = obj.acotar(obj.vectorRuido);
        end
        
        function vectorAcotado = acotar(obj,vector)
            for i=1:length(vector)
                if i == 1 || i == 2 || i == 3 || i == 4
                    if vector(i) < obj.lim_inf_lon
                        vector(i) = 2 * obj.lim_inf_lon -  vector(i);
                    elseif vector(i) > obj.lim_sup_lon
                        vector(i) = 2 * obj.lim_sup_lon -  vector(i);
                    else
                        vector(i) = vector(i);
                    end
                elseif vector(i) < obj.lim_inf_ang
                        vector(i) = 2 * obj.lim_inf_ang -  vector(i);
                elseif vector(i) > obj.lim_sup_ang
                        vector(i) = 2 * obj.lim_sup_ang -  vector(i);
                else
                    vector(i) = vector(i);
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
            obj.vectorTrial = obj.acotar(trial);
            % obj.vectorTrial = trial;
        end
        
        function remplazo(obj)
            [f,v,b] = merito1din(obj.vectorTrial);
            if obj.fit ~= 0 && f ~= 0
                if obj.fit < f
                    obj.setVector(obj.vectorTrial,f,v,b);
                end             
            elseif obj.fit == 0 && f ~= 0
                obj.setVector(obj.vectorTrial,f,v,b);
            elseif obj.fit ~= 0 && f == 0
                %obj.setVector(obj.vectorTrial);
            else
                if obj.viorest > v
                    obj.setVector(obj.vectorTrial,f,v,b);
                end
            end
        end
        
    end
    
end

