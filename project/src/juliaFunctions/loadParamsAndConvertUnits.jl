using XLSX
using JLD

function loadParamsAndConvertUnits()

    display("Starting to load parameters and convert units")

    # Get experimental data file name

    if isfile("temp/paramsFilePath.jld")
        paramsFilePath = load("temp/paramsFilePath.jld", "paramsFilePath")
    else
        println("Parameter file not yet selected")
    end

#-------
    # Constant

    FarConst_uA = 96485*(1.0e6) ;
          # [=] uA*s*mol-1, Faraday's constant

#-----

    Ptot_mM = XLSX.readdata(paramsFilePath, "ExptlParams", "B2") ;

        if (Ptot_mM==0)
            println("Error: Ptot cannot be set equal to zero")
            Ptot_cm3 = Ptot_mM*(1e-3)*(1e-3) ; # %Conversion to M then to mol*cm-3
        else
            Ptot_cm3 = Ptot_mM*(1e-3)*(1e-3) ; # %Conversion to M then to mol*cm-3
        end

        

    Dp_cm2_s = XLSX.readdata(paramsFilePath, "ExptlParams", "B3") ;

    k0_cm = XLSX.readdata(paramsFilePath, "ExptlParams", "B4") ;

    Alpha = XLSX.readdata(paramsFilePath, "ExptlParams", "B5") ;

#-----

    Ytot_mM = XLSX.readdata(paramsFilePath, "ExptlParams", "B7") ;

        if (Ytot_mM==0)
            Ytot_mM=1e-20 ;
            Ytot_cm3 = Ytot_mM*(1e-3)*(1e-3) ; # %Conversion to M then to mol*cm-3
        else
            Ytot_cm3 = Ytot_mM*(1e-3)*(1e-3) ; # %Conversion to M then to mol*cm-3
        end

        

    Dy_cm2_s = XLSX.readdata(paramsFilePath, "ExptlParams", "B8") ;

    k_py_M = XLSX.readdata(paramsFilePath, "ExptlParams", "B9") ;

        if (k_py_M==0)
            k_py_M=1e-20 ;
            k_py_cm3 = k_py_M*1000 ; # Conversion to mol*cm-3*s-1
        else
            k_py_cm3 = k_py_M*1000 ; # Conversion to mol*cm-3*s-1
        end

        

#-----

    Ei_mV = XLSX.readdata(paramsFilePath, "ExptlParams", "B11") ;

    Es_mV = XLSX.readdata(paramsFilePath, "ExptlParams", "B12") ;

    Ef_mV = XLSX.readdata(paramsFilePath, "ExptlParams", "B13") ;

    Ep0_mV = XLSX.readdata(paramsFilePath, "ExptlParams", "B14") ;

    scanRate_mVps = XLSX.readdata(paramsFilePath, "ExptlParams", "B15") ;

#-----

    filmThickness_um = XLSX.readdata(paramsFilePath, "ExptlParams", "B17") ;
        filmThickness_cm = filmThickness_um*(1e-6)*(1e2) ;

    discArea_cm2 = XLSX.readdata(paramsFilePath, "ExptlParams", "B18") ;

    Temp_C = XLSX.readdata(paramsFilePath, "ExptlParams", "B19") ;
          Temp_K = Temp_C + 273.15 ; # Temperature in Kelvin

    # Solution resistance

    Rs_GOhm = XLSX.readdata(paramsFilePath, "ExptlParams", "B21") ;
        Rs_Ohm = (1e9)*Rs_GOhm ; # [=] Ohm, Ohm = V*A^-1

    # Double layer capacitance

    Cd_pF = XLSX.readdata(paramsFilePath, "ExptlParams", "B22") ;
        Cd_F = Cd_pF*(1e-12) ; # [=] Farads, F = A*s*V^-1
        Cd_uA_mV = Cd_pF ; # [=] uA*s-1*mV-1


 # Save the initial plot variables in a jld file for later use

          jldopen("temp/exptlParams.jld", "w") do file
              write(file, "FarConst_uA", FarConst_uA)
              write(file, "Ptot_cm3", Ptot_cm3)
              write(file, "Dp_cm2_s", Dp_cm2_s)
              write(file, "k0_cm", k0_cm)
              write(file, "Alpha", Alpha)
              write(file, "Ytot_cm3", Ytot_cm3)
              write(file, "Dy_cm2_s", Dy_cm2_s)
              write(file, "k_py_cm3", k_py_cm3)
              write(file, "Ei_mV", Ei_mV)
              write(file, "Es_mV", Es_mV)
              write(file, "Ef_mV", Ef_mV)
              write(file, "Ep0_mV", Ep0_mV)
              write(file, "scanRate_mVps", scanRate_mVps)
              write(file, "filmThickness_cm", filmThickness_cm)
              write(file, "discArea_cm2", discArea_cm2)
              write(file, "Temp_K", Temp_K)
              write(file, "Rs_Ohm", Rs_Ohm)
              write(file, "Cd_F", Cd_F)
              write(file, "Cd_uA_mV", Cd_uA_mV)
          end

          # To view all of the variables in a jld file
          # In the REPL
          # using JLD
          # d = load("temp/exptlParams.jld")

       display("Parameters loaded and units converted")

end
