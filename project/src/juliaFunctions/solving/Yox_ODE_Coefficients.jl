function Yox_ODE_Coefficients(P_ODE,numPts,h,wHalf_y,Xi400,kappa_py_y)


# Parameters for the ODEs corresponding to the oxidized form of the freely diffusing substrate (Yox)

        eqnNum = 2 ;

        offset = numPts*(eqnNum-1) ;
            # offset accounts for the fact that the ODEs for each species are vertically stacked

       # Electrode Surface, Yox

               Part1 = h[1]/2 ;
               Part2 = wHalf_y^2 ;
               Part3 = (1/Xi400) ;
       P_ODE[1+offset,100] = (Part1)*(Part2)*(Part3) ;

       P_ODE[1+offset,1] = 1/h[1] ;

       P_ODE[1+offset,2] = -kappa_py_y*(h[1]/2) ;

       P_ODE[1+offset,101] = P_ODE[1+numPts,1]/P_ODE[1+numPts,100] ;

       P_ODE[1+offset,102] = P_ODE[1+numPts,2]/P_ODE[1+numPts,100] ;

       # Interior, Yox

       for i=2:(numPts-1)

               # global numPts

                   Part1 = (h[i-1]+h[i])/2 ;
                   Part2 = wHalf_y^2 ;
                   Part3 = (1/Xi400) ;
               P_ODE[i+offset,100] = (Part1)*(Part2)*(Part3) ;

               P_ODE[i+offset,1] = -1/h[i-1] ;

               P_ODE[i+offset,2] = 1/h[i] ;

               P_ODE[i+offset,3] = -kappa_py_y*(h[i-1]+h[i])/2 ;

               P_ODE[i+offset,101] = P_ODE[i+numPts,1]/P_ODE[i+numPts,100] ;

               P_ODE[i+offset,102] = P_ODE[i+numPts,2]/P_ODE[i+numPts,100] ;

               P_ODE[i+offset,103] = P_ODE[i+numPts,3]/P_ODE[i+numPts,100] ;

       end


return P_ODE

end
