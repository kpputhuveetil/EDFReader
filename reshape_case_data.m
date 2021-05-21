function t_reshape = reshape_case_data(t)
    row_names = t.Properties.RowNames;
    data = {}; annotations = {}; info = {};
    for i = 1:length(row_names)
        temp = {};
        temp = all_records_as_table(t, row_names{i},'all');
%         try
%             temp = all_records_as_table(t, row_names{i},'all');
%         end
        
        
        if height(temp) == 0
            warning(['duplicated column names for row: ' row_names{i}])
            data{i,1} = NaN;
            annotations{i,1} = NaN;
            info{i,1} = NaN;
        else
            data{i,1} = temp;
            annotations{i,1} = t.annotations{i};
            info{i,1} = t.info{i};
        end
      
    end
    %t_reshape = 0;
    t_reshape = table(data, annotations, info, 'RowNames', row_names);
end

