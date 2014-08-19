function CheckRequiredInputs(inpStruct, reqInps)
    % Check that all required inputs are present in input
    % structure, returning an error and list of requirements if any
    % are missing.
    for i = 1:length(reqInps)
        if ~isfield(inpStruct,lower(reqInps{i}))
            fprintf('Problems of type "%s" require the following inputs:\n',...
                    inpStruct.problemtype);

            for j = 1:length(reqInps)
                fprintf('  %s',reqInps{j});
                if i == j
                    fprintf('  <-- Missing');
                end
                fprintf('\n');
            end

            error('CEA:CheckRequiredInputs',...
                  'Required input "%s" is missing',reqInps{i});
        end
    end