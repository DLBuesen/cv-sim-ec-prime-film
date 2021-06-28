
function compositeCVPanelFigure(dimensionalCompositeSimulatedCV_Plot,dimensionlessCompositeSimulatedCV_Plot)


    #-----Prepare the first frame of the panel plot

        window_Width = 1068 ;
        window_Height = 634 ;

        global compositeCVPanel_Plot_Window = Blink.AtomShell.Window(
        Blink.shell(),
        Dict( :width=>window_Width,
              :height=>window_Height,
              :alwaysOnTop=>false,
              :title=>"Composite CVs",
              :resizable=>true,
              :x=>306,
              :y=>349
              );
        async=false)

        # Commands to get the window size and position after manually adjusting. After the optimal settings are determined, they can be set in the script before the window is created.

            # Blink.AtomShell.size(compositeCVPanel_Plot_Window)
            # Blink.AtomShell.position(compositeCVPanel_Plot_Window)

		compositeCVPanel_Plot =  [dimensionalCompositeSimulatedCV_Plot dimensionlessCompositeSimulatedCV_Plot] ;

        Blink.body!(compositeCVPanel_Plot_Window, compositeCVPanel_Plot; fade=false, async=false)

end
