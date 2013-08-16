function main(cr,f,t1,t2,pobladores)
       %Metodo main
       for i=1:15
           disp(['------------------EJECUCION No. ', num2str(i), '------------------']);
           mejoresResultados = zeros(1,30);
           
           finf = 0.1;
           fsup = 0.9;
%            cr = .5;
%            f = .5;
%            t1 = 0.2;
%            t2 = 0.2;
%            pobladores = 40;
           maxgen = 12500;
           gen = 1;
           evaluaciones = pobladores;
           pob = Poblacion(pobladores);
           disp(['Eval: ', num2str(evaluaciones), ' Gen: ', num2str(gen)]);
           %disp(gen);
           %pob.obtenerMejorIndividuo();

           mejorFit = pob.obtenerMejorIndividuo();
           noCambia = 0;


           while evaluaciones < (maxgen * pobladores) && noCambia < 6000
               gen = gen + 1;
               evaluaciones = evaluaciones + pobladores;
               pob.generarInvitados();
               pob.calcularVectoresRuido(f);
               pob.recombinar(cr);
               pob.reemplazar();
               disp(['Eval: ', num2str(evaluaciones), ' Gen: ', num2str(gen)]);
               mejorFit2 = pob.obtenerMejorIndividuo();
               if mejorFit == mejorFit2
                   noCambia = noCambia + 1;
                   mejorFit = mejorFit2;
               else
                   noCambia = 0;
                   mejorFit = mejorFit2;
               end

               if rand() < t1
                   f = finf + rand() * fsup;
               end
               if rand() < t2
                   cr = rand();
               end
               
              

           end
           
           mejoresResultados(i) = mejorFit2;
           
       end
       disp(['Mejores Resultados: ', num2str(mejoresResultados)]);

end

