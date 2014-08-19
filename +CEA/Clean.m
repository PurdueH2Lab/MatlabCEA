function Clean()
    % Remove all generated files from CEA/bin folder
    CEAPath = GetPath();
    files = dir(fullfile(CEAPath,'Detn.*'));
    for f = 1:length(files)
        delete(fullfile(CEAPath,files(f).name));
    end

    i = 1;
    while isdir(fullfile(CEAPath,sprintf('%02d',i)))
        rmdir(fullfile(CEAPath,sprintf('%02d',i)),'s');
        i = i + 1;
    end
