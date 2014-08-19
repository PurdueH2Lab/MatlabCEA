function outputStruct = InitializeOptionalInputs(inpStruct, optInps)
    % Check if any optional arguments are missing from input
    % structure, and initialize them to an empty string if they
    % are not present
    outputStruct = inpStruct;
    for i = 1:length(optInps)
        if ~isfield(inpStruct,optInps{i})
            outputStruct.(lower(optInps{i})) = '';
        end
    end