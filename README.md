# Introduction
- Cyclic voltammetry simulation of a redox-active film for a given set of dimensional parameters (concentrations, kinetic rate constant, etc) for an EC' mechanism.
- The app is used in the course "Electrobiotechnology", taught by Prof. Dr. Nicolas Plumeré in the Professorship for Electrobiotechnology at the Technical University of Munich, Campus Straubing (TUMCS). A link to the group webpage can be found [here](https://ebt.cs.tum.de/?lang=en). The app is freely available and not restricted only for education and research purposes.
- Docker is used here because our group is currently exploring the possibility of deploying research apps using this platform. An in-depth presentation on this topic can be found [here](https://www.youtube.com/watch?v=L4nqky8qGm8).

# System Description Highlights
- The redox mediator and catalyst is immobilized in the film. The reactant can diffuse freely within the film from the surrounding solution.
- EC' mechanism in which the forward sweep is a reduction.
- Electron transfer at the electrode surface is characterized by Butler-Volmer kinetics.
- A complete description of the system can be found in the SI of the following [paper](https://www.nature.com/articles/s41467-020-14673-7). It is closely related to two other redox active film models, which can be found [here](https://pubs.acs.org/doi/abs/10.1021/acs.jpcc.5b02376) and [here](https://chemistry-europe.onlinelibrary.wiley.com/doi/abs/10.1002/celc.201500217). This app can be used to replicate CVs from the model in the first paper, because it shares the assumption of constant substrate in the surrounding solution which does not experience depletion. The second model applies to the situation where substrate is uniformally depleted, which corresponds to a different experimental situation. Therefore, the model here is closely related to but not equal to the second one.
- Can include capacitance contributions to the simulated signal by entering resistance and capacitance parameter values.
- Although this app is centered on the application of the EC' reaction within a redox active film, for sufficiently large and arbitrarily chosen film thickness values (i.e. 1 cm), one can obtain the result which corresponds to the EC' mechanism in homogeneous solution. Conversely, if one uses a sufficiently small and arbitrarily chosen film thickness (i.e. 1 nm), the result obtained can correspond to the EC' mechanism in an adsorbed monolayer. In this case, the equivalent adsorbed monolayer coverage would be equal to the concentration multiplied by the film thickness.
- Some of the plots which are presented in terms of scaled parameters. However, plots of dimensional current are provided so the use of scaled quantities is not required in order to obtain satisfactory agreement between an imported experimental CV and the simulated CV based on the given set of dimensional parameters. Time is referenced to the time required for a LSV in which the potential is swept +/- 200 mV around the standard potential of the redox couple. Concentration is referenced to its total value regardless of redox form. Space is referenced to the film thickness. Potential difference is referenced to (RT/nF), and current is referenced to the peak current that would be obtained for a reversible wave under semi-infinite conditions (i.e. dimensionless peak current = 0.4463 for a reversible wave).

# App Demonstration Videos
- Demonstration videos in which the app is running on a windows 10 operating system are available.
- A video in which an overview of the app is given can be found [here](https://vimeo.com/570681480).
- A video showing the installation, verification, and the uninstallation of the app can be found [here](https://vimeo.com/570627294) to give a visual impression of what to expect in the process, but it will still be necessary to read the provided documentation.

# Results Obtained
- A plot of the spatial grid used for solving can also be obtained for purposes of tuning the solving parameters in order to gain satisfactory accuracy without sacrificing speed.
- An overlay plot of an imported experimental CV current signal with the simulated CV. This plot is dimensional.
- A composite overlay plot showing the contributions of faradaic and non-faradaic current (i.e. capacitive current). This is a panel figure with the dimensional and dimensionless versions next to each other.
- An animated video comprised of the simulated CV on the left side and an overlay plot of the concentration profiles on the right side. This is saved as an mp4 file in the user folder (i.e. ubuntu1804 or windows10). This is a plot of dimensionless current and concentrations.
- Current-potential data (dimensional and dimensionless) for the simulated CV, exported to an Excel file in the user folder (i.e. ubuntu1804 or windows10).

# Typical Workflow
- Data from the experimental CV is copied/pasted into its respective tab of the parameter input file.
- Dimensional parameters (i.e. experimetal data, concentration, scan-rate, etc.) are copied/pasted into its respective tabs of the parameter input file.
- Options related to plots and the solver are indicated in its respective tab of the parameter input file.
- If applicable, start up prerequiste supporting software (i.e. Docker, XLaunch).
- When starting the app, the location of the parameter file must be confirmed. This only needs to be done once per session.

# Operating Systems and Installation
- The app can be run from Windows 10 or from Ubuntu 18.04 LTS.
- The core of the simulation is carried out in a common Docker image, which is used by either the windows 10 or ubuntu 18.04 host operating system. Therefore, installation of docker is required. It is also necessary to register for a free docker account.
- The docker image requires use of the host screen infrastructure to show the simple graphical user interface menu and the plots on the screen. Therefore, on Windows 10 systems, installation of XLaunch is required. However, this is not required on Linux 18.04 systems.
- It is recommended that the installation of the prerequisites for this app (Docker and xLaunch) be performed by IT-support personnel or by advanced PC users (i.e. comfortable going into bios to change settings, using the command line, resolution of system-specific issues that might arise via google search and some troubleshooting).
- Installation and use of the app itself does not require any specialized computer knowledge once the prerequisites are fulfulled.
- Additional installation instructions which are operating system specific can be found within this project for [Windows 10](https://github.com/DLBuesen/cv-sim-ec-prime-film/tree/main/project/windows10) and for [Ubuntu 18.04](https://github.com/DLBuesen/cv-sim-ec-prime-film/tree/main/project/ubuntu1804).

# License
- This app was made using free open source software (Julia programming language). Therefore, usage is not restricted to teaching and research purposes.


