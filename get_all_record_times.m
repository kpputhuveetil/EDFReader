function all_times = get_all_record_times(t, name)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

num_records = t.info{name}.NumDataRecords;
rows_per_record = t.info{name}.NumSamples(1);
num_rows = num_records*rows_per_record;

all_times = datetime(zeros(num_rows,3));

for i = 0:num_records-1
    start_ind = i*rows_per_record+1;
    stop_ind = start_ind+rows_per_record-1;
    all_times(start_ind: stop_ind) = t.data{name}{i+1,1}{1}.Time;
end
end

