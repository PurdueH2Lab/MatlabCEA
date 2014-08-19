function [value, key] = ReadPossibleInputs(inputs,options)

    matches = isfield(inputs,options);
    key = options{1};
    value = NaN;
    
    if sum(matches) >  1
        disp(options)
        error('CEA:ReadPossibleInputs',...
              'Too many inputs of the set above were provided');
    end
    
    if any(matches)
        fldName = options(matches);
        value = inputs.(fldName{1});
    end