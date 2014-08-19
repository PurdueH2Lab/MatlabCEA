classdef Reactant
    % The CEA reactant class, which is used to create reactants
    
    % Set dependent (calculated) properties
    properties (SetAccess = protected)
        Formula
        Type
        Temperature
        Quantity
        Enthalpy
    end
    
    properties (Constant, Access = private)
        % pTable - This is the periodic table
        pTable = struct...
        (...
            'E',5.4858e-4,  ...  Electron
            'H',1.0079,     ...  1
            'D',2.014,      ...  1
            'He',4.0026,    ...  2
            'Li',6.941,     ...  3
            'Be',9.01218,   ...  4
            'B',10.81,      ...  5
            'C',12.011,     ...  6
            'N',14.007,     ...  7
            'O',15.999,     ...  8
            'F',18.998,     ...  9
            'Ne',20.180,    ...  10
            'Na',22.98977,  ...  11
            'Mg',24.305,    ...  12
            'Al',26.98154,  ...  13
            'Si',28.0855,   ...  14
            'P',30.974,     ...  15
            'S',32.06,      ...  16
            'Cl',34.45,     ...  17
            'Ar',39.948,    ...  18
            'K',39.0983,    ...  19
            'Ca',40.078,    ...  20
            'Sc',44.9559,   ...  21
            'Ti',47.867,    ...  22
            'V',50.9415,    ...  23
            'Cr',51.996,    ...  24
            'Mn',54.938,    ...  25
            'Fe',55.847,    ...  26
            'Co',58.9332,   ...  27
            'Ni',58.693,    ...  28
            'Cu',63.546,    ...  29
            'Zn',65.41,     ...  30
            'Ga',69.723,    ...  31
            'Ge',72.64,     ...  32
            'As',74.922,    ...  33
            'Se',78.96,     ...  34
            'Br',79.904,    ...  35
            'Kr',83.798,    ...  36
            'Rb',85.468,    ...  37
            'Sr',87.62,     ...  38
            'Y',88.9059,    ...  39
            'Zr',91.22,     ...  40
            'Nb',92.9064,   ...  41
            'Mo',95.94,     ...  42
            'Tc',97.91,     ...  43
            'Ru',101.07,    ...  44
            'Rh',102.9055,  ...  45
            'Pd',106.4,     ...  46
            'Ag',107.868,   ...  47
            'Cd',112.41,    ...  48
            'In',114.82,    ...  49
            'Sn',118.69,    ...  50
            'Sb',121.76,    ...  51
            'Te',127.60,    ...  52
            'I',126.90,     ...  53
            'Xe',131.29,    ...  54
            'Cs',132.91,    ...  55
            'Ba',139.33,    ...  56
            'La',138.9055,  ...  57
            'Ce',140.12,    ...  58
            'Pr',140.91,    ...  59
            'Nd',144.24,    ...  60
            'Pm',144.91,    ...  61
            'Sm',150.36,    ...  62
            'Eu',151.96,    ...  63
            'Gd',157.25,    ...  64
            'Tb',158.93,    ...  65
            'Dy',162.50,    ...  66
            'Ho',164.93,    ...  67
            'Er',167.26,    ...  68
            'Tm',168.93,    ...  69
            'Yb',173.05,    ...  70
            'Lu',174.97,    ...  71
            'Hf',178.49,    ...  72
            'Ta',180.95,    ...  73
            'W',183.84,     ...  74
            'Re',186.21,    ...  75
            'Os',190.23,    ...  76
            'Ir',192.22,    ...  77
            'Pt',195.08,    ...  78
            'Au',196.97,    ...  79
            'Hg',200.59,    ...  80
            'Tl',204.38,    ...  81
            'Pb',207.2,     ...  82
            ...
            'Rn',222.02,    ...  86
            ...
            'Th',232.04,    ...  90
            'Pa',231.0359,  ...  91
            'U',238.03      ...  92
         );
        
    end
    
    methods (Static = true)
        function inputs = read_args(args, reqInps)
            
            % Define structure of inputs with default values, or just an empty
            % structure to be filled with whatever was entered
            inputs = struct();

            % Verify that there are an even number of args
            if mod(size(args,2),2)
                error('CEA:ReadInputs',...
                      'Inputs must be valid name-value pairs');
            else
                nargs = size(args,2)/2;
            end

            % Put input arguments into structure
            %  Note: force all strings to lower case to inputs are not case
            %  sensitive
            for i = 1:nargs
                flag = lower(args{2*(i-1)+1});
                value = args{2*(i-1)+2};
                inputs.(flag) = value;
            end
            
            for i = 1:length(reqInps)
                if ~isfield(inputs,lower(reqInps{i}))
                    fprintf('Reactants require the following inputs:\n');

                    for j = 1:length(reqInps)
                        fprintf('  %s',reqInps{j});
                        if i == j
                            fprintf('  <-- Missing');
                        end
                        fprintf('\n');
                    end

                    error('Reactant:read_args',...
                          'Required input "%s" is missing',reqInps{i});
                end
            end
            
        end
        
        function CEAPath = CEAPath()
            % Determine the path to the CEA package folder
            CEAPath = fullfile(fileparts(fileparts(which('CEA.Reactant'))),'bin');
        end
        
        function [inINP,W,formula] = in_INP(formula)
            % Check whether the specie is in the INP file, get the molar
            % mass, and clean the formula name if it is not in the INP file
            
            CEAPath = CEA.Reactant.CEAPath();
            inpFile = fullfile(CEAPath,'THERMO.INP');
            
            fid = fopen(inpFile,'r');

            tline = fgetl(fid);
            inINP = false;
            W = 0;
            
            while ischar(tline)
                if inINP
                    eList = tline(11:50);
                    
                    for i = 1:5 % max elements per line in INP is 5
                        eStr = upper(strtrim(eList(1:2)));
                        eNum = str2double(strtrim(eList(3:8)));
                        if isempty(eStr)
                            break;
                        end
                        if length(eStr) > 1
                            eStr(2:end) = lower(eStr(2:end));
                        end
                        if isfield(CEA.Reactant.pTable,eStr)
                            eW = CEA.Reactant.pTable.(eStr);
                        else
                            error('Reactant:in_INP',...
                                 'Element "%s" missing from periodic table',...
                                 eStr);
                        end
                        W = W + eW*eNum;
                        eList = eList(9:end);
                    end
                    W = DimVar(W,'g/mol');
                    return
                end
                if tline(1) ~= ' ' && tline(1) ~= '-'
                    specieName = strtrim(tline(1:18));
                    if ~any(strcmpi(specieName,{'thermo','end reactants','end products'}));   
                        inINP = strcmpi(formula,specieName);
                    end
                end
                tline = fgetl(fid);
            end

            fclose(fid);
            
            %If it gets here, formula was not found, attempt to read it
            str = formula;
            
            % If it is space-separated, element cases may be wrong, fix
            % here first (e.g. convert 'CO' to 'Co' rather than carbon
            % and oxygen
            if ~isempty(strfind(str,' '))
                [elements,first,last] = regexp(str,'[A-Z][A-Z]?','match');
                for e = 1:length(elements)
                    if length(elements{e}) > 1
                        elements{e}(2:end) = lower(elements{e}(2:end));
                        str(first(e):last(e)) = elements{e};
                    end
                end
                str(str==' ') = '';
            end
            
            %Parse the string to get its chemical composition
            [elements,first,last] = regexp(str,'[A-Z][a-z]?','match');
                                   
            first = [first length(str)+1];
            Ne = length(elements);
            formula = ''; % Rebuild CEA formatted formula string
            for e = 1 : Ne
                if isfield(CEA.Reactant.pTable,elements{e})

                    % Find the numbers following the element
                    nd = last(e)+1 : first(e+1)-1;
                    
                    formula = [formula, upper(elements{e}), ' ']; %#ok<AGROW>
                    
                    if isempty(nd)
                        N = 1;
                        formula = [formula, '1 '];  %#ok<AGROW>
                    else
                        N = str2double(str(nd));
                        formula = [formula, str(nd), ' '];  %#ok<AGROW>
                    end
                    
                    
                    W = W + N*CEA.Reactant.pTable.(elements{e});
                else
                    error('Reactant:in_INP',...
                          'Unable to interpret "%s" from string "%s"',...
                           elements{e},str);
                end
            end
            formula = strtrim(formula);
            W = DimVar(W,'g/mol');
        end

    end
    
    methods
        %------------------------------------------------------------------
        function reac = Reactant(formula, varargin)

            % Check if specie is in the INP file, and get its molar mass
            [inINP,W,reac.Formula] = CEA.Reactant.in_INP(formula);

            if inINP
                requiredInputs = {'Q','T'};
            else
                % TODO: does formula have to be formatted a certain way
                % if it is not in thermo.inp?
                requiredInputs = {'Q','T','E'};
            end
            
            % Read the varargs and make sure all inputs are present
            as = CEA.Reactant.read_args(varargin, requiredInputs);
            
            % Set type to name if not provided
            if ~isfield(as,'type')
                as.type = 'name';
            end
            
            % Interpret the Type argument based on its first letter
            types = struct('o','ox','f','fu','n','na');
            if isfield(types,lower(as.type(1)))
                reac.Type = types.(lower(as.type(1)));
            else
                error('Reactant:Reactant',...
                      ['Species type "%s" is not valid. Please use',...
                      ' either fuel, oxidizer, or name as Type'],...
                      as.type);
            end
            
            % Load the other inputs and test their units and class types
            try
                if ~isa(as.t,'DimVar')
                    error('dummy error');
                end
                as.t.Convert('K');
            catch e
                error('Reactant:Temperature',...
                      ['Temperature argument must be a DimVar with a',...
                      ' valid temperature unit.']);
            end
            reac.Temperature = as.t;
            
            
            try
                if ~isa(as.q,'DimVar')
                    error('dummy error');
                end
                as.q.Convert('kg');
                Q = as.q;
            catch e %#ok<NASGU>
                try
                    if ~isa(as.q,'DimVar')
                        error('dummy error');
                    end
                    as.q.Convert('mol');
                    Q = as.q*W;
                catch e
                    error('Reactant:Quantity',...
                          ['Quantity argument must be a DimVar',...
                          ' with a valid mass or molar unit.']);
                end
            end
            reac.Quantity = Q;
            
            if isfield(as,'e')
                try
                    if ~isa(as.e,'DimVar')
                        error('dummy error');
                    end
                    as.e.Convert('J/mol');
                catch e
                    error('Reactant:Enthalpy',...
                          ['Enthalpy argument must be a DimVar',...
                          ' with a valid energy per mole unit.']);
                end
                reac.Enthalpy = as.e;
            end
        end
        
        % Define how the class is displayed
        %------------------------------------------------------------------
        function disp(self)
            disp(self.Formula);
        end
        
        % -----------------------------------------------------------------
        function str = writeString(self,totalMassKg)
            % Generate a string for CEA for this specie
            if ~isempty(self.Enthalpy)
                enthalpy_string = [' h,j/mol=' num2str(self.Enthalpy.Convert('J/mol'))];
            else
                enthalpy_string='';
            end
            str = [' ' self.Type ' = ' self.Formula enthalpy_string ' w%=' ...
                   num2str(self.Quantity.Convert('kg')/totalMassKg) ' t(k)=' ...
                   num2str(self.Temperature.Convert('K'))];
        end
    end

end








