function data = ReadRocketOutput(inputs, raw)
    % Parses the output data from a rocket problem taken from the raw array
    %
    % This takes the raw array (for now from the plt file) and formats it
    % into a structure based on the requested outputs.
    
    data(size(inputs)) = struct();
    
    for j = 1:length(inputs)
        for i = 1:length(inputs(j).outputs)
            outputName = inputs(j).outputs{i};
            outputName(outputName=='/') = '';
            outputName(outputName==' ') = '_';

            [name,values] = ExtractData(raw{j}(:,i),outputName);
            data(j).(name) = values;

        end
    end