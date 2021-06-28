#cd("/home/tadeus/Documents/SS2021/115_CV_Simulation_Julia/100_22Feb2021/juliaFunctions")

using DiffEqBase
#println("DiffEqBase Package Compiled")
using LSODA
#println("LSODA Package Compiled")
using PlotlyJS
#println("PlotlyJS Package Compiled")
# using DifferentialEquations
# println("DifferentialEquations Package Compiled")
using XLSX
#println("XLSX Package Compiled")
using JLD


# Need to reference the functions based on this location even though the pwd is project/src


#= include("solving/singleExpGridConcAtZero.jl")
include("calcDimensionlessGrps.jl") =#

include("singleExpGridConcAtZero.jl")
include("../calcDimensionlessGrps.jl")




#= include("solving/iotaCap_CV.jl")
include("solving/epsilon_CV.jl") =#

include("iotaCap_CV.jl")
include("epsilon_CV.jl")




#= include("solving/Pox_ODE_Coefficients.jl")
include("solving/Yox_ODE_Coefficients.jl")
 =#

include("Pox_ODE_Coefficients.jl")
include("Yox_ODE_Coefficients.jl")


#include("solving/CV_Film_ODEs.jl")

function CV_FwdSweepReduction()

# Using the Atom IDE with Juno for Julia
	# Using Julia version 1.4.1 (2019-05-16)
	# The Atom IDE is version 1.38.2, using uber-juno package version 0.2.0

# Julia packages
#-----------(need to include the versions)--------------

	# using Pkg ;
 	# 	Pkg.add(PackageSpec(name="DifferentialEquations",version="6.15.0")) ;
 	# 	Pkg.add(PackageSpec(name="LSODA",version="0.6.2")) ;
 	# 	Pkg.add(PackageSpec(name="XLSX",version="0.7.2")) ;
	#	Pkg.add(PackageSpec(name="PlotlyJS",version="0.13.1")) ;
	#	Pkg.add(PackageSpec(name="JLD",version="0.10.0")) ;

# Output to screen

	display("Starting Simulation...")

# Calculate dimensionless groups

#= scanRate_mVps,FarConst_uA,
Ptot_cm3,Ytot_cm3,k_py_cm3,
Dp_cm2_s,Dy_cm2_s,
discArea_cm2,filmThickness_cm,
k0_cm,Alpha,
Ei_mV,Es_mV,Ef_mV,Ep0_mV,
Rs_Ohm,Cd_F,Cd_uA_mV,RsCd_s,maxCapCurrent_uA,
Temp_K,RTdivF_mV,
refCurrent_uA,Xi400,refTime_s,
wHalf_p,wHalf_y,
tauCap,zetaCap,
phiP,Eref_mV,Epsilon_pi,Epsilon_ps,Epsilon_pf,
kappa_py_p,kappa_py_y,
t_tot,t_fwd,t_sw,t_rev,
t_tot_s,t_fwd_s,t_sw_s,t_rev_s,gBard,refCurrent_AdsMono_uA,Gamma_pmol_cm2,G_Laviron,peakPotentialLaviron_mV,psiLaviron_uA = calcDimensionlessGrps() =#

scanRate_mVps,FarConst_uA,
Ptot_cm3,Ytot_cm3,k_py_cm3,
Dp_cm2_s,Dy_cm2_s,
discArea_cm2,filmThickness_cm,
k0_cm,Alpha,
Ei_mV,Es_mV,Ef_mV,Ep0_mV,
Rs_Ohm,Cd_F,Cd_uA_mV,RsCd_s,maxCapCurrent_uA,
Temp_K,RTdivF_mV,
refCurrent_uA,Xi400,refTime_s,
wHalf_p,wHalf_y,
tauCap,zetaCap,
phiP,Eref_mV,Epsilon_pi,Epsilon_ps,Epsilon_pf,
kappa_py_p,kappa_py_y,
t_tot,t_fwd,t_sw,t_rev,
t_tot_s,t_fwd_s,t_sw_s,t_rev_s = calcDimensionlessGrps()



		# Grid options

			FileNameAndPath = "temp/options.jld"

			# numIntervals = 100 ; # Number of x points on the grid
			# numIntervals = load("temp/exptlParams.jld", "numIntervals")
			numIntervals = load("$FileNameAndPath", "numIntervals")

			# Beta = 10.0 ; # Factor for exponential grid spacing
			# Beta = load("temp/exptlParams.jld", "Beta")
			Beta = load("$FileNameAndPath", "Beta")


	# The simulation is designed only for the case where the forward sweep in the CV is cathodic.

    		if (Ef_mV>Ei_mV)
      			println("---Error---")
      			println("Ef_mV must be lower than Ei_mV")
      			println("-----------")
      		return
    		else
    		end

#-----------------------------------------------------------------------------#

# Preparation of the grid by calling a function to get x (the values of the cell centers) and h (the distance differences between the cell centers)

    	# global numPts = numIntervals+1 ;
		numMatBal = 2 ; # Number of material (species) balances


    	# x,h,~,~ = expConcentratedGridsAt0or1(numIntervals,Beta,GridPlotsOrNoPlots)
		# x,h = singleExpGridConcAtZero(numIntervals,Beta,GridPlotsOrNoPlots)
		x,h,numPts = singleExpGridConcAtZero(numIntervals,Beta)
		global numPts
		

# Prepararations before defining the ODE system function

		tspan = (0.0,t_tot) ; # Dimensionless time span


#-----------------------------------------------------------------------------#


# Preparation of the coefficient matrix for solving the system of ODEs using the LSODA solver within DifferentialEquations.jl

	# Initialize parameter matrices for main ODEs

			#P_ODE = zeros(1001+1001,200) ;

			numODEs = numPts*numMatBal ;
			maxNumCoeffsPerODE = 200 ;
			P_ODE = zeros(numODEs,maxNumCoeffsPerODE) ;

	# Function to populate the parameter matrix

			# The name of the matrix is the same because it is populating the entries of the initialized matrix.

			# Populate ODE coefficients for Pox

			# P_ODE = Pox_ODE_Coefficients(P_ODE,h,numPts,wHalf_p,Xi400,Alpha,Eref_mV,RTdivF_mV,phiP,kappa_py_p,gBard) ;
			P_ODE = Pox_ODE_Coefficients(P_ODE,h,numPts,wHalf_p,Xi400,Alpha,Eref_mV,RTdivF_mV,phiP,kappa_py_p) ;

			# Populate ODE coefficients for Yox

			P_ODE = Yox_ODE_Coefficients(P_ODE,numPts,h,wHalf_y,Xi400,kappa_py_y) ;

#----------------------------------------------------------------------------#

# Defining the main ODE function

  function CV_Film_ODEs(du,u,P_ODE,t)

	# numPts = load("../temp/singlExpGridConcAtZero.jld", "numPts")
    global numPts

    # println("time = $t")

    # Oxidized Form of the redox film mediator (u[1]-u[1001])

          # Electrode Surface, Pox, u[1])

            # 	Part1a = P_ODE[1,101] ;
            # 	Part1b = exp( -P_ODE[1,99]*(Epsilon_CV(t,t_sw,t_tot,RTdivF_mV,Eref_mV,Xi400,Epsilon_pi,Epsilon_pf)) ) ;
			# 	Part1c = exp( P_ODE[1,99]*P_ODE[1,98]*u[1] ) ;
            # 	Part1d = u[1] ;
            # Part1 = (Part1a)*(Part1b)*(Part1c)*(Part1d) ;
			#
            # 	Part2a = P_ODE[1,102] ;
            # 	Part2b = exp( (1-P_ODE[1,99])*(Epsilon_CV(t,t_sw,t_tot,RTdivF_mV,Eref_mV,Xi400,Epsilon_pi,Epsilon_pf)) ) ;
			# 	Part2c = exp( -(1-P_ODE[1,99])*P_ODE[1,98]*u[1] )
            # 	Part2d = 1-u[1] ;
            # Part2 = (Part2a)*(Part2b)*(Part2c)*(Part2d) ;


			Part1a = P_ODE[1,101] ;
			Part1b = exp( -P_ODE[1,99]*(Epsilon_CV(t,t_sw,t_tot,RTdivF_mV,Eref_mV,Xi400,Epsilon_pi,Epsilon_pf)) ) ;
			#Part1c = 1 ;
			#Part1c = exp( P_ODE[1,99]*P_ODE[1,98]*(u[1]) ) ;
			Part1c = exp( P_ODE[1,99]*(u[1]) ) ;
			Part1d = u[1] ;
		Part1 = (Part1a)*(Part1b)*(Part1c)*(Part1d) ;

			Part2a = P_ODE[1,102] ;
			Part2b = exp( (1-P_ODE[1,99])*(Epsilon_CV(t,t_sw,t_tot,RTdivF_mV,Eref_mV,Xi400,Epsilon_pi,Epsilon_pf)) ) ;
			#Part2c = 1 ;
			#Part2c = exp( -(1-P_ODE[1,99])*P_ODE[1,98]*u[1] ) ;
			Part2c = exp( -(1-P_ODE[1,99])*u[1] ) ;
			Part2d = 1-u[1] ;
		Part2 = (Part2a)*(Part2b)*(Part2c)*(Part2d) ;

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
				#numPts = load("../temp/singlExpGridConcAtZero.jld", "numPts")

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

#-----------------------------------------------------------------------------#

# Setting the initial condition

   	u0 = 1.0*ones(1,numPts*numMatBal) ;

# Calling the ODE solver

	prob1 = ODEProblem(CV_Film_ODEs,u0,tspan,P_ODE) ;

	FileNameAndPath = "temp/options.jld" ;

	abstol = load("$FileNameAndPath", "abstol") ;
	reltol = load("$FileNameAndPath", "reltol") ;
	saveat = load("$FileNameAndPath", "saveat") ;

	global sol = solve(prob1,lsoda(),abstol=abstol,reltol=reltol,saveat=saveat,:interpolant) ;

  	solArray = Array(sol) ;
	# println("solArray = $solArray")

# Extracting the time and concentrations

    	t = sol.t ;

    	Pox1 = solArray[1,1,:] ; # Concentration at x=x1

    	Pox2 = solArray[1,2,:] ; # Concentration at x=x2

# Calculating the dimensional potential difference for plotting

	# Dimensionless potential difference

		# Calculating the individual epsilon_p values

		      numTimePts = size(t,1) ;

			  epsilon_p = Vector{Float64}(undef, numTimePts) ;

		      # Loop to calculate the individual epsilon_p values

		          for j = 1:numTimePts ;
		            epsilon_p[j] = Epsilon_CV(t[j],t_sw,t_tot,RTdivF_mV,Eref_mV,Xi400,Epsilon_pi,Epsilon_pf) ;
		          end
	# Dimensional potential from dimensionless potential difference

		       Potential_mV = Ep0_mV .+ epsilon_p.*(Eref_mV) ;

# Calculating the current

	# Faradaic current

	  FaradaicCurrent = -(1/wHalf_p).*(Pox2.-Pox1)./h[1] ;
	  FaradaicCurrent_uA = FaradaicCurrent*refCurrent_uA ;

	# Capacitive current

		  # Calculating the individual epsilon_p values

		        #iotaCap = zeros(numTimePts,1) ;
				iotaCap = Vector{Float64}(undef, numTimePts) ;

		        # Loop to calculate the individual epsilon_p values

		        for j = 1:numTimePts
		          iotaCap[j] = iotaCap_CV(t[j],t_sw,t_tot,tauCap,zetaCap) ;
		        end


	  CapacitiveCurrent = iotaCap ;
	  CapacitiveCurrent_uA = CapacitiveCurrent*refCurrent_uA ;

	  # Total dimensionless current

	  TotalCurrent = FaradaicCurrent + CapacitiveCurrent ;
	  TotalCurrent_uA = FaradaicCurrent_uA + CapacitiveCurrent_uA ;

#-----------------------------------------------------------------------------#
# Exporting the results to an Excel file

	paramsFileNameDirectory = load("temp/paramsFileDirectory.jld", "paramsFileNameDirectory") ;

	excelFileExportName = "DataExport.xlsx"

	excelFileExportPath = paramsFileNameDirectory * excelFileExportName ;
	

	XLSX.openxlsx("$excelFileExportPath", mode="w") do xf

		# mode="rw" overwrites an existing file. If using this option, the starting excel file must have the necessary number of worksheets already created because the default is that only one worksheet is created when a new excel file is created in libre open office calc.
		# mode="w" creates a new file. Choosing this option because the number of time points (rows) will change depending on the potential sweep range and the time point interval, to make sure that there is no clash between simulation data sets.

		sheet = xf[1]

		sheet["A1"] = "Potential [mV]"

		sheet["A2", dim=1] = Potential_mV

		sheet["B1"] = "Faradaic Current [uA]"

		sheet["B2", dim=1] = FaradaicCurrent_uA

		sheet["C1"] = "Capacitive Current [uA]"

		sheet["C2", dim=1] = CapacitiveCurrent_uA

		sheet["D1"] = "Total Current [uA]"

		sheet["D2", dim=1] = TotalCurrent_uA

		# sheet = xf[2]

		sheet["G1"] = "E-E0 (Scaled)"
		sheet["G2", dim=1] = epsilon_p

		sheet["H1"] = "Faradaic Current (Scaled)"
		sheet["H2", dim=1] = FaradaicCurrent

		sheet["I1"] = "Capacitive Current (Scaled)"
		sheet["I2", dim=1] = CapacitiveCurrent_uA

		sheet["J1"] = "Total Current (Scaled)"
		sheet["J2", dim=1] = TotalCurrent

		# sheet = xf[3]

#= 		sheet["M1"] = "Adsorbed Monolayer Comparison"

		sheet["M3"] = "Equivalent Coverage [=] pmol*cm-2"

		sheet["M4"] = Gamma_pmol_cm2

		sheet["M6"] = "Adsorbed Monolayer Current [=] uA"
		sheet["M7"] = refCurrent_AdsMono_uA

		sheet["M9"] = "G (Laviron)"
		sheet["M10"] = G_Laviron

		sheet["M12"] = "Reference Current Psi (Laviron) [=] uA"
		sheet["M13"] = psiLaviron_uA

		sheet["M15"] = "Peak Potential (Laviron) [=] mV"
		sheet["M16"] = peakPotentialLaviron_mV =#

 	end
		

#--------------------------------------------------------------
# Saving the reults to a JLD file

jldopen("temp/plotData.jld", "w") do file
	write(file, "numMatBal", numMatBal)
	write(file, "Potential_mV", Potential_mV)
	write(file, "epsilon_p", epsilon_p)
	write(file, "FaradaicCurrent", FaradaicCurrent)
	write(file, "FaradaicCurrent_uA", FaradaicCurrent_uA)
	write(file, "TotalCurrent_uA", TotalCurrent_uA)
	write(file, "TotalCurrent", TotalCurrent)
	write(file, "CapacitiveCurrent_uA", CapacitiveCurrent_uA)
	write(file, "CapacitiveCurrent", CapacitiveCurrent)
end


#-----------------------------------------------------------------------------#
    #-----Constructing the concentration profile matrices

		# Need to rearrange the solution array vector

		# To get a matrix where the columns are the time points and the rows are the concentration values

		# Extract the Pox solution values at all time points. The rows are
		PoxExtracted = solArray[1,1:numPts,:] ;
		YoxExtracted = solArray[1,(numPts+1):(2*numPts),:] ;

		# To extract all of the Pox concentration value points at the first time point
			# Get a column vector. Can transpose to a row vector, but PlotlyJS plots column vectors.

			# To access the concentrations for Pox or Yox at time point 150
			# PoxExtracted[:,150]
			# YoxExtracted[:,150]

		PoxExtractedAtTimeEquals2 = solArray[1,1:numPts,2] ;

		PoxExtractedAtTimeEquals2Transpose = transpose(PoxExtractedAtTimeEquals2) ;

		PoxExtractedAtTimeEquals2Transpose[1,1] ;

	#-----To view plotting related variables


		# allVariables = load("temp/plotData.jld")




end
