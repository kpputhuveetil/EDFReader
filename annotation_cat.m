function t_note_cat = annotation_cat(t_note)
	unique_times = unique(t_note.Onset);
    for i = 1:length(unique_times)
        str_time = datestr(unique_times(i));
        height(t_note(str_time, :))
    end
    t_note_cat = 0;
end

