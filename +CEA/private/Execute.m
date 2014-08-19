function Execute()
    % Run the CEA execuatble for each input file present
    
    % TODO: For parallel execution, the case builder can make N
    % input files ('Detn.inp.1', 'Detn.inp.2', etc). The run function
    % would then check for that, and create N subfolders in the
    % @CEA folder. In each subfolder, it would copy the CEA
    % executable and libraries, and the appropriate Detn input
    % file. Each folder could be started in parallel, then the
    % results from the Detn.out files condensed with a single
    % CEA.ReadResults function.
    % To start multiple, use system('start CEA600.exe') in windows.
    % Alternately, use java with
    % rt = java.lang.Runtime.getRuntime();
    % p = rt.exec('CEA600.exe');
    % p.waitFor();
    % 
    CEAPath = GetPath();
    inpFiles = dir(fullfile(CEAPath,'Detn.inp*'));

    if length(inpFiles) == 1
        CEAPaths = {CEAPath};
    else
        CEAPaths = cell(length(inpFiles),1);
        CEAFiles = {'CEA600.exe','thermo.lib','trans.lib'};
        for i = 1:length(inpFiles)
            CEAPaths{i} = fullfile(CEAPath,sprintf('%02d',i));
            mkdir(CEAPaths{i});
            for f = 1:length(CEAFiles)
                copyfile(fullfile(CEAPath,CEAFiles{f}),...
                         fullfile(CEAPaths{i},CEAFiles{f}));
            end
            copyfile(fullfile(CEAPath,inpFiles(i).name),...
                     fullfile(CEAPaths{i},'Detn.inp'));
        end
    end

    % Parallel execution, start N instances of CEA, one per
    % condition, then wait for them all to complete.
    for p = 1:length(CEAPaths)
        currentPath = cd(CEAPaths{p});
        if ispc
            system('start CEA600.exe');
        elseif isunix
            error('CEA:Execute','UNIX not supported yet');
        else
            error('CEA:Execute','Unrecognized system');
        end
        cd(currentPath);
    end

    % Wait for all CEA runs to complete
    isComplete(size(CEAPaths)) = false;

    while ~all(isComplete)
        % TODO: If CEA crashes this will wait infinitely here. Fix.
        for p = 1:length(CEAPaths)
            isComplete(p) = ...
               exist(fullfile(CEAPaths{p},'Detn.out'),'file') & ...
               exist(fullfile(CEAPaths{p},'Detn.plt'),'file');
        end
        pause(0.25);
    end