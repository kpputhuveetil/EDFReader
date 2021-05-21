function t = read_case_data(dataPath)
    cd(dataPath);
    all_files = dir( "*.edf" );
    name = {}; data = {}; info = {};
    for i = 1:length(all_files)
        file = all_files(i).name;
        name = [name; {file(1:end-4)}];
        [data{i,1}, annotations{i,1}] = edfread(file, ...
                                                'DataRecordOutputType', 'timetable', ...
                                                'TimeOutputType','datetime')
        info = [info; {edfinfo(file)}];
    end
    
    t = table(data, annotations, info, 'RowNames', name);
end
