function UpdateLibs()
    % Update lib files from current inp files
    %
    % To get new thermodynamic and transport properties, go to the
    % CEA web site and download the most recent version of the CEA
    % GUI. Copy the 'thermo.inp' and 'trans.inp' files to the
    % '+CEA/bin' folder and call CEA.UpdateLibs(). You may have to
    % delete the header in the provided thermo.inp file so the
    % first line reads 'thermo'
    CEAPath = GetPath();
    CEA.Clean();
    copyfile(fullfile(CEAPath,'thermo.inp'),...
             fullfile(CEAPath,'Detn.inp'));
    Execute();
    copyfile(fullfile(CEAPath,'trans.inp'),...
             fullfile(CEAPath,'Detn.inp'));
    Execute();
    CEA.Clean();