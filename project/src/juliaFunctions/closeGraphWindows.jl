function closeGraphWindows()

    # Use active and close commands from Blink.AtomShell.Window

    if active(initialCVPlotWindow)
        close(initialCVPlotWindow)
    else
    end

    if active(exponentialGridPlotWindow)
        close(exponentialGridPlotWindow)
    else
    end

    if active(dimensionalCompositeSimulatedCV_Plot_Window)
        close(dimensionalCompositeSimulatedCV_Plot_Window)
    else
    end

    if active(dimensionlessCompositeSimulatedCV_Plot_Window)
        close(dimensionlessCompositeSimulatedCV_Plot_Window)
    else
    end

    if active(dimensional_ExpSim_CV_Overlay_Plot_Window)
        close(dimensional_ExpSim_CV_Overlay_Plot_Window)
    else
    end

end
