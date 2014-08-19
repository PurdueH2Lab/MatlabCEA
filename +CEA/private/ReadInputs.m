function inputs = ReadInputs(args)


    % Load variable inputs to structure

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
        flag(flag=='/') = '';
        flag(flag==' ') = ' ';
        value = args{2*(i-1)+2};
        inputs.(flag) = value;
    end