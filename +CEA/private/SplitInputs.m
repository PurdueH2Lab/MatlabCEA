function inputs = SplitInputs(reactants, inputs, splitFlds)
    if ~all(strcmpi('na',{reactants.Type}))
        % Not all are 'name', require fuel and ox and ratio arg
        
        while true
            [value,key] = ReadPossibleInputs(inputs,{'o/f','of','of_ratio','ofratio'});
            if ~isnan(value), break, end
        
            [value,key] = ReadPossibleInputs(inputs,{'f/o','fo','fa','fuelox','fuelair'});
            if ~isnan(value), break, end
        
            [value,key] = ReadPossibleInputs(inputs,{'phi','eqratio','eq_ratio'});
            if ~isnan(value), break, end
            
            [value,key] = ReadPossibleInputs(inputs,{'r'});
            if ~isnan(value), break, end
            
            fprintf(['Mixture values must be specified if input reactants\n',...
                     'are set as fuels and oxidants. Valid entries are:\n']);
            
            fprintf('   %%f  Percent fuel by weight\n');
            fprintf('  F/O  Fuel to oxidant weight ratio\n');
            fprintf('  O/F  Oxidant to fuel weight ratio\n');
            fprintf('  phi  Equivalence ratio (fuel-to-ox weight ratio)\n');
            fprintf('  r    Chemical equivalence ratios in terms of valences\n');
            
            error('CEA:SplitInputs','Missing mixture values');
        end
        
        inputs.mixtype = key;
        inputs.mixvalue = value;
    else
        inputs.mixtype = NaN;
        inputs.mixvalue = NaN;
    end
    
    % Set splitFlds to empty if not provided
    if ~exist('splitFlds','var')
        splitFlds = {};
    end
    
    % Now split inputs structure based on the following splittable
    % fields (only 1 split permitted for now):
    %   mixvalue (if provided)
    %   splitFlds
    if ~isnan(inputs.mixvalue)
        splitFlds = ['mixvalue', lower(splitFlds)];
    else
        splitFlds = lower(splitFlds);
    end

    if ~isempty(splitFlds)
        fldLengths = cellfun(@(x) length(inputs.(x)),splitFlds);
        splitIDs = fldLengths>1;
        nSplits = sum(splitIDs);

        if nSplits > 1
            error('CEA:SplitInputs',...
                  'You can only run one vector of inputs at a time');
        elseif nSplits == 1
            splitFldName = splitFlds(splitIDs);
            inputs.splitfld = splitFldName{1};
            LSplit = fldLengths(splitIDs);
            
            % TODO: Split into chunks of 8 or something greater than 1
            % condition per input structure
            splitArray = inputs.(inputs.splitfld);
            inputs(1:LSplit) = inputs;

            for i = 1:length(inputs)
                inputs(i).(inputs.splitfld) = splitArray(i);
            end
        end
    end
    
    
    
    

        

