indexing
	description	: "Tool to search and replace a string in clusters, classes or editor in the whole system."
	date		: "$Date$"
	revision	: "$Revision$"

class
	EB_MULTI_SEARCH_TOOL

inherit

	EB_SEARCH_TOOL
		rename
			replace as replace_current
		export
			{MSR_REPLACE_IN_ESTUDIO_STRATEGY} editor
		redefine
			make,
			build_interface,
			search,
			replace_current,
			switch_mode,
			search_is_possible,
			force_new_search,
			go_to_next_found,
			go_to_previous_found,
			key_pressed,
			default_search,
			enable_disable_search_button,
			on_text_edited,
			on_text_reset,
			on_text_fully_loaded,
			set_focus,
			recycle
		end

	MSR_FORMATTER

	EB_SHARED_MANAGERS
		undefine
			default_create
		end

	EB_CLASS_TEXT_MANAGER
		export
			{NONE} all
		undefine
			default_create
		end

	EB_PIXMAPABLE_ITEM_PIXMAP_FACTORY
		undefine
			default_create, copy, is_equal
		end

	EB_SHARED_PREFERENCES

create
	make

feature {NONE} -- Initialization

	make (a_manager: EB_DEVELOPMENT_WINDOW) is
			-- Initialization
		do
			Precursor (a_manager)
			create multi_search_performer.make
			new_search_set := true
			is_text_new_loaded := true
			check_class_succeed := true
			create report_summary_string.make_empty
			create changed_classes.make (0)
			create loaded_actions
		end

	build_interface is
			-- Build all the tool's widgets.
		local
			vbox: EV_VERTICAL_BOX
			search_box: EV_VERTICAL_BOX
			replace_box: EV_VERTICAL_BOX
			label, label_search: EV_LABEL
			size: INTEGER
			options_box: EV_BOX
			report_box: EV_BOX
			frame: EV_FRAME
			hbox: EV_HORIZONTAL_BOX
			cell: EV_CELL
			option_and_replace_all_box: EV_HORIZONTAL_BOX
			option_frame: EV_FRAME
		do
					-- Search box
			create label_search.make_with_text (Interface_names.l_Search_for + " ")
			label_search.align_text_left
			size := label_search.minimum_width

			create keyword_field
			keyword_field.change_actions.extend (agent enable_disable_search_button)
			keyword_field.key_press_actions.extend (agent key_pressed (?, True))
			keyword_field.set_minimum_width (Layout_constants.Dialog_unit_to_pixels (290))
			keyword_field.drop_actions.extend (agent display_stone_signature (keyword_field, ?))

			create search_box
			search_box.set_padding (1)
			create hbox
			search_box.extend (hbox)
			hbox.extend (label_search)
			hbox.disable_item_expand (label_search)

			hbox.extend (keyword_field)
			hbox.disable_item_expand (keyword_field)
			create cell
			cell.set_minimum_width (3)
			hbox.extend (cell)
			hbox.disable_item_expand (cell)
			create search_button.make_with_text_and_action (interface_names.b_search, agent search_button_clicked)
			search_button.key_press_actions.extend (agent handle_enter_on_button (?, agent search_button_clicked))
			search_button.disable_sensitive
			hbox.extend (search_button)
			hbox.disable_item_expand (search_button)

					-- Replace box
			create replace_combo_box
			replace_combo_box.key_press_actions.extend (agent key_pressed (?, False))
			replace_combo_box.set_minimum_width (Layout_constants.Dialog_unit_to_pixels (290))
			replace_combo_box.drop_actions.extend (agent display_stone_signature (replace_combo_box, ?))

			create replace_check_button.make_with_text (Interface_names.l_Replace_with)
			replace_check_button.select_actions.extend (agent switch_mode)
			replace_check_button.key_press_actions.extend (agent key_pressed (?, True ))


			create replace_button.make_with_text_and_action (interface_names.b_replace, agent replace_current)
			replace_button.key_press_actions.extend (agent handle_enter_on_button (?, agent replace_current))

			create replace_text.make (0)

			create replace_box
			create hbox
			replace_box.extend (hbox)
			replace_box.disable_item_expand (hbox)
			create label.make_with_text (interface_names.l_replace_with + " ")

			hbox.extend (label)
			hbox.disable_item_expand (label)
			label_search.set_minimum_width (label.width)

			hbox.extend (replace_check_button)
			replace_check_button.hide
			hbox.disable_item_expand (replace_check_button)
			hbox.extend (replace_combo_box)
			hbox.disable_item_expand (replace_combo_box)
			size := label.width + replace_combo_box.width

			create cell
			cell.set_minimum_width (3)
			hbox.extend (cell)
			hbox.disable_item_expand (cell)

			hbox.extend (replace_button)
			hbox.disable_item_expand (replace_button)

					-- Options and replace all
			create option_and_replace_all_box
			create option_frame.make_with_text (interface_names.l_Options)
			option_frame.set_minimum_width (size)
			option_and_replace_all_box.extend (option_frame)
			option_and_replace_all_box.disable_item_expand (option_frame)
			create hbox
			create cell
			cell.set_minimum_width (10)
			hbox.extend (cell)
			hbox.disable_item_expand (cell)
			option_frame.extend (hbox)
				-- Option "Match case"
			create case_sensitive_button.make_with_text (Interface_names.l_Match_case)
			case_sensitive_button.key_press_actions.extend (agent key_pressed (?, True))
			case_sensitive_button.select_actions.extend (agent force_new_search)

				-- Option "Whole word"
			create whole_word_button.make_with_text (Interface_names.l_Whole_word)
			whole_word_button.key_press_actions.extend (agent key_pressed (?, True))
			whole_word_button.select_actions.extend (agent force_new_search)

				-- Option "Use regular expression"
			create use_regular_expression_button.make_with_text (Interface_names.l_Use_regular_expression)
			use_regular_expression_button.key_press_actions.extend (agent key_pressed (?, True))
			use_regular_expression_button.select_actions.extend (agent force_new_search)


				-- Option "Search backward"
			create search_backward_button.make_with_text (Interface_names.l_Search_backward)
			search_backward_button.key_press_actions.extend (agent key_pressed (?, True))

			create vbox
			hbox.extend (vbox)
			hbox.disable_item_expand (vbox)
			vbox.extend (case_sensitive_button)
			vbox.disable_item_expand (case_sensitive_button)
			vbox.extend (whole_word_button)
			vbox.disable_item_expand (whole_word_button)

			create cell
			cell.set_minimum_width (80)
			hbox.extend (cell)
			hbox.disable_item_expand (cell)

			create vbox
			hbox.extend (vbox)
			hbox.disable_item_expand (vbox)
			vbox.extend (use_regular_expression_button)
			vbox.disable_item_expand (use_regular_expression_button)
			vbox.extend (search_backward_button)
			vbox.disable_item_expand (search_backward_button)

			create replace_all_click_button.make_with_text_and_action (interface_names.b_replace_all, agent confirm_and_replace_all)
			replace_all_click_button.key_press_actions.extend (agent handle_enter_on_button (?, agent confirm_and_replace_all))
			create vbox
			vbox.extend (replace_all_click_button)
			vbox.disable_item_expand (replace_all_click_button)
			vbox.extend (create {EV_CELL})

			create cell
			cell.set_minimum_width (3)
			option_and_replace_all_box.extend (cell)
			option_and_replace_all_box.disable_item_expand (cell)

			option_and_replace_all_box.extend (vbox)
			option_and_replace_all_box.disable_item_expand (vbox)

			replace_button.set_minimum_width (layout_constants.default_button_width)
			replace_all_click_button.set_minimum_width (layout_constants.default_button_width)
			search_button.set_minimum_width (layout_constants.default_button_width)

			replace_button.disable_sensitive
			replace_all_click_button.disable_sensitive

			options_box := build_scope_box
			report_box := build_report_box

			if not preferences.development_window_data.show_search_options then
				toggle_options
			end

			create vbox
			vbox.set_border_width (Layout_constants.Small_border_size)
			vbox.set_padding (Layout_constants.Small_border_size)
			vbox.extend (search_box)
			vbox.disable_item_expand (search_box)
			vbox.extend (replace_box)
			vbox.disable_item_expand (replace_box)
			vbox.extend (option_and_replace_all_box)
			vbox.disable_item_expand (option_and_replace_all_box)

			create notebook
			notebook.drop_actions.set_veto_pebble_function (agent notebook_veto_pebble)
			notebook.drop_actions.extend (agent on_drop_notebook)
			notebook.selection_actions.extend (agent on_notebook_selected)
			notebook.set_tab_position (notebook.tab_top)
			notebook.extend (vbox)
			notebook.extend (options_box)
			notebook.item_tab (vbox).set_text (interface_names.t_search_tool)
			notebook.item_tab (options_box).set_text (interface_names.l_scope)

			create vbox
			vbox.extend (notebook)
			vbox.disable_item_expand (notebook)

			vbox.extend (report_box)
			create frame
			frame.set_style ((create {EV_FRAME_CONSTANTS}).Ev_frame_raised)
			frame.extend (vbox)

			prepare_interface

			switch_mode
			widget := frame
		end

feature -- Access

	grid_head_class: STRING is				"Class"
	grid_head_line_number: STRING is 		"Line"
	grid_head_found: STRING is				"Found"
	grid_head_context: STRING is			"Context"
	grid_head_file_location: STRING is		"File location"
			-- Grid header texts

	header_width: ARRAYED_LIST [INTEGER] is
			-- List of header width.
		once
			create Result.make (4)
			Result.extend (label_font.string_width (grid_head_class) + column_border_space + column_border_space)
			Result.extend (label_font.string_width (grid_head_found) + column_border_space + column_border_space)
			Result.extend (label_font.string_width (grid_head_context) + column_border_space + column_border_space)
			Result.extend (label_font.string_width (grid_head_file_location) + column_border_space + column_border_space)
		end

	surrounding_text_number: INTEGER is 	20
			-- Maximal number of characters on one side of found text in the report.

	column_border_space: INTEGER is 8
			-- Padding space for column content	

	resized_columns_list: ARRAY [BOOLEAN] is
			-- List of boolean s for each column indicating if it has been user resizedat all.
		once
			Result := <<False, False, False, False>>
		end

	multi_search_performer: MSR
			-- Tool that actually performs the search

	replace_all_click_button: EV_BUTTON
			-- Replace all button

	add_button: EV_BUTTON
			-- Add button

	remove_button: EV_BUTTON
			-- Remove button

	remove_all_button: EV_BUTTON
			-- Remove all button

	use_regular_expression_button: EV_CHECK_BUTTON
			-- Button to tell if pattern contains wild card.

	current_editor_button: EV_RADIO_BUTTON
			-- Button to search in editor

	whole_project_button: EV_RADIO_BUTTON
			-- Button to search in whole project

	custom_button: EV_RADIO_BUTTON
			-- Button to search in a specific scope

	search_subcluster_button: EV_CHECK_BUTTON
			-- Button to indicate if subcluster of the specific scope will be searched.

	search_compiled_class_button: EV_CHECK_BUTTON
			-- Button to indicate if compiled classes will be searched.

	incremental_search_button: EV_CHECK_BUTTON
			-- Button to control incremental search.

	scope_list: EV_LIST
			-- List of the specific scope

	search_report_grid: ES_GRID
			-- Grid to contain search report

	replace_combo_box: EV_COMBO_BOX
			-- Replacment combo box

	notebook: EV_NOTEBOOK
			-- Notebook, one tab for basic search, one for scopes.

feature -- Status report

	reverse : BOOLEAN is
			-- Search upwards?
		do
			Result := search_backward_button.is_selected or temp_reverse
		end

	is_whole_project_searched : BOOLEAN is
			-- Is the whole project searched?
		do
			Result := whole_project_button.is_selected
		end

	is_customized : BOOLEAN is
			-- Is search scoped?
		do
			Result := custom_button.is_selected
		end

	is_case_sensitive: BOOLEAN is
			-- Is search case sensitive?
		do
			Result := case_sensitive_button.is_selected
		end

	is_whole_word_matched: BOOLEAN is
			-- Is search whole word matched?
		do
			Result := whole_word_button.is_selected
		end

	is_regular_expression_used: BOOLEAN is
			-- Is regular expression used in search?
		do
			Result := use_regular_expression_button.is_selected
		end

	is_incremental_search: BOOLEAN is
			-- Is incremental search enabled?
		do
			Result := incremental_search_button.is_selected
		end

	is_sub_cluster_searched: BOOLEAN is
			-- Are subclusters searched?
		do
			Result := search_subcluster_button.is_selected
		end

	is_current_editor_searched: BOOLEAN is
			-- Is current editor searched?
		do
			Result := current_editor_button.is_selected
		end

	only_compiled_class_searched: BOOLEAN is
			-- Only compiled classes are searched?
		do
			Result := search_compiled_class_button.is_selected
		end

	item_selected (a_editor: EB_EDITOR): BOOLEAN is
			-- If item in report is selected in a_editor.
		local
			l_text_item: MSR_TEXT_ITEM
		do
			if multi_search_performer.is_search_launched and not multi_search_performer.off then
				l_text_item ?= multi_search_performer.item
				if
					l_text_item /= Void and then
					(is_current_editor_searched implies old_editor = editor) and
					(a_editor.text_displayed.selection_start.pos_in_text = l_text_item.start_index_in_unix_text) and
					(a_editor.text_displayed.selection_end.pos_in_text = l_text_item.end_index_in_unix_text + 1)
				then
					Result := true
				end
				if l_text_item = Void then
					Result := true
				end
			end
		end

feature -- Status setting

	force_new_search is
			-- Force new search.
		do
			new_search_set := true
		end

	enable_incremental_search is
			-- Enable incremental search.
		do
			incremental_search_button.enable_select
		end

	disable_incremental_search is
			-- Disable increamental search	
		do
			incremental_search_button.disable_select
		end

	set_focus is
			-- give the focus to the pattern field
		do
			if notebook.selected_item_index /= 1 then
				notebook.select_item (notebook.i_th (1))
			end
			keyword_field.set_focus
		end

feature -- Action

	go_to_next_found is
			-- Highlight next found item if possible, possibly go back.
			-- If search is not launched, launch it.
		do
			if new_search_set or (old_editor /= editor and is_current_editor_searched) or (is_current_editor_searched and is_text_changed_in_editor) then
				force_new_search
				dispatch_search
				select_and_show
			else
				extend_and_run_loaded_action (agent go_to_next_found_perform (reverse))
				extend_and_run_loaded_action (agent go_to_next_found_select_and_show)
			end
		end

	go_to_previous_found is
			-- Highlight previous found item if possible.
			-- If search is not launched, launch it.
		do
			temp_reverse := true
			go_to_next_found
			temp_reverse := false
		end

	replace_current is
			-- Replace current match.
		local
			l_item: MSR_TEXT_ITEM
			l_start: INTEGER
			l_end: INTEGER
			l_class_i : CLASS_I
			l_check: BOOLEAN
		do
			l_start := 0
			l_end := 1
			check_class_succeed := true
			if multi_search_performer.is_search_launched and then not multi_search_performer.off then
				l_item ?= multi_search_performer.item
				if l_item /= Void then
					l_start := l_item.start_index_in_unix_text
					l_end := l_item.end_index_in_unix_text + 1
				end
			end
			if new_search_set or else
				not multi_search_performer.is_search_launched or else
				(not multi_search_performer.off and then
				(editor.text_displayed.cursor /= Void and then
				(editor.text_displayed.cursor.pos_in_text > l_end or
				editor.text_displayed.cursor.pos_in_text < l_start)))
			then
				search_button_clicked
			end
			if multi_search_performer.is_search_launched and then not multi_search_performer.off then
				 l_class_i ?= multi_search_performer.item.data
				 if l_class_i /= Void then
				 	 if not is_class_i_editing (l_class_i) then
				 	 	l_check := true
				 	 end
				 end
			end
			if editor.number_of_lines /= 0 then
				if editor.is_editable then
					if not multi_search_performer.off and not multi_search_performer.is_empty then
						l_item ?= multi_search_performer.item
						if l_item /= Void and then not is_item_source_changed (l_item) then
							if l_check then
								check_class_file_and_do (agent replace_current_perform)
							else
								extend_and_run_loaded_action (agent replace_current_perform)
							end
							extend_and_run_loaded_action (agent go_to_next_found)
							extend_and_run_loaded_action (agent redraw_grid)
							extend_and_run_loaded_action (agent select_current_row)
							extend_and_run_loaded_action (agent force_not_changed)
						end
					end
				else
					editor.display_not_editable_warning_message
				end
			end
		end

	confirm_and_replace_all is
			-- Ask for confirmation, then replace all.
		local
			cd: STANDARD_DISCARDABLE_CONFIRMATION_DIALOG
			hindered: BOOLEAN
		do
			if is_current_editor_searched then
				if not editor.is_editable then
					hindered := true
					editor.display_not_editable_warning_message
				end
			end
			if not hindered then
				if not is_current_editor_searched then
					create cd.make_initialized (3, preferences.dialog_data.confirm_replace_all_string, warning_messages.w_replace_all, interface_names.l_Discard_replace_all_warning_dialog, preferences.preferences)
					cd.set_ok_action (agent extend_and_run_loaded_action (agent replace_all))
					cd.show_modal_to_window (window_manager.last_focused_development_window.window)
				else
					extend_and_run_loaded_action (agent replace_all)
				end
			end
		end

	prepare_search is
			-- Show the search tool and set focus to the search text field and fill the search field with selection.
		local
			l_clickable_editor: EB_CLICKABLE_EDITOR
		do
			l_clickable_editor ?= editor
			if l_clickable_editor /= Void then
				l_clickable_editor.search
			else
				show_and_set_focus
			end
		end

feature {MSR_REPLACE_IN_ESTUDIO_STRATEGY, EB_CLICKABLE_EDITOR} -- Implementation

	check_class_succeed: BOOLEAN
			-- `check_class_file' makes file changed if needed?

	set_check_class_succeed (a_succeed : BOOLEAN) is
			-- Set `check_class_succeed' with `a_succeed'.
		do
			check_class_succeed := a_succeed
		end

	is_item_source_changed (a_item: MSR_ITEM): BOOLEAN is
			-- Source in a_item changed?
		require
			a_item_attached: a_item /= Void
		local
			l_class_i: CLASS_I
		do
			l_class_i ?= a_item.data
			if old_editor = Void or old_editor = editor then
				if l_class_i /= Void then
	--				Result := is_text_changed_in_editor or a_item.date /= l_class_i.date or changed_classes.has (l_class_i)
					if is_current_editor_searched then
						Result := is_text_changed_in_editor
					else
						if editor.changed then
							Result := not changed_by_replace or changed_classes.has (l_class_i) or a_item.date /= l_class_i.date
						else
							Result := is_text_changed_in_editor or changed_classes.has (l_class_i) or a_item.date /= l_class_i.date
						end
	--					if is_text_changed_in_editor then
	--						Result := editor.changed and Result
	--					else
	--						Result := editor.changed or Result
	--					end
					end
				else
--					Result := true
				end
			end
		end

	changed_by_replace: BOOLEAN
			-- Changed by replace?

	set_changed_by_replace (a_changed: BOOLEAN) is
			-- Set `changed_by_replace'
		do
			changed_by_replace:= a_changed
		end

	force_not_changed is
			-- Set `new_search' and `is_text_changed_in_editor' to false.
		do
			new_search_set := false
			is_text_changed_in_editor := false
		end

feature {NONE} -- Build interface

	build_scope_box: EV_VERTICAL_BOX is
			-- Create and return a box containing the search options
		local
			vbox: EV_VERTICAL_BOX
			frm: EV_FRAME
			options_toolbar: EV_TOOL_BAR
			cell: EV_CELL
			hbox: EV_HORIZONTAL_BOX
			l_hbox: EV_HORIZONTAL_BOX
		do
				-- Option "Incremental search"
			create incremental_search_button.make_with_text ("Have not added to search panel")

				-- Option "Current Editor"		
			create current_editor_button.make_with_text (Interface_names.l_Current_editor)
			current_editor_button.key_press_actions.extend (agent key_pressed (?, True))
			current_editor_button.select_actions.extend (agent toggle_scope_detail (current_editor_button))
			current_editor_button.select_actions.extend (agent force_new_search)

				-- Option "Whole Project"
			create whole_project_button.make_with_text (Interface_names.l_Whole_project)
			whole_project_button.key_press_actions.extend (agent key_pressed (?, True))
			whole_project_button.select_actions.extend (agent toggle_scope_detail (whole_project_button))
			whole_project_button.select_actions.extend (agent force_new_search)

				-- Option "Scope"
			create custom_button.make_with_text (Interface_names.l_Custom)
			custom_button.key_press_actions.extend (agent key_pressed (?, True))
			custom_button.select_actions.extend (agent toggle_scope_detail (custom_button))
			custom_button.select_actions.extend (agent force_new_search)
			custom_button.drop_actions.extend (agent on_drop_custom_button (?))

				-- Option "Subcluster"
			create search_subcluster_button.make_with_text (Interface_names.l_Sub_clusters)
			search_subcluster_button.key_press_actions.extend (agent key_pressed (?, True))
			search_subcluster_button.select_actions.extend (agent force_new_search)

				-- Option "Compiled class"
			create search_compiled_class_button.make_with_text (Interface_names.l_Compiled_class)
			search_compiled_class_button.key_press_actions.extend (agent key_pressed (?, True))
			search_compiled_class_button.select_actions.extend (agent force_new_search)

				-- Option list scope
			create scope_list.default_create
			scope_list.key_press_actions.extend (agent key_pressed (?, True))
			scope_list.enable_multiple_selection
			scope_list.set_pick_and_drop_mode
			scope_list.drop_actions.extend (agent on_drop_add (?))

				-- Add button
			create add_button.make_with_text (interface_names.b_Add)
			add_button.set_minimum_width (layout_constants.default_button_width)
			add_button.select_actions.extend (agent add_scope)
			add_button.drop_actions.extend (agent on_drop_add (?))

				-- Remove button
			create remove_button.make_with_text (interface_names.b_Remove)
			remove_button.set_minimum_width (layout_constants.default_button_width)
			remove_button.select_actions.extend (agent remove_scope)
			remove_button.drop_actions.extend (agent on_drop_remove (?))

				-- Remove all button
			create remove_all_button.make_with_text (interface_names.b_Remove_all)
			remove_all_button.set_minimum_width (layout_constants.default_button_width)
			remove_all_button.select_actions.extend (agent remove_all)

			create vbox

			create options_button.make_with_text (Interface_names.l_Search_options_hide)
			options_button.select_actions.extend (agent toggle_options)
			create options_toolbar
			options_toolbar.extend (options_button)
			create frm
				-- This is a small workaround for a bug on Windows, where a toolbar
				-- directly inserted within an EV_FRAME, overlaps the bottom of the frame.
				-- There is currently no easy fix for this so this code has been added temporarily
				-- as a work around. Julian.
			create cell
			frm.extend (cell)
			cell.extend (options_toolbar)
			create Result

			create hbox
			hbox.set_border_width (Layout_constants.Small_border_size)

			create cell
			cell.set_minimum_width (5)
			hbox.extend (cell)
			hbox.disable_item_expand (cell)

			create scope
			create vbox
			vbox.set_padding_width (layout_constants.small_border_size )
			vbox.extend (current_editor_button)
			vbox.extend (whole_project_button)
			vbox.extend (custom_button)
			vbox.extend (search_compiled_class_button)
			vbox.disable_item_expand (current_editor_button)
			vbox.disable_item_expand (whole_project_button)
			vbox.disable_item_expand (custom_button)
			vbox.disable_item_expand (search_compiled_class_button)
			hbox.extend (vbox)
			hbox.disable_item_expand (vbox)


			create vbox
			vbox.extend (scope_list)
			scope_list.set_minimum_width (142 + layout_constants.default_button_width)

			scope.extend (vbox)
			scope.disable_item_expand (vbox)

			create cell
			cell.set_minimum_width (3)
			scope.extend (cell)
			scope.disable_item_expand (cell)

			create vbox
			vbox.set_padding_width (layout_constants.small_border_size)

			create l_hbox
			vbox.extend (l_hbox)
			vbox.disable_item_expand (l_hbox)
			l_hbox.extend (add_button)
			l_hbox.disable_item_expand (add_button)

			create l_hbox
			vbox.extend (l_hbox)
			vbox.disable_item_expand (l_hbox)
			l_hbox.extend (remove_button)
			l_hbox.disable_item_expand (remove_button)

			create l_hbox
			vbox.extend (l_hbox)
			vbox.disable_item_expand (l_hbox)
			l_hbox.extend (remove_all_button)
			l_hbox.disable_item_expand (remove_all_button)

			vbox.extend (search_subcluster_button)
			vbox.disable_item_expand (search_subcluster_button)
			scope.extend (vbox)
			scope.disable_item_expand (vbox)

			hbox.extend (scope)

			create options
			options.extend (hbox)
			Result.extend (options)
			Result.disable_item_expand (options)
			Result.set_border_width (layout_constants.small_border_size)
		end

	report : EV_FRAME
			-- Report container

	report_button : EV_TOOL_BAR_BUTTON
			-- Button to hide or show report.

	summary_label : EV_LABEL
			-- Label to show search summary.

	shortcut_tool_bar: EV_TOOL_BAR
			-- Tool bar contains expand all button etc.

	new_search_tool_bar: EV_TOOL_BAR
			-- Tool bar contains new search button.

	new_search_button: EV_TOOL_BAR_BUTTON
			-- Button to force a new search.

	expand_all_button: EV_TOOL_BAR_BUTTON
			-- Button to expand all.

	collapse_all_button: EV_TOOL_BAR_BUTTON
			-- Button to collapse all.

	build_report_box : EV_VERTICAL_BOX is
			-- Create and return a box containing result grid.
		local
			frm: EV_FRAME
			report_toolbar: EV_TOOL_BAR
			hbox: EV_HORIZONTAL_BOX
		do
			create report_button.make_with_text (Interface_names.l_Search_report_hide)
			report_button.select_actions.extend (agent toggle_search_report)
			create report_toolbar
			report_toolbar.extend (report_button)
			create frm
				-- This is a small workaround for a bug on Windows, where a toolbar
				-- directly inserted within an EV_FRAME, overlaps the bottom of the frame.
				-- There is currently no easy fix for this so this code has been added temporarily
				-- as a work around. Julian.
			create hbox
			frm.extend (hbox)
			hbox.extend (report_toolbar)
			create summary_label.default_create
			hbox.extend (summary_label)
			hbox.disable_item_expand (summary_label)
			hbox.disable_item_expand (report_toolbar)

			create new_search_tool_bar
			hbox.extend (new_search_tool_bar)
			hbox.disable_item_expand (new_search_tool_bar)
			create new_search_button.make_with_text (interface_names.b_new_search)
			new_search_tool_bar.extend (new_search_button)
			new_search_tool_bar.extend (create {EV_TOOL_BAR_SEPARATOR})
			new_search_button.select_actions.extend (agent new_search)
			new_search_tool_bar.hide

			create shortcut_tool_bar
			hbox.extend (create {EV_CELL})
			hbox.extend (shortcut_tool_bar)
			hbox.disable_item_expand (shortcut_tool_bar)
			shortcut_tool_bar.extend (create {EV_TOOL_BAR_SEPARATOR})
			create expand_all_button.make_with_text (interface_names.b_expand_all)
			create collapse_all_button.make_with_text (interface_names.b_collapse_all)
			shortcut_tool_bar.extend (expand_all_button)
			shortcut_tool_bar.extend (create {EV_TOOL_BAR_SEPARATOR})
			shortcut_tool_bar.extend (collapse_all_button)
			expand_all_button.select_actions.extend (agent expand_all)
			collapse_all_button.select_actions.extend (agent collapse_all)

			create search_report_grid
			search_report_grid.enable_row_height_fixed
			search_report_grid.enable_single_row_selection
			search_report_grid.disable_always_selected
			search_report_grid.enable_tree
			search_report_grid.set_item (4, 1, Void)
			search_report_grid.column (1).set_title (grid_head_class)
			search_report_grid.column (2).set_title (grid_head_found)
			search_report_grid.column (3).set_title (grid_head_context)
			search_report_grid.column (4).set_title (grid_head_file_location)

			search_report_grid.column (1).header_item.pointer_button_press_actions.force_extend (agent on_grid_header_click (1))
			search_report_grid.column (2).header_item.pointer_button_press_actions.force_extend (agent on_grid_header_click (2))

			search_report_grid.row_select_actions.extend (agent on_grid_row_selected (?))
			search_report_grid.set_item_pebble_function (agent grid_pebble_function (?))
			search_report_grid.set_accept_cursor (Cursors.cur_class)
			search_report_grid.set_deny_cursor (Cursors.cur_x_class)
			search_report_grid.set_minimum_width (100)

			create Result
			Result.extend (frm)
			Result.disable_item_expand (frm)

			create report

			report.extend (search_report_grid)
			Result.extend (report)

		end

	scope : EV_HORIZONTAL_BOX
			-- Scope widget container.

	choose_dialog: EB_CHOOSE_MULTI_CLUSTER_N_CLASS_DIALOG
			-- Dialog used to add classes or clusters to scope

	prepare_interface is
			-- Initialize options' status.
		local
			l_pre : EB_SEARCH_TOOL_DATA
			l_scope: STRING
		do
			l_pre := preferences.search_tool_data
			if l_pre.init_incremental then
				incremental_search_button.enable_select
			else
				incremental_search_button.disable_select
			end
			if l_pre.init_match_case then
				case_sensitive_button.enable_select
			else
				case_sensitive_button.disable_select
			end
			if l_pre.init_only_compiled_classes then
				search_compiled_class_button.enable_select
			else
				search_compiled_class_button.disable_select
			end
			if l_pre.init_search_backwards then
				search_backward_button.enable_select
			else
				search_backward_button.disable_select
			end
			if l_pre.init_subclusters then
				search_subcluster_button.enable_select
			else
				search_subcluster_button.disable_select
			end
			if l_pre.init_use_regular_expression then
				use_regular_expression_button.enable_select
			else
				use_regular_expression_button.disable_select
			end
			if l_pre.init_whole_word then
				whole_word_button.enable_select
			else
				whole_word_button.disable_select
			end
			l_scope := l_pre.init_scope
			if l_scope.is_equal ("Current Editor") then
				current_editor_button.enable_select
				toggle_scope_detail (current_editor_button)
			elseif l_scope.is_equal ("Whole Project") then
				whole_project_button.enable_select
				toggle_scope_detail (whole_project_button)
			elseif l_scope.is_equal ("Custom") then
				custom_button.enable_select
				toggle_scope_detail (custom_button)
			else
				check
					default_xml_not_correctly_done: false
				end
			end
		end

feature {NONE} -- Shortcut button actions

	new_search is
			--
		do
			force_new_search
			search_button_clicked
		end

	expand_all is
			--
		local
			i: INTEGER
			l_row: EV_GRID_ROW
		do
			from
				i := 1
			until
				i > search_report_grid.row_count
			loop
				l_row := search_report_grid.row (i)
				if l_row.is_expandable then
					l_row.expand
				end
				i := i + 1
			end
		end

	collapse_all is
			--
		local
			i: INTEGER
			l_row: EV_GRID_ROW
		do
			from
				i := 1
			until
				i > search_report_grid.row_count
			loop
				l_row := search_report_grid.row (i)
				l_row.collapse
				i := i + 1
			end
		end

feature {NONE} -- Sort data

	on_grid_header_click (a_column_index: INTEGER) is
			-- User click on the column header of index `a_column_index'.
		require
			a_column_index_valid: column_index_valid (a_column_index)
			output_grid_not_destroyed: not search_report_grid.is_destroyed
		local
			l_item: MSR_TEXT_ITEM
		do
			if search_report_grid.header.pointed_divider_index = 0 then
				if sorted_column = a_column_index then
						-- We invert the sorting.
					sorting_order := not sorting_order
				else
					sorted_column := a_column_index
					sorting_order := False
				end
				if search_report_grid.row_count > 0 then
					l_item ?= multi_search_performer.item_matched.first
					if l_item = Void then
						if a_column_index = 1 then
							multi_search_performer.sort_on (multi_search_performer.sort_by_class_name, sorting_order)
							redraw_grid
							select_current_row
						elseif a_column_index = 2 then
							multi_search_performer.sort_on (multi_search_performer.sort_by_found, sorting_order)
							redraw_grid
							select_current_row
						end
					end
				end
			end
		end

	sorted_column: INTEGER
			-- Column on which sorting is done.	

	column_index_valid (a_column_index: INTEGER): BOOLEAN  is
			-- Validate a column index.
		do
			Result := a_column_index > 0 and a_column_index <= search_report_grid.column_count
		end

	sorting_order: BOOLEAN
			-- If True, sort from the smaller to the larger.

feature {NONE} -- Actions handler

	search_button_clicked is
			-- Invokes when search button is clicked.
		do
			check_class_succeed := true
			if new_search_set or not multi_search_performer.is_search_launched then
				dispatch_search
				select_and_show
			else
				go_to_next_found
			end
		end

	on_text_fully_loaded is
			-- Text observer, runs when text is fully loaded.
		do
			Precursor {EB_SEARCH_TOOL}
			if not loaded_actions.is_empty then
				loaded_actions.call ([])
				loaded_actions.wipe_out
			end
			if is_current_editor_searched then
				force_new_search
			end
		end

	key_pressed (k: EV_KEY; search_only: BOOLEAN) is
			-- Key `k' was pressed in the interface.
			-- If k is Enter then launch the search, if it is Esc then hide the search interface.
		do
			if k /= Void then
				if k.code = Key_enter then
					if not keyword_field.text.is_empty and then search_is_possible then
						if search_only then
							search_button_clicked
						else
							replace_current
						end
					end
				elseif k.code = Key_escape then
					close
					ev_application.do_once_on_idle (agent editor.set_focus)
				else
					if search_selection_shortcut.matches (k, ev_application.alt_pressed, ev_application.ctrl_pressed, ev_application.shift_pressed) then
						if not keyword_field.text.is_empty and then search_only then
							search_button_clicked
						end
					elseif search_last_shortcut.matches (k, ev_application.alt_pressed, ev_application.ctrl_pressed, ev_application.shift_pressed) then
						if not keyword_field.text.is_empty and then search_only then
							temp_reverse := true
							search_button_clicked
							temp_reverse := false
						end
					end
				end
			end
		end

	handle_enter_on_button (a_key: EV_KEY; a_pro: PROCEDURE [ANY, TUPLE]) is
			-- Handle enter on buttons.
		do
			if a_key.code = {EV_KEY_CONSTANTS}.key_enter then
				a_pro.apply
			end
		end

	toggle_search_report is
			-- Hide report if it is shown, show it if it is hidden.
		do
			if report.is_show_requested then
				report.hide
				report_button.set_text (Interface_names.l_Search_report_show)
			else
				report.show
				report_button.set_text (Interface_names.l_Search_report_hide)
			end
		end

	toggle_scope_detail (a_button: EV_RADIO_BUTTON) is
			-- Show and hide the scope detail according to the scope box's selection.
		do
			if is_customized then
				scope.enable_sensitive
			else
				scope.disable_sensitive
			end
			if is_whole_project_searched or is_customized then
				search_compiled_class_button.enable_sensitive
			else
				search_compiled_class_button.disable_sensitive
			end
			if notebook /= Void then
				if a_button = current_editor_button then
					if widget /= Void and then is_visible then
						set_focus
					end
				end
				notebook.item_tab (notebook.i_th (2)).set_text (interface_names.l_scope + ": " + a_button.text)
			end

		end

	add_scope is
			-- Add a new scope from a choose dialog to the list.
		do
			if choose_dialog = Void or else choose_dialog.is_destroyed then
				create choose_dialog.make
				choose_dialog.set_class_add_action (agent add_class_item (?))
				choose_dialog.set_cluster_add_action (agent add_cluster_item (?))
				choose_dialog.show_relative_to_window (manager.window)
				choose_dialog.default_push_button.select_actions.extend (agent force_new_search)
			end
			choose_dialog.set_focus
		end

	on_drop_custom_button (a_any: ANY) is
			-- Invoke hen dropping on the scope check button.
		do
			custom_button.enable_select
			on_drop_add (a_any)
		end

	on_drop_add (a_any: ANY) is
			-- Invoke when dropping a pebble to add an item to the scope.
		require
			a_any_not_void: a_any /= Void
		local
			l_classi_stone: CLASSI_STONE
			l_cluster_stone: CLUSTER_STONE
		do
			l_classi_stone ?= a_any
			l_cluster_stone ?= a_any
			if l_classi_stone /= Void then
				add_class_item (l_classi_stone.class_i)
			end
			if l_cluster_stone /= Void then
				add_cluster_item (l_cluster_stone.cluster_i)
			end
		end

	on_drop_remove (a_any: ANY) is
			-- Invoke when dropping a pebble on remove button.
		require
			a_any_not_void: a_any /= Void
		local
			l_classi_stone: CLASSI_STONE
			l_cluster_stone: CLUSTER_STONE
		do
			l_classi_stone ?= a_any
			l_cluster_stone ?= a_any
			if l_classi_stone /= Void then
				remove_class_item (l_classi_stone.class_i)
			end
			if l_cluster_stone /= Void then
				remove_cluster_item (l_cluster_stone.cluster_i)
			end
		end

	on_text_edited (directly_edited: BOOLEAN) is
			-- Notify observers that some text has been modified.
			-- If `directly_edited', the user has modified the text in the editor,
			-- not via another tool or wizard.
		local
			l_class_stone: CLASSI_STONE
		do
			force_new_search
			is_text_changed_in_editor := true
			if is_text_new_loaded and then multi_search_performer.is_search_launched and then not multi_search_performer.is_empty then
				l_class_stone ?= manager.stone
				if l_class_stone /= Void and not changed_by_replace then
					class_changed (l_class_stone.class_i)
				end
				is_text_new_loaded := false
			end
			set_changed_by_replace (false)
		end

	on_text_reset is
			-- Obsever reset action.
		do
			is_text_changed_in_editor := false
			is_text_new_loaded := true
		end

	enable_disable_search_button is
			-- disable the search buton if the search field is empty, incremental search if it is possible.
		local
			l_editor: like old_editor
		do
			if search_is_possible then
				search_button.enable_sensitive
				replace_button.enable_sensitive
				replace_all_click_button.enable_sensitive
				if not editor.is_empty and then is_incremental_search then
					l_editor := old_editor
					old_editor := editor
					incremental_search (keyword_field.text)
					if not multi_search_performer.off then
						select_in_current_editor
					else
						editor.deselect_all
					end
					old_editor := l_editor
				end
			else
				editor.deselect_all
				search_button.disable_sensitive
				replace_button.disable_sensitive
				replace_all_click_button.disable_sensitive
			end
			if old_search_key_value /= Void and then not old_search_key_value.is_equal (keyword_field.text) then
				force_new_search
			end
		end

	on_drop_notebook (a_stone: STONE) is
			-- When dropping on tabs of notebook.
		local
			l_filed_stone: FILED_STONE
		do
			inspect notebook.pointed_tab_index
			when 1 then
				notebook.select_item (notebook.i_th (1))
				l_filed_stone ?= a_stone
				if l_filed_stone /= Void then
					display_stone_signature (keyword_field, l_filed_stone)
				end
			when 2 then
				notebook.select_item (notebook.i_th (2))
				on_drop_custom_button (a_stone)
			else
			end
		end

	notebook_veto_pebble (a_stone: STONE) : BOOLEAN is
			-- Notebook veto pebble
		local
			l_classc_stone: CLASSC_STONE
			l_cluster_stone: CLUSTER_STONE
		do
			inspect notebook.pointed_tab_index
			when 1 then
				Result := true
			when 2 then
				l_classc_stone ?= a_stone
				l_cluster_stone ?= a_stone
				if l_classc_stone /= Void or else l_cluster_stone /= Void then
					Result := true
				end
			else
			end
		end

	on_notebook_selected is
			-- On notebook selected.
		do
			if notebook.pointed_tab_index = 1 then
				if widget /= Void and is_visible then
					set_focus
				end
			end
		end

feature {EB_DEVELOPMENT_WINDOW} -- Notification

	class_changed (a_class: CLASS_I) is
			-- Remenber `a_class' as a user changed class since last search.
		do
			if a_class /= Void and then not changed_classes.has (a_class) then
				changed_classes.extend (a_class)
			end
		end

feature {NONE} -- Search perform

	dispatch_search is
			-- Dispatch search.
		do
			if is_whole_project_searched then
				search_whole_project
			elseif is_customized then
				search_in_scope
			else
				if shown then
					if search_button.is_sensitive then
						if new_search_set or not multi_search_performer.is_search_launched then
							search
						end
						if not editor.has_focus then
							editor.set_focus
						end
					end
				else
					if new_search_set or not multi_search_performer.is_search_launched then
						default_search
					end
				end
			end
		end

	incremental_search (a_word: STRING) is
			-- Incremental search in the editor displayed text
		local
			incremental_search_strategy: MSR_SEARCH_INCREMENTAL_STRATEGY
			class_i: CLASS_I
			file_name: FILE_NAME
			class_name: STRING
			class_stone: CLASSI_STONE
		do
			manager.window.set_pointer_style (default_pixmaps.wait_cursor)
			if not editor.is_empty then
				currently_searched := a_word
				class_stone ?= manager.stone
				if class_stone /= Void then
					class_i := class_stone.class_i
					file_name:= class_i.file_name
					class_name := class_i.name
				else
					class_name := ""
					create file_name.make
				end
				if editor.text_displayed.reading_text_finished then
					create incremental_search_strategy.make (currently_searched, surrounding_text_number, class_name, file_name, editor.text_displayed.text)
					if case_sensitive_button.is_selected then
						incremental_search_strategy.set_case_sensitive
					else
						incremental_search_strategy.set_case_insensitive
					end
					incremental_search_strategy.set_regular_expression_used (use_regular_expression_button.is_selected)
					incremental_search_strategy.set_whole_word_matched (whole_word_button.is_selected)
					if class_i /= Void then
						incremental_search_strategy.set_data (class_i)
						incremental_search_strategy.set_date (class_i.date)
					end
					if manager.class_name /= Void then
						incremental_search_strategy.set_class_name (manager.class_name)
					end
					multi_search_performer.set_search_strategy (incremental_search_strategy)
					multi_search_performer.do_search
					multi_search_performer.start
					force_new_search
				end
			end
			manager.window.set_pointer_style (default_pixmaps.standard_cursor)
		end

	search is
			-- Search in editor.
		local
			text_strategy: MSR_SEARCH_TEXT_STRATEGY
			class_i: CLASS_I
			file_name: FILE_NAME
			class_name: STRING
			class_stone: CLASSI_STONE
		do
			manager.window.set_pointer_style (default_pixmaps.wait_cursor)
			currently_searched := keyword_field.text
			class_stone ?= manager.stone
			if class_stone /= Void then
				class_i := class_stone.class_i
				file_name := class_i.file_name
				if not is_main_editor then
					create file_name.make_from_string ("-")
				end
				class_name := class_i.name
			else
				class_name := "Not a class"
				create file_name.make
			end
			if not editor.is_empty then
				create text_strategy.make (currently_searched, surrounding_text_number, class_name, file_name, editor.text_displayed.text)
				multi_search_performer.set_search_strategy (text_strategy)
				if case_sensitive_button.is_selected then
					text_strategy.set_case_sensitive
				else
					text_strategy.set_case_insensitive
				end
				text_strategy.set_regular_expression_used (use_regular_expression_button.is_selected)
				text_strategy.set_whole_word_matched (whole_word_button.is_selected)
				if class_i /= Void then
					text_strategy.set_data (class_i)
					text_strategy.set_date (class_i.date)
				end
				multi_search_performer.do_search
				update_combo_box_specific (keyword_field, currently_searched)
				after_search
				extend_and_run_loaded_action (agent go_to_next_found_perform (reverse))
				update_combo_box_specific (keyword_field, currently_searched)
			end
			manager.window.set_pointer_style (default_pixmaps.standard_cursor)
		end

	default_search is
			-- Search with default options.
		local
			text_strategy: MSR_SEARCH_TEXT_STRATEGY
			class_i: CLASS_I
			file_name: FILE_NAME
			class_name: STRING
			class_stone: CLASSI_STONE
		do
			manager.window.set_pointer_style (default_pixmaps.wait_cursor)
			if currently_searched /= Void and then not currently_searched.is_empty then
					-- search is possible but the search box is not shown
					-- default options
				currently_searched := keyword_field.text
				class_stone ?= manager.stone
				if class_stone /= Void then
					class_i := class_stone.class_i
					file_name := class_i.file_name
					class_name := class_i.name
				else
					class_name := "Not a class"
					create file_name.make
				end
				if not editor.is_empty then
					create text_strategy.make (currently_searched, surrounding_text_number, class_name, file_name, editor.text_displayed.text)
					multi_search_performer.set_search_strategy (text_strategy)
					if case_sensitive_button.is_selected then
						text_strategy.set_case_sensitive
					else
						text_strategy.set_case_insensitive
					end
					text_strategy.set_regular_expression_used (true)
					text_strategy.set_whole_word_matched (false)
					if class_i /= Void then
						text_strategy.set_data (class_i)
						text_strategy.set_date (class_i.date)
					end
					multi_search_performer.do_search
					update_combo_box_specific (keyword_field, currently_searched)
					after_search
					extend_and_run_loaded_action (agent go_to_next_found_perform (reverse))
				end
			end
			manager.window.set_pointer_style (default_pixmaps.standard_cursor)
		end

	search_whole_project is
			-- Search the whole project.
		local
			l_project_strategy: MSR_SEARCH_WHOLE_PROJECT_STRATEGY
		do
			manager.window.set_pointer_style (default_pixmaps.wait_cursor)
			currently_searched := keyword_field.text
			create l_project_strategy.make (currently_searched, surrounding_text_number, clusters_in_the_project, only_compiled_class_searched)
			if is_case_sensitive then
				l_project_strategy.set_case_sensitive
			else
				l_project_strategy.set_case_insensitive
			end
			l_project_strategy.set_regular_expression_used (is_regular_expression_used)
			l_project_strategy.set_whole_word_matched (is_whole_word_matched)
			multi_search_performer.set_search_strategy (l_project_strategy)
			multi_search_performer.do_search
			update_combo_box_specific (keyword_field, currently_searched)
			after_search
			old_editor := Void
			extend_and_run_loaded_action (agent go_to_next_found_perform (reverse))
			manager.window.set_pointer_style (default_pixmaps.standard_cursor)
		end

	search_in_scope is
			-- Search in scope.
		local
			l_scope_strategy: MSR_SEARCH_IN_SCOPE_STRATEGY
		do
			manager.window.set_pointer_style (default_pixmaps.wait_cursor)
			currently_searched := keyword_field.text
			create l_scope_strategy.make (currently_searched, surrounding_text_number, scope_list, only_compiled_class_searched)
			if is_case_sensitive then
				l_scope_strategy.set_case_sensitive
			else
				l_scope_strategy.set_case_insensitive
			end
			l_scope_strategy.set_regular_expression_used (is_regular_expression_used)
			l_scope_strategy.set_subcluster_searched (is_sub_cluster_searched)
			l_scope_strategy.set_whole_word_matched (is_whole_word_matched)
			multi_search_performer.set_search_strategy (l_scope_strategy)
			multi_search_performer.do_search
			update_combo_box_specific (keyword_field, currently_searched)
			after_search
			old_editor := Void
			manager.window.set_pointer_style (default_pixmaps.standard_cursor)
		end

	after_search is
			-- When a search done, go here. Incremental search excluded.
		do
			if multi_search_performer.is_search_launched then
				old_search_key_value := currently_searched
				old_editor := editor
				redraw_grid
				changed_classes.wipe_out
				extend_and_run_loaded_action (agent force_not_changed)
			end
		end

feature {NONE} -- Search report

	compute_adjust_vertical (a_font: EV_FONT; a_label_item: EV_GRID_ITEM) is
			-- Compute `adjust_vertical'
		require
			font_attached: a_font /= Void
			label_item_attached: a_label_item /= Void
		local
			vertical_text_offset_into_available_space: INTEGER
			label_item: EV_GRID_LABEL_ITEM
			client_height: INTEGER
		do
			if adjust_vertical = 0 then
				label_item ?= a_label_item
				if label_item /= Void then
					if text_height = 0 then
						text_height := a_font.string_size ("a").integer_item (2)
					end
					client_height := label_item.height - label_item.top_border - label_item.bottom_border
					vertical_text_offset_into_available_space := client_height - text_height - 1
					if label_item.is_top_aligned then
						vertical_text_offset_into_available_space := 0
					elseif label_item.is_bottom_aligned then
					else
						vertical_text_offset_into_available_space := vertical_text_offset_into_available_space // 2
					end
					vertical_text_offset_into_available_space := vertical_text_offset_into_available_space.max (0)
					adjust_vertical := vertical_text_offset_into_available_space + label_item.top_border
				end
			end
		end

	new_label_item (a_string: STRING): EV_GRID_LABEL_ITEM is
			-- Create uniformed label item
		require
			string_attached: a_string /= Void
		local
			l_color: EV_COLOR
		do
			create Result.make_with_text (a_string)
			l_color := search_report_grid.background_color
			Result.set_foreground_color (row_text_color (l_color))
		ensure
			new_item_not_void: Result /= Void
		end

	label_font: EV_FONT is
			-- Font of report text.
		local
			l_label: EV_LABEL
		once
			create l_label
			Result := l_label.font
		end

	adjust_vertical: INTEGER
			-- Offset between top of a row and top of charactors in it, buffer for effiency enhancement

	text_height: INTEGER
			-- Height of the text in the `search_report_grid', buffer for effiency enhancement

	expose_drawable_action (drawable: EV_DRAWABLE; a_item: MSR_ITEM; query_grid_row: EV_GRID_ROW) is
			-- Draw grid item, to make the text colorfull.
			-- return width of current drawable item.
		local
			offset: INTEGER
			row_selected, focused: BOOLEAN
			l_color, focused_sel_color, non_focused_sel_color: EV_COLOR
			font: EV_FONT
			l_item: MSR_TEXT_ITEM
		do
			font := label_font
			focused_sel_color := search_report_grid.focused_selection_color
			non_focused_sel_color := search_report_grid.non_focused_selection_color
			if adjust_vertical = 0 then
				compute_adjust_vertical (font, query_grid_row.item (1))
			end
			drawable.clear
			drawable.set_font (font)
			row_selected := query_grid_row.is_selected
			focused := search_report_grid.has_focus
			if row_selected then
				if focused then
					drawable.set_foreground_color(focused_sel_color)
				else
					drawable.set_foreground_color(non_focused_sel_color)
				end
			else
				drawable.set_foreground_color (search_report_grid.background_color)
			end
			l_color := row_text_color (drawable.foreground_color)

			drawable.fill_rectangle (0, 0, drawable.width,drawable.height)
			l_item ?= a_item
			if l_item /= Void then
				drawable.set_foreground_color (l_color)
				drawable.draw_text_top_left (0, adjust_vertical,
											l_item.context_text.substring (1, l_item.start_index_in_context_text - 1))
				if not row_selected then
					drawable.set_foreground_color (preferences.editor_data.operator_text_color)
				end
				offset := font.string_width (l_item.context_text.substring (1, l_item.start_index_in_context_text - 1))

				drawable.draw_text_top_left (offset, adjust_vertical, replace_rnt_to_space (l_item.text))
				drawable.set_foreground_color (l_color)
				offset := font.string_width (l_item.context_text.substring (1, l_item.start_index_in_context_text + l_item.text.count - 1))

				drawable.draw_text_top_left (offset,
											adjust_vertical,
											l_item.context_text.substring (l_item.start_index_in_context_text + l_item.text.count,
																			l_item.context_text.count))
			else
				drawable.draw_text (0, adjust_vertical, "-")
			end
		end

	row_text_color (a_bg_color: EV_COLOR): EV_COLOR is
			-- Text color according to its background color `a_bg_color'
		require
			bg_color_attached: a_bg_color  /= Void
		do
			if a_bg_color.lightness > 0.6 then
				create Result.make_with_rgb (0, 0, 0)
			else
				create Result.make_with_rgb (1, 1, 1)
			end
		end

	report_summary_string: STRING

	redraw_grid is
			-- Redraw grid according to search result and refresh summary label.
		local
			l_index: INTEGER
			i, j, k: INTEGER
			row_count: INTEGER
			submatch_parent: INTEGER
			arrayed_list: ARRAYED_LIST[MSR_ITEM]
			l_item: MSR_ITEM
			l_class_item: MSR_CLASS_ITEM
			l_text_item: MSR_TEXT_ITEM
			l_grid_drawable_item: EV_GRID_DRAWABLE_ITEM
			l_grid_label_item: EV_GRID_LABEL_ITEM
			l_class_i: CLASS_I
			font: EV_FONT
			l_new_row: EV_GRID_ROW
		do
			if multi_search_performer.is_search_launched then
				if not multi_search_performer.is_empty then
					l_class_item ?= multi_search_performer.item_matched.first
					if l_class_item /= Void then
						search_report_grid.column (1).set_title (grid_head_class)
					else
						search_report_grid.column (1).set_title (grid_head_line_number)
					end
				end
				search_report_grid.remove_and_clear_all_rows
				report_summary_string := "   " +
										multi_search_performer.text_found_count.out +
										" found(s) in " +
										multi_search_performer.class_count.out +
										" class(es)"
				summary_label.set_text (report_summary_string)
				new_search_tool_bar.hide

				l_index := multi_search_performer.index
				font := label_font
				from
					arrayed_list := multi_search_performer.item_matched
					arrayed_list.start
					row_count := search_report_grid.row_count + 1
					i := 0
					j := 0
					k := 0
				until
					arrayed_list.after
				loop
					l_item := arrayed_list.item

					l_class_item ?= arrayed_list.item
					if l_class_item /= Void then
						j := j + 1
						search_report_grid.insert_new_row (row_count)
						l_new_row := search_report_grid.row (row_count)
						l_new_row.set_data (l_class_item)
						if i /= 0 then
							search_report_grid.set_item (2, i, new_label_item (k.out))
							search_report_grid.item (2, i).set_foreground_color (preferences.editor_data.number_text_color_preference.value)
							extend_pointer_actions (search_report_grid.row (i))
						end
						i := row_count
						create l_grid_label_item.make_with_text (l_item.class_name)
						l_class_i ?= l_class_item.data
						if l_class_i /= Void then
							l_grid_label_item.set_pixmap (pixmap_from_class_i (l_class_i))
						end
						search_report_grid.set_item (1, row_count, l_grid_label_item)
						search_report_grid.set_item (3,
													row_count,
													new_label_item (once "-"))
						search_report_grid.set_item (4,
													row_count,
													new_label_item (l_item.path))
						k := 0
					else
						l_text_item ?= l_item
						if l_text_item /= Void then
							k := k + 1
							if i /= 0 then
								search_report_grid.insert_new_row_parented (row_count, search_report_grid.row (i))
								l_new_row := search_report_grid.row (row_count)
								l_new_row.set_data (l_text_item)
							end
							if row_count > search_report_grid.row_count then
								search_report_grid.insert_new_row (row_count)
								l_new_row := search_report_grid.row (row_count)
								l_new_row.set_data (l_text_item)
							end
							search_report_grid.set_item (1,
														row_count,
														new_label_item ("Line " + l_text_item.line_number.out + ":"))
							search_report_grid.set_item (2,
														row_count,
														new_label_item (replace_rnt_to_space (l_text_item.text)))
							search_report_grid.item (2, row_count).set_foreground_color (preferences.editor_data.operator_text_color)
							create l_grid_drawable_item
							search_report_grid.set_item (3, row_count, l_grid_drawable_item)
							l_grid_drawable_item.expose_actions.extend (agent expose_drawable_action (?, l_item, search_report_grid.row (row_count)))
							l_grid_drawable_item.set_required_width (font.string_width (l_text_item.context_text))
							search_report_grid.set_item (4, row_count, new_label_item (l_item.path))
							extend_pointer_actions (l_new_row)
							if not l_text_item.captured_submatches.is_empty then
								submatch_parent := row_count
								search_report_grid.row (row_count).ensure_expandable
								from
									l_text_item.captured_submatches.start
								until
									l_text_item.captured_submatches.after
								loop
									row_count := row_count + 1
									search_report_grid.insert_new_row_parented (row_count, search_report_grid.row (submatch_parent))
									search_report_grid.set_item (1,
																row_count,
																new_label_item ("Capture " +
																				l_text_item.captured_submatches.index.out +
																				": " +
																				l_text_item.captured_submatches.item))
									l_text_item.captured_submatches.forth
								end
							end
						end
					end
					row_count := row_count + 1
					arrayed_list.forth
				end
				if i /= 0 then
					search_report_grid.set_item (2, i, new_label_item (k.out))
					search_report_grid.item (2, i).set_foreground_color (preferences.editor_data.number_text_color)
				end
				multi_search_performer.go_i_th (l_index)
			end
			adjust_grid_column_width
		end

	extend_pointer_actions (a_row: EV_GRID_ROW) is
			-- Extend pointer actions to every row item.
		require
			a_row_attached: a_row /= Void
		local
			i: INTEGER
		do
			from
				i := 1
			until
				i > a_row.count
			loop
				a_row.item (i).pointer_button_press_actions.extend (agent on_grid_row_clicked (?, ?, ?, ?, ?, ?, ?, ?, a_row))
				i := i + 1
			end
		end

	on_grid_row_clicked (a, b, c : INTEGER; d, e, f: DOUBLE; g, h: INTEGER; a_row: EV_GRID_ROW) is
			-- A row is clicked by mouse pointer.
		do
			if not search_report_grid.selected_rows.is_empty then
				if search_report_grid.selected_rows.first = a_row then
					on_grid_row_selected (a_row)
				end
			end
		end

	adjust_grid_column_width is
			-- Adjust grid column width to best fit visible area.
		local
			i: INTEGER
			l_grid_width: INTEGER
			col : EV_GRID_COLUMN
			full_width: INTEGER
			temp_width: INTEGER
			l_width: INTEGER
			l_required_width: ARRAYED_LIST [INTEGER]
		do
			if search_report_grid.row_count /= 0 then
				create l_required_width.make (search_report_grid.column_count)
				from
					i := 1
				until
					i > search_report_grid.column_count
				loop
					col := search_report_grid.column (i)
					l_required_width.extend (col.required_width_of_item_span (1, col.parent.row_count))
					full_width := full_width + (header_width @ i).max (l_required_width @ i)
					i := i + 1
				end
				l_grid_width := search_report_grid.width
				from
					i := 1
				until
					i > search_report_grid.column_count
				loop
					col := search_report_grid.column (i)
					temp_width := (header_width @ i).max (l_required_width @ i)
					l_width := ((temp_width / full_width) * l_grid_width).floor
					if l_width > temp_width then
						l_width := temp_width
					end
					l_width := l_width-- + column_border_space
					col.set_width (l_width)
					i := i + 1
				end
			end
		end

	on_grid_row_selected (a_row: EV_GRID_ROW) is
			-- Invoke when a row of the report grid selected
		require
			a_row_not_void: a_row /= Void
		local
			l_item: MSR_ITEM
		do
			check_class_succeed := true
			if a_row.parent /= Void and then a_row.parent_row /= Void and then a_row.parent_row.is_expandable and then not a_row.parent_row.is_expanded then
				a_row.parent_row.expand
				adjust_grid_column_width
			end
			a_row.ensure_visible
			l_item ?= a_row.data
			if l_item /= Void then
				multi_search_performer.start
				multi_search_performer.search (l_item)
				if multi_search_performer.is_search_launched and then not multi_search_performer.off then
					check_class_file_and_do (agent on_grid_row_selected_perform)
				end
			end
		end

	on_grid_row_selected_perform is
			-- Do actual `on_grid_row_selected'
		local
			l_text_item: MSR_TEXT_ITEM
			l_editor: EB_EDITOR
		do
			new_search_set := false
			l_text_item ?= multi_search_performer.item
			if l_text_item /= Void then
				if old_editor /= Void then
					l_editor := old_editor
				else
					l_editor := editor
				end
--				if old_editor /= editor implies (not is_item_source_changed (l_text_item)) then
				if (not is_item_source_changed (l_text_item)) then
					if l_text_item.end_index_in_unix_text + 1 > l_text_item.start_index_in_unix_text then
						if l_editor.text_is_fully_loaded then
							l_editor.select_region (l_text_item.start_index_in_unix_text, l_text_item.end_index_in_unix_text + 1)
						end
					elseif l_text_item.end_index_in_unix_text + 1 = l_text_item.start_index_in_unix_text then
						l_editor.text_displayed.cursor.go_to_position (l_text_item.end_index_in_unix_text + 1)
						l_editor.deselect_all
					end
					if l_editor.has_selection then
						l_editor.show_selection (False)
					end
					l_editor.refresh_now
					summary_label.set_text (report_summary_string)
					new_search_tool_bar.hide
				else
					summary_label.set_text (report_summary_string + "   Item selected has expired.")
					new_search_tool_bar.show
				end
			else
				summary_label.set_text (report_summary_string)
				new_search_tool_bar.hide
			end
		end

	changed_classes: ARRAYED_LIST [CLASS_I]
			-- Keep a record of modified class by editor.

	select_current_row is
			-- Select current row in the grid
		require
			search_launched: multi_search_performer.is_search_launched
		local
			l_row: EV_GRID_ROW
			l_row_index: INTEGER
			l_selected_rows: ARRAYED_LIST [EV_GRID_ROW]
		do
			if not multi_search_performer.off then
				l_row := grid_row_by_data (search_report_grid, multi_search_performer.item)
			end
			if l_row /= Void then
				l_row_index := l_row.index
			elseif search_report_grid.row_count > 0 then
				l_row_index := 1
			end
			l_selected_rows := search_report_grid.selected_rows
			if not l_selected_rows.is_empty then
				(l_selected_rows @ 1).disable_select
			end
			search_report_grid.select_row (l_row_index)
		end

	grid_row_by_data (a_grid: ES_GRID; a_data: ANY) : EV_GRID_ROW is
			-- Find a row in a_grid that include a_data
		local
			i: INTEGER
			l_row: EV_GRID_ROW
			loop_end: BOOLEAN
		do
			loop_end := false
			from
				i := 1
			until
				i > a_grid.row_count or loop_end
			loop
				l_row := a_grid.row (i)
				if l_row.data /= Void and then l_row.data = a_data then
					Result := l_row
					loop_end := true
				end
				i := i + 1
			end
		end

feature {NONE} -- Replacement Implementation

	replace_current_perform is
			-- Do actual `replace_current'.
		local
			editor_replace_strategy: MSR_REPLACE_IN_ESTUDIO_STRATEGY
		do
			create editor_replace_strategy.make (current)
			currently_replacing := replace_combo_box.text
			multi_search_performer.set_replace_strategy (editor_replace_strategy)
			multi_search_performer.set_replace_string (currently_replacing)
			multi_search_performer.replace
			update_combo_box_specific (replace_combo_box, currently_replacing)
			force_not_changed
		end

	replace_all is
			-- Replace all matches in specified scale.
		local
			editor_replace_strategy: MSR_REPLACE_IN_ESTUDIO_STRATEGY
		do
			check_class_succeed := true
			manager.window.set_pointer_style (default_pixmaps.wait_cursor)
			currently_replacing := replace_combo_box.text
			if is_current_editor_searched then
				search_button_clicked
			else
				if
					new_search_set or else
					not multi_search_performer.is_search_launched
				then
					search_button_clicked
				end
			end
			if multi_search_performer.is_search_launched then
				create editor_replace_strategy.make (current)
				multi_search_performer.set_replace_strategy (editor_replace_strategy)
				multi_search_performer.set_replace_string (currently_replacing)
				multi_search_performer.replace_all
				update_combo_box_specific (replace_combo_box, currently_replacing)
				redraw_grid
			end
			manager.window.set_pointer_style (default_pixmaps.standard_cursor)
		end

feature {NONE} -- Destroy behavior.

	save_preferences is
			-- Save preferences. All options' status.
		local
			l_pre : EB_SEARCH_TOOL_DATA
		do
			l_pre := preferences.search_tool_data
			l_pre.init_incremental_preference.set_value (is_incremental_search)
			preferences.preferences.save_preference (l_pre.init_incremental_preference)

			l_pre.init_match_case_preference.set_value (is_case_sensitive)
			preferences.preferences.save_preference (l_pre.init_match_case_preference)

			l_pre.init_only_compiled_classes_preference.set_value (only_compiled_class_searched)
			preferences.preferences.save_preference (l_pre.init_only_compiled_classes_preference)

			l_pre.init_search_backwards_preference.set_value (search_backward_button.is_selected)
			preferences.preferences.save_preference (l_pre.init_search_backwards_preference)

			l_pre.init_subclusters_preference.set_value (is_sub_cluster_searched)
			preferences.preferences.save_preference (l_pre.init_subclusters_preference)

			l_pre.init_use_regular_expression_preference.set_value (is_regular_expression_used)
			preferences.preferences.save_preference (l_pre.init_use_regular_expression_preference)

			l_pre.init_whole_word_preference.set_value (is_whole_word_matched)
			preferences.preferences.save_preference (l_pre.init_whole_word_preference)

			if is_current_editor_searched then
				l_pre.init_scope_preference.set_selected_index (1)
			elseif is_whole_project_searched then
				l_pre.init_scope_preference.set_selected_index (2)
			elseif is_customized then
				l_pre.init_scope_preference.set_selected_index (3)
			end
			preferences.preferences.save_preference (l_pre.init_scope_preference)
		end

	recycle is
			-- Recycle
		do
			save_preferences
			Precursor {EB_SEARCH_TOOL}
		end

feature {NONE} -- Implementation

	go_to_next_found_perform (b: BOOLEAN) is
			-- Do actual `go_to_next_found'.
		local
			l_list: LIST [CLASS_I]
			l_class_i: CLASS_I
			l_pos: INTEGER
			l_text: EDITABLE_TEXT
			l_text_item: MSR_TEXT_ITEM
			l_selected: BOOLEAN
		do
			if multi_search_performer.is_search_launched and then not multi_search_performer.item_matched.is_empty then
				if manager.class_name /= Void then
					l_list := manager.eiffel_universe.classes_with_name (manager.class_name)
					if not l_list.is_empty then
						l_class_i := l_list.first
					end
				end
				l_text := editor.text_displayed
				if editor.text_displayed.has_selection then
					if b then
						l_pos := l_text.selection_start.pos_in_text
					else
						l_pos := l_text.selection_end.pos_in_text
					end
				elseif l_text.cursor /= Void then
					l_pos := l_text.cursor.pos_in_characters
				end
				if not multi_search_performer.off then
					l_text_item ?= multi_search_performer.item
					if l_text_item /= Void and then ((old_editor = Void or old_editor = editor) implies is_item_source_changed (l_text_item)) then
						multi_search_performer.go_to_next_text_item (b)
						select_current_row
						l_selected := true
					end
				end
				if not l_selected then
					multi_search_performer.go_to_closest_item (l_pos, b, l_class_i, (is_main_editor and manager.class_name /= Void) or not is_current_editor_searched)
					go_to_next_need_select_and_show := true
					if (not multi_search_performer.off) and then is_item_source_changed (multi_search_performer.item) then
						multi_search_performer.start
						if l_text_item /= Void then
							multi_search_performer.search (l_text_item)
						end
						multi_search_performer.go_to_next_text_item (b)
						go_to_next_need_select_and_show := false
						select_current_row
					end
				end
			end
		end

	go_to_next_found_select_and_show is
			--
		do
			if go_to_next_need_select_and_show then
				select_and_show
				go_to_next_need_select_and_show := false
			end
		end

	go_to_next_need_select_and_show : BOOLEAN

	check_class_file is
			-- Check if class of current selected item is loaded. If not, load it.
			-- After check run `a_pro'.
		local
			l_item: MSR_ITEM
			l_list: LIST [CLASS_I]
			class_name: STRING
			l_stone: STONE
		do
			check_class_succeed := true
			if not multi_search_performer.off then
				l_stone := manager.stone
				l_item := multi_search_performer.item
				create class_name.make_from_string (l_item.class_name)
				class_name.to_upper
				l_list := manager.eiffel_universe.classes_with_name (class_name)
				if manager.class_name /= Void and then not manager.class_name.is_equal (l_item.class_name) then
					if not l_list.is_empty then
						manager.set_stone (stone_from_class_i (l_list.first))
						if l_stone /= manager.stone then
							is_text_changed_in_editor := false
						else
							loaded_actions.wipe_out
							check_class_succeed := false
						end
					end
				elseif not is_current_editor_searched then
					manager.set_stone (stone_from_class_i (l_list.first))
					if l_stone = manager.stone then
						loaded_actions.wipe_out
						check_class_succeed := false
					end
				end
				if not is_current_editor_searched and l_stone /= manager.stone then
					manager.editor_tool.text_area.set_focus
				end
			end
		end

	extend_and_run_loaded_action (a_pro: PROCEDURE [ANY, TUPLE]) is
			-- Insert `a_pro' to loaded_actions and run all actions in it.
		local
			l_pro: PROCEDURE [ANY, TUPLE]
			loop_end : BOOLEAN
		do
			if check_class_succeed then
				loaded_actions.extend (a_pro)
				block_actions
				blocking_actions_times := blocking_actions_times + 1
				from
					loaded_actions.start
				until
					loaded_actions.count = 0 or loop_end
				loop
					if editor.text_is_fully_loaded or editor.is_empty then
						l_pro := loaded_actions.item
						loaded_actions.remove
						l_pro.call ([])
					else
						loop_end := true
					end
				end
				if blocking_actions_times <= 1 then
					resume_actions
					blocking_actions_times := 0
				else
					blocking_actions_times := blocking_actions_times - 1
				end
			end
		end

	check_class_file_and_do (a_pro: PROCEDURE [ANY, TUPLE]) is
			-- Check class before insert `a_pro' to loaded_actions and run all actions in it.
		do
			extend_and_run_loaded_action (agent check_class_file)
			extend_and_run_loaded_action (a_pro)
		end

	loaded_actions: EV_NOTIFY_ACTION_SEQUENCE
			-- Actions that are invoked sequently when text is fully loaded


	stone_from_class_i (a_class_i: CLASS_I): STONE is
			-- Make a stone from a_class_i.
			-- If a_class_i compiled returns CLASSC_STONE , or a CLASSI_STONE.
		require
			a_class_i_not_void: a_class_i /= Void
		local
			l_class_c: CLASS_C
		do
			l_class_c := a_class_i.compiled_class
			if l_class_c /= Void then
				create {CLASSC_STONE}Result.make (l_class_c )
			else
				create {CLASSI_STONE}Result.make (a_class_i)
			end
			Result.set_pos_container (manager.managed_main_formatters.first)
		end

	is_text_changed_in_editor: BOOLEAN
			-- Text changed in the editor?

	is_text_new_loaded: BOOLEAN
			-- Text loaded in the editor?

	add_class_item (a_class: CLASS_I) is
			-- Add a class item to the tree.
		require
			a_class_not_void: a_class /= Void
		local
			l_item: EV_LIST_ITEM
		do
			l_item := scope_list.retrieve_item_by_data (a_class, false)
			if l_item = Void then
				create l_item.make_with_text (a_class.name)
				l_item.set_pixmap (pixmap_from_class_i (a_class))
				scope_list.extend (l_item)
				l_item.set_data (a_class)
				l_item.set_pebble_function (agent scope_pebble_function (a_class))
				l_item.set_accept_cursor (Cursors.cur_class)
				l_item.set_deny_cursor (Cursors.cur_x_class)
				force_new_search
			end
		end

	remove_class_item (a_class: CLASS_I) is
			-- Remove a class item from the list.
		require
			a_class_not_void: a_class /= Void
		local
			l_item: EV_LIST_ITEM
		do
			l_item := scope_list.retrieve_item_by_data (a_class, false)
			scope_list.prune_all (l_item)
			force_new_search
		end

	remove_cluster_item (a_cluster: CLUSTER_I) is
			-- Remove a class item from the list.
		require
			a_cluster_not_void: a_cluster /= Void
		local
			l_item: EV_LIST_ITEM
		do
			l_item := scope_list.retrieve_item_by_data (a_cluster, false)
			scope_list.prune_all (l_item)
			force_new_search
		end

	add_cluster_item (a_cluster: CLUSTER_I) is
			-- Add a cluster item to the list.
		require
			a_cluster_not_void: a_cluster /= Void
		local
			l_item: EV_LIST_ITEM
		do
			l_item := scope_list.retrieve_item_by_data (a_cluster, false)
			if l_item = Void then
				create l_item.make_with_text (a_cluster.display_name)
				l_item.set_pixmap (pixmap_from_cluster_i (a_cluster))
				scope_list.extend (l_item)
				l_item.set_data (a_cluster)
				l_item.set_pebble_function (agent scope_pebble_function (a_cluster))
				l_item.set_accept_cursor (Cursors.cur_cluster)
				l_item.set_deny_cursor (Cursors.cur_x_class)
				force_new_search
			end
		end

	scope_pebble_function (a_data: ANY) : STONE is
			-- Scope pebble function
		local
			l_class_i: CLASS_I
			l_cluster_i: CLUSTER_I
		do
			l_class_i ?= a_data
			l_cluster_i ?= a_data
			if l_class_i /= Void then
				Result := stone_from_class_i (l_class_i)
			end
			if l_cluster_i /= Void then
				create {CLUSTER_STONE}Result.make (l_cluster_i)
			end
		end

	grid_pebble_function (a_item: EV_GRID_ITEM) : STONE is
			-- Grid pebble function
		local
			l_row: EV_GRID_ROW
			l_item: MSR_ITEM
			l_class_name: STRING
			l_list: LIST [CLASS_I]
		do
			if a_item /= Void then
				l_row := a_item.row
				l_item ?= l_row.data
				if l_item /= Void then
					create l_class_name.make_from_string (l_item.class_name)
					l_class_name.to_upper
					l_list := manager.eiffel_universe.classes_with_name (l_class_name)
					if l_list /= Void and then not l_list.is_empty then
						Result := stone_from_class_i (l_list.first)
					end
				end
			end
		end

	clusters_in_the_project: EB_CLUSTERS is
			-- Clusters in the project
		do
			Result:= manager.cluster_manager.manager
		end

	remove_scope is
			-- Remove a scope from the list
		local
			test: DYNAMIC_LIST [EV_LIST_ITEM]
		do
			test := scope_list.selected_items
			from
				test.start
			until
				test.after
			loop
				scope_list.prune (test.item)
				test.forth
			end
			if scope_list.selected_items.count /= 0 then
				force_new_search
			end
		end

	remove_all is
			-- Remove all from scope
		do
			scope_list.wipe_out
		end

	switch_mode is
			-- Switch from the normal mode to the replace mode
			-- or the opposite
		do
		end

	search_is_possible: BOOLEAN is
			-- Is it possible to look for the current content of the "search for:" field?
		local
			for_test: STRING
		do
			for_test := keyword_field.text
			Result := not for_test.is_empty
		end

	select_and_show is
			-- Select and show in the editor
		do
			if multi_search_performer.is_search_launched and then not multi_search_performer.off then
				check_class_file_and_do (agent select_and_show_perform)
			end
		end

	select_and_show_perform is
			-- Do actual `select_and_show'.
		do
			if multi_search_performer.is_search_launched and then not multi_search_performer.off then
				select_in_current_editor_perform
				select_current_row
			end
		end

	select_in_current_editor is
			-- Select in the editor
		do
			if multi_search_performer.is_search_launched and then not multi_search_performer.off then
				extend_and_run_loaded_action (agent select_in_current_editor_perform)
			end
		end

	select_in_current_editor_perform is
			-- Do actual `select_in_current_editor'.
		local
			l_text_item: MSR_TEXT_ITEM
			l_editor: EB_EDITOR
		do
			if old_editor /= Void then
				l_editor := old_editor
			else
				l_editor := editor
			end
			if multi_search_performer.is_search_launched and then not multi_search_performer.off then
				l_text_item ?= multi_search_performer.item
				if l_text_item /= Void then
					if l_text_item.end_index_in_unix_text + 1 > l_text_item.start_index_in_unix_text then
						if l_editor.text_is_fully_loaded then
							l_editor.select_region (l_text_item.start_index_in_unix_text, l_text_item.end_index_in_unix_text + 1)
						end
					elseif l_text_item.end_index_in_unix_text + 1 = l_text_item.start_index_in_unix_text then
						l_editor.text_displayed.cursor.go_to_position (l_text_item.end_index_in_unix_text + 1)
						l_editor.deselect_all
					end
					if l_editor.has_selection then
						l_editor.show_selection (False)
					end
					l_editor.refresh_now
				end
			end
		end

	new_search_set: BOOLEAN
			-- Will a new search be launched? (Incremental search excluded)

	old_search_key_value: STRING
			-- Last search keyword.

	old_editor: EB_EDITOR
			-- In which last search did.

	temp_reverse: BOOLEAN
			-- Go upwards or forwards to next match in report?

	is_class_i_editing (a_class : CLASS_I): BOOLEAN is
			-- If class_i is being edited in the editor.
		require
			a_class_not_void: a_class /= Void
		local
			l: LIST [EB_DEVELOPMENT_WINDOW]
			l_editor: EB_SMART_EDITOR
		do
			l := window_manager.development_windows_with_class (a_class.name)
			if not l.is_empty then
				from
					l.start
				until
					l.after
				loop
					l_editor := l.item.editor_tool.text_area
					if l_editor.is_editable and l.item /= Void then
						Result := true
					end
					l.forth
				end
			end
		end

	update_combo_box_specific (box: EV_COMBO_BOX; word: STRING) is
			-- Add word to combo box list.
		local
			l: LIST[STRING]
		do
			l := box.strings
			if l /= Void then
				l.compare_objects
			end
			if l = Void or else not l.has (word) then
				if box.count = search_history_size then
					box.start
					box.remove
				end
				box.extend (create {EV_LIST_ITEM}.make_with_text (word))
			end
			if box.text.is_empty or else not word.is_equal (box.text) then
				box.set_text (word)
			end
		end

	is_main_editor: BOOLEAN is
			-- Is `editor' main editor?
		do
			Result := (manager.editor_tool.text_area = editor)
		end

	block_actions is
			-- Block actions.
		do
			keyword_field.change_actions.block
			replace_combo_box.key_press_actions.block
			replace_check_button.key_press_actions.block
			case_sensitive_button.key_press_actions.block
			whole_word_button.key_press_actions.block
			use_regular_expression_button.key_press_actions.block
			search_backward_button.key_press_actions.block
			current_editor_button.key_press_actions.block
			whole_project_button.key_press_actions.block
			custom_button.key_press_actions.block
			search_subcluster_button.key_press_actions.block
			search_compiled_class_button.key_press_actions.block
			scope_list.key_press_actions.block
			search_button.select_actions.block
			replace_button.select_actions.block
			replace_all_click_button.select_actions.block
			search_button.key_press_actions.block
			replace_button.key_press_actions.block
			replace_all_click_button.key_press_actions.block
		end

	resume_actions is
			-- Resume actions.
		do
			keyword_field.change_actions.resume
			replace_combo_box.key_press_actions.resume
			replace_check_button.key_press_actions.resume
			case_sensitive_button.key_press_actions.resume
			whole_word_button.key_press_actions.resume
			use_regular_expression_button.key_press_actions.resume
			search_backward_button.key_press_actions.resume
			current_editor_button.key_press_actions.resume
			whole_project_button.key_press_actions.resume
			custom_button.key_press_actions.resume
			search_subcluster_button.key_press_actions.resume
			search_compiled_class_button.key_press_actions.resume
			scope_list.key_press_actions.resume
			search_button.select_actions.resume
			replace_button.select_actions.resume
			replace_all_click_button.select_actions.resume
			search_button.key_press_actions.resume
			replace_button.key_press_actions.resume
			replace_all_click_button.key_press_actions.resume
		end

	blocking_actions_times: INTEGER
			-- Blocking actions?

end -- class EB_MULTI_SEARCH_TOOL
