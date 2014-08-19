function CEAPath = GetPath()
    % Determine the path to the CEA package folder
    CEAPath = fullfile(fileparts(fileparts(which('CEA.Reactant'))),'bin');