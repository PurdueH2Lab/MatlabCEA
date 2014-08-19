MatlabCEA
============================

This Matlab package contains tools for configuring and running
NASA's CEA program.

Installation
---------------------------

### Using SSH or Linux (recommended)
Use an SSH client to log in to a Linux server if you are not on one, or just
open a terminal. To clone this repository into your Matlab folder (assuming
it is at `~/Personal/MATLAB`), enter the following commands:

    cd ~/Personal/MATLAB
    git clone git://github.com/PurdueH2Lab/MatlabCEA.git

Note: if you are a developer (and want to be able to push changes to this repository),
use the following notation instead:

    git clone git@github.com/PurdueH2Lab/MatlabCEA.git
    
To update your version of the code if you have already cloned the repository:

    cd ~/MATLAB/MatlabCEA
    git pull
    
To have the MatlabCEA folder added to your Matlab path by default, add the
following line to your `startup.m` file in your default Matlab path (create
`startup.m` if it does not exist):
    
    addpath(fullfile(fileparts(userpath),'MATLAB','MatlabCEA'));

### Using the GitHub Windows Client
Download [GitHub for Windows](http://windows.github.com) and install it. Click
the Clone in Desktop button on the right
to clone this repository onto your local machine. The repository will be saved 
in your `GitHub` folder by default.

To update your version of the code, use the 'Sync' button in the GitHub program.

To have the MatlabCEA folder added to your Matlab path by default, add the
following line to your `startup.m` file in your default Matlab path (create
`startup.m` if it does not exist):
    
    addpath(fullfile(fileparts(userpath),'GitHub','MatlabCEA'));

### Using the Source Download
Download the [source zip file](https://github.com/PurdueH2Lab/MatlabCEA/archive/master.zip). 
Extract its contents to your default Matlab folder and rename the newly created 
`MatlabCEA-master` folder to `MatlabCEA`.

To update your version of the code, delete the existing `MatlabCEA` folder and
repeat the above procedure.

To have the MatlabCEA folder added to your Matlab path by default, add the
following line to your `startup.m` file in your default Matlab path (create
`startup.m` if it does not exist):
    
    addpath(fullfile(fileparts(userpath),'MATLAB','MatlabCEA'));
    
    
User Guide
=============================

The MatlabCEA package documentation can be viewed in Matlab by typing

    doc CEA
    
which will give you a list of functions and classes that are publicly
accessible in the CEA package.

There are example scripts in the `tests` folder showing how to use the
currently implemented features in MatlabCEA.


Future Development
=============================
This section lists, in no particular order, areas for future development
of this tool.

 * The current version of MatlabCEA uses a Windows CEA executable that is
   more than a decade old. The newest version available from NASA, however
   uses an interactive prompt that makes it difficult to script. There may
   be a way to get around this, or the Fortran source file could be modified
   and re-compiled. This would also allow this to be used in Linux 
   environments.
   
 * Currently, only rocket problems are implemented. On an as-needed basis, 
   some of the other possible problem types (e.g. detonation) could be
   implemented too.
   
 * The output currently only reads the data in the Detn.plt file, although
   there is a lot more information present in Detn.out. The script could be
   modified to read Detn.out if a specific need arose, which would give
   species compositions among other things.
