function main( poblacion, cr, f)
    
    population = poblacion; % 50; %100
    cr = cr; %0.9; %.9
    f = f; %0.3; %.3
    max_generations = 10000;
    
    
    p.cr = cr;
    p.f = f;
    tic
	
    for j=1:2
        p = Poblacion( population );
        for i=1:max_generations
			%Recorremos cada elemento de la población
			for j=1:length( p.population )
				target = p.population( j );
				trial = p.getTrial(j);
				
				p.population( j ) = mini( [target, trial] );
			end
			
			% Mostramos la solución
			mejor = mini( p.population );
			
			if i == 3000 && mejor.aptitud == 1000
				break;
			end
			
			disp( [num2str(i), ': Viorest: ', num2str( mejor.viorest), ', aptitud: ', num2str(mejor.aptitud, '%6.20f'), ', vector: ', num2str( mejor.vector, '%6.20f'), ' , tt: ', num2str(toc) ] );
			
        end
    end
	
	diary off
	
end %main


%{
function main
       %Metodo main
       cr = .7;
       f = .5;
       pobladores = 50;
       maxgen = 100000;
       gen = 1;
       pob = Poblacion(pobladores);
       disp('Generacion:');
       disp(gen);
       pob.obtenerMejorIndividuo();
       
       while gen < maxgen
           pob.generarInvitados();
           pob.calcularVectoresRuido(f);
           pob.recombinar(cr);
           pob.reemplazar();
           disp('Generacion:');
           disp(gen);
           pob.obtenerMejorIndividuo();
           gen = gen + 1;
       end

end

%}