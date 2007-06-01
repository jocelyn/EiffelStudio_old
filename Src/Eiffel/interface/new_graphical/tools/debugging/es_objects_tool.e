indexing
	description: "Objects that represents the display of stack and debugged objects"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	author: "$Author$"
	date: "$Date$"
	revision: "$Revision$"

class
	ES_OBJECTS_TOOL

inherit
	REFACTORING_HELPER

	ES_OBJECTS_GRID_SPECIFIC_LINE_CONSTANTS
		rename
			stack_id as position_stack,
			current_object_id as position_current,
			arguments_id as position_arguments,
			locals_id as position_locals,
			result_id as position_result,
			dropped_id as position_dropped
		end

	ES_OBJECTS_GRID_MANAGER

	EB_STONABLE_TOOL
		rename
			make as make_tool,
			mini_toolbar as mini_toolbar_box,
			build_mini_toolbar as build_mini_toolbar_box
		redefine
			menu_name,
			pixmap,
			mini_toolbar_box,
			build_mini_toolbar_box,
			build_docking_content,
			internal_recycle,
			show
		end

	VALUE_TYPES
		export
			{NONE} all
		end

	EB_SHARED_PREFERENCES
		export
			{NONE} all
		end

	DEBUGGING_UPDATE_ON_IDLE
		redefine
			update,
			real_update
		end

create
	make_with_debugger

feature {NONE} -- Initialization

	make_with_debugger (a_manager: EB_DEVELOPMENT_WINDOW; a_debugger: EB_DEBUGGER_MANAGER) is
			-- Initialize with `a_debugger'.
		require
			a_debugger_not_void: a_debugger /= Void
		do
			set_debugger_manager (a_debugger)
			cleaning_delay := preferences.debug_tool_data.delay_before_cleaning_objects_grid
			make_tool (a_manager)
		end

feature {NONE} -- Internal properties

	first_grid_id: STRING is "1"

	second_grid_id: STRING is "2"

	reset_objects_grids_contents_to_default is
		local
			lst: LIST [INTEGER]
		do
			dropped_objects_grid := Void
			from
				objects_grids.start
			until
				objects_grids.after
			loop
				lst := objects_grids.item_for_iteration.ids
				lst.wipe_out
				if objects_grids.key_for_iteration.is_equal (first_grid_id) then
					lst.extend (position_stack)
					lst.extend (position_current)
					lst.extend (position_arguments)
					lst.extend (position_locals)
					lst.extend (position_result)
					if dropped_objects_grid /= Void then
						objects_grid_ids (dropped_objects_grid.id).prune_all (position_dropped)
					end
					lst.extend (position_dropped)
					dropped_objects_grid := objects_grids.item_for_iteration.grid
				end
				objects_grids.forth
			end
		end

	objects_grids_contents_to_array: ARRAY [STRING] is
			--
		local
			lst: LIST [INTEGER]
			res: ARRAYED_LIST [STRING]
			nb: INTEGER
			s: STRING
		do
			from
				nb := 0
				objects_grids.start
			until
				objects_grids.after
			loop
				nb := nb + 1 + objects_grids.item_for_iteration.ids.count
				objects_grids.forth
			end

			create res.make (nb)
			from
				objects_grids.start
			until
				objects_grids.after
			loop
				s := objects_grids.key_for_iteration.twin
				s.prepend_character ('#')
				res.extend (s)
				lst := objects_grids.item_for_iteration.ids
				from
					lst.start
				until
					lst.after
				loop
					res.extend (lst.item.out)
					lst.forth
				end
				objects_grids.forth
			end
			Result := res
		ensure
			Result_has_no_void_item: not Result.has (Void)
		end

	Position_entries: ARRAY [INTEGER] is
		once
			Result := <<
							position_stack,
							position_current,
							position_arguments,
							position_locals,
							position_result,
							position_dropped
					>>
		end

	objects_grids: HASH_TABLE [like objects_grid_data, STRING]
			-- Contains the stack and debugged objects grids

	objects_grid (a_id: STRING): ES_OBJECTS_GRID is
			-- Objects grid identified by `a_id'.
		require
			a_id /= Void
		do
			Result := objects_grids.item (a_id).grid
		end

	objects_grid_ids (a_id: STRING): LIST [INTEGER] is
			-- Objects grid's contents identified by `a_id'.
		require
			a_id /= Void
		do
			Result := objects_grids.item (a_id).ids
		end

	objects_grid_data (a_id: STRING): TUPLE [grid:ES_OBJECTS_GRID; grid_is_empty:BOOLEAN;
						layout_initialized:BOOLEAN;
						ids:LIST[INTEGER]; lines:LIST[ES_OBJECTS_GRID_SPECIFIC_LINE]
					] is
			-- Objects grid identified by `a_id'.
		require
			a_id /= Void
		do
			Result := objects_grids.item (a_id)
		end

	dropped_objects_grid: ES_OBJECTS_GRID

feature {NONE} -- Interface

	build_interface is
			-- Build all the tool's widgets.
		local
			l_box: EV_HORIZONTAL_BOX
			stack_objects_grid, debugged_objects_grid: like objects_grid
		do
				--| Build interface

			create displayed_objects.make

			create objects_grids.make (2)
			objects_grids.compare_objects
			create_objects_grid (interface_names.l_object_tool_left, first_grid_id)
			create_objects_grid (interface_names.l_object_tool_right, second_grid_id)

			stack_objects_grid := objects_grid (first_grid_id)
			debugged_objects_grid := objects_grid (second_grid_id)

			create split
			split.pointer_double_press_actions.force_extend (agent (a_split: EV_SPLIT_AREA)
					do
						a_split.set_proportion (0.5)
					end(split)
				)

				-- The `stack_objects_grid' and `debugged_objects_grid' are
				-- inserted into a temporary box to provide a padding of one pixel
				-- so that it appears that they have a border. This makes the distinction
				-- between the edges of the control and the split area more pronounced.

			create l_box
			l_box.set_border_width (1)
			l_box.set_background_color ((create {EV_STOCK_COLORS}).gray)
			split.set_first (l_box)
			l_box.extend (stack_objects_grid)

			create l_box
			l_box.set_border_width (1)
			l_box.set_background_color ((create {EV_STOCK_COLORS}).gray)
			split.set_second (l_box)
			l_box.extend (debugged_objects_grid)

			widget := split


				--| objects grid layout
			initialize_objects_grid_layout (preferences.debug_tool_data.is_stack_grid_layout_managed_preference, stack_objects_grid)
			initialize_objects_grid_layout (preferences.debug_tool_data.is_debugged_grid_layout_managed_preference, debugged_objects_grid)

				--| Initialize various agent and special mecanisms
			init_delayed_cleaning_mecanism
			create_update_on_idle_agent
			preferences.debug_tool_data.objects_tool_layout_preference.change_actions.extend (agent refresh_objects_layout_from_preference)

			refresh_objects_layout_from_preference (preferences.debug_tool_data.objects_tool_layout_preference)
		end

	create_objects_grid (a_name: STRING_GENERAL; a_id: STRING) is
			-- Create an objects grid named `a_name' and identified by `a_id'
		local
			spref: STRING_PREFERENCE
			g: like objects_grid
		do
			create g.make_with_name (a_name, a_id)
			objects_grids.force ([g, True, False, create {ARRAYED_LIST[INTEGER]}.make (6) ,create {ARRAYED_LIST[ES_OBJECTS_GRID_SPECIFIC_LINE]}.make (6)], a_id)

			g.set_objects_grid_item_function (agent objects_grid_object_line)
			spref := preferences.debug_tool_data.grid_column_layout_preference_for (g.id)
			g.set_default_columns_layout (
						<<
							[1, True, False, 150, interface_names.l_name, interface_names.to_name],
							[2, True, False, 150, interface_names.l_value, interface_names.to_value],
							[3, True, False, 200, interface_names.l_type, interface_names.to_type],
							[4, True, False, 80, interface_names.l_address, interface_names.to_address],
							[5, False, False, 0, interface_names.l_context_dot, interface_names.to_context_dot]
						>>
					)
			g.set_columns_layout_from_string_preference (preferences.debug_tool_data.grid_column_layout_preference_for (g.id))

				-- Set scrolling preferences.
			g.set_mouse_wheel_scroll_size (preferences.editor_data.mouse_wheel_scroll_size)
			g.set_mouse_wheel_scroll_full_page (preferences.editor_data.mouse_wheel_scroll_full_page)
			g.set_scrolling_common_line_count (preferences.editor_data.scrolling_common_line_count)
			preferences.editor_data.mouse_wheel_scroll_size_preference.typed_change_actions.extend (
				agent g.set_mouse_wheel_scroll_size)
			preferences.editor_data.mouse_wheel_scroll_full_page_preference.typed_change_actions.extend (
				agent g.set_mouse_wheel_scroll_full_page)
			preferences.editor_data.scrolling_common_line_count_preference.typed_change_actions.extend (
				agent g.set_scrolling_common_line_count)

				-- Key actions
			g.key_press_actions.extend (agent debug_value_key_action (g, ?))

				-- PND settings
			g.drop_actions.extend (agent object_stone_dropped_on_grid (g, ?))
			g.drop_actions.set_veto_pebble_function (agent grid_veto_pebble_function (g, ?))

				-- Select/Unselect behavior
			g.row_select_actions.extend (agent on_objects_row_selected)
			g.row_deselect_actions.extend (agent on_objects_row_deselected)

			g.set_pre_activation_action (agent pre_activate_cell)

			g.set_configurable_target_menu_mode
			g.set_configurable_target_menu_handler (agent context_menu_handler)
		end

	build_mini_toolbar_box is
		do
			create mini_toolbar_box
			build_header_box
			build_mini_toolbar
			mini_toolbar_box.extend (header_box)
			mini_toolbar_box.extend (mini_toolbar)
		end

	build_mini_toolbar is
			-- Build associated tool bar
		local
			tbb: SD_TOOL_BAR_BUTTON
			scmd: EB_STANDARD_CMD
		do
			create mini_toolbar.make
			create scmd.make
			scmd.set_mini_pixmap (pixmaps.mini_pixmaps.toolbar_dropdown_icon)
			scmd.set_mini_pixel_buffer (pixmaps.mini_pixmaps.toolbar_dropdown_icon_buffer)
			scmd.set_tooltip (interface_names.f_Open_object_tool_menu)
			scmd.add_agent (agent open_objects_menu (mini_toolbar, 0, 0))
			scmd.enable_sensitive
			mini_toolbar.extend (scmd.new_mini_sd_toolbar_item)

				--| Delete command
			create remove_debugged_object_cmd.make
			remove_debugged_object_cmd.set_mini_pixmap (pixmaps.mini_pixmaps.general_delete_icon)
			remove_debugged_object_cmd.set_mini_pixel_buffer (pixmaps.mini_pixmaps.general_delete_icon_buffer)
			remove_debugged_object_cmd.set_tooltip (Interface_names.e_Remove_object)
			remove_debugged_object_cmd.add_agent (agent remove_selected_debugged_objects)
			tbb := remove_debugged_object_cmd.new_mini_sd_toolbar_item
			tbb.drop_actions.extend (agent remove_dropped_debugged_object)
			tbb.drop_actions.set_veto_pebble_function (agent is_removable_debugged_object)
			remove_debugged_object_cmd.enable_sensitive

			mini_toolbar.extend (tbb)

			create slices_cmd.make (Current)
			slices_cmd.enable_sensitive
			mini_toolbar.extend (slices_cmd.new_mini_sd_toolbar_item)

			mini_toolbar.extend (object_viewer_cmd.new_mini_sd_toolbar_item)

			create hex_format_cmd.make (agent set_hexadecimal_mode (?))
			hex_format_cmd.enable_sensitive
			mini_toolbar.extend (hex_format_cmd.new_mini_sd_toolbar_item)

				--| Attach the slices_cmd to the objects grid
			from
				objects_grids.start
			until
				objects_grids.after
			loop
				objects_grids.item_for_iteration.grid.set_slices_cmd (slices_cmd)
				objects_grids.forth
			end

			mini_toolbar.compute_minimum_size
		ensure then
			mini_toolbar_exists: mini_toolbar /= Void
		end

	build_docking_content (a_docking_manager: SD_DOCKING_MANAGER) is
			-- Build docking content
		do
			Precursor {EB_STONABLE_TOOL} (a_docking_manager)
			content.drop_actions.extend (agent add_debugged_object)
			content.drop_actions.extend (agent drop_stack_element)
		end

	open_objects_menu (w: EV_WIDGET; ax, ay: INTEGER) is
		local
			m, sm,subm: EV_MENU
			mi,msi,mall: EV_MENU_ITEM
			l_has_all: BOOLEAN
			og: like objects_grid
			lid: STRING
			pos_titles: ARRAY [STRING_GENERAL]
			gdata: like objects_grid_data
			gids: LIST [INTEGER]
			i: INTEGER
			missings: ARRAYED_LIST [INTEGER]
			l_keys: TWO_WAY_SORTED_SET [STRING]
		do
			if not objects_grids.is_empty then
				create m
				from
					create l_keys.make
					objects_grids.start
				until
					objects_grids.after
				loop
					l_keys.extend (objects_grids.key_for_iteration)
					objects_grids.forth
				end
				from
					create pos_titles.make (Position_entries.lower, Position_entries.upper)
					pos_titles[position_stack] := Interface_names.l_stack_information
					pos_titles[position_current] := Interface_names.l_current_object
					pos_titles[position_arguments] := Interface_names.l_arguments
					pos_titles[position_locals] := Interface_names.l_locals
					pos_titles[position_result] := Interface_names.l_result
					pos_titles[position_dropped] := Interface_names.l_dropped_references

					l_keys.start
				until
					l_keys.after
				loop
					lid := l_keys.item
					gdata := objects_grids.item (lid)

					create missings.make_from_array (position_entries.deep_twin)
					og := gdata.grid
					create sm.make_with_text (og.name)
					m.extend (sm)

					l_has_all := True
					gids := gdata.ids
					if gids /= Void and then not gids.is_empty then
						create mall.make_with_text ("All")
						mall.set_pixmap (pixmaps.mini_pixmaps.general_delete_icon)
						mall.enable_sensitive
						sm.extend (mall)

						from
							gids.start
						until
							gids.after
						loop
							i := gids.item
							if i > 0 then
								mall.select_actions.extend (agent remove_objects_grids_position (lid, i))
								missings.prune_all (i)
								create subm.make_with_text (pos_titles[i])
								if not gids.isfirst then
									create msi.make_with_text (interface_names.f_move_item_up)
									msi.select_actions.extend (agent move_objects_grids_position (lid, i, -1))
									msi.set_pixmap (pixmaps.mini_pixmaps.general_up_icon)
									subm.extend (msi)
								end
								create msi.make_with_text (interface_names.b_remove)
								msi.select_actions.extend (agent remove_objects_grids_position (lid, i))
								msi.set_pixmap (pixmaps.mini_pixmaps.general_delete_icon)
								subm.extend (msi)
								if not gids.islast then
									create msi.make_with_text (interface_names.f_move_item_down)
									msi.select_actions.extend (agent move_objects_grids_position (lid, i, +1))
									msi.set_pixmap (pixmaps.mini_pixmaps.general_down_icon)
									subm.extend (msi)
								end
								sm.extend (subm)
							end
							gids.forth
						end
						sm.extend (create {EV_MENU_SEPARATOR})
					end

					l_has_all := missings.is_empty
					if not l_has_all then
						create mall.make_with_text ("All")
						mall.set_pixmap (pixmaps.mini_pixmaps.general_add_icon)
						mall.enable_sensitive
						sm.extend (mall)

						from
							missings.start
						until
							missings.after
						loop
							i := missings.item
							if i > 0 then
								create mi.make_with_text (pos_titles[i])
								mi.set_pixmap (pixmaps.mini_pixmaps.general_add_icon)
								mi.select_actions.extend (agent assign_objects_grids_position (lid, i))
								sm.extend (mi)

								mall.select_actions.extend (agent assign_objects_grids_position (lid, i))
							end
							missings.forth
						end
					end
					l_keys.forth
				end

				m.show_at (w, ax, ay)
			end
		end

	assign_objects_grids_position (a_gid: STRING; a_pos: INTEGER) is
			-- Change grid position for item at position `a_pos' to grid identified by `a_gid'
		local
			apref: ARRAY_PREFERENCE
			lst: LIST [INTEGER]
		do
			lst := objects_grids.item (a_gid).ids
			if not lst.has (a_pos) then
				if a_pos = position_dropped then
					if dropped_objects_grid /= Void then
						objects_grid_ids (dropped_objects_grid.id).prune_all (position_dropped)
					end
					dropped_objects_grid := objects_grid (a_gid)
				end
				lst.extend (a_pos)
				apref := preferences.debug_tool_data.objects_tool_layout_preference
				apref.set_value (objects_grids_contents_to_array) --| Should trigger "update"				
			end
		end

	remove_objects_grids_position (a_gid: STRING; a_pos: INTEGER) is
			-- Change grid position for item at position `a_pos' to grid identified by `a_gid'
		local
			apref: ARRAY_PREFERENCE
			lst: LIST [INTEGER]
		do
			lst := objects_grids.item (a_gid).ids
			if lst.has (a_pos) then
				lst.prune_all (a_pos)
				if a_pos = position_dropped and dropped_objects_grid /= Void then
					objects_grid_ids (dropped_objects_grid.id).prune_all (position_dropped)
				end
				apref := preferences.debug_tool_data.objects_tool_layout_preference
				apref.set_value (objects_grids_contents_to_array) --| Should trigger "update"				
			end
		end

	move_objects_grids_position	(a_gid: STRING; a_pos: INTEGER; a_step: INTEGER) is
		require
			valid_step: a_step /= 0
		local
			apref: ARRAY_PREFERENCE
			lst: LIST [INTEGER]
		do
			lst := objects_grids.item (a_gid).ids
			if lst.has (a_pos) then
				lst.start
				lst.search (a_pos)
				if
					not lst.exhausted
					and lst.valid_index (lst.index + a_step)
				then
					lst.swap (lst.index + a_step)
				end
				apref := preferences.debug_tool_data.objects_tool_layout_preference
				apref.set_value (objects_grids_contents_to_array) --| Should trigger "update"				
			end
		end

	context_menu_handler (a_menu: EV_MENU; a_target_list: ARRAYED_LIST [EV_PND_TARGET_DATA]; a_source: EV_PICK_AND_DROPABLE; a_pebble: ANY) is
			-- Context menu handler
		do
			develop_window.menus.context_menu_factory.object_tool_menu (a_menu, a_target_list, a_source, a_pebble)
		end

feature -- preference

	refresh_objects_layout_from_preference (p: ARRAY_PREFERENCE) is
			-- Refresh the layout using preference `p'
		local
			error_occurred: BOOLEAN
			vals: ARRAY [STRING]
			l_id: STRING
			s: STRING
			i, si: INTEGER
			lst: LIST [INTEGER]
		do
			vals := p.value
			if not error_occurred and (vals /= Void and then not vals.is_empty) then
--				reset_objects_grids_contents_to_default
				from
					i := vals.lower
				until
					i > vals.upper
				loop
					s := vals [i]
					if s = Void or else s.is_empty then
						error_occurred := True
					elseif s.item (1) = '#' then
						l_id := s.substring (2, s.count)
						lst := objects_grid_ids (l_id)
						if lst /= Void then
							lst.wipe_out
						end
					elseif lst /= Void and s.is_integer then
						si := s.to_integer
						if i = position_dropped then
							if dropped_objects_grid /= Void then
								objects_grid_ids (dropped_objects_grid.id).prune_all (position_dropped)
							end
							dropped_objects_grid := objects_grid (l_id)
						end
						if not lst.has (si) then
							lst.extend (si)
						end
					else
						error_occurred := True
					end
					i := i + 1
				end
				if not error_occurred then
					lst := objects_grid_ids (second_grid_id)
					if lst = Void or else lst.is_empty then
						split.second.hide
					elseif not split.second.is_show_requested then
						split.second.show
					end
					split.show
					update
				end
			end
			if error_occurred or (vals = Void or else vals.is_empty) then
				reset_objects_grids_contents_to_default
				if not error_occurred then
					p.set_value (objects_grids_contents_to_array) --| should trigger the `p.change_actions' and then recall this feature
				end
			end
		rescue
			error_occurred := True
			retry
		end

	save_grids_preferences is
		local
			g: like objects_grid
		do
			from
				objects_grids.start
			until
				objects_grids.after
			loop
				g := objects_grids.item_for_iteration.grid
				g.save_columns_layout_to_string_preference (
					preferences.debug_tool_data.grid_column_layout_preference_for (g.id)
					)
				objects_grids.forth
			end
		end

feature -- Access

	mini_toolbar_box: EV_HORIZONTAL_BOX

	mini_toolbar: SD_TOOL_BAR
			-- Associated mini tool bar.

	header_box: EV_HORIZONTAL_BOX
			-- Associated header box

	widget: EV_WIDGET
			-- Widget representing Current.

	title: STRING_GENERAL is
			-- Title of the tool.
		do
			Result := interface_names.t_object_tool
		end

	title_for_pre: STRING is
			-- Title for prefence, STRING_8
		do
			Result := Interface_names.to_object_tool
		end

	menu_name: STRING_GENERAL is
			-- Name as it may appear in a menu.
		do
			Result := interface_names.m_object_tools
		end

	pixmap: EV_PIXMAP is
			-- Pixmap as it may appear in toolbars and menus.
		do
			Result := pixmaps.icon_pixmaps.tool_objects_icon
		end

	debugger_manager: EB_DEBUGGER_MANAGER
			-- Manager in charge of all debugging operations.

	stone: STONE
			-- Not used.

feature {NONE} -- Notebook item's behavior

	header_class_label: EV_LABEL
			-- Label to display class information in `header_box'.

	header_text_label: EV_LABEL
			-- Label to display information in `header_box'.

	header_feature_label: EV_LABEL
			-- Label to display feature information in `header_box'.

	clean_header_box is
		do
			if header_box /= Void then
				header_box.wipe_out
			end
		ensure
			header_box /= Void implies header_box.is_empty
		end

	build_header_box is
		do
			create header_box
		ensure
			header_box /= Void
		end

	update_header_box (dbg_stopped: BOOLEAN) is
		require
			header_box /= Void
		local
			app: APPLICATION_EXECUTION
			ecse: EIFFEL_CALL_STACK_ELEMENT
			l_fstone: FEATURE_STONE
			l_cstone: CLASSC_STONE
			hbox: EV_BOX
			sep: EV_CELL
		do
			hbox := header_box
			if header_text_label = Void or else header_text_label.parent /= hbox then
				clean_header_box
				create header_class_label
				header_class_label.set_foreground_color (preferences.editor_data.class_text_color)
				hbox.extend (header_class_label)
				hbox.disable_item_expand (header_class_label)

				create header_text_label
				hbox.extend (header_text_label)
				hbox.disable_item_expand (header_text_label)

				create header_feature_label
				header_feature_label.set_foreground_color (preferences.editor_data.feature_text_color)
				hbox.extend (header_feature_label)
				hbox.disable_item_expand (header_feature_label)

				create sep
				sep.set_minimum_width (30)
				hbox.extend (sep)
				hbox.disable_item_expand (sep)
			end
			check
				header_class_label /= Void
				header_text_label /= Void
				header_feature_label /= Void
				header_text_label.parent = header_box
			end
			if
				debugger_manager.application_is_executing
			then
				app := debugger_manager.application
				if app.is_stopped and then dbg_stopped then
					if not app.current_call_stack_is_empty then
						ecse ?= current_stack_element
						if ecse /= Void then
							header_class_label.set_text ("{" + ecse.dynamic_class.name_in_upper.twin + "}")
							create l_cstone.make (ecse.dynamic_class)
							header_class_label.set_pebble (l_cstone)
							header_class_label.set_accept_cursor (l_cstone.stone_cursor)
							header_class_label.set_deny_cursor (l_cstone.x_stone_cursor)

							header_text_label.set_text (".")

							header_feature_label.set_text (ecse.routine_name)
							create l_fstone.make (ecse.routine)
							header_feature_label.set_pebble (l_fstone)
							header_feature_label.set_accept_cursor (l_fstone.stone_cursor)
							header_feature_label.set_deny_cursor (l_fstone.x_stone_cursor)
						end
					else
						header_class_label.remove_text
						header_text_label.set_text (Interface_names.l_unknown_status)
						header_feature_label.remove_text
					end
				else
					header_class_label.remove_text
					header_text_label.set_text (Interface_names.l_System_running)
					header_feature_label.remove_text
				end
			else
				header_class_label.remove_text
				header_text_label.set_text (Interface_names.l_System_not_running)
				header_feature_label.remove_text
			end
			header_class_label.refresh_now
			header_text_label.refresh_now
			header_feature_label.refresh_now
			header_box.refresh_now

			develop_window.docking_manager.update_mini_tool_bar_size (content)
		end

feature {ES_OBJECTS_GRID_SLICES_CMD} -- Query

	objects_grid_object_line (addr: STRING): ES_OBJECTS_GRID_OBJECT_LINE is
			-- Return managed object located at address `addr'.
		local
			found: BOOLEAN
		do
			from
				displayed_objects.start
			until
				displayed_objects.after or else found
			loop
				Result := displayed_objects.item
				check
					Result.object_address /= Void
				end
				found := Result.object_address.is_equal (addr)
				displayed_objects.forth
			end
			if not found then
				Result := Void
			end
		end

feature -- Properties setting

	set_hexadecimal_mode (v: BOOLEAN) is
		do
			from
				objects_grids.start
			until
				objects_grids.after
			loop
				objects_grids.item_for_iteration.grid.set_hexadecimal_mode (v)
				objects_grids.forth
			end
		end

feature {NONE} -- Row actions	

	on_objects_row_selected (row: EV_GRID_ROW) is
			-- An item in the list of expression was selected.
		local
			g: like objects_grid
		do
			g ?= row.parent
			if g /= Void and then g = dropped_objects_grid then
				remove_debugged_object_cmd.enable_sensitive
			else
				remove_debugged_object_cmd.disable_sensitive
			end
		end

	on_objects_row_deselected (row: EV_GRID_ROW) is
			-- An item in the list of expression was selected.
		do
			remove_debugged_object_cmd.disable_sensitive
		end

feature -- Change

	set_stone (a_stone: STONE) is
			-- Assign `a_stone' as new stone.
		local
			conv_stack: CALL_STACK_STONE
		do
			debug ("debug_recv")
				print ("ES_OBJECTS_TOOL.set_stone%N")
			end
			if can_refresh then
				conv_stack ?= a_stone
				if conv_stack /= Void then
					update
				end
			end
		end

	enable_refresh is
			-- Set `can_refresh' to `True'.
		do
				-- FIXME: this should be useless now, to check
			can_refresh := True
		end

	disable_refresh is
			-- Set `can_refresh' to `False'.
		do
				-- FIXME: this should be useless now, to check
			can_refresh := False
		end

	refresh is
			-- Refresh current grid
			--| Could be optimized to refresh only grid's content display ..
		do
			record_grids_layout
			update
		end

	update is
			-- Display current execution status.
		do
			cancel_process_real_update_on_idle
			if Debugger_manager.application_is_executing then
				process_real_update_on_idle (Debugger_manager.application_is_stopped)
			else
				from
					objects_grids.start
				until
					objects_grids.after
				loop
					objects_grids.item_for_iteration.grid.reset_layout_recorded_values
					objects_grids.forth
				end
			end
		end

	set_debugger_manager (a_manager: like debugger_manager) is
			-- Affect `a_manager' to `debugger_manager'.
		do
			debugger_manager := a_manager
		end

	show is
			-- Show tool.
		local
			l_grid: like objects_grid
		do
			Precursor {EB_STONABLE_TOOL}
			l_grid := objects_grid (first_grid_id)
			if not l_grid.is_destroyed and then l_grid.is_displayed and then l_grid.is_sensitive then
				l_grid.set_focus
			end
		end

feature -- Status report

	can_refresh: BOOLEAN
			-- Should we display the trees when a stone is set?

feature -- Status Setting

	reset_tool is
		local
			g: like objects_grid
			t: like objects_grid_data
			l: ES_OBJECTS_GRID_SPECIFIC_LINE
			lines: LIST [ES_OBJECTS_GRID_SPECIFIC_LINE]
		do
			reset_update_on_idle
			displayed_objects.wipe_out
			from
				objects_grids.start
			until
				objects_grids.after
			loop
				t := objects_grids.item_for_iteration
				lines := t.lines
				from
					lines.start
				until
					lines.after
				loop
					l := lines.item
					if l /= Void then
						l.reset
					end
					lines.forth
				end

				g := t.grid
				g.call_delayed_clean
				g.reset_layout_manager
				objects_grids.forth
			end
			clean_header_box
		end

feature {NONE} -- Memory management

	internal_recycle is
			-- Recycle `Current', but leave `Current' in an unstable state,
			-- so that we know whether we're still referenced or not.
		do
			reset_tool
		end

feature {EB_DEBUGGER_MANAGER} -- Cleaning timer change

	set_cleaning_delay (ms: INTEGER) is
		require
			delay_positive_or_null: ms >= 0
		local
			g: like objects_grid
		do
			cleaning_delay := ms
			from
				objects_grids.start
			until
				objects_grids.after
			loop
				g := objects_grids.item_for_iteration.grid
				if g.delayed_cleaning_exists then
					g.set_cleaning_delay (cleaning_delay)
				end
				objects_grids.forth
			end
		ensure
			cleaning_delay = ms
		end

	init_delayed_cleaning_mecanism is
		local
			g: like objects_grid
		do
			from
				objects_grids.start
			until
				objects_grids.after
			loop
				g := objects_grids.item_for_iteration.grid
				if not g.delayed_cleaning_exists then
					g.build_delayed_cleaning
					g.set_cleaning_delay (cleaning_delay)
					g.set_delayed_cleaning_action (agent action_clean_objects_grid (g.id))
				end
				objects_grids.forth
			end
		end

feature {NONE} -- grid Layout Implementation

--	keep_object_reference_fixed (addr: STRING) is
--		do
--			if debugger_manager.application_is_executing then
--				debugger_manager.application_status.keep_object (addr)
--			end
--		end

	cleaning_delay: INTEGER
			-- Number of milliseconds waited before clearing debug output.
			-- By waiting for a short period of time, the flicker is removed
			-- for normal debug usage as it is only cleared immediately before
			-- being rebuilt, unless the timer period has been exceeded.

	current_stack_class_feature_identification: STRING is
		local
			cse: CALL_STACK_ELEMENT
		do
			cse := current_stack_element
			if cse /= Void then
				Result := cse.class_name + "." + cse.routine_name
			end
		end

feature {NONE} -- Stack grid Layout Implementation

	initialize_objects_grid_layout (pv: BOOLEAN_PREFERENCE; g: like objects_grid) is
		require
			not objects_grids.item (g.id).layout_initialized
			g.layout_manager = Void
		do
			g.initialize_layout_management (pv)
			check
				g.layout_manager /= Void
			end
			g.layout_manager.set_global_identification_agent (agent current_stack_class_feature_identification)
			objects_grids.item (g.id).layout_initialized := True
		end

	action_clean_objects_grid (g_id: STRING) is
		local
			t: like objects_grid_data
		do
			t := objects_grid_data (g_id)
			if not t.grid_is_empty then
				t.grid.default_clean
				t.grid_is_empty := True
			end
		ensure
			objects_grid_cleaned: objects_grid_data (g_id).grid_is_empty
		end

feature -- grid Layout access

	record_grids_layout is
		local
			g: like objects_grid
			lines: LIST [ES_OBJECTS_GRID_SPECIFIC_LINE]
		do
			from
				objects_grids.start
			until
				objects_grids.after
			loop
				lines := objects_grids.item_for_iteration.lines
				from
					lines.start
				until
					lines.after
				loop
					if lines.item /= Void then
						lines.item.record_layout
					end
					lines.forth
				end
				g := objects_grids.item_for_iteration.grid
				if g.row_count > 0 then
					g.record_layout
				end
				objects_grids.forth
			end
		end

feature {NONE} -- Commands Implementation

	remove_debugged_object_cmd: EB_STANDARD_CMD
			-- Command that is used to remove objects from the tree.

	object_viewer_cmd: EB_OBJECT_VIEWER_COMMAND is
		do
			Result := debugger_manager.object_viewer_cmd
		end

feature {NONE} -- Implementation

	current_stack_element: CALL_STACK_ELEMENT is
			-- Stack element currently displayed in `stack_objects_grid'.
		local
			l_status: APPLICATION_STATUS
		do
			l_status := debugger_manager.application_status
			if l_status.current_call_stack /= Void then
				Result := l_status.current_call_stack_element
			end
		end

	split: EV_HORIZONTAL_SPLIT_AREA
			-- Split area that contains both `stack_objects_grid' and `debugged_objects_grid'.

	real_update (dbg_was_stopped: BOOLEAN) is
			-- Display current execution status.
			-- dbg_was_stopped is ignore if Application/Debugger is not running
		local
			l_app: APPLICATION_EXECUTION
			l_status: APPLICATION_STATUS
			g: like objects_grid
			lines: LIST [ES_OBJECTS_GRID_SPECIFIC_LINE]
			t: like objects_grid_data
		do
			Precursor {DEBUGGING_UPDATE_ON_IDLE} (dbg_was_stopped)
			from
				objects_grids.start
			until
				objects_grids.after
			loop
				objects_grids.item_for_iteration.grid.request_delayed_clean
				objects_grids.forth
			end

			if debugger_manager.application_is_executing then
				l_app := debugger_manager.application
				l_status := l_app.status
			end
			if l_status /= Void then
				if l_status.is_stopped and dbg_was_stopped then
					if l_status.has_valid_call_stack and then l_status.has_valid_current_eiffel_call_stack_element then
						init_specific_lines
						from
							objects_grids.start
						until
							objects_grids.after
						loop
							objects_grids.item_for_iteration.grid.cancel_delayed_clean
							objects_grids.forth
						end
						from
							objects_grids.start
						until
							objects_grids.after
						loop
							t := objects_grids.item_for_iteration
							g := t.grid
							g.call_delayed_clean
							t.grid_is_empty := False

							lines := t.lines
							from
								lines.start
							until
								lines.after
							loop
								if lines.item /= Void then
									lines.item.attach_to_row (g.extended_new_row)
								else --| Void is the place for displayed objects
									if dropped_objects_grid = g then
										add_displayed_objects_to_grid (g)
									end
								end
								lines.forth
							end
							if g.row_count > 0 then
									--| be sure the grid is redrawn, and the first row is visible
								g.row (1).redraw
							end
							g.restore_layout
							objects_grids.forth
						end
					end
				end
			end
			if header_box /= Void then
				update_header_box (dbg_was_stopped)
			end
			on_objects_row_deselected (Void) -- reset toolbar buttons
		end

feature {NONE} -- Current objects grid Implementation

	displayed_objects: LINKED_LIST [ES_OBJECTS_GRID_OBJECT_LINE];
			-- All displayed objects, their addresses, types and display options.

	add_displayed_objects_to_grid (a_target_grid: ES_OBJECTS_GRID) is
		local
			item: ES_OBJECTS_GRID_LINE
		do
			from
				displayed_objects.start
			until
				displayed_objects.after
			loop
				item := displayed_objects.item
				if item.is_attached_to_row then
					item.unattach
				end
				if item.parent_grid /= a_target_grid then
					item.relocate_to_parent_grid (a_target_grid)
				end
				item.attach_to_row (a_target_grid.extended_new_row)
				displayed_objects.forth
			end
		end

feature {NONE} -- Impl : Debugged objects grid specifics

	object_stone_dropped_on_grid (a_grid: like objects_grid; st: OBJECT_STONE) is
		local
			cst: CALL_STACK_STONE
		do
			cst ?= st
			if cst /= Void then
				drop_stack_element (cst)
			else
				check a_grid = dropped_objects_grid end
				add_debugged_object (st)
			end
		end

	grid_veto_pebble_function (a_grid: like objects_grid; a_pebble: ANY): BOOLEAN is
		local
			ost: OBJECT_STONE
			cst: CALL_STACK_STONE
		do
			if a_grid = dropped_objects_grid then
				ost ?= a_pebble
				Result := ost /= Void
			else
				cst ?= a_pebble
				Result := cst /= Void
			end
		end

	add_debugged_object (a_stone: OBJECT_STONE) is
			-- Add the object represented by `a_stone' to the managed objects.
		require
			application_is_running: debugger_manager.application_is_executing
			dropped_objects_grid_not_void: dropped_objects_grid /= Void
		local
			n_obj: ES_OBJECTS_GRID_OBJECT_LINE
			conv_spec: SPECIAL_VALUE
			abstract_value: ABSTRACT_DEBUG_VALUE
			exists: BOOLEAN
			l_item: EV_ANY
			g: like objects_grid
		do
			debug ("debug_recv")
				print (generator + ".add_object%N")
			end
			g := dropped_objects_grid
			from
				displayed_objects.start
			until
				displayed_objects.after or else exists
			loop
				n_obj := displayed_objects.item
				check
					n_obj.object_address /= Void
				end
				exists := n_obj.object_address.is_equal (a_stone.object_address)
				displayed_objects.forth
			end
			n_obj := Void
			if not exists then
				l_item := a_stone.ev_item
				if l_item /= Void then
					if debugger_manager.is_dotnet_project then
						abstract_value ?= grid_data_from_widget (l_item)
							--| FIXME jfiat : check if it is safe to use a Value ?
						if abstract_value /= Void then
							create {ES_OBJECTS_GRID_VALUE_LINE} n_obj.make_with_value (abstract_value, g)
						end
					else
						conv_spec ?= grid_data_from_widget (l_item)
						if conv_spec /= Void then
							create {ES_OBJECTS_GRID_VALUE_LINE} n_obj.make_with_value (conv_spec, g)
						end
					end
				end
				if n_obj = Void then
					create {ES_OBJECTS_GRID_ADDRESS_LINE} n_obj.make_with_address (a_stone.object_address, a_stone.dynamic_class, g)
				end

				n_obj.set_title (a_stone.name + Left_address_delim + a_stone.object_address + Right_address_delim)
				debugger_manager.application_status.keep_object (a_stone.object_address)
				displayed_objects.extend (n_obj)
				g.insert_new_row (g.row_count + 1)
				n_obj.attach_to_row (g.row (g.row_count))
				if n_obj.row.is_displayed then
					n_obj.row.ensure_visible
				end
				n_obj.row.enable_select
			end
		end

	remove_dropped_debugged_object (ost: OBJECT_STONE) is
		local
			row: EV_GRID_ROW
			gline: ES_OBJECTS_GRID_OBJECT_LINE
			sline: ES_OBJECTS_GRID_SPECIFIC_LINE
		do
			row ?= ost.ev_item
			if row /= Void then
				gline ?= row.data
				sline ?= gline
				if
					gline /= Void
					and then (sline = Void) -- or else not current_object_line.is_represented_by (gline))
				then
					remove_debugged_object_line (gline)
				end
			end
		end

	remove_selected_debugged_objects is
		local
			glines: LIST [ES_OBJECTS_GRID_OBJECT_LINE]
			line: ES_OBJECTS_GRID_OBJECT_LINE
			sline: ES_OBJECTS_GRID_SPECIFIC_LINE
		do
			glines := selected_debugged_object_lines
			if glines /= Void then
				from
					glines.start
				until
					glines.after
				loop
					line := glines.item

					check
						line /= Void
						line.row /= Void
					end
					sline ?= line
					if
						is_removable_debugged_object_row (line.row)
						and then is_removable_debugged_object_address (line.object_address)
						and then sline = Void  --(current_object_line = Void or else not current_object_line.is_represented_by (line))
					then
						remove_debugged_object_line (line)
					end
					glines.forth
				end
			end
		end

	remove_debugged_object_line (gline: ES_OBJECTS_GRID_OBJECT_LINE) is
		require
			gline_not_void: gline /= Void
		local
			row: EV_GRID_ROW
			g: like objects_grid
		do
			row := gline.row
			gline.unattach
			displayed_objects.prune_all (gline)
			g := gline.parent_grid
			if g /= Void then
--| bug#11272 : using the next line raises display issue:
--|				g.remove_row (row.index)
				g.remove_rows (row.index, row.index + row.subrow_count_recursive)
			end
		end

	selected_debugged_object_lines: LINKED_LIST [ES_OBJECTS_GRID_OBJECT_LINE] is
		local
			row: EV_GRID_ROW
			rows: ARRAYED_LIST [EV_GRID_ROW]
			gline: ES_OBJECTS_GRID_OBJECT_LINE
			g: like objects_grid
		do
			g := dropped_objects_grid
			rows := g.selected_rows
			if not rows.is_empty then
				from
					rows.start
					create Result.make
				until
					rows.after
				loop
					row := rows.item
					gline ?= row.data
					if gline /= Void then
						Result.extend (gline)
					end
					rows.forth
				end
			end
		end

	is_removable_debugged_object (ost: OBJECT_STONE): BOOLEAN is
		local
			row: EV_GRID_ROW
		do
			if ost /= Void then
				row ?= ost.ev_item
				if row /= Void then
					Result := is_removable_debugged_object_row (row)
				end
				Result := Result and then is_removable_debugged_object_address (ost.object_address)
			end
		end

	is_removable_debugged_object_row (row: EV_GRID_ROW): BOOLEAN is
		do
			Result := row.parent_row = Void
		end

	is_removable_debugged_object_address (addr: STRING): BOOLEAN is
		do
			if addr /= Void then
				from
					displayed_objects.start
				until
					displayed_objects.after or else Result
				loop
					Result := displayed_objects.item.object_address.is_equal (addr)
					displayed_objects.forth
				end
			end
		end

feature {NONE} -- Impl : Stack objects grid

	drop_stack_element (st: CALL_STACK_STONE) is
			-- Display stack element represented by `st'.
		do
			debugger_manager.launch_stone (st)
		end

	debug_value_key_action (grid: ES_OBJECTS_GRID; k: EV_KEY) is
			-- Actions performed when a key is pressed on a debug_value.
			-- Handle `Ctrl+C'.
		local
			ost: OBJECT_STONE
		do
			inspect
				k.code
			when {EV_KEY_CONSTANTS}.key_c , {EV_KEY_CONSTANTS}.key_insert then
				if
					ev_application.ctrl_pressed
					and then not ev_application.alt_pressed
					and then not ev_application.shift_pressed
				then
					update_clipboard_string_with_selection (grid)
				end
			when {EV_KEY_CONSTANTS}.key_e then
				if
					ev_application.ctrl_pressed
					and then not ev_application.alt_pressed
					and then not ev_application.shift_pressed
				then
					if grid.selected_rows.count > 0 then
						ost ?= grid.grid_pebble_from_row_and_column (grid.selected_rows.first, Void)
						object_viewer_cmd.set_stone (ost)
					end
				end
			when {EV_KEY_CONSTANTS}.key_enter then
				toggle_expanded_state_of_selected_rows (grid)
			when {EV_KEY_CONSTANTS}.key_delete then
				remove_debugged_object_cmd.execute
			else
			end
		end

feature {NONE} -- Debugged objects grid Implementation

	new_specific_line (a_id: INTEGER): ES_OBJECTS_GRID_SPECIFIC_LINE is
			--
		do
			inspect a_id
			when position_stack then
				create Result.make_as_stack
			when position_current then
				create Result.make_as_current_object
			when position_arguments then
				create Result.make_as_arguments
			when position_locals then
				create Result.make_as_locals
			when position_result then
				create Result.make_as_result
			when position_dropped then
--				create Result.make_as_dropped
			else
				check should_not_occur: False end
			end
		end

	init_specific_lines is
		local
			g: like objects_grid
			gdata: like objects_grid_data
			l: ES_OBJECTS_GRID_SPECIFIC_LINE
			lines: LIST [ES_OBJECTS_GRID_SPECIFIC_LINE]
			lst_pos: LIST [INTEGER]
			l_reused: HASH_TABLE [ARRAY [ES_OBJECTS_GRID_SPECIFIC_LINE], STRING]
			l_reused_lines: ARRAY [ES_OBJECTS_GRID_SPECIFIC_LINE]
		do
				--| Clean old lines
			from
				create l_reused.make (objects_grids.count)
				objects_grids.start
			until
				objects_grids.after
			loop
				g := objects_grids.item_for_iteration.grid
				lines := objects_grids.item_for_iteration.lines
				create l_reused_lines.make (position_stack, position_dropped)
				l_reused.put (l_reused_lines, g.id)
				from
					lines.start
				until
					lines.after
				loop
					l := lines.item
					if l /= Void then
						if l.is_attached_to_row then
							l.unattach
						end
						l_reused_lines[l.id] := l
					end
					lines.forth
				end
				objects_grids.forth
			end

				-- New lines
			dropped_objects_grid := Void
			from
				objects_grids.start
			until
				objects_grids.after
			loop
				gdata := objects_grid_data (objects_grids.key_for_iteration)
				lst_pos := gdata.ids
				gdata.lines.wipe_out
				from
					l_reused_lines := l_reused.item (objects_grids.key_for_iteration)
					lst_pos.start
				until
					lst_pos.after
				loop
					if lst_pos.item = position_dropped then
						if dropped_objects_grid /= Void then
							objects_grid_ids (dropped_objects_grid.id).prune_all (position_dropped)
						end
						dropped_objects_grid := gdata.grid
						gdata.lines.force (Void) --| FIXME: for now, Void item is the placeholder for displayed objects
					else
						l := l_reused_lines [lst_pos.item]
						if l = Void then
							l := new_specific_line (lst_pos.item)
						end
						if l /= Void then
							gdata.lines.force (l)
						end
					end
					lst_pos.forth
				end
				objects_grids.forth
			end
			if dropped_objects_grid = Void then
				check gdata /= Void end
				dropped_objects_grid := gdata.grid
			end
		end

feature {NONE} -- Constants

	Left_address_delim: STRING is " <"
	Right_address_delim: STRING is ">";

invariant

	debugger_manager_not_void: debugger_manager /= Void

	objects_grids_not_void: objects_grids /= Void

indexing
	copyright:	"Copyright (c) 1984-2006, Eiffel Software"
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
			distributed in the hope that it will be useful,	but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the	GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301  USA
		]"
	source: "[
			 Eiffel Software
			 356 Storke Road, Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"

end
