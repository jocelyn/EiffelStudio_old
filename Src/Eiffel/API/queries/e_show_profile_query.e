note

	description:
		"Class to show the output of the profile query."
	legal: "See notice at end of class."
	status: "See notice at end of class.";
	date: "$Date$";
	revision: "Revision: $"

class E_SHOW_PROFILE_QUERY

inherit
	E_OUTPUT_CMD
		rename
			make as e_cmd_make,
			work as execute
		redefine
			executable, execute
		end

	E_PROFILER_CONSTANTS

create
	make,
	make_simple

feature -- Initialization

	make (a_text_formatter: TEXT_FORMATTER;
		profiler_query: PROFILER_QUERY;
		profiler_options: PROFILER_OPTIONS)
			-- Create the object and use `new_st'
			-- for output.
		require
			a_text_formatter_not_void: a_text_formatter /= Void;
			profiler_query_not_void: profiler_query /= Void;
			profiler_options_not_void: profiler_options /= Void
		do
			text_formatter := a_text_formatter;
			prof_query := profiler_query;
			prof_options := profiler_options.twin
			create expanded_filenames.make
		end;

	make_simple (profiler_query: PROFILER_QUERY;
		profiler_options: PROFILER_OPTIONS)
			-- Create the object without any output generated.
			-- Output may be generated by querying `profiler_query'.
		require
			profiler_query_not_void: profiler_query /= Void;
			profiler_options_not_void: profiler_options /= Void
		do
			prof_query := profiler_query;
			prof_options := profiler_options.twin
			create expanded_filenames.make
		end;

feature -- Access

	executable: BOOLEAN
			-- Is Current executable?
		do
			Result := prof_query /= Void and then
					prof_options /= Void
		end;

feature -- Result computation

	execute
			-- Computes results of the query.
		do
			from
				expand_columnnames;
				expand_filenames;
				expanded_filenames.start
debug("SHOW_PROF_QUERY")
	io.error.put_string ("About to `execute'%Nexpanded_filenames.after: ");
	io.error.put_boolean (expanded_filenames.after);
	io.error.put_new_line
end;
			until
				expanded_filenames.after
			loop
				read_specified_file;
				if profile_information /= Void then
					print_header;
					generate_filters;
					print_result
				end;
				expanded_filenames.forth;
			end
		end;

feature -- Last output

	last_output: PROFILE_INFORMATION
		do
			Result := int_last_output
		end;

	set_last_output (new_output: PROFILE_INFORMATION)
			-- Sets `new_output' to `last_output'.
		require
			new_output_not_void: new_output /= Void
		do
			int_last_output := new_output
		ensure
			last_output_set: last_output = new_output
		end;

feature {NONE} -- Implementation

	read_specified_file
			-- Retrieves an object from storage.
		local
			retried: BOOLEAN;
			current_item: STRING_32;
			profile_file: RAW_FILE;
			line_str: STRING
		do
			if not retried then
				current_item := expanded_filenames.item;
				if not current_item.same_string_general ("last_output") then
					create profile_file.make_with_name (current_item)
					if profile_file.exists and then profile_file.is_readable then
						profile_file.open_read
						profile_information ?= profile_file.retrieved
						profile_file.close
					end
					if profile_information /= Void then
						if text_formatter /= Void then
							text_formatter.add (current_item);
							text_formatter.add_new_line;
							create line_str.make (current_item.count);
							line_str.fill_character ('-');
							text_formatter.add (line_str);
							text_formatter.add_new_line;
							text_formatter.add_new_line
						end
					else
					end
				else
					if text_formatter /= Void then
						text_formatter.add ("last output");
						text_formatter.add_new_line;
						text_formatter.add ("-----------");
						text_formatter.add_new_line;
						text_formatter.add_new_line;
						profile_information := int_last_output
					end
				end
			else
				if text_formatter /= Void then
					text_formatter.add ("Error during retrieval of: ");
					text_formatter.add (current_item);
					text_formatter.add_new_line
				end
			end
		rescue
			retried := true;
			retry
		end;

	expand_columnnames
			-- Expands `all' to all posible columnnames
		do
			if prof_options.output_names.is_empty then
				prof_options.output_names.force (profiler_percentage, 1);
				prof_options.output_names.force (profiler_self, 2);
				prof_options.output_names.force (profiler_descendants, 3);
				prof_options.output_names.force (profiler_total, 4);
				prof_options.output_names.force (profiler_calls, 5);
				prof_options.output_names.force (profiler_feature_name, 6)
			end
		end;

	expand_filenames
			-- Expands wildcarded filenames to non-wildcarded filenames
		local
			i: INTEGER;
			dir_name, wc_name, name, entries_name: STRING_32;
			directory: DIRECTORY;
			wildcard_matcher: KMP_WILD;
			entries: ARRAYED_LIST [PATH];
			empty_array: like {PROFILER_OPTIONS}.filenames
		do
			from
				i := prof_options.filenames.lower
debug("SHOW_PROF_QUERY")
	io.error.put_string ("Expanding filenames.%Nprof_options.filenames.count: ");
	io.error.put_integer (prof_options.filenames.count);
	io.error.put_new_line;
	io.error.put_string ("index (i): ");
	io.error.put_integer (i);
	io.error.put_new_line;
end;
			until
				i > prof_options.filenames.upper
			loop
				name := prof_options.filenames.item (i);
				if has_wildcards (name) then
					dir_name := extract_directory_name (name)
					if dir_name.count = 0 then
						dir_name := "."
					end;
					wc_name := extract_filename (name);
					wc_name.to_lower
					create directory.make (dir_name);
					if directory.exists then;
						from
							entries := directory.entries;
							entries.start;
							entries.forth;
							entries.forth
							entries_name := entries.item.name
							entries_name.to_lower
							create wildcard_matcher.make (wc_name, entries_name);
						until
							entries.after
						loop
							entries_name := entries.item.name
							entries_name.to_lower
							wildcard_matcher.set_text (entries_name);
							if wildcard_matcher.pattern_matches then
								entries_name := dir_name.twin
								-- entries_name.append_character (Operating_environment.Directory_separator)
								entries_name.append (entries.item.name)
								--| Guillaume - 09/16/97
								expanded_filenames.extend (entries_name)
							end;
							entries.forth
						end
					end
				else
					expanded_filenames.extend (name)
				end;
				i := i + 1
			end;

				-- Copy filenames back in the original array
				-- to keep them for the next run as default.
			from
				create empty_array.make (1, 0);
				prof_options.filenames.copy (empty_array);
				expanded_filenames.start
			until
				expanded_filenames.after
			loop
				prof_options.filenames.force (expanded_filenames.item, prof_options.filenames.count + 1);
				expanded_filenames.forth
			end
		end;

	has_wildcards(name: STRING_32): BOOLEAN
		do
			Result := (name.index_of ('*', 1) > 0) or else
						(name.index_of ('?', 1) > 0)
		end

	extract_directory_name(name: STRING_32): STRING_32
		local
			new_index, old_index: INTEGER
		do
			from
				new_index := 1
			until
				new_index = 0
			loop
				old_index := new_index;
				new_index := name.index_of (Operating_environment.Directory_separator,
								old_index);
				if new_index /= 0 then
					new_index := new_index + 1
				else
					old_index := old_index - 1
				end
			end;
			create Result.make (0);
			if old_index > 1 then
				Result.append_string (name.substring (1, old_index))
			end
		end;

	extract_filename (name: STRING_32): STRING_32
		local
			i: INTEGER
		do
			from
				i := name.count
			until
				i > 0 and then name.item (i) = Operating_environment.Directory_separator or else i < 1
			loop
				i := i - 1
			end;
			create Result.make (0);
			Result.append_string (name.substring (i + 1, name.count))
		end;

	print_header
			-- Prints the header of the table
		local
			i: INTEGER
		do
			if text_formatter /= Void then
				from
					i:= 1
				until
					i > prof_options.output_names.count
				loop
					text_formatter.add (prof_options.output_names.item(i));
					text_formatter.add_indent;
					i := i + 1
				end;
				text_formatter.add_new_line
			end
		end;

	print_result
			-- Computes the result of the query.
		local
			answer_set: PROFILE_SET
		do
			int_last_output := profile_information.twin
			answer_set := first_filter.filter (profile_information.profile_data);
			int_last_output.set_profile_data (answer_set);
			from
				answer_set.start
			until
				answer_set.after
			loop
				print_columns (answer_set.item);
				answer_set.forth
			end
		end;

	generate_filters
			-- Generate the filters used by.
		local
			i: INTEGER;
			boolean_filter: PROFILE_FILTER;
			last_op: STRING
		do
debug("SHOW_PROF_QUERY")
	io.error.put_string ("Generating filters.");
	io.error.put_new_line;
	io.error.put_string ("prof_query.subquery_operators.count: ");
	io.error.put_integer (prof_query.subquery_operators.count);
	io.error.put_new_line;
end;

			if prof_query.subquery_operators.count > 0 then
				if prof_query.operator_at (1).actual_operator.is_equal ("or") then
					create {OR_FILTER} first_filter.make;
					last_op := "or"
				else
					create {AND_FILTER} first_filter.make;
					last_op := "and"
				end;
				boolean_filter := first_filter;
				first_filter.extend (generate_filter (1));
				from
					i := 2
				until
					i > prof_query.subquery_operators.count
				loop
					if prof_query.operator_at (i).actual_operator.is_equal (last_op) then
						first_filter.extend (generate_filter (i))
					else
						if boolean_filter /= first_filter then
							first_filter.extend (generate_filter (i))
						else
							if prof_query.operator_at (i).actual_operator.is_equal ("or") then
								create {OR_FILTER} boolean_filter.make;
								last_op := "or"
							else
								create {AND_FILTER} boolean_filter.make;
								last_op := "and"
							end;
							boolean_filter.extend (generate_filter (i))
						end
					end;
					i := i + 1
				end;
				boolean_filter.extend (generate_filter (i));
				if boolean_filter /= first_filter then
					first_filter.extend (boolean_filter)
				end
			else
				first_filter := generate_filter (1)
			end;
			extend_with_languages
		end;

	generate_filter (i: INTEGER): PROFILE_FILTER
		local
			col_name: STRING
		do
			col_name := prof_query.subquery_at (i).column;
			if col_name.is_equal (profiler_percentage) then
				create {PERCENTAGE_FILTER} Result.make;
				Result := set_filter_value (Result, false, i)
			elseif col_name.is_equal (profiler_self) then
				create {SELF_FILTER} Result.make;
				Result := set_filter_value (Result, false, i)
			elseif col_name.is_equal (profiler_descendants) then
				create {DESCENDANTS_FILTER} Result.make;
				Result := set_filter_value (Result, false, i)
			elseif col_name.is_equal (profiler_total) then
				create {TOTAL_FILTER} Result.make;
				Result := set_filter_value (Result, false, i)
			elseif col_name.is_equal (profiler_calls) then
				create {CALLS_FILTER} Result.make;
				Result := set_filter_value (Result, true, i)
			elseif col_name.is_equal (profiler_feature_name) then
				create {NAME_FILTER} Result.make;
				Result.set_value (prof_query.subquery_at (i).value)
			end;
			Result.set_operator (prof_query.subquery_at (i).operator)
		end;

	set_filter_value (filter: PROFILE_FILTER; calls: BOOLEAN; i: INTEGER): PROFILE_FILTER
			-- Sets the value specified by the user in `filter'.
			-- `calls' distinguishes between the filter is a
			-- CALLS_FILTER (true) or not (false).
			-- Index of value is `i'.
		local
			real_ref: REAL_64_REF;
			int_ref: INTEGER_REF;
			lower, upper, origin: STRING;
			lower_ref_int, upper_ref_int: INTEGER_REF;
			lower_ref_real, upper_ref_real: REAL_64_REF
		do
			Result := filter;
			origin := prof_query.subquery_at (i).value;
			if calls then
				if origin.has ('-') then
					lower := origin.substring (1, origin.index_of ('-', 1) - 1);
					upper := origin.substring (origin.index_of ('-', 1) + 1, origin.count);
					lower_ref_int ?= single_value (lower, calls, i);
					upper_ref_int ?= single_value (upper, calls, i);
					Result.set_value_range (lower_ref_int, upper_ref_int)
				else
					int_ref ?= single_value (origin, calls, i);
					Result.set_value (int_ref)
				end
			else
				if origin.has ('-') then
					lower := origin.substring (1, origin.index_of ('-', 1) - 1);
					upper := origin.substring (origin.index_of ('-', 1) + 1, origin.count);
					lower_ref_real ?= single_value (lower, calls, i);
					upper_ref_real ?= single_value (upper, calls, i);
					Result.set_value_range (lower_ref_real, upper_ref_real)
				else
					real_ref ?= single_value (origin, calls, i);
					Result.set_value (real_ref)
				end
			end
		end;

	single_value (val: STRING; calls: BOOLEAN; i: INTEGER): COMPARABLE
			-- `calls' distinguishes between the filter is a
			-- CALLS_FILTER (true) or not (false).
			-- `val' contains the value.
		local
			int_ref: INTEGER_REF
			real_ref: REAL_64_REF
		do
			if calls then
				create int_ref;
				if val.is_equal (profiler_min) then
					if prof_options.language_names.item (1).is_equal (profiler_eiffel) then
						int_ref.set_item (profile_information.profile_data.calls_min_eiffel)
					elseif prof_options.language_names.item (1).is_equal (profiler_c) then
						int_ref.set_item (profile_information.profile_data.calls_min_c)
					elseif prof_options.language_names.item (1).is_equal (profiler_cycle) then
						int_ref.set_item (profile_information.profile_data.calls_min_cycle)
					end
				elseif val.is_equal (profiler_max) then
					if prof_options.language_names.item (1).is_equal (profiler_eiffel) then
						int_ref.set_item (profile_information.profile_data.calls_max_eiffel)
					elseif prof_options.language_names.item (1).is_equal (profiler_c) then
						int_ref.set_item (profile_information.profile_data.calls_max_c)
					elseif prof_options.language_names.item (1).is_equal (profiler_cycle) then
						int_ref.set_item (profile_information.profile_data.calls_max_cycle)
					end
				elseif val.is_equal (profiler_avg) then
					if prof_options.language_names.item (1).is_equal (profiler_eiffel) then
						int_ref.set_item (profile_information.profile_data.calls_avg_eiffel
									// profile_information.profile_data.number_of_eiffel_features)
					elseif prof_options.language_names.item (1).is_equal (profiler_c) then
						int_ref.set_item (profile_information.profile_data.calls_avg_c
									// profile_information.profile_data.number_of_c_functions)
					elseif prof_options.language_names.item (1).is_equal (profiler_cycle) then
						int_ref.set_item (profile_information.profile_data.calls_avg_cycle
									// profile_information.profile_data.number_of_cycles)
					end
				else
					int_ref.set_item (val.to_integer)
				end;
				Result := int_ref
			else
				create real_ref;
				if prof_query.subquery_at (i).column.is_equal (profiler_percentage) then
					if val.is_equal (profiler_min) then
						if prof_options.language_names.item (1).is_equal (profiler_eiffel) then
							real_ref.set_item (profile_information.profile_data.calls_min_eiffel)
						elseif prof_options.language_names.item (1).is_equal (profiler_c) then
							real_ref.set_item (profile_information.profile_data.calls_min_c)
						elseif prof_options.language_names.item (1).is_equal (profiler_cycle) then
							real_ref.set_item (profile_information.profile_data.calls_min_cycle)
						end
					elseif val.is_equal (profiler_max) then
						if prof_options.language_names.item (1).is_equal (profiler_eiffel) then
							real_ref.set_item (profile_information.profile_data.calls_max_eiffel)
						elseif prof_options.language_names.item (1).is_equal (profiler_c) then
							real_ref.set_item (profile_information.profile_data.calls_max_c)
						elseif prof_options.language_names.item (1).is_equal (profiler_cycle) then
							real_ref.set_item (profile_information.profile_data.calls_max_cycle)
						end
					elseif val.is_equal (profiler_avg) then
						if prof_options.language_names.item (1).is_equal (profiler_eiffel) then
							real_ref.set_item (profile_information.profile_data.calls_avg_eiffel
									/ profile_information.profile_data.number_of_eiffel_features)
						elseif prof_options.language_names.item (1).is_equal (profiler_c) then
							real_ref.set_item (profile_information.profile_data.calls_avg_c
									/ profile_information.profile_data.number_of_c_functions)
						elseif prof_options.language_names.item (1).is_equal (profiler_cycle) then
							real_ref.set_item (profile_information.profile_data.calls_avg_cycle
									/ profile_information.profile_data.number_of_cycles)
						end
					else
						real_ref.set_item (val.to_double)
					end
				elseif prof_query.subquery_at (i).column.is_equal (profiler_descendants) then
					if val.is_equal (profiler_min) then
						if prof_options.language_names.item (1).is_equal (profiler_eiffel) then
							real_ref.set_item (profile_information.profile_data.descendants_min_eiffel)
						elseif prof_options.language_names.item (1).is_equal (profiler_c) then
							real_ref.set_item (profile_information.profile_data.descendants_min_c)
						elseif prof_options.language_names.item (1).is_equal (profiler_cycle) then
							real_ref.set_item (profile_information.profile_data.descendants_min_cycle)
						end
					elseif val.is_equal (profiler_max) then
						if prof_options.language_names.item (1).is_equal (profiler_eiffel) then
							real_ref.set_item (profile_information.profile_data.descendants_max_eiffel)
						elseif prof_options.language_names.item (1).is_equal (profiler_c) then
							real_ref.set_item (profile_information.profile_data.descendants_max_c)
						elseif prof_options.language_names.item (1).is_equal (profiler_cycle) then
							real_ref.set_item (profile_information.profile_data.descendants_max_cycle)
						end
					elseif val.is_equal (profiler_avg) then
						if prof_options.language_names.item (1).is_equal (profiler_eiffel) then
							real_ref.set_item (profile_information.profile_data.descendants_avg_eiffel
									/ profile_information.profile_data.number_of_eiffel_features)
						elseif prof_options.language_names.item (1).is_equal (profiler_c) then
							real_ref.set_item (profile_information.profile_data.descendants_avg_c
									/ profile_information.profile_data.number_of_c_functions)
						elseif prof_options.language_names.item (1).is_equal (profiler_cycle) then
							real_ref.set_item (profile_information.profile_data.descendants_avg_cycle
									/ profile_information.profile_data.number_of_cycles)
						end
					else
						real_ref.set_item (val.to_double)
					end
				elseif prof_query.subquery_at (i).column.is_equal (profiler_self) then
					if val.is_equal (profiler_min) then
						if prof_options.language_names.item (1).is_equal (profiler_eiffel) then
							real_ref.set_item (profile_information.profile_data.self_min_eiffel)
						elseif prof_options.language_names.item (1).is_equal (profiler_c) then
							real_ref.set_item (profile_information.profile_data.self_min_c)
						elseif prof_options.language_names.item (1).is_equal (profiler_cycle) then
							real_ref.set_item (profile_information.profile_data.self_min_cycle)
						end
					elseif val.is_equal (profiler_max) then
						if prof_options.language_names.item (1).is_equal (profiler_eiffel) then
							real_ref.set_item (profile_information.profile_data.self_max_eiffel)
						elseif prof_options.language_names.item (1).is_equal (profiler_c) then
							real_ref.set_item (profile_information.profile_data.self_max_c)
						elseif prof_options.language_names.item (1).is_equal (profiler_cycle) then
							real_ref.set_item (profile_information.profile_data.self_max_cycle)
						end
					elseif val.is_equal (profiler_avg) then
						if prof_options.language_names.item (1).is_equal (profiler_eiffel) then
							real_ref.set_item (profile_information.profile_data.self_avg_eiffel
									/ profile_information.profile_data.number_of_eiffel_features)
						elseif prof_options.language_names.item (1).is_equal (profiler_c) then
							real_ref.set_item (profile_information.profile_data.self_avg_c
									/ profile_information.profile_data.number_of_c_functions)
						elseif prof_options.language_names.item (1).is_equal (profiler_cycle) then
							real_ref.set_item (profile_information.profile_data.self_avg_cycle
									/ profile_information.profile_data.number_of_cycles)
						end
					else
						real_ref.set_item (val.to_double)
					end
				elseif prof_query.subquery_at (i).column.is_equal (profiler_total) then
					if val.is_equal (profiler_min) then
						if prof_options.language_names.item (1).is_equal (profiler_eiffel) then
							real_ref.set_item (profile_information.profile_data.total_min_eiffel)
						elseif prof_options.language_names.item (1).is_equal (profiler_c) then
							real_ref.set_item (profile_information.profile_data.total_min_c)
						elseif prof_options.language_names.item (1).is_equal (profiler_cycle) then
							real_ref.set_item (profile_information.profile_data.total_min_cycle)
						end
					elseif val.is_equal (profiler_max) then
						if prof_options.language_names.item (1).is_equal (profiler_eiffel) then
							real_ref.set_item (profile_information.profile_data.total_max_eiffel)
						elseif prof_options.language_names.item (1).is_equal (profiler_c) then
							real_ref.set_item (profile_information.profile_data.total_max_c)
						elseif prof_options.language_names.item (1).is_equal (profiler_cycle) then
							real_ref.set_item (profile_information.profile_data.total_max_cycle)
						end
					elseif val.is_equal (profiler_avg) then
						if prof_options.language_names.item (1).is_equal (profiler_eiffel) then
							real_ref.set_item (profile_information.profile_data.total_avg_eiffel
									/ profile_information.profile_data.number_of_eiffel_features);
						elseif prof_options.language_names.item (1).is_equal (profiler_c) then
							real_ref.set_item (profile_information.profile_data.total_avg_c
									/ profile_information.profile_data.number_of_c_functions)
						elseif prof_options.language_names.item (1).is_equal (profiler_cycle) then
							real_ref.set_item (profile_information.profile_data.total_avg_cycle
									/ profile_information.profile_data.number_of_cycles)
						end
					else
						real_ref.set_item (val.to_double)
					end
				end;
				Result := real_ref
			end
		end;

	extend_with_languages
			-- Creates extra language filters
		local
			lang_filt: PROFILE_FILTER;
			new_ff: PROFILE_FILTER;
			i: INTEGER
		do
			if prof_options.language_names.count > 1 then
				from
					create {OR_FILTER} lang_filt.make;
					i := 1
				until
					i > prof_options.language_names.count
				loop
					lang_filt.extend (generate_language_filter (i));
					i := i + 1
				end
				create {AND_FILTER} new_ff.make;
				new_ff.extend (lang_filt);
				new_ff.extend (first_filter);
				first_filter := new_ff
			elseif prof_options.language_names.count = 1 then
				create {AND_FILTER} new_ff.make;
				new_ff.extend (generate_language_filter (1));
				new_ff.extend (first_filter);
				first_filter := new_ff
			end
		end;

	generate_language_filter (i: INTEGER): PROFILE_FILTER
			-- Generates a filter for a specified
			-- language
		local
			lang_name: STRING
		do
			lang_name := prof_options.language_names.item (i);
			lang_name.to_lower;
			if lang_name.is_equal (profiler_eiffel) then
				create {EIFFEL_FILTER} Result.make
			elseif lang_name.is_equal (profiler_c) then
				create {C_FILTER} Result.make
			elseif lang_name.is_equal (profiler_cycle) then
				create {CYCLE_FILTER} Result.make
			end
		end;

	print_columns (item: PROFILE_DATA)
			-- Prints the values from the columns the user wanted
			-- to see.
		local
			i: INTEGER
		do
			if text_formatter /= Void then
				from
					i := 1
				until
					i > prof_options.output_names.count
				loop
					if prof_options.output_names.item (i).is_equal ("featurename") then
						item.function.append_to (text_formatter)
						text_formatter.add_indent
					elseif prof_options.output_names.item (i).is_equal ("calls") then
						text_formatter.add (item.calls.out)
					elseif prof_options.output_names.item (i).is_equal ("self") then
						text_formatter.add (time_formatter.formatted (item.self))
					elseif prof_options.output_names.item (i).is_equal ("descendants") then
						text_formatter.add (time_formatter.formatted (item.descendants))
					elseif prof_options.output_names.item (i).is_equal ("total") then
						text_formatter.add (time_formatter.formatted (item.total))
					elseif prof_options.output_names.item (i).is_equal ("percentage") then
						text_formatter.add (percentage_formatter.formatted (item.percentage))
					end
					text_formatter.add_indent
					i := i + 1
				end;
				text_formatter.add_new_line
			end
		end;

feature {NONE} -- Attributes

	expanded_filenames: LINKED_LIST [STRING_32];
		-- unwildcarded filenames

	profile_information: PROFILE_INFORMATION;
		-- Retrieved from disk- where it is stored by prof_converter.

	first_filter: PROFILE_FILTER;
		-- Filter of which the `filter'-feature is to be called.

	int_last_output: PROFILE_INFORMATION;
		-- Output as result of the last queried query.

	prof_query: PROFILER_QUERY;
		-- All the active queries.

	prof_options: PROFILER_OPTIONS
		-- The options specified by the user.

	time_formatter: FORMAT_DOUBLE
			-- Consistent presentation of real numbers.
		once
			create Result.make (7, 6)
			Result.hide_trailing_zeros
		end

	percentage_formatter: FORMAT_DOUBLE
			-- Consistent presentation of real numbers.
		once
			create Result.make (4, 3)
			Result.hide_trailing_zeros
		end

note
	copyright:	"Copyright (c) 1984-2013, Eiffel Software"
	license:	"GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options:	"http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful, but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
		]"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"

end -- class E_SHOW_PROFILE_QUERY
