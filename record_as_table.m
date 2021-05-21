
% ONLY WORKS WHEN 'DataRecordOutputType' in edf read is 'timetable'!!!!
function t_r = record_as_table(t, name, signal_label, record_number)
    info = t{name, 'info'}{1,1};
    data = t{name, 'data'}{1,1};
    
    if signal_label == 'all'
        record = data{record_number,:};
    else
        record = data{record_number,signal_label};
    end
    %initialize output table with tt under first signal label
    count = 1;
    t_r = record{1,count};
    
    while count < length(record)
        count = count + 1;
        t_r = [t_r, record{1,count}];
    end
end