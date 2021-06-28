# Defining the main ODE function
using JLD

function CV_Film_ODEs(du,u,P_ODE,t)

# The arguments for the function are fixed by the solver (du,u,P_ODE,t), so need to use JLD to get parameters into the function without altering the function call arguments.

    # But it makes the simulation way too slow, so can't use JLD.
    # Can make the variables global or include in P_ODE, but at the moment it seems best to leave it in the same script as the function call.

fromDimlessGrpCalcsFileNameAndPath = "temp/fromDimlessGrpCalcs.jld" ;

t_sw = load("$fromDimlessGrpCalcsFileNameAndPath", "t_sw") ;
t_tot = load("$fromDimlessGrpCalcsFileNameAndPath", "t_tot") ;
RTdivF_mV = load("$fromDimlessGrpCalcsFileNameAndPath", "RTdivF_mV") ;
Eref_mV = load("$fromDimlessGrpCalcsFileNameAndPath", "Eref_mV") ;
Xi400 = load("$fromDimlessGrpCalcsFileNameAndPath", "Xi400") ;
Epsilon_pi = load("$fromDimlessGrpCalcsFileNameAndPath", "Epsilon_pi") ;
Epsilon_pf = load("$fromDimlessGrpCalcsFileNameAndPath", "Epsilon_pf") ;


    global numPts

    println("time = $t")

    # Oxidized Form of the redox film mediator (u[1]-u[1001])

          # Electrode Surface, Pox, u[1])

            	Part1a = P_ODE[1,101] ;
            	Part1b = exp( -P_ODE[1,99]*(Epsilon_CV(t,t_sw,t_tot,RTdivF_mV,Eref_mV,Xi400,Epsilon_pi,Epsilon_pf))*P_ODE[1,98] ) ;
            	Part1c = u[1] ;
            Part1 = (Part1a)*(Part1b)*(Part1c) ;

            	Part2a = P_ODE[1,102] ;
            	Part2b = exp( (1-P_ODE[1,99])*(Epsilon_CV(t,t_sw,t_tot,RTdivF_mV,Eref_mV,Xi400,Epsilon_pi,Epsilon_pf))*P_ODE[1,98] ) ;
            	Part2c = 1-u[1] ;
            Part2 = (Part2a)*(Part2b)*(Part2c) ;

            Part3 = P_ODE[1,103]*(u[2]-u[1]) ;

            Part4 = P_ODE[1,104]*(1-u[1])*u[numPts+1] ;

            du[1] = (Part1) + (Part2) + (Part3) + (Part4) ;

          # Interior cells, Pox, u[2]-u[1000]

            for i=2:(numPts-1)

              global numPts

              Part1 = P_ODE[i,101]*(u[i]-u[i-1]) ;

              Part2 = P_ODE[i,102]*(u[i+1]-u[i]) ;

              Part3 = P_ODE[i,103]*(1-u[i])*u[numPts+i] ;

              du[i] = (Part1) + (Part2) + (Part3) ;

            end

          # Boundary at the edge of the film, Pox, u[1001]

              Part1 = P_ODE[numPts,101]*(u[numPts]-u[(numPts-1)]) ;

              Part2 = P_ODE[numPts,102]*(1-u[numPts])*u[numPts+numPts] ;

              du[numPts] = (Part1) + (Part2) ;


# Oxidized Form of the reactant Yox (1002-2002)

        # Electrode Surface, Yox, u[1002])

            #Part1 = P_ODE[1+1001,101]*(u[2+1001]-u[1+1001]) ;
            Part1 = P_ODE[1+numPts,101]*(u[2+numPts]-u[1+numPts]) ;

            #Part2 = P_ODE[1+1001,102]*(1-u[1])*(u[1+1001]) ;
            Part2 = P_ODE[1+numPts,102]*(1-u[1])*(u[1+numPts]) ;

            #du[1+1001] = (Part1) + (Part2) ;
            du[1+numPts] = (Part1) + (Part2) ;

        # Interior, Yox, u[1002]-u[2001]

            #for i=2:1000
            for i=2:(numPts-1)

                global numPts

                      #Part1a = P_ODE[i+1001,101];
                      Part1a = P_ODE[i+numPts,101];
                      #Part1b = u[i+1001]-u[(i-1)+1001] ;
                      Part1b = u[i+numPts]-u[(i-1)+numPts] ;
                    Part1 = (Part1a)*(Part1b) ;

                      #Part2a = P_ODE[i+1001,102] ;
                      Part2a = P_ODE[i+numPts,102] ;
                      #Part2b = u[(i+1)+1001]-u[i+1001] ;
                      Part2b = u[(i+1)+numPts]-u[i+numPts] ;
                    Part2 = (Part2a)*(Part2b) ;

                      #Part3a = P_ODE[i+1001,103] ;
                      Part3a = P_ODE[i+numPts,103] ;
                      Part3b = 1-u[i] ;
                      #Part3c = u[i+1001] ;
                      Part3c = u[i+numPts] ;
                    Part3 = (Part3a)*(Part3b)*(Part3c) ;

                #du[i+1001] = (Part1) + (Part2) + (Part3) ;
                du[i+numPts] = (Part1) + (Part2) + (Part3) ;

            end

        # Film/Solution boundary, Yox, u[2002]

              #du[1001+1001] = 0 ;
              du[numPts+numPts] = 0 ;

end
