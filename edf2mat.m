addpath('C:\MATLAB\EDFReader')
dataPath = 'C:\MATLAB\EDFReader\2021-03-30 07-15-04';
t = read_case_data(dataPath)

%%
% [time, y] = record_as_vector(t, 'EEG', 'all', 1)
% plot(time,y)

%%
t_r1 = record_as_table(t, 'EEG', 'all', 1);
t_r2 = record_as_table(t, 'EEG', 'all', 2);
stackedplot([t_r1; t_r2])

%%
t_allrecords = all_records_as_table(t, 'EEG', 'all');

%%
t_reshape = reshape_case_data(t)
%%
figure()
stackedplot(t_reshape{'EEG','data'}{1,1})
figure()
stackedplot(t_reshape{'EEG','data'}{1,1}(3000:4000, :))

%%
t_note = t_reshape{'L POST TIB','annotations'}{1,1};unique_times = unique(t_note.Onset)
t_note_cat = annotation_cat(t_note)
%%

% t('EEG', 'data'){1,1}
% 
% %Open data folder and load in all the files that end in .dat
% %If you don't want them all then you can change the 'files' struct
% 
% % t.EEGFp1_Cp3
% % data = [];
% 
% % for i = 1:length(t.EEGFp1_Cp3)
% %     data = [data;t.EEGFp1_Cp3{i}];
% % end
% 
% t{'EEG', 'data'}
% 
% info = t{'EEG', 'info'}{1,1}
% fs = info.NumSamples/seconds(info.DataRecordDuration)
% x = (0:info.NumSamples(1)-1)/fs(1)


% ONLY WORKS WHEN 'DataRecordOutputType' in edf read is 'vector'!!!!
% t: table
% name: char vector
% signal_label: char vector; for multiple signals, input cell array of label names; for all, pass 'all'
% record_number: int
function [time, y] = record_as_vector(t, name, signal_label, record_number)
    info = t{name, 'info'}{1,1}
    data = t{name, 'data'}{1,1}
    fs = info.NumSamples/seconds(info.DataRecordDuration)
    
    time = ((0:info.NumSamples(1)-1)/fs(1))'
    
    if signal_label == 'all'
        y = data{1, :}
    else
        y = data{1, record_number}
    end
    y = cell2mat(y)
end