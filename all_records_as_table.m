function t_allrecords = all_records_as_table(t, name, signal_label)
    count = 1;
    t_allrecords = record_as_table(t, name, signal_label, count);
    while count < height(t{name, 'data'}{1,1})
        count = count + 1;
        t_allrecords = [t_allrecords; record_as_table(t, name, signal_label, count)];
    end

end
