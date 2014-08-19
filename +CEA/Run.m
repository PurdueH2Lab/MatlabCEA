function data = Run(reactants, varargin)
    % Build the problem input files, execute CEA, and read the results
    %
    % Inputs to the Run function are given in name, argument pairs. For example,
    %
    %    data =  CEA.Run(reactants,                              ...
    %                    'ProblemType','Rocket',                 ...
    %                    'Flow','eq',                            ...
    %                    'Pc',DimVar([500 600 700],'psi'),       ...
    %                    'O/F',1,                                ...
    %                    'Outputs',{'isp','t'});
    %
    % The only input without a name is the first, which is an array of the
    % reactants. The reactants are defined using the CEA.Reactant class.
    %
    % The other possible inputs (names are not case-sensitive) are:
    %
    %   ProblemType:  Required input, only "rocket" is supported currently
    %
    %   Flow:         Required input for rocket problems, can be "equilibrium", 
    %                 "frozen", or "not frozen". Shorthand notation is also
    %                 allowed, so "eq","fz","nfz",etc...
    %
    %   CombLength:   Optional input for rocket problems. Can be "fac" for
    %                 finite area combustor, or "inf" for infinite area (Default).
    %                 You cannot specify "fac" and "fz" together.
    %
    %   Pc:           Required input for rocket problems, this is the chamber
    %                 pressure. It must be a DimVar with pressure units. It can
    %                 be a single value, or an 1D array of values.
    %
    %   O/F:          This is a required input to specify the O/F ratio. It can
    %                 be a single value or a 1D array, but you cannot currently
    %                 set both Pc and O/F as arrays, only one can be an array.
    %
    %   Outputs:      This is a required input. It is a cell array of outputs
    %                 to return. Options are "isp", "T", and others. See the CEA
    %                 manual for a complete list.
    %
    %

    inputs = ReadInputs(varargin);

    % Make sure problem type was provided
    if ~isfield(inputs,'problemtype')
        % TODO: Complete list of problem types in error message
        error('CEA:Run',...
              ['A problem type must be specified. Valid options',...
               ' are "Rocket"']);
    end
    
    % Make sure outputs were specified
    if ~isfield(inputs,'outputs')
        error('CEA:Run',...
              ['A cell array of problem outputs must be provided.']);
    end

    % Configure the input file(s) based on the problem type. Possible
    % problem types are defined on page 12 of RP-1311-P2.pdf
    switch lower(inputs.problemtype)
        case {'rkt','rocket','ro'}
            CheckRequiredInputs(inputs,{'Pc','Flow'});
            inputs.problemtype = 'rkt';

            % TODO: Verify that all species are name, otherwise that both a
            % fuel and oxidizer are specified <- TGV: Is this true for all
            % problem types? If so, deal with in SplitInputs, not the
            % rocket problem case
            
            % TODO: Check for O/F or phi (not both) - determine # of CEA runs
            % required (incl output list too) <- TGV: Is this true for all
            % problem types? If so, deal with in SplitInputs, not the
            % rocket problem case

            % For multiple input files, break 'inputs' into an
            % array of structures here.
            inputs = SplitInputs(reactants, inputs, {'Pc'});

            % Use function handles to set the writer and reader 
            % functions here so we don't need another switch-case 
            % structure later on
            ProblemWriter = @WriteRocketInput;
            DataParser    = @ReadRocketOutput;

        case {'det','detn','detonation'}
            inputs.problemtype = 'det';
            error('CEA:Run','Detonation problems not supported');
			
        case {'tp','pt'}
            inputs.problemtype = 'tp';
            error('CEA:Run','Assigned temperature and pressure problems not supported');
			
        case {'hp','ph'}
            inputs.problemtype = 'hp';
            error('CEA:Run','Assigned enthalpy and pressure problems not supported');
			
        case {'sp','ps'}
            inputs.problemtype = 'sp';
            error('CEA:Run','Assigned entropy and pressure problems not supported');
			
        case {'tv','vt'}
            inputs.problemtype = 'tv';
            error('CEA:Run','Assigned temperature and volume (or density) problems not supported');
			
        case {'uv','vu'}
            inputs.problemtype = 'uv';
            error('CEA:Run','Assigned internal energy and volume (or density) problems not supported');
			
        case {'sv','vs'}
            inputs.problemtype = 'sv';
            error('CEA:Run','Assigned entropy and volume (or density) problems not supported');
			
        case {'sh','shock'}
            inputs.problemtype = 'sh';
            error('CEA:Run','Shock problems not supported');
			
        otherwise
            error('CEA:Run',...
                  'ProblemType type "%s" is not valid.',...
                  inputs.problemtype);
    end

    % Clean bin folder and generate input files
    CEA.Clean();
    CEAPath = GetPath();

    if length(inputs) > 1
        for i = 1:length(inputs)
            str = ProblemWriter(reactants, inputs(i));
            FID = fopen(fullfile(CEAPath,sprintf('Detn.inp.%1d',i)),'w');
            fprintf(FID,'%s',str);
            fclose(FID);
        end
    else
        str = ProblemWriter(reactants, inputs);
        FID = fopen(fullfile(CEAPath,'Detn.inp'),'w');
        fprintf(FID,'%s',str);
        fclose(FID);
    end

    % Run CEA
    Execute();

    % Load the resulting data (reads the plt file(s))
    raw = ReadOutputs();
    data = DataParser(inputs, raw);

    % Clean the CEA generated files out
    CEA.Clean();
