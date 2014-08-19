function raw = ReadOutputs()
    % Read the output file(s), and condense multiple outputs or
    % single outputs to a consistent format
    CEAPath = GetPath();
    inpFiles = dir(fullfile(CEAPath,'Detn.inp*'));

    if length(inpFiles) == 1
        CEAPaths = {CEAPath};
    else
        CEAPaths = cell(length(inpFiles),1);
        for i = 1:length(inpFiles)
            CEAPaths{i} = fullfile(CEAPath,sprintf('%02d',i));
        end
    end

    % Load the raw data from all the Detn.plt files
    % TODO: Also read results from Detn.out file (more results)
    raw = cell(size(CEAPaths));
    for p = 1:length(CEAPaths)
        raw{p} = load(fullfile(CEAPaths{p},'Detn.plt'));
    end
