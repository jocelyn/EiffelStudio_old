note
	description: "Objects that represent an EV_TITLED_WINDOW.%
		%The original version of this class was generated by EiffelBuild."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	MA_FILTER_WINDOW

inherit
	MA_FILTER_WINDOW_IMP

	MA_SINGLETON_FACTORY
		undefine
			copy, default_create
		end

feature {NONE} -- Initialization

	user_initialization
			-- Called by `initialize'.
			-- Any custom user initialization that
			-- could not be performed in `initialize',
			-- (due to regeneration of implementation class)
			-- can be added here.
		do
		 	close_request_actions.extend (agent hide)
			file_open.set_pixmap (icons.open_system_states_icon)
			file_save.set_pixmap (icons.save_current_state_icon)
			add_new_class_name.set_pixmap (icons.new_filter_class_name_icon)
			del_class_name.set_pixmap (icons.new_filter_class_name_x_icon)
			set_size (260,400)
			grid.insert_new_column (1)
			grid.column (1).set_title ("Class name")
			grid.insert_new_column (2)
			grid.column (2).set_title ("Ignore")
			grid.insert_new_column (3)
			grid.column (3).set_title ("Description")

			grid.column (1).header_item.pointer_double_press_actions.force_extend (agent adjust_column_width (1))
			grid.column (2).header_item.pointer_double_press_actions.force_extend (agent adjust_column_width (2))
			grid.column (3).header_item.pointer_double_press_actions.force_extend (agent adjust_column_width (3))

			-- If enable single row selection, user can't change grid item value.
--			grid.enable_single_row_selection

			update_grid_data
		ensure then
			close_request_actions_set: old close_request_actions.count = close_request_actions.count - 1
			file_open_pixmap_set: file_open.pixmap /= Void
			file_save_pixmap_set: file_save.pixmap /= Void
			add_new_class_name_pixmap_set: add_new_class_name.pixmap /= Void
			grid_column_set: grid.column_count = 3
			grid_column_header_double_clicked_action_set: grid.column (1).header_item.pointer_double_press_actions.count = 1
				and grid.column (2).header_item.pointer_double_press_actions.count = 1
				 and grid.column (3).header_item.pointer_double_press_actions.count = 1
			window_height_and_width_set: width = 260 and height = 400
			grid_updated: grid.row_count = filter.item_and_filter_names.count
		end

feature -- Command
	add_class_name (a_class_name: STRING)
			-- Add a class whose name is `a_class_name' to be filtered.
		require
			a_class_name_not_void: a_class_name /= Void
		do
			add_new_row (a_class_name)
		end

feature {NONE} -- Implementation

	update_grid_data
			-- Update the grid items base on the "item_and_filter_names" in the singleton factory
		local
			l_edit: EV_GRID_EDITABLE_ITEM
			l_check: MA_GRID_CHECK_BOX_ITEM
		do
			from
				filter.item_and_filter_names.start
				grid_util.grid_remove_and_clear_all_rows (grid)
			until
				filter.item_and_filter_names.after
			loop
				create l_edit.make_with_text (filter.item_and_filter_names.item_for_iteration.class_name)
				l_edit.select_actions.extend (agent user_edit_item (l_edit))
				l_edit.deactivate_actions.extend (agent user_edit_item_after (l_edit, 1))
				grid.set_item (1, filter.item_and_filter_names.key_for_iteration, l_edit)
				l_edit.set_data (filter.item_and_filter_names.item_for_iteration)

				create l_check.make
				l_check.set_selected (filter.item_and_filter_names.item_for_iteration.selected)
				l_check.selected_changed_actions.extend (agent handle_check_box_value_changed)
				grid.set_item (2, filter.item_and_filter_names.key_for_iteration, l_check)
				l_check.set_data (filter.item_and_filter_names.item_for_iteration)

				create l_edit.make_with_text (filter.item_and_filter_names.item_for_iteration.description)
				l_edit.select_actions.extend (agent user_edit_item (l_edit))
				l_edit.deactivate_actions.extend (agent user_edit_item_after (l_edit, 3))
				grid.set_item (3, filter.item_and_filter_names.key_for_iteration, l_edit)
				l_edit.set_data (filter.item_and_filter_names.item_for_iteration)

				filter.item_and_filter_names.forth
			end
		ensure
			grid_data_updated: grid.row_count = filter.item_and_filter_names.count
		end

	handle_check_box_value_changed (a_check_item: MA_GRID_CHECK_BOX_ITEM)
			-- Handle the check box grid item valuse changed.
		local
			l_filter_data: TUPLE [class_name: STRING; selected: BOOLEAN; description: STRING]
		do
			l_filter_data ?= a_check_item.data
			check l_filter_data /= Void end
			l_filter_data.selected := a_check_item.selected
		end

	open_clicked
			-- Called by `select_actions' of `l_ev_tool_bar_button_1'.
		local
			l_dlg: EV_FILE_OPEN_DIALOG
		do
			create l_dlg
			l_dlg.filters.extend (filter_filter_suffix)
			l_dlg.open_actions.extend (agent open_filter_file (l_dlg))
			l_dlg.show_modal_to_window (Current)
		end

	open_filter_file (a_dlg: EV_FILE_OPEN_DIALOG)
			-- Open a filter config file
		local
			l_datas: MA_ARRAYED_LIST_STORABLE [like a_filter_data]
		do
			create l_datas.make (1)
			l_datas ?= l_datas.retrieve_by_name (a_dlg.file_name)
			check l_datas /= Void end
			arrayed_list_datas_to_hash_table_datas (l_datas)
		end

	save_clicked
			-- Called by `select_actions' of `l_ev_tool_bar_button_2'.
		local
			l_dlg: EV_FILE_SAVE_DIALOG
		do
			create l_dlg
			l_dlg.filters.extend (filter_filter_suffix)
			l_dlg.save_actions.extend (agent save_filter_file (l_dlg))
			l_dlg.show_modal_to_window (Current)
		end

	save_filter_file (a_dlg: EV_FILE_SAVE_DIALOG)
			-- Save filter datas to a file.
		local
			l_data_file: RAW_FILE
			l_suffix: STRING
			l_filter_datas: MA_ARRAYED_LIST_STORABLE [like a_filter_data]
		do
			l_suffix := filter_filter_suffix.filter
			l_suffix := l_suffix.substring (2, l_suffix.count)
			create l_data_file.make_create_read_write (a_dlg.file_name + l_suffix)
			l_filter_datas := hash_table_datas_to_arrayed_list_datas
			l_filter_datas.basic_store (l_data_file)
		end

	add_new_class_name_clicked
			-- Called by `select_actions' of `l_ev_tool_bar_button_3'.
		local
			l_item: EV_GRID_EDITABLE_ITEM
		do
			add_new_row (Void)
			l_item ?= grid.last_visible_row.item (1)
			check l_item /= Void end
			l_item.activate
		end

	del_class_clicked (a_x, a_y, a_button: INTEGER; a_x_tilt, a_y_tilt, a_pressure: DOUBLE; a_screen_x, a_screen_y: INTEGER)
			-- Del row user current selected in `grid'.
		local
			l_rows: ARRAYED_LIST [EV_GRID_ITEM]
		do
			l_rows := grid.selected_items

			if l_rows.count >= 1 then
				l_rows.start
				filter.item_and_filter_names.remove (l_rows.item.row.index)
				grid.remove_row (l_rows.item.row.index)
			end
		end

	add_new_row (a_class_name: STRING)
			-- Add a new row to `grid' then update filter datas.
		local
			l_item, l_item_2: EV_GRID_EDITABLE_ITEM
			l_check: MA_GRID_CHECK_BOX_ITEM
			l_new_row_index: INTEGER
			l_filter_data: like a_filter_data
		do
			l_new_row_index := grid.row_count + 1
			if a_class_name /= Void then
				create l_item.make_with_text (a_class_name)
			else
				create l_item
			end

			grid.set_item (1, l_new_row_index, l_item)
			l_item.select_actions.extend (agent user_edit_item (l_item))
			l_item.deactivate_actions.extend (agent user_edit_item_after (l_item, 1))

			create l_check.make_with_boolean (True)
			grid.set_item (2, l_new_row_index, l_check)
			l_check.selected_changed_actions.extend (agent handle_check_box_value_changed )

			create l_item_2
			grid.set_item(3, l_new_row_index, l_item_2)
			l_item_2.select_actions.extend (agent user_edit_item (l_item_2))
			l_item_2.deactivate_actions.extend (agent user_edit_item_after (l_item_2, 3))

			l_filter_data := [l_item.text.to_string_8, l_check.selected, l_item_2.text.to_string_8]
			-- Put the first grid item into the hash table.
			filter.item_and_filter_names.force (l_filter_data, l_new_row_index)

			l_item.set_data (l_filter_data)
			l_check.set_data (l_filter_data)
			l_item_2.set_data (l_filter_data)

		ensure then
			grid_row_increased: old grid.row_count = grid.row_count - 1
		end

	user_edit_item (a_item: EV_GRID_ITEM)
			-- When user click a editable item on the grid, active it.
		require
			a_item_not_void: a_item /= Void
		do
			a_item.activate
		ensure
			a_item_activated: True
		end

	user_edit_item_after (a_item: EV_GRID_LABEL_ITEM; a_index: INTEGER)
			-- When user edited the grid item, set the user changed value to the filter data's hash table.
			-- A index is the index user edited in the filter data tuple.
		require
			a_item_not_void: a_item /= Void
			a_index_valid: a_index = 1 or a_index = 2 or a_index = 3
		local
			l_filter_data: like a_filter_data
			l_check_box: MA_GRID_CHECK_BOX_ITEM
		do
			l_filter_data ?= a_item.data
			check l_filter_data /= Void end
			if a_index /= 2 then
				l_filter_data [a_index] := a_item.text
			else
				l_check_box ?= a_item
				check l_check_box /= Void end
				l_filter_data.selected := l_check_box.is_selected
			end
		end

	adjust_column_width (a_column_index: INTEGER)
			-- adjust a column width to fix the max width of the item its contain
		require
			column_index_valid: grid.column_count >= a_column_index and a_column_index > 0
		do
			if grid.row_count > 0 then
				grid.column (a_column_index).set_width (grid.column (a_column_index).required_width_of_item_span (1, grid.row_count))
			end
		end

	a_filter_data: TUPLE [class_name: STRING; selected: BOOLEAN; description: STRING]
			-- A anchor, should not be called
		require
			False
		do
		end

	hash_table_datas_to_arrayed_list_datas: MA_ARRAYED_LIST_STORABLE [like a_filter_data]
			-- Change the data stored in DS_HASH_TABLE to a arrayed_list which is storable.

		local
			l_datas: MA_ARRAYED_LIST_STORABLE [like a_filter_data]
		do
			create l_datas.make (1)
			from
				filter.item_and_filter_names.start
			until
				filter.item_and_filter_names.after
			loop
				l_datas.extend (filter.item_and_filter_names.item_for_iteration)
				filter.item_and_filter_names.forth
			end
			Result := l_datas
		ensure
			result_not_void: Result /= Void
			result_valid: Result.count = filter.item_and_filter_names.count
		end

	arrayed_list_datas_to_hash_table_datas (a_datas: MA_ARRAYED_LIST_STORABLE [like a_filter_data])
			-- Set the data stored in DS_HASH_TABLE to a_datas, and update the grid content
		require
			a_datas_not_void: a_datas /= Void
		local
			l_row_count: INTEGER
		do
			filter.item_and_filter_names.wipe_out
			grid_util.grid_remove_and_clear_all_rows (grid)

			from
				a_datas.start
				l_row_count := 1
			until
				a_datas.after
			loop
				filter.item_and_filter_names.force (a_datas.item, l_row_count)
				a_datas.forth
				l_row_count := l_row_count + 1
			end
			update_grid_data
		ensure
			filter_datas_set: a_datas.count = filter.item_and_filter_names.count
		end

invariant

	file_open_not_void: file_open /= Void
	file_save_not_void: file_save /= Void
	add_new_class_name_not_void: add_new_class_name /= Void
	grid_not_void: grid /= Void

note
	copyright:	"Copyright (c) 1984-2006, Eiffel Software and others"
	license:	"Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			 Eiffel Software
			 356 Storke Road, Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"




end -- class MA_FILTER_WINDOW

