indexing
	description: "Shared object that manages all debugging actions."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	author: "$Author$"
	date: "$Date$"
	revision: "$Revision$"

class
	EB_DEBUGGER_MANAGER

inherit

	DEBUGGER_MANAGER
		redefine
			make,
			controller,
			classic_debugger_timeout,
			classic_debugger_location,
			classic_close_dbg_daemon_on_end_of_debugging,
			dotnet_keep_stepping_info_non_eiffel_feature_pref,
			change_current_thread_id,
			on_application_before_launching,
			on_application_launched,
			on_application_before_resuming,
			on_application_resumed,
			on_application_before_stopped,
			on_application_just_stopped,
			on_application_quit,
			process_breakpoint,
			implementation,
			set_default_parameters,
			set_maximum_stack_depth,
			notify_breakpoints_changes,
			add_idle_action, remove_idle_action, new_timer,
			debugger_output_message, debugger_warning_message, debugger_status_message,
			display_application_status, display_system_info, display_debugger_info,
			set_error_message,
			windows_handle
		end

	EB_CONSTANTS

	EB_SHARED_INTERFACE_TOOLS

	EB_SHARED_GRAPHICAL_COMMANDS

	EB_SHARED_PREFERENCES

	EB_ERROR_MANAGER
		rename
			set_error_message as eb_set_error_message
		end

	EV_SHARED_APPLICATION

create
	make

feature {NONE} -- Initialization

	make is
			-- Initialize `Current'.
		local
			pbool: BOOLEAN_PREFERENCE
		do
			Precursor

			if not eiffel_project.batch_mode then
					--| When compiling in batch mode with the graphical "ec"
				create debug_run_cmd.make

					--| Graphical Preferences settings
				objects_split_proportion := preferences.debug_tool_data.local_vs_object_proportion

				display_agent_details := preferences.debug_tool_data.display_agent_details
				preferences.debug_tool_data.display_agent_details_preference.typed_change_actions.extend (
						agent (b: BOOLEAN)
							do
								display_agent_details := b
							end
					)

				pbool := preferences.debugger_data.debug_output_evaluation_enabled_preference
				dump_value_factory.set_debug_output_evaluation_enabled (pbool.value)
				pbool.typed_change_actions.extend (agent dump_value_factory.set_debug_output_evaluation_enabled)

					--| End of settings
				init_commands
				create watch_tool_list.make
			end

			create {DEBUGGER_TEXT_FORMATTER_OUTPUT} text_formatter_visitor.make
		end

	set_default_parameters
			-- Set hard coded default parameters values
			-- (export status {NONE})
		do
			Precursor {DEBUGGER_MANAGER}
			if preferences.debugger_data /= Void then
				set_slices (preferences.debugger_data.min_slice, preferences.debugger_data.max_slice)
				set_displayed_string_size (preferences.debugger_data.default_displayed_string_size)
				set_maximum_stack_depth (preferences.debugger_data.default_maximum_stack_depth)

				set_max_evaluation_duration (preferences.debugger_data.max_evaluation_duration)
				preferences.debugger_data.max_evaluation_duration_preference.typed_change_actions.extend (agent set_max_evaluation_duration)
			end
			check
				displayed_string_size: displayed_string_size = preferences.debugger_data.default_displayed_string_size
				max_evaluation_duration_set: preferences.debugger_data /= Void implies
						max_evaluation_duration = preferences.debugger_data.max_evaluation_duration
			end
		end

	init_commands is
			-- Create a new project toolbar.
		local
			l_cmd: EB_STANDARD_CMD
		do
			create show_tool_commands.make (6)

				-- Show call stack command.
			l_cmd := new_std_cmd (  Interface_names.t_call_stack_tool,
									Pixmaps.icon_pixmaps.tool_call_stack_icon,
									preferences.misc_shortcut_data.shortcuts.item ("show_call_stack_tool"), True,
									agent show_call_stack_tool
								)
			show_tool_commands.extend (l_cmd)
			show_call_stack_tool_command := l_cmd

				-- Show objects tool command.
			l_cmd := new_std_cmd (  Interface_names.t_object_tool,
									Pixmaps.icon_pixmaps.tool_objects_icon,
									preferences.misc_shortcut_data.shortcuts.item ("show_objects_tool"), True,
									agent show_objects_tool
								)
			show_tool_commands.extend (l_cmd)
			show_objects_tool_command := l_cmd

				-- Show thread tool command.
			l_cmd := new_std_cmd (  Interface_names.t_threads_tool,
									Pixmaps.icon_pixmaps.tool_threads_icon,
									preferences.misc_shortcut_data.shortcuts.item ("show_threads_tool"), True,
									agent show_thread_tool
								)
			show_tool_commands.extend (l_cmd)
			show_thread_tool_command := l_cmd

				-- Show object viewer tool command.
			l_cmd := new_std_cmd (  Interface_names.t_Object_viewer_tool,
									Pixmaps.icon_pixmaps.debugger_object_expand_icon,
									preferences.misc_shortcut_data.shortcuts.item ("show_object_viewer_tool"), True,
									agent show_object_viewer_tool
								)
			show_tool_commands.extend (l_cmd)
			show_object_viewer_tool_command := l_cmd

				-- Create and show watch tool command.
			l_cmd := new_std_cmd (  Interface_names.f_create_new_watch,
									Pixmaps.icon_pixmaps.tool_watch_icon,
									show_watch_tool_preference, False, --| Only make use of shortcut displayed string.									
									agent create_and_show_new_watch_tool
								)
			show_tool_commands.extend (l_cmd)
			create_and_show_watch_tool_command := l_cmd

				-- Show watch tool command.
			l_cmd := new_std_cmd (  Interface_names.t_watch_tool,
									Pixmaps.icon_pixmaps.tool_watch_icon,
									show_watch_tool_preference, True,
									agent show_new_or_hidden_watch_tool
								)
			show_tool_commands.extend (l_cmd)
			show_watch_tool_command := l_cmd

--| FIXME XR: TODO: Add:
--| 3) edit feature, feature evaluation
			create toolbarable_commands.make (20)

			create clear_bkpt
			clear_bkpt.enable_sensitive
			toolbarable_commands.extend (clear_bkpt)

			create enable_bkpt
			enable_bkpt.enable_sensitive
			toolbarable_commands.extend (enable_bkpt)

			create disable_bkpt
			disable_bkpt.enable_sensitive
			toolbarable_commands.extend (disable_bkpt)

			create bkpt_info_cmd.make
			bkpt_info_cmd.set_pixmap (pixmaps.icon_pixmaps.tool_breakpoints_icon)
			bkpt_info_cmd.set_pixel_buffer (pixmaps.icon_pixmaps.tool_breakpoints_icon_buffer)
			bkpt_info_cmd.set_tooltip (Interface_names.e_Bkpt_info)
			bkpt_info_cmd.set_menu_name (Interface_names.m_Bkpt_info)
			bkpt_info_cmd.set_tooltext (Interface_names.b_Bkpt_info)
			bkpt_info_cmd.set_name ("Bkpt_info")
			bkpt_info_cmd.add_agent (agent toggle_display_breakpoints)
			bkpt_info_cmd.enable_sensitive
			toolbarable_commands.extend (bkpt_info_cmd)

			create system_info_cmd.make
			system_info_cmd.set_pixmap (pixmaps.icon_pixmaps.command_system_info_icon)
			system_info_cmd.set_pixel_buffer (pixmaps.icon_pixmaps.command_system_info_icon_buffer)
			system_info_cmd.set_tooltip (Interface_names.e_Display_system_info)
			system_info_cmd.set_menu_name (Interface_names.m_Display_system_info)
			system_info_cmd.set_name ("System_info")
			system_info_cmd.set_tooltext (Interface_names.b_System_info)
			system_info_cmd.add_agent (agent display_system_status)
			toolbarable_commands.extend (system_info_cmd)

			create set_critical_stack_depth_cmd.make
			set_critical_stack_depth_cmd.set_menu_name (Interface_names.m_Set_critical_stack_depth)
			set_critical_stack_depth_cmd.add_agent (agent change_critical_stack_depth)
			set_critical_stack_depth_cmd.enable_sensitive

			create display_error_help_cmd.make
			toolbarable_commands.extend (display_error_help_cmd)

			create exception_handler_cmd.make
			exception_handler_cmd.enable_sensitive
			toolbarable_commands.extend (exception_handler_cmd)

			create assertion_checking_handler_cmd.make
			assertion_checking_handler_cmd.enable_sensitive
			toolbarable_commands.extend (assertion_checking_handler_cmd)
			create force_debug_mode_cmd.make (Current)
			force_debug_mode_cmd.enable_sensitive
			toolbarable_commands.extend (force_debug_mode_cmd)

			create options_cmd.make (Current)
			toolbarable_commands.extend (options_cmd)
			create step_cmd.make (Current)
			toolbarable_commands.extend (step_cmd)
			create into_cmd.make (Current)
			toolbarable_commands.extend (into_cmd)
			create out_cmd.make (Current)
			toolbarable_commands.extend (out_cmd)
			create debug_cmd.make (Current)
			toolbarable_commands.extend (debug_cmd)
			create no_stop_cmd.make (Current)
			toolbarable_commands.extend (no_stop_cmd)
			create stop_cmd.make (Current)
			toolbarable_commands.extend (stop_cmd)
			create restart_cmd.make (Current)
			toolbarable_commands.extend (restart_cmd)
			create quit_cmd.make (Current)
			toolbarable_commands.extend (quit_cmd)

			step_cmd.enable_sensitive
			into_cmd.enable_sensitive
			out_cmd.enable_sensitive
			debug_cmd.enable_sensitive
			no_stop_cmd.enable_sensitive
			stop_cmd.disable_sensitive
			quit_cmd.disable_sensitive
			restart_cmd.disable_sensitive

			toolbarable_commands.extend (system_cmd)
			toolbarable_commands.extend (Melt_project_cmd)
			toolbarable_commands.extend (Freeze_project_cmd)
			toolbarable_commands.extend (Finalize_project_cmd)
			run_finalized_cmd.enable_sensitive
			toolbarable_commands.extend (run_finalized_cmd)
			toolbarable_commands.extend (override_scan_cmd)
			toolbarable_commands.extend (discover_melt_cmd)

				-- Disable commands if no project is loaded
			if not Eiffel_project.manager.is_project_loaded then
				if Eiffel_project.manager.is_created then
					enable_commands_on_project_created
				else
					disable_commands_on_project_unloaded
				end
			else
				enable_commands_on_project_loaded
			end

				-- Enable/Disable commands on project loading/unloading.
			Eiffel_project.manager.create_agents.extend (agent enable_commands_on_project_created)
			Eiffel_project.manager.load_agents.extend (agent enable_commands_on_project_loaded)
			Eiffel_project.manager.close_agents.extend (agent disable_commands_on_project_unloaded)
		end

feature -- Settings

	classic_debugger_timeout: INTEGER is
		do
			if preferences.debugger_data /= Void then
				Result := preferences.debugger_data.classic_debugger_timeout
			end
		end

	classic_debugger_location: STRING is
		do
			if preferences.debugger_data /= Void then
				Result := preferences.debugger_data.classic_debugger_location
			end
		end

	classic_close_dbg_daemon_on_end_of_debugging: BOOLEAN is
		do
			if preferences.debugger_data /= Void then
				Result := preferences.debugger_data.close_classic_dbg_daemon_on_end_of_debugging
			end
		end

	dotnet_keep_stepping_info_non_eiffel_feature_pref: BOOLEAN_PREFERENCE is
		do
			if preferences.debugger_data /= Void then
				Result := preferences.debugger_data.keep_stepping_info_dotnet_feature_preference
			end
		end

feature -- Properties

	controller: EB_DEBUGGER_CONTROLLER

feature -- Access

	clear_bkpt: EB_CLEAR_STOP_POINTS_COMMAND
			-- Command that can remove one or more breakpoints from the system.

	enable_bkpt: EB_DEBUG_STOPIN_HOLE_COMMAND
			-- Command that can enable one or more breakpoints in the system.

	disable_bkpt: EB_DISABLE_STOP_POINTS_COMMAND
			-- Command that can disable one or more breakpoints in the system.

	debug_run_cmd: EB_DEBUG_RUN_CMD
		-- Command to run the project under debugger.

	toolbarable_commands: ARRAYED_LIST [EB_TOOLBARABLE_AND_MENUABLE_COMMAND]
			-- All commands that can be put in a toolbar.

	show_tool_commands: ARRAYED_LIST [EB_STANDARD_CMD]
			-- Show tool commands.

	show_call_stack_tool_command: EB_STANDARD_CMD
			-- Show call stack command

	show_objects_tool_command: EB_STANDARD_CMD
			-- Show object tool command

	show_thread_tool_command: EB_STANDARD_CMD
			-- Show thread tool command

	show_object_viewer_tool_command: EB_STANDARD_CMD
			-- Show object viewer tool command			

	show_watch_tool_command: EB_STANDARD_CMD
			-- Show watch tool command

	create_and_show_watch_tool_command: EB_STANDARD_CMD
			-- Create and show watch tool.

	force_debug_mode_cmd: EB_FORCE_DEBUG_MODE_CMD
			-- Force debug mode command.

feature -- tools

	call_stack_tool: EB_CALL_STACK_TOOL
			-- A tool that represents the call stack in a graphical display.

	threads_tool: ES_DBG_THREADS_TOOL
			-- A tool that represents the threads list in a graphical display.

	objects_tool: ES_OBJECTS_TOOL

	object_viewer_tool: EB_OBJECT_VIEWERS_TOOL

	watch_tool_list: LINKED_SET [ES_WATCH_TOOL]

	all_tools: ARRAYED_LIST [EB_TOOL] is
			-- All managed tools.
		local
			l_wc: INTEGER
			l_list: LINKED_SET [ES_WATCH_TOOL]
		do
			if watch_tool_list /= Void then
				l_wc := watch_tool_list.count
			end
			create Result.make (3 + l_wc)
			if call_stack_tool /= Void then
				Result.extend (call_stack_tool)
			end
			if threads_tool /= Void then
				Result.extend (threads_tool)
			end
			if objects_tool /= Void then
				Result.extend (objects_tool)
			end
			if object_viewer_tool /= Void then
				Result.extend (object_viewer_tool)
			end
			if watch_tool_list /= Void then
				from
					l_list := watch_tool_list
					l_list.start
				until
					l_list.after
				loop
					Result.extend (l_list.item)
					l_list.forth
				end
			end
		ensure
			result_not_void: Result /= Void
		end

feature -- Output visitor

	text_formatter_visitor: DEBUGGER_TEXT_FORMATTER_VISITOR

feature -- tools management

	refresh_objects_grids is
			-- Refresh objects grids
			-- most likely due to display parameters changes
		do
			objects_tool.refresh
			watch_tool_list.do_all (agent {ES_WATCH_TOOL}.refresh)
		end

	new_toolbar (a_recycler: EB_RECYCLER): ARRAYED_SET [SD_TOOL_BAR_ITEM] is
			-- Toolbar containing all debugging commands.
		require
			a_recycler_not_void: a_recycler /= Void
		local
			l_button: EB_SD_COMMAND_TOOL_BAR_BUTTON
		do
			Result := preferences.debug_tool_data.retrieve_project_toolbar (toolbarable_commands)
			from
				Result.start
			until
				Result.after
			loop
				l_button ?= Result.item
				if l_button /= Void then
					a_recycler.add_recyclable (l_button)
				end
				Result.forth
			end
		end

	new_debug_menu (a_recycler: EB_RECYCLER): EV_MENU is
			-- Generate a menu that can be displayed in development windows.
		require
			a_recycler_not_void: a_recycler /= Void
			--| commands_initialized: toolbarable_commands /= Void
		local
			sep: EV_MENU_SEPARATOR
			l_item: EB_COMMAND_MENU_ITEM
		do
			create Result.make_with_text (Interface_names.m_Debug)

			l_item := clear_bkpt.new_menu_item
			Result.extend (clear_bkpt.new_menu_item)
			a_recycler.add_recyclable (l_item)
			l_item := disable_bkpt.new_menu_item
			Result.extend (l_item)
			a_recycler.add_recyclable (l_item)
			l_item := enable_bkpt.new_menu_item
			Result.extend (l_item)
			a_recycler.add_recyclable (l_item)
			l_item := bkpt_info_cmd.new_menu_item
			Result.extend (l_item)
			a_recycler.add_recyclable (l_item)

				-- Separator.
			create sep
			Result.extend (sep)

			l_item := options_cmd.new_menu_item
			Result.extend (l_item)
			a_recycler.add_recyclable (l_item)

				-- Separator.
			create sep
			Result.extend (sep)
			a_recycler.add_recyclable (l_item)

			l_item := step_cmd.new_menu_item
			Result.extend (l_item)
			a_recycler.add_recyclable (l_item)
			l_item := into_cmd.new_menu_item
			Result.extend (l_item)
			a_recycler.add_recyclable (l_item)
			l_item := out_cmd.new_menu_item
			Result.extend (l_item)
			a_recycler.add_recyclable (l_item)

				-- Separator.
			create sep
			Result.extend (sep)

			l_item := debug_cmd.new_menu_item
			Result.extend (l_item)
			a_recycler.add_recyclable (l_item)
			l_item := no_stop_cmd.new_menu_item
			Result.extend (l_item)
			a_recycler.add_recyclable (l_item)

				-- Separator.
			create sep
			Result.extend (sep)

			l_item := stop_cmd.new_menu_item
			Result.extend (l_item)
			a_recycler.add_recyclable (l_item)
			l_item := quit_cmd.new_menu_item
			Result.extend (l_item)
			a_recycler.add_recyclable (l_item)

				-- Separator.
			create sep
			Result.extend (sep)

			l_item := set_critical_stack_depth_cmd.new_menu_item
			Result.extend (l_item)
			a_recycler.add_recyclable (l_item)

				-- Separator.
			create sep
			Result.extend (sep)
			l_item := exception_handler_cmd.new_menu_item
			Result.extend (l_item)
			a_recycler.add_recyclable (l_item)

				-- Separator.
			create sep
			Result.extend (sep)
			l_item := assertion_checking_handler_cmd.new_menu_item
			Result.extend (l_item)
			a_recycler.add_recyclable (l_item)
			l_item := force_debug_mode_cmd.new_menu_item
			Result.extend (l_item)
			a_recycler.add_recyclable (l_item)

--| FIXME XR: TODO: Add:
--| 3) edit feature, feature evaluation
		end

	new_debugging_tools_menu: EV_MENU is
			-- New debugging tools menu.
		do
			create Result.make_with_text (Interface_names.m_Tools)
			Result.disable_sensitive
		ensure
			Result /= Void
		end

	update_debugging_tools_menu_from (w: EB_DEVELOPMENT_WINDOW) is
			-- Update the debugging_tools_menu related to `w'	
		require
			w /= Void
		local
			m: EV_MENU
			mi: EB_COMMAND_MENU_ITEM
			mn: STRING_GENERAL
			wt: ES_WATCH_TOOL
			l_recyclable: EB_RECYCLABLE
			l_bptool: ES_BREAKPOINTS_TOOL
			l_show_cmd: EB_SHOW_TOOL_COMMAND
		do
			m := w.menus.debugging_tools_menu
				-- Recycle existing menu items.
			from
				m.start
			until
				m.after
			loop
				l_recyclable ?= m.item
				if l_recyclable /= Void then
					l_recyclable.recycle
					w.remove_recyclable (l_recyclable)
				end
				m.forth
			end
			m.wipe_out

			if raised then
				if debugging_window /= Void then
					l_bptool := debugging_window.tools.breakpoints_tool
					l_show_cmd := debugging_window.commands.show_tool_commands.item (l_bptool)
					mi := l_show_cmd.new_menu_item
					m.extend (mi)
					w.add_recyclable (mi)
				end
				mi := show_call_stack_tool_command.new_menu_item
				m.extend (mi)
				w.add_recyclable (mi)
				mi := show_thread_tool_command.new_menu_item
				m.extend (mi)
				w.add_recyclable (mi)
				mi := show_objects_tool_command.new_menu_item
				m.extend (mi)
				w.add_recyclable (mi)
				mi := show_object_viewer_tool_command.new_menu_item
				m.extend (mi)
				w.add_recyclable (mi)


					-- Do not display shortcut if any watch tool exists.
				if not watch_tool_list.is_empty then
					create_and_show_watch_tool_command.set_referred_shortcut (Void)
				else
					create_and_show_watch_tool_command.set_referred_shortcut (show_watch_tool_preference)
				end
				mi := create_and_show_watch_tool_command.new_menu_item
				m.extend (mi)
				w.add_recyclable (mi)

				if not watch_tool_list.is_empty then
					m.extend (create {EV_MENU_SEPARATOR})
					from
						watch_tool_list.start
					until
						watch_tool_list.after
					loop
						wt := watch_tool_list.item
						mn := wt.menu_name.twin
						if show_watch_tool_command.shortcut_available then
							mn.append ("%T")
							mn.append (show_watch_tool_command.shortcut_string)
						end
						mi := show_watch_tool_command.new_menu_item
						mi.set_text (mn)
						mi.select_actions.wipe_out
						mi.select_actions.extend (agent wt.show)
						m.extend (mi)
						w.add_recyclable (mi)

						watch_tool_list.forth
					end
				end
				m.enable_sensitive
			else
				m.disable_sensitive
			end
		end

	update_all_debugging_tools_menu is
			-- Update all debugging_tools_menu in all development windows
		do
			window_manager.for_all_development_windows (agent update_debugging_tools_menu_from)
		end

	show_call_stack_tool is
			-- Show call stack tool if any.
		do
			if call_stack_tool /= Void and raised then
				call_stack_tool.show
			end
		end

	show_thread_tool is
			-- Show thread tool if any.
		do
			if threads_tool /= Void and raised then
				threads_tool.show
			end
		end

	show_objects_tool is
			-- Show object tool if any.
		do
			if objects_tool /= Void and raised then
				objects_tool.show
			end
		end

	show_object_viewer_tool is
			-- Show object viewer tool if any.
		do
			if object_viewer_tool /= Void and raised then
				object_viewer_tool.show
			end
		end

	show_new_or_hidden_watch_tool is
			-- Show a hidden watch tool if any.
			-- If all shown, show next one.
		local
			l_watch_tools: like watch_tool_list
			l_shown: BOOLEAN
			l_watch_tool: ES_WATCH_TOOL
			l_focused_watch_index: INTEGER
		do
			if raised then
				l_watch_tools := watch_tool_list
				if l_watch_tools.is_empty then
					create_and_show_new_watch_tool
				else
					from
						l_watch_tools.start
					until
						l_watch_tools.after
					loop
						if l_watch_tools.item.content.has_focus then
							l_shown := True
							l_focused_watch_index := l_watch_tools.index
						end
						if l_watch_tool = Void and then not l_watch_tools.item.shown then
							l_watch_tool := l_watch_tools.item
						end
						l_watch_tools.forth
					end
					if l_watch_tool /= Void then
						l_watch_tool.show
					else
						if l_focused_watch_index = l_watch_tools.count then
							l_focused_watch_index := 1
						else
							l_focused_watch_index := l_focused_watch_index + 1
						end
						l_watch_tools.i_th (l_focused_watch_index).show
					end
				end
			end
		end

	create_and_show_new_watch_tool is
			-- Create a new watch tool attached to current debugging window
		local
			t: EB_TOOL
		do
			if debugging_window /= Void then
				if not watch_tool_list.is_empty then
					t := watch_tool_list.last
				else
					t := objects_tool
				end
				create_new_watch_tool_inside_notebook (debugging_window, t)
				watch_tool_list.last.show
			end
		end

	create_new_watch_tool_inside_notebook (a_manager: EB_DEVELOPMENT_WINDOW; a_tool: EB_TOOL) is
			-- Create a new watch tool.
		require
			a_manager /= Void
		local
			l_watch_tool: ES_WATCH_TOOL
			i: INTEGER
		do
			i := new_watch_tool_number

				--| Create watch tool
			create l_watch_tool.make_with_title (a_manager, Current,
					last_watch_tool_number,
					Interface_names.t_watch_tool.as_string_32 + " #" + i.out,
					Interface_names.to_watch_tool + i.out
				)
			if
				a_tool /= Void
				and then a_tool.content /= Void
				and then a_tool.content.is_visible
			then
			 	l_watch_tool.attach_to_docking_manager_with (a_manager.docking_manager, a_tool)
			else
				l_watch_tool.attach_to_docking_manager (a_manager.docking_manager)
			end
			watch_tool_list.extend (l_watch_tool)
			assign_watch_tool_unique_titles
			update_all_debugging_tools_menu
		end

	close_watch_tool (wt: ES_WATCH_TOOL) is
		require
			wt /= Void
		do
			wt.close
			watch_tool_list.prune_all (wt)
		end

feature -- Events helpers

	new_timer: EV_DEBUGGER_TIMER is
		do
			create Result
		end

	add_idle_action (v: PROCEDURE [ANY, TUPLE]) is
		do
			ev_application.add_idle_action (v)
		end

	remove_idle_action (v: PROCEDURE [ANY, TUPLE]) is
		do
			ev_application.remove_idle_action (v)
		end

feature -- GUI Access

	windows_handle: POINTER is
		do
			Result := implementation.ev_window_win32_handle (debugging_window.window)
		end

feature {NONE} -- watch tool numbering

	new_watch_tool_number: INTEGER is
		do
				--| Get new watch id
			if watch_tool_list.is_empty then
				last_watch_tool_number := 1
			else
				last_watch_tool_number := last_watch_tool_number + 1
			end
			Result := last_watch_tool_number
		end

	last_watch_tool_number: INTEGER

feature -- Status report

	debugging_window: EB_DEVELOPMENT_WINDOW
			-- Window in which the debugger was launched (via run...).

	raised: BOOLEAN
			-- Are the debugging tools currently raised?

	debug_mode_forced: BOOLEAN
			-- Do we force debugger interface to stay raised ?

	is_exiting_eiffel_studio: BOOLEAN
			-- Is exiting Eiffel Studio now?

feature -- Output

	debugger_output_message (m: STRING_GENERAL) is
		do
			check output_manager /= Void end
			output_manager.start_processing (True)
			output_manager.add_string (m)
			output_manager.add_new_line
			output_manager.end_processing
		end

	debugger_warning_message (m: STRING_GENERAL) is
		local
			w_dlg: EV_WARNING_DIALOG
		do
			if ev_application = Void then
				Precursor {DEBUGGER_MANAGER} (m)
			else
				create w_dlg.make_with_text (m)
				if window_manager.last_focused_development_window /= Void then
					w_dlg.show_modal_to_window (window_manager.last_focused_development_window.window)
				else
					w_dlg.show
				end
			end
		end

	debugger_status_message (m: STRING_GENERAL) is
		do
			if m.index_of_code (('%N').natural_32_code, 1) = 0 then
				window_manager.display_message (m)
			end
		end

	display_application_status is
		do
			output_manager.display_application_status
		end

	display_system_info	is
		do
			output_manager.display_system_info
		end

	display_debugger_info is
		do
			text_formatter_visitor.append_debugger_information (Current, output_manager)
		end

	display_system_status is
		do
			display_system_info
			if application_is_executing then
				display_debugger_info
			end
		end

feature -- Change

	set_error_message (s: STRING) is
		do
			eb_set_error_message (s)
		end

	toggle_display_breakpoints is
			-- Show or hide the breakpoint tool
		local
			bp_tool: ES_BREAKPOINTS_TOOL
			conv_dev: EB_DEVELOPMENT_WINDOW
		do
			conv_dev := last_focused_development_window (False)
			if conv_dev /= Void then
				bp_tool := conv_dev.tools.breakpoints_tool
				if bp_tool /= Void then
					bp_tool.show
				end
			end
		end

	display_breakpoints (show_tool_if_closed: BOOLEAN) is
			-- Show the list of breakpoints (set and disabled) in the output manager.
		local
			bp_tool: ES_BREAKPOINTS_TOOL
			conv_dev: EB_DEVELOPMENT_WINDOW
		do
			conv_dev := last_focused_development_window (False)
			if conv_dev /= Void then
				bp_tool := conv_dev.tools.breakpoints_tool
				if bp_tool /= Void then
					if show_tool_if_closed then
						bp_tool.show
					end
				end
			end
		end

	last_focused_development_window (create_if_void: BOOLEAN): EB_DEVELOPMENT_WINDOW is
		do
			Result := window_manager.last_focused_development_window
			if Result = Void and create_if_void then
				Result := window_manager.a_development_window
			end
		end

	notify_breakpoints_changes is
		do
			Precursor
			display_breakpoints (False)
			window_manager.synchronize_all_about_breakpoints
		end

	refresh_commands (a_window: EB_DEVELOPMENT_WINDOW) is
			-- Refresh commands with their interfaces/shortcuts.
		require
			a_window_not_void: a_window /= Void
		local
			l_cmds: like show_tool_commands
			w: EB_VISION_WINDOW
		do
			w := a_window.window
			bkpt_info_cmd.update (w)
			set_critical_stack_depth_cmd.update (w)
			exception_handler_cmd.update (w)
			assertion_checking_handler_cmd.update (w)
			options_cmd.update (w)
			force_debug_mode_cmd.update (w)
			stop_cmd.update (w)
			quit_cmd.update (w)
			step_cmd.update (w)
			out_cmd.update (w)
			into_cmd.update (w)
			debug_cmd.update (w)
			restart_cmd.update (w)
			no_stop_cmd.update (w)

			from
				l_cmds := show_tool_commands
				l_cmds.start
			until
				l_cmds.after
			loop
				l_cmds.item.update (w)
				l_cmds.forth
			end

			update_debugging_tools_menu_from (a_window)
		end

feature -- Status setting

	force_debug_mode (a_save_tools_layout: BOOLEAN) is
			-- Force debug mode
		do
			debug_mode_forced := True
			if not raised then
				raise_saving_layout (a_save_tools_layout)
			end
		end

	unforce_debug_mode is
			-- unForce debug mode
		require
			debug_mode_forced = True
		do
			debug_mode_forced := False
			if raised
				and not application_launching_in_progress
				and not application_is_executing
			then
				unraise
			end
		end

	set_debugging_window (a_window: EB_DEVELOPMENT_WINDOW) is
			-- Associate `Current' with `a_window'.
		do
			if not raised then
				debugging_window := a_window
			end
		end

	set_maximum_stack_depth (nb: INTEGER) is
			-- Set the maximum number of stack elements to be displayed to `nb'.
		local
			pos: INTEGER
			cst: CALL_STACK_STONE
			ecs: EIFFEL_CALL_STACK
			st: APPLICATION_STATUS
		do
			Precursor (nb)
			if application_is_executing then
				st := application_status
				st.set_max_depth (nb)
				if st.is_stopped then
					pos := application.current_execution_stack_number
					st.force_reload_current_call_stack
					ecs := st.current_call_stack
					if ecs = Void or else ecs.is_empty then
						--| Nothing to display, maybe debugger had an issue getting call stack ..
					else
						if pos > st.current_call_stack.count then
								-- We reloaded less elements than there were.
							pos := 1
						end
						call_stack_tool.update
						create cst.make (pos)
						if cst.is_valid then
							launch_stone (cst)
						end
					end
				end
			end
		end

	on_compile_start is
			-- A new compilation has started. Kill any debugged application and gray out all run* commands.
		do
			if application_is_executing then
				application.kill
			end
			no_stop_cmd.disable_sensitive
			debug_cmd.disable_sensitive
			step_cmd.disable_sensitive
			out_cmd.disable_sensitive
			into_cmd.disable_sensitive
			assertion_checking_handler_cmd.disable_sensitive
		end

	on_compile_stop is
			-- A compilation is over. Make all run* commands sensitive.
		do
			if is_msil_dll_system then
				disable_debugging_commands (True)
			else
				if not process_manager.is_freezing_running then
					step_cmd.enable_sensitive
					into_cmd.enable_sensitive
					no_stop_cmd.enable_sensitive
					debug_cmd.enable_sensitive
					enable_debug
				end
			end
		end

	raise is
			-- Make the debug tools appear in `debugging_window'.
			-- Save tools layout.
		do
			raise_saving_layout (True)
		end

	raise_saving_layout (a_save: BOOLEAN) is
			-- Make the debug tools appear in `debugging_window'.
			-- If `a_save' True, then save tools layout, otherwise not save.
		require
			not_already_raised: not raised
		local
			split: EV_SPLIT_AREA
			l_watch_tool: ES_WATCH_TOOL
			l_watch_tool_list: like watch_tool_list
			l_tool: EB_TOOL
			l_docking_manager: SD_DOCKING_MANAGER
			nwt: INTEGER
			l_unlock: BOOLEAN
		do
			force_debug_mode_cmd.disable_sensitive
			initialize_debugging_window
			check
				debugging_window_set: debugging_window /= Void
			end

				--| Switching popup
			popup_switching_mode

			if ev_application.locked_window = Void then
				l_unlock := True
				debugging_window.window.lock_update
			end

			if a_save then
				debugging_window.save_tools_docking_layout
			end

				-- Change the state of the debugging window.
			debugging_window.hide_tools
			l_docking_manager := debugging_window.docking_manager

				--| Before any objects and watches tools
			if object_viewer_cmd = Void then
				create object_viewer_cmd.make
			end
			object_viewer_cmd.enable_sensitive

				--| Grid Objects Tool
			if objects_tool = Void then
				create objects_tool.make_with_debugger (debugging_window, Current)
			else
				objects_tool.set_manager (debugging_window)
			end
			objects_tool.attach_to_docking_manager (l_docking_manager)

			objects_tool.set_cleaning_delay (preferences.debug_tool_data.delay_before_cleaning_objects_grid)
			objects_tool.request_update

				--| object viewer Objects Tool
			if object_viewer_tool = Void then
				object_viewer_tool := object_viewer_cmd.new_tool (debugging_window)
			else
				object_viewer_tool.set_manager (debugging_window)
			end
			object_viewer_tool.attach_to_docking_manager (l_docking_manager)

				--| Watches tool
			l_watch_tool_list := watch_tool_list
				--| At least one watch tool
			nwt := Preferences.debug_tool_data.number_of_watch_tools.max (1)
			if l_watch_tool_list.count < nwt  then
				from
					l_tool := Void
					if not l_watch_tool_list.is_empty then
						l_watch_tool := l_watch_tool_list.last
						if l_watch_tool.shown then
							l_tool := l_watch_tool
						end
					end
				until
					l_watch_tool_list.count >= nwt
				loop
					create_new_watch_tool_inside_notebook (debugging_window, l_tool)
				end
			elseif not l_watch_tool_list.is_empty then
				from
					l_tool := Void
					if not l_watch_tool_list.is_empty then
						l_watch_tool := l_watch_tool_list.last
						if l_watch_tool.shown then
							l_tool := l_watch_tool
						end
					end
					l_watch_tool_list.start
				until
					l_watch_tool_list.after
				loop
					l_watch_tool := l_watch_tool_list.item
					if l_watch_tool /= Void then
						l_watch_tool.set_manager (debugging_window)
						if l_tool /= Void and then l_watch_tool.content /= Void and then l_watch_tool.content.target_content_shown (l_tool.content) then
							l_watch_tool.attach_to_docking_manager_with (l_docking_manager, l_tool)
						else
							l_watch_tool.attach_to_docking_manager (l_docking_manager)
						end
					end
					l_watch_tool_list.forth
				end
			end
			l_watch_tool_list.do_all (agent {ES_WATCH_TOOL}.prepare_for_debug)
			l_watch_tool_list.do_all (agent {ES_WATCH_TOOL}.request_update)

				--| Threads Tool
			if threads_tool = Void then
				create threads_tool.make (debugging_window)
			end
			threads_tool.attach_to_docking_manager (debugging_window.docking_manager)
			threads_tool.request_update

				--| Call Stack Tool
			if call_stack_tool = Void then
				create call_stack_tool.make (debugging_window)
			end
			call_stack_tool.attach_to_docking_manager (debugging_window.docking_manager)
			call_stack_tool.request_update

				-- Show Tools and final visual settings
			debugging_window.show_tools
			restore_debug_docking_layout


				--| Watch tool can not be simply hidden
				--| they are shown or closed.
			from
				l_tool := Void
				if not l_watch_tool_list.is_empty then
					l_watch_tool := l_watch_tool_list.last
					if l_watch_tool.shown then
						l_tool := l_watch_tool
					end
				end
				if l_tool = Void
					and then objects_tool /= Void
					and then objects_tool.shown
				then
					l_tool := objects_tool
				end
				l_watch_tool_list.start
			until
				l_watch_tool_list.after
			loop
				l_watch_tool := l_watch_tool_list.item
				if l_watch_tool.content /= Void and then not l_watch_tool.content.is_visible then
					if l_tool /= Void then
						l_watch_tool.content.set_tab_with (l_tool.content, False)
					end
					l_watch_tool.content.show
				end
				l_watch_tool_list.forth
			end

				--| Set the Grid Objects tool split position to 200 which is the default size of the local tree.
			split ?= objects_tool.widget
			if split /= Void then
				if 0 <= objects_split_proportion and objects_split_proportion <= 1 then
					split.set_proportion (objects_split_proportion)
				end
				split := Void
			end

			raised := True
			if l_unlock then
				debugging_window.window.unlock_update
			end
			update_all_debugging_tools_menu
			unpopup_switching_mode
			force_debug_mode_cmd.enable_sensitive
		ensure
			raised
		end

	restore_debug_docking_layout is
			-- Restore debug docking layout
		local
			l_result: BOOLEAN
			l_file: RAW_FILE

		do
			create l_file.make (debugging_window.docking_debug_config_file)
			if l_file.exists then
				l_result := debugging_window.docking_manager.open_tools_config (debugging_window.docking_debug_config_file)
			end
			if not l_result then
				restore_standard_debug_docking_layout
			end

			debugging_window.menus.update_menu_lock_items
			debugging_window.menus.update_show_tool_bar_items

			refresh_breakpoints_tool
		end

	save_debug_docking_layout is
			-- Save debug docking layout
		do
			if debugging_window /= Void then
				debugging_window.docking_manager.save_tools_config (debugging_window.docking_debug_config_file)
			end
		end

	restore_standard_debug_docking_layout is
			-- Restore standard debug docking layout.
		local
			l_result: BOOLEAN
			l_file: RAW_FILE
			l_fn: FILE_NAME
		do
			l_fn := debugging_window.docking_standard_layout_path.twin
			l_fn.set_file_name (debugging_window.standard_tools_debug_layout_name)
			create l_file.make (l_fn)
			if l_file.exists then
				l_result := debugging_window.docking_manager.open_tools_config (l_fn)
			end
			if not l_result then
				restore_standard_debug_docking_layout_by_code
			end
		end

	unraise is
			-- Make the debug tools disappear from `a_window'.
		require
			debugger_raised: raised
		local
			split: EV_SPLIT_AREA
			l_unlock: BOOLEAN
		do
			force_debug_mode_cmd.disable_sensitive

				--| Switching popup
			popup_switching_mode

			if ev_application.locked_window = Void then
				l_unlock := True
				debugging_window.window.lock_update
			end

			objects_tool.save_grids_preferences
			split ?= objects_tool.widget
			if split /= Void then
				objects_split_proportion := split.split_position / split.width
			end

			save_debug_docking_layout
			objects_tool.content.close
			Preferences.debug_tool_data.number_of_watch_tools_preference.set_value (watch_tool_list.count)
			from
				watch_tool_list.start
			until
				watch_tool_list.after
			loop
				watch_tool_list.item.content.close
				watch_tool_list.forth
			end

			call_stack_tool.content.close
			threads_tool.content.close
			object_viewer_tool.content.close

				-- Free and recycle tools
			raised := False

			debugging_window.restore_tools_docking_layout
			refresh_breakpoints_tool
			if l_unlock then
				debugging_window.window.unlock_update
			end

			update_all_debugging_tools_menu
			unpopup_switching_mode
			force_debug_mode_cmd.enable_sensitive
		ensure
			not raised
		end

	reset_tools is
			-- Reset tools to free unused data
		do
			threads_tool.reset_tool
			call_stack_tool.reset_tool
			objects_tool.reset_tool
			object_viewer_cmd.end_debug
			if object_viewer_tool /= Void then
				object_viewer_tool.reset_tool
			end
			watch_tool_list.do_all (agent {ES_WATCH_TOOL}.reset_tool)
			if application /= Void then
				destroy_application
			end
		end

	set_stone (st: STONE) is
			-- Propagate `st' to tools.
		local
			cst: CALL_STACK_STONE
			propagate_stone: BOOLEAN
		do
			if raised then
				cst ?= st
				if cst /= Void then
					if application_is_executing then
						propagate_stone := application.current_execution_stack_number /= cst.level_number
						application.set_current_execution_stack_number (cst.level_number)
					end
				end
				if propagate_stone then
					call_stack_tool.set_stone (st)
					objects_tool.set_stone (st)
					watch_tool_list.do_all (agent {ES_WATCH_TOOL}.set_stone (st))
				end
			end
		end

	change_current_thread_id (tid: INTEGER) is
			-- Set Current thread id to `tid'
		do
			Precursor (tid)
			if raised then
				call_stack_tool.update
				threads_tool.update
			end
		end

	assign_watch_tool_unique_titles is
			-- Reassign all unique titles of watch tools.
		local
			w: ES_WATCH_TOOL
			lst: like watch_tool_list
		do
			from
				lst := watch_tool_list
				lst.start
			until
				lst.after
			loop
				w := lst.item
				w.content.set_unique_title (once "watch_tool_" + lst.index.out)
				lst.forth
			end
		end

	enable_exiting_eiffel_studio is
			-- Set `is_exiting_eiffel_studio' with true.
		do
			is_exiting_eiffel_studio := True
		end

feature {NONE} -- Raise/unraise notification

	popup_switching_mode is
		local
			popup: EV_POPUP_WINDOW
			lab: EV_LABEL
			w,h, pw,ph: INTEGER
		do
			if debugging_window /= Void and then debugging_window.window /= Void then
				create popup
				popup.enable_border
				create lab
				if raised then
					lab.set_text (interface_names.l_Switching_to_normal_mode)
				else
					lab.set_text (interface_names.l_Switching_to_debug_mode)
				end
				popup.extend (lab)
				lab.refresh_now
				w := debugging_window.window.width
				h := debugging_window.window.height
				pw := lab.font.string_width (lab.text) + 30
				ph := lab.font.height + 30
				popup.set_size (pw, ph)
				popup.set_position (debugging_window.window.x_position + (w - pw) // 2, debugging_window.window.y_position + (h - ph) // 2)
				popup.show_relative_to_window (debugging_window.window)
				popup.refresh_now
				switching_mode_popup := popup
			end
		end

	unpopup_switching_mode is
		do
			if switching_mode_popup /= Void then
				switching_mode_popup.destroy
			end
		end

	switching_mode_popup: EV_POPUP_WINDOW

feature -- Debugging events

	process_breakpoint (bp: BREAKPOINT): BOOLEAN is
		do
			Result := Precursor {DEBUGGER_MANAGER} (bp)
			if debugging_window /= Void then
				debugging_window.tools.breakpoints_tool.refresh
			end
		end

	resume_application is
			-- Quickly relaunch the application.
		require
			stopped: safe_application_is_stopped
		do
			application.continue
			if application_is_executing and then not application_is_stopped then
				application.on_application_resumed
			else
				debug ("debugger_trace")
					print ("Application is stopped, but it should not")
				end
			end
		end

	launch_stone (st: STONE) is
			-- Set `st' in the debugging window as the new stone.
		do
			debugging_window.tools.launch_stone (st)
		end

	on_application_before_launching is
			-- Application is about to be launched.
		do
			Precursor
			disable_debugging_commands (False)
		end

	on_application_launched is
			-- Application has just been launched.
		do
			update_all_debugging_tools_menu

			Precursor
			debug("debugger_trace_synchro")
				io.put_string (generator + ".on_application_launched %N")
			end

			debugging_window.tools.features_relation_tool.pop_feature_flat

				-- Modify the debugging window display.
			stop_cmd.enable_sensitive
			quit_cmd.enable_sensitive
			restart_cmd.enable_sensitive
			no_stop_cmd.disable_sensitive
			debug_cmd.disable_sensitive
			debug_cmd.set_launched (True)
			step_cmd.disable_sensitive
			into_cmd.disable_sensitive
			set_critical_stack_depth_cmd.disable_sensitive

			assertion_checking_handler_cmd.reset

			if dialog /= Void and then not dialog.is_destroyed then
				close_dialog
			end

				-- Update Watch tool
			watch_tool_list.do_all (agent {ES_WATCH_TOOL}.request_update)
			debug ("debugger_trace_synchro")
				io.put_string (generator + ".on_application_launched : done%N")
			end
		end

	on_application_before_stopped is
			-- Execute command after application is
			-- stopped in a breakpoint or an exception
			-- occurred
		do
			Precursor
		end

	on_application_just_stopped is
			-- Application was just stopped (by a breakpoint, ...).
		local
			st: CALL_STACK_STONE
			cd: EB_CONFIRMATION_DIALOG
		do
			Precursor
			debug ("debugger_trace_synchro")
				io.put_string (generator + ".on_application_just_stopped : start%N")
			end
			stop_cmd.disable_sensitive
			no_stop_cmd.enable_sensitive
			debug_cmd.enable_sensitive
			step_cmd.enable_sensitive
			out_cmd.enable_sensitive
			into_cmd.enable_sensitive
			set_critical_stack_depth_cmd.enable_sensitive
			assertion_checking_handler_cmd.enable_sensitive

			debug ("debugger_interface")
				io.put_string ("Application Stopped (dixit EB_DEBUGGER_MANAGER)%N")
			end

			objects_tool.disable_refresh
			watch_tool_list.do_all (agent {ES_WATCH_TOOL}.disable_refresh)
			if not application.current_call_stack_is_empty then
				st := first_valid_call_stack_stone
				if st /= Void then
					launch_stone (st)
					-- After launch_stone, the call stack tool will show something, so we want the feature relation tool show up too.
					if call_stack_tool.widget.is_displayed then
						debugging_window.tools.features_relation_tool.show
					end
				end
			end
			object_viewer_cmd.refresh
			window_manager.quick_refresh_all_margins

				-- Fill in the threads tool.
			threads_tool.request_update
				-- Fill in the stack tool.
			call_stack_tool.request_update
				-- Fill in the objects tool.
			objects_tool.enable_refresh
			watch_tool_list.do_all (agent {ES_WATCH_TOOL}.enable_refresh)

			objects_tool.request_update
			object_viewer_tool.request_update
			watch_tool_list.do_all (agent {ES_WATCH_TOOL}.request_update)

			debugging_window.window.raise

			if application_status.reason_is_overflow then
				create cd.make_with_text_and_actions (Warning_messages.w_Overflow_detected, <<agent do_nothing, agent resume_application>>)
				cd.show_modal_to_window (debugging_window.window)
			end

			debug ("debugger_interface")
				io.put_string ("Application Stopped End (dixit EB_DEBUGGER_MANAGER)%N")
			end
			debug ("debugger_trace_synchro")
				io.put_string (generator + ".on_application_just_stopped : done%N")
			end
		end

	on_application_before_resuming is
		do
			Precursor
			objects_tool.record_grids_layout
			watch_tool_list.do_all (agent {ES_WATCH_TOOL}.record_grid_layout)
		end

	on_application_resumed is
			-- Application was resumed after a stop.
		do
			Precursor

			debug ("debugger_trace_synchro")
				io.put_string (generator + ".on_application_resumed%N")
			end

			stop_cmd.enable_sensitive
			no_stop_cmd.disable_sensitive
			debug_cmd.disable_sensitive
			step_cmd.disable_sensitive
			out_cmd.disable_sensitive
			into_cmd.disable_sensitive
			set_critical_stack_depth_cmd.disable_sensitive
			assertion_checking_handler_cmd.disable_sensitive

			objects_tool.disable_refresh
			watch_tool_list.do_all (agent {ES_WATCH_TOOL}.disable_refresh)

				-- Fill in the threads tool.
			threads_tool.request_update
				-- Fill in the stack tool.
			call_stack_tool.request_update

			objects_tool.enable_refresh
			watch_tool_list.do_all (agent {ES_WATCH_TOOL}.enable_refresh)

				-- Fill in the objects tool.
			objects_tool.request_update

				-- Update Watch tool
			watch_tool_list.do_all (agent {ES_WATCH_TOOL}.request_update)

			window_manager.quick_refresh_all_margins
			if dialog /= Void and then not dialog.is_destroyed then
				close_dialog
			end

			debug ("debugger_trace_synchro")
				io.put_string (generator + ".on_application_resumed : done%N")
			end
		end

	on_application_quit is
			-- Application just quit.
			-- This application means the debuggee.
		local
			was_executing: BOOLEAN
		do
			debug("debugger_trace_synchro")
				io.put_string (generator + ".on_application_quit %N")
			end
			was_executing := application_is_executing
			Precursor

			if was_executing then
					-- Modify the debugging window display.
				window_manager.quick_refresh_all_margins
				disable_debugging_commands (False)

					--| Clean and reset debugging tools
				reset_tools

					-- Make all debugging tools disappear.
				if debugging_window.destroyed then
					debugging_window := Void
					raised := False
					debug_mode_forced := False
					force_debug_mode_cmd.set_select (False)
				elseif is_exiting_eiffel_studio then
					save_debug_docking_layout
					debugging_window := Void
				elseif not debug_mode_forced then
					unraise
					debugging_window := Void
				end

				enable_debugging_commands
				update_all_debugging_tools_menu

					-- Make related buttons insensitive.
				stop_cmd.disable_sensitive
				quit_cmd.disable_sensitive
				restart_cmd.disable_sensitive
				debug_cmd.enable_sensitive
				debug_cmd.set_launched (False)
				no_stop_cmd.enable_sensitive

				step_cmd.enable_sensitive
				into_cmd.enable_sensitive
				out_cmd.disable_sensitive

				set_critical_stack_depth_cmd.enable_sensitive
				assertion_checking_handler_cmd.reset
			end

			debug("debugger_trace_synchro")
				io.put_string (generator + ".on_application_quit : done%N")
			end
		end

	first_valid_call_stack_stone: CALL_STACK_STONE is
			-- Stone of the first call stack valid for EiffelStudio.
		require
			Stopped: safe_application_is_stopped
			Call_stack_non_empty: not application.current_call_stack_is_empty
		local
			m, i: INTEGER
			st: CALL_STACK_STONE
		do
			from
				m := application.number_of_stack_elements
				i := 1
			until
				Result /= Void or i > m
			loop
				create st.make (i)
				if st.is_valid then
					Result := st
				else
					i := i + 1
				end
			end
		ensure
			result_is_valid: Result /= Void implies Result.is_valid
		end

feature {EB_DEVELOPMENT_WINDOW, EB_DEVELOPMENT_WINDOW_PART} -- Implementation

	system_info_cmd: EB_STANDARD_CMD
			-- Command that displays information about current system in the output tool.

	display_error_help_cmd: EB_ERROR_INFORMATION_CMD
			-- Command to pop up a dialog giving help on compilation errors.

feature {ES_OBJECTS_GRID_MANAGER} -- Command

	object_viewer_cmd: EB_OBJECT_VIEWER_COMMAND

feature -- Options

	display_agent_details: BOOLEAN
			-- Do we display extra agent information ?

feature {NONE} -- Implementation

	new_std_cmd (a_menu_name: STRING_GENERAL; a_pixmap: EV_PIXMAP;
					a_shortcut_pref: SHORTCUT_PREFERENCE; a_use_acc: BOOLEAN;
					a_action: PROCEDURE [ANY, TUPLE]): EB_STANDARD_CMD is
		local
			l_cmd: EB_STANDARD_CMD
			l_acc: EV_ACCELERATOR
		do
			create l_cmd.make
			l_cmd.enable_sensitive
			l_cmd.set_menu_name (a_menu_name)
			l_cmd.set_pixmap (a_pixmap)
			l_cmd.add_agent (a_action)
			if a_shortcut_pref /= Void then
				l_cmd.set_referred_shortcut (a_shortcut_pref)
				if a_use_acc then
					create l_acc.make_with_key_combination (a_shortcut_pref.key, a_shortcut_pref.is_ctrl, a_shortcut_pref.is_alt, a_shortcut_pref.is_shift)
					l_acc.actions.extend (agent l_cmd.execute)
					l_cmd.set_accelerator (l_acc)
				end
			end
			Result := l_cmd
		end

	objects_split_proportion: REAL
			-- Position of the splitter inside the object tool.

	bkpt_info_cmd: EB_STANDARD_CMD
			-- Command that can display info concerning the breakpoints in the system.

	set_critical_stack_depth_cmd: EB_STANDARD_CMD
			-- Command that changes the depth at which we warn the user against a stack overflow.

	exception_handler_cmd: EB_EXCEPTION_HANDLER_CMD

	assertion_checking_handler_cmd: EB_ASSERTION_CHECKING_HANDLER_CMD

	options_cmd: EB_DEBUG_OPTIONS_CMD

	stop_cmd: EB_EXEC_STOP_CMD
			-- Command that can interrupt the execution.

	quit_cmd: EB_EXEC_QUIT_CMD
			-- Command that can kill the execution.

	step_cmd: EB_EXEC_STEP_CMD
			-- Step by step command.

	out_cmd: EB_EXEC_OUT_CMD
			-- Out of routine command.

	into_cmd: EB_EXEC_INTO_CMD
			-- Step into command.

	debug_cmd: EB_EXEC_DEBUG_CMD
			-- Run with stop points command.

	restart_cmd: EB_EXEC_RESTART_DEBUG_CMD
			-- Restart debugging without closing the interface.

	no_stop_cmd: EB_EXEC_NO_STOP_CMD
			-- Run without stop points command.


	enable_commands_on_project_created is
			-- Enable commands when a new project has been created (not yet compiled)
		do
			display_error_help_cmd.enable_sensitive
		end

	enable_commands_on_project_loaded is
			-- Enable commands when a new project has been created and compiled
		do
			display_error_help_cmd.enable_sensitive
			enable_debugging_commands
		end

	enable_debugging_commands is
		do
			if is_msil_dll_system then
				disable_debugging_commands (True)
			else
				debug_cmd.enable_sensitive
				no_stop_cmd.enable_sensitive

				clear_bkpt.enable_sensitive
				enable_bkpt.enable_sensitive
				disable_bkpt.enable_sensitive
				bkpt_info_cmd.enable_sensitive
				assertion_checking_handler_cmd.disable_sensitive

				options_cmd.enable_sensitive
				step_cmd.enable_sensitive
				into_cmd.enable_sensitive
				out_cmd.disable_sensitive
			end
		end

	disable_commands_on_project_unloaded is
			-- Disable commands when a project has been closed.
		do
			clear_bkpt.disable_sensitive
			enable_bkpt.disable_sensitive
			disable_bkpt.disable_sensitive
			bkpt_info_cmd.disable_sensitive
			debug_cmd.disable_sensitive
			no_stop_cmd.disable_sensitive
			step_cmd.disable_sensitive
			into_cmd.disable_sensitive
			out_cmd.disable_sensitive

			display_error_help_cmd.disable_sensitive
			assertion_checking_handler_cmd.disable_sensitive

			options_cmd.disable_sensitive
		end

	disable_debugging_commands (full: BOOLEAN) is
			-- Disable commands related to debugging.
			-- If `full' disable also commands for manipulating breakpoints.
		do
			if full then
				clear_bkpt.disable_sensitive
				enable_bkpt.disable_sensitive
				disable_bkpt.disable_sensitive
				bkpt_info_cmd.disable_sensitive
			end

			debug_cmd.disable_sensitive
			no_stop_cmd.disable_sensitive
			step_cmd.disable_sensitive
			into_cmd.disable_sensitive
			out_cmd.disable_sensitive
			assertion_checking_handler_cmd.disable_sensitive
		end

	change_critical_stack_depth is
			-- Display a dialog that lets the user change the critical stack depth.
		require
			not_running: not application_is_executing or else application_is_stopped
		local
			rb2: EV_RADIO_BUTTON
			l: EV_LABEL
			okb, cancelb: EV_BUTTON
			hb: EV_HORIZONTAL_BOX
			vb: EV_VERTICAL_BOX
		do
				-- Create widgets.
			create dialog
			create show_all_radio.make_with_text (Interface_names.l_Do_not_detect_stack_overflows)
			create rb2.make_with_text (Interface_names.l_Display_call_stack_warning)
			create l.make_with_text (Interface_names.l_Elements)
			create element_nb.make_with_value_range (1 |..| 30000)
			create okb.make_with_text (Interface_names.b_Ok)
			create cancelb.make_with_text (Interface_names.b_Cancel)

				-- Organize widgets.
			create vb
			vb.set_border_width (Layout_constants.Default_border_size)
			vb.set_padding (Layout_constants.Small_padding_size)
			vb.extend (show_all_radio)
			vb.extend (rb2)
			create hb
			hb.set_padding (Layout_constants.Small_padding_size)
			hb.extend (element_nb)
			hb.disable_item_expand (element_nb)
			hb.extend (l)
			hb.disable_item_expand (l)
			hb.extend (create {EV_CELL})
			vb.extend (hb)

			create hb
			hb.set_padding (Layout_constants.Small_padding_size)
			hb.extend (create {EV_CELL})
			hb.extend (okb)
			hb.disable_item_expand (okb)
			hb.extend (cancelb)
			hb.disable_item_expand (cancelb)
			hb.extend (create {EV_CELL})
			vb.extend (hb)

			dialog.extend (vb)

				-- Set widget properties.
			dialog.set_title (Interface_names.t_Set_critical_stack_depth)
			dialog.set_icon_pixmap (pixmaps.icon_pixmaps.general_dialog_icon)
			dialog.disable_user_resize
			rb2.enable_select
			Layout_constants.set_default_width_for_button (okb)
			Layout_constants.set_default_width_for_button (cancelb)
			if preferences.debugger_data.critical_stack_depth > 30000 then
				element_nb.set_value (30000)
			elseif preferences.debugger_data.critical_stack_depth = -1 then
				element_nb.set_value (1000)
				show_all_radio.enable_select
				element_nb.disable_sensitive
			else
				element_nb.set_value (preferences.debugger_data.critical_stack_depth)
			end
			element_nb.set_minimum_width (100)

				-- Set up actions.
			cancelb.select_actions.extend (agent close_dialog)
			okb.select_actions.extend (agent accept_dialog)
			show_all_radio.select_actions.extend (agent element_nb.disable_sensitive)
			rb2.select_actions.extend (agent element_nb.enable_sensitive)
			dialog.set_default_push_button (okb)
			dialog.set_default_cancel_button (cancelb)
			if element_nb.is_sensitive then
				dialog.show_actions.extend (agent element_nb.set_focus)
			end

			dialog.show_modal_to_window (last_focused_development_window (True).window)
		end

	element_nb: EV_SPIN_BUTTON
			-- Spin button that indicates the critical call stack depth.

	dialog: EV_DIALOG
			-- Dialog that lets the user choose the critical call stack depth.

	show_all_radio: EV_RADIO_BUTTON
			-- Radio button that indicates that stack overflows shouldn't be detected.

	close_dialog is
			-- Close `dialog' without doing anything.
		do
			dialog.destroy
			dialog := Void
			element_nb := Void
			show_all_radio := Void
		end

	accept_dialog is
			-- Close `dialog' and change the critical stack depth.
		local
			nb: INTEGER
		do
			if show_all_radio.is_selected then
				nb := -1
			else
				nb := element_nb.value
			end
			close_dialog
			preferences.debugger_data.critical_stack_depth_preference.set_value (nb)
			set_critical_stack_depth (nb)
		end

	initialize_debugging_window is
			-- Set `debugging_window' with window requesting a debug session.
		do
			if debugging_window = Void then
				debugging_window := last_focused_development_window (True)
			end
		ensure
			debugging_window_set: debugging_window /= Void
		end

	restore_standard_debug_docking_layout_by_code is
			-- Restore standard debug docking layout.
		local
			l_contents: ARRAYED_LIST [SD_CONTENT]
			l_tools: EB_DEVELOPMENT_WINDOW_TOOLS
		do
			l_tools := debugging_window.tools
			if
				l_tools.features_relation_tool.content.is_visible
				and l_tools.features_relation_tool.content.state_value /= {SD_ENUMERATION}.auto_hide
			then
				objects_tool.content.set_relative (debugging_window.tools.features_relation_tool.content, {SD_ENUMERATION}.bottom)
			else
				objects_tool.content.set_top ({SD_ENUMERATION}.bottom)
			end

			from
				watch_tool_list.start
			until
				watch_tool_list.after
			loop
				watch_tool_list.item.content.set_tab_with (objects_tool.content, False)
				watch_tool_list.forth
			end
			if objects_tool.content.is_visible then
				objects_tool.content.set_focus
			end

			if
				l_tools.features_tool.content.is_visible
				and l_tools.features_tool.content.state_value /= {SD_ENUMERATION}.auto_hide
			then
				call_stack_tool.content.set_relative (l_tools.features_tool.content, {SD_ENUMERATION}.bottom)
			elseif
				l_tools.cluster_tool.content.is_visible
				and l_tools.cluster_tool.content.state_value /= {SD_ENUMERATION}.auto_hide
			then
				call_stack_tool.content.set_relative (l_tools.cluster_tool.content, {SD_ENUMERATION}.bottom)
			else
				call_stack_tool.content.set_top ({SD_ENUMERATION}.left)
			end

				--| Minimize all editors
			from
				l_contents := debugging_window.docking_manager.contents
				l_contents.start
			until
				l_contents.after
			loop
				if l_contents.item.type = {SD_ENUMERATION}.editor then
					l_contents.item.minimize
				end
				l_contents.forth
			end
		end

	refresh_breakpoints_tool is
			-- Refresh breakpoint tool if needed.
		local
			l_tool: ES_BREAKPOINTS_TOOL
		do
			l_tool := debugging_window.tools.breakpoints_tool
			if l_tool.content.is_visible then
				l_tool.refresh
			end
		end

	show_watch_tool_preference: SHORTCUT_PREFERENCE is
			-- Show watch tool preference
		do
			Result := preferences.misc_shortcut_data.shortcuts.item ("show_watch_tool")
		end

feature {NONE} -- MSIL system implementation

	is_msil_dll_system: BOOLEAN is
			-- Is a MSIL DLL system ?
		do
			Result := Eiffel_project.initialized
					and then Eiffel_project.system_defined
					and then Eiffel_system.System.il_generation
					and then equal (Eiffel_system.System.msil_generation_type, dll_type)
		end

	dll_type: STRING is "dll"
			-- DLL type constant for MSIL system

feature {NONE} -- specific implementation

	implementation: EB_DEBUGGER_MANAGER_IMP;

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

end -- class EB_DEBUGGER_MANAGER
