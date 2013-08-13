function main
    population = 6;
    cr = 0.5;
    f = 0.5;
    max_generations = 2;
    
    p = Poblacion( population );
    p.cr = cr;
    p.f = f;
    
    for i=1:max_generations
        %Recorremos cada elemento de la población
        for j=1:length( p.population )
            target = p.population{ j };
            trial = p.getTrial(j);
            
            p.population{ j } = mini( [target, trial] );
        end
        
        % Mostramos la solución
        disp(  p.population );
    end 
    
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