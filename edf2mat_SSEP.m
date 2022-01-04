clear all; clc;
%% READ IN DATA FROM A GIVEN SET OF EDF CASE FILES
% change the data and code paths before running!
% TODO: change how these paths are captured, maybe define them in a text
% file? list the file in .gitignore. or cmd args?
codePath = pwd;
addpath(codePath);
addpath(fullfile(codePath,'util'));
case_date = '2021-03-30 07-15-04'
dataPath = ['C:\Users\kavya\Documents\MATLAB\Projects\EDFReader\', case_date];
savePath = 'C:\Users\kavya\Documents\MATLAB\sen_des_data\unpacked\';

% unpacks data from all available EDF files on the dataPath
% data is returned exactly as unpacked (timetables) in a table with rows
% for each file
% this might take some time to run since it has to read in all of the files!
raw_from_EDF = read_case_data(dataPath, 'timetable');
raw_from_EDF

%%
% we can also read the data in as vectors instead of as a timetable. take a
% look at output and compare it to that above. The raw_from_EDF (timetable)
% version is used going forward, this is just should to demonstrate that 
% the option is available - there may be cases where this is desirable
%
% i think that switching to doing this data reformating in vector form
% instead of timetable would significantly decrease processing time but
% since we won't be working with huge amounts of case data, I don't think
% optimization is a priority <- maybe something to revist in the future

% vector_example = read_case_data(dataPath, 'vector');


%% CREATING A CONSOLIDATED, CONTINUOUS TIMETABLE OF THE EEG DATA
%% Preallocating the timetable (helps reduce processing time for next step)
% collect all the information needed to create an empty timetable that
% is appropriately sized to all the EEG data

ssep_stim_sites = {'L BAER', 'L POST TIB', 'L TCMEP', 'L ULNAR', ...
              'R BAER', 'R POST TIB', 'R TCMEP', 'R ULNAR'};
ssep_tables = cell(length(ssep_stim_sites), 1);
for site = 1:length(ssep_stim_sites)
    ssep_stim_sites{site};
    num_records = raw_from_EDF.info{ssep_stim_sites{site}}.NumDataRecords;
    rows_per_record = raw_from_EDF.info{ssep_stim_sites{site}}.NumSamples(1);
    num_rows = num_records*rows_per_record;

    num_columns = raw_from_EDF.info{ssep_stim_sites{site}}.NumSignals;
    column_labels = raw_from_EDF.data{ssep_stim_sites{site}}.Properties.VariableNames;
    
    var_types = {};
    var_types(1:num_columns) = {'double'};
    row_times = get_all_record_times(raw_from_EDF, ssep_stim_sites{site});
    

    concat_data = timetable('Size', [num_rows, num_columns], ...
                            'RowTimes', row_times, ...
                            'VariableTypes', var_types, ...
                            'VariableName', column_labels);
    ssep_tables{site} = concat_data;
end

%% Concatenate all time records and retime the data
% loop through all the records, concatenate each one to create a
% consolidated timetable of the EEG data
% this may take a long time to run!
for site = 1:length(ssep_stim_sites)
    ssep_stim_sites{site}
    num_records = raw_from_EDF.info{ssep_stim_sites{site}}.NumDataRecords
    rows_per_record = raw_from_EDF.info{ssep_stim_sites{site}}.NumSamples(1)
    for i = 0:num_records-1
        start_ind = i*rows_per_record+1;
        stop_ind = start_ind+rows_per_record-1;
        ssep_tables{site,1}(start_ind: stop_ind,:) = record_as_table(raw_from_EDF, ssep_stim_sites{site}, 'all', i+1);
    end
end

% retime the timetable of all the EEG data so that that any discontinuities
% (where there are irregularites in spacing)are filled with NaN values
% EEG_retimed = retime(concat_EEG_data,'regular','fillwithmissing','SampleRate',128);

%% Replace record representation of EEG data with this new continous, retimed representation
allEDFs = raw_from_EDF

for site = 1:length(ssep_stim_sites)
    ssep_stim_sites{site}
    allEDFs.data{ssep_stim_sites{site}} = ssep_tables{site}
end

%% Save processed EDF data so that we don't have to do this again lol
case_date_split = split(case_date)
filename = ['ADT_', case_date_split{1}, '_eegONLY', '.mat']
cd(savePath)
save(filename, 'allEDFs')

%% NOTES
% I think we will eventually want to perform steps to completely unpack
% all the other data files as was done here for EEG for, but its unclear
% what all of these steps will look like at this point. 

% We will probably want to create functions that unpack each type of file
% (EEG, SSEP) and then chain them together in another script.


