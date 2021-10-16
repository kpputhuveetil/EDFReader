
% ONLY WORKS WHEN 'DataRecordOutputType' in edf read is 'timetable'!!!!
function t_r = record_as_table(t, name, signal_label, record_number)
    data = t.data{name};
    
    if signal_label == 'all'
        record = data{record_number,:};
        column_labels = data.Properties.VariableNames;
    else
        record = data{record_number,signal_label};
        column_labels = signal_label;
    end
    
    row_times = record{1}.Time;
    num_rows = height(row_times);
    num_columns = length(record);
    var_types(1:num_columns) = {'double'};
  
    %initialize output table with tt under first signal label
    count = 1;
    t_r = timetable('Size', [num_rows, num_columns], ...
                    'RowTimes', row_times, ...
                    'VariableTypes', var_types, ...
                    'VariableName', column_labels);
   % t_r = record{1,count};
    
    for i = 1:num_columns
        t_r(:,i) = record{1,i};
    end
end