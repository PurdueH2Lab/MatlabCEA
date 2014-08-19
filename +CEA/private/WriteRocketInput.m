function str = WriteRocketInput(reactants, inputs)

    % Flow options: fac (default is iac), eq, fr or rz, nfr or nfz.
    %
    % fac assumes a finite area combusion chamber. If the area is not
    % given, the default is infinite area combusion assumption, iac.
    %
    % eq assumes equilibrium composition during expansion
    %
    % fr assumes frozen composition during expansion (not available with
    % fac option)
    %
    % nfr is followed by an integer which is the column number for freezing
    % composition. Default is 1 (the combustion point)
    
    switch lower(inputs.flow)
        case {'eq','equilibrium','equil'}
            inputs.flow = 'eq';
        case {'fr','fz','frz','frozen'}
            inputs.flow = 'fr';
        case {'nfr','nfz','not frozen'}
            inputs.flow = 'nfr';
        otherwise
            error('CEA:WriteRocketInput',...
                  'Flow type "%s" is not valid.',...
                  inputs.flow);
    end
    
    if ~isfield(inputs,'comblength')
        inputs.comblength = '';
    else
        switch lower(inputs.comblength)
            case {'fac','finite area combustor'}
                inputs.comblength = 'fac';

            case ''
                % Check: default is inf area combustor, this creates empty
                % string for inpgen. Nothing to do here.

            otherwise
                error('CEA:WriteRocketInput',...
                      'CombLength type "%s" is not valid.',...
                      inputs.comblength);
        end
    end
    
    if strcmp(inputs.comblength,'fac') && strcmp(inputs.flow,'fr')
        error('CEA:WriteRocketInput',...
              ['Combustion length "fac" may not be used with the ',...
              'frozen flow assumption'])
    end
     
    % TODO: Include options have ionized species
    % TODO: Have the nfr allow the integer input (currently uses default of
    % 1)
    
    
    str = sprintf('problem  %s %s %s',...
                  inputs.problemtype,inputs.flow,inputs.comblength);
    
    % TODO: Include optional combustion temperature for rocket problem
    
    % TODO: Consider making total enthalpy of reactant mixture an input for
    % rocket problem type
        
        
    if ~isnan(inputs.mixvalue)
        str = strcat(str,sprintf(' %s=%9.4f \n', ...
                inputs.mixtype,inputs.mixvalue));
    end
    
    if strcmp(inputs.comblength,'fac')
        if ~isfield(inputs,'cr')
            % TODO: per RP-1311-P2 Section 2.4.15, mdot is also allowed
            error('CEA:WriteRocketInput',...
                  'CR is required for problems with CombLength of "fac"');
        end
                
        str = strcat(str,sprintf(' ac/at=%9.4f ',inputs.cr));
    end
    
    % Write Pc values to input file    
    str = strcat(str,sprintf(' p,bar=%9.2f  \n',inputs.pc.Convert('bar')));
    
    % Check for various optional inputs:

    % Pressure ratio, p_inj/p_exit
    if isfield(inputs,'pr')
        str = strcat(str,sprintf(' pi/p=%9.4f \n',inputs.PR));
    end

    % Ae/At (subsonic area ratios)
    if isfield(inputs,'subar')
        str = strcat(str,sprintf(' subar=%9.4f \n',inputs.subar));
    end
        
    % Ae/At (supersonic area ratios)
    if isfield(inputs,'supar')
        str = strcat(str,sprintf(' supar=%9.4f \n',inputs.supar));
    end
    
    str = strcat(str,sprintf(' \n reactants \n reac '));
    
    totalMassKg = 0;
    for i=1:length(reactants)
        totalMassKg = totalMassKg + reactants(i).Quantity.Convert('kg');
    end
    
    for i=1:length(reactants)
        str = strcat(str,sprintf('%s \n', ...
                  reactants(i).writeString(totalMassKg)));
    end
   
    % Include other options e.g. incl
    % TODO: Support this in the future
    
    
    % Write outputs (check total # of outputs)
    
    str = strcat(str,sprintf(' \n output plot trans '));
    for i=1:length(inputs.outputs)
        str = strcat(str,sprintf(' %s',inputs.outputs{i}));
    end
    
    % End input file
    str = strcat(str,sprintf('\n end'));
