indexing
	description: "Tab page to edit condition."
	date: "$Date$"
	revision: "$Revision$"

class
	CONDITION_TAB

inherit
	EV_VERTICAL_BOX
		redefine
			data,
			initialize,
			is_in_default_state
		end

	PROPERTY_GRID_LAYOUT
		undefine
			default_create,
			copy,
			is_equal
		end

	CONF_ACCESS
		undefine
			default_create,
			copy,
			is_equal
		end

	CONF_VALIDITY
		undefine
			default_create,
			copy,
			is_equal
		end

	CONF_INTERFACE_NAMES
		undefine
			default_create,
			copy,
			is_equal
		end

	EB_LAYOUT_CONSTANTS
		undefine
			default_create,
			copy,
			is_equal
		end

create
	make

feature {NONE} -- Initialization

	make (a_condition: CONF_CONDITION) is
			-- Create with `a_condition'.
		require
			a_condition_not_void: a_condition /= Void
		do
			data := a_condition
			default_create
		ensure
			condition_set: data = a_condition
		end

	initialize is
			-- Initialize.
		local
			l_label: EV_LABEL
			vb, vb_grid: EV_VERTICAL_BOX
			hb_top, hb_version, hb: EV_HORIZONTAL_BOX
			l_frame: EV_FRAME
			li: EV_LIST_ITEM
			l_btn: EV_BUTTON
		do
			Precursor

			set_border_width (default_border_size)

				-- top part (platforms, builds, multithreaded, .NET)
			create hb_top
			extend (hb_top)
			disable_item_expand (hb_top)
			hb_top.set_padding (default_padding_size)

				-- platforms
			create l_frame.make_with_text (dial_cond_platforms)
			hb_top.extend (l_frame)
			hb_top.disable_item_expand (l_frame)
			create vb
			l_frame.extend (vb)
			vb.set_border_width (default_border_size)
			create platforms
			from
				platform_names.start
			until
				platform_names.after
			loop
				create li.make_with_text (platform_names.item_for_iteration)
				platforms.extend (li)
				if data.platform /= Void and then data.platform.value.has (platform_names.key_for_iteration) then
					platforms.check_item (li)
				end
				platform_names.forth
			end
			vb.extend (platforms)
			platforms.set_minimum_size (105, 75)
			create exclude_platforms.make_with_text (dial_cond_platforms_exclude)
			vb.extend (exclude_platforms)
			vb.disable_item_expand (exclude_platforms)
			if data.platform /= Void and then data.platform.invert then
				exclude_platforms.enable_select
			end

				-- other
			create l_frame.make_with_text (dial_cond_other)
			hb_top.extend (l_frame)
			l_frame.set_minimum_width (220)
			hb_top.disable_item_expand (l_frame)

			create hb
			l_frame.extend (hb)
			hb.set_border_width (default_border_size)

				-- build
			create vb
			vb.set_minimum_width (100)
			hb.extend (vb)
			hb.disable_item_expand (vb)
			create build_enabled.make_with_text (dial_cond_build)
			vb.extend (build_enabled)
			vb.disable_item_expand (build_enabled)
			create builds.make_with_strings (<<build_workbench_name, build_finalize_name>>)
			builds.disable_edit
			vb.extend (builds)
			vb.disable_item_expand (builds)
			if data.build /= Void then
				build_enabled.enable_select
				if data.build.invert then
					if data.build.value.first = build_workbench then
						builds.last.enable_select
					else
						builds.first.enable_select
					end
				else
					if data.build.value.first = build_workbench then
						builds.first.enable_select
					else
						builds.last.enable_select
					end
				end
			else
				builds.disable_sensitive
			end

				-- dynamic runtime
			append_small_margin (vb)
			create dynamic_runtime_enabled.make_with_text (dial_cond_dynamic_runtime)
			vb.extend (dynamic_runtime_enabled)
			vb.disable_item_expand (dynamic_runtime_enabled)
			create dynamic_runtime.make_with_strings (<<"True", "False">>)
			dynamic_runtime.disable_edit
			vb.extend (dynamic_runtime)
			vb.disable_item_expand (dynamic_runtime)
			if data.dynamic_runtime /= Void then
				dynamic_runtime_enabled.enable_select
				if data.dynamic_runtime.item then
					dynamic_runtime.first.enable_select
				else
					dynamic_runtime.last.enable_select
				end
			else
				dynamic_runtime.disable_sensitive
			end

			hb.extend (create {EV_CELL})

				-- dotnet
			create vb
			vb.set_minimum_width (100)
			hb.extend (vb)
			hb.disable_item_expand (vb)
			create dotnet_enabled.make_with_text (dial_cond_dotnet)
			vb.extend (dotnet_enabled)
			vb.disable_item_expand (dotnet_enabled)
			create dotnet.make_with_strings (<<"True", "False">>)
			dotnet.disable_edit
			vb.extend (dotnet)
			vb.disable_item_expand (dotnet)
			if data.dotnet /= Void then
				dotnet_enabled.enable_select
				if data.dotnet.item then
					dotnet.first.enable_select
				else
					dotnet.last.enable_select
				end
			else
				dotnet.disable_sensitive
			end

				-- multithreaded
			append_small_margin (vb)
			create multithreaded_enabled.make_with_text (dial_cond_multithreaded)
			vb.extend (multithreaded_enabled)
			vb.disable_item_expand (multithreaded_enabled)
			create multithreaded.make_with_strings (<<"True", "False">>)
			multithreaded.disable_edit
			vb.extend (multithreaded)
			vb.disable_item_expand (multithreaded)
			if data.multithreaded /= Void then
				multithreaded_enabled.enable_select
				if data.multithreaded.item then
					multithreaded.first.enable_select
				else
					multithreaded.last.enable_select
				end
			else
				multithreaded.disable_sensitive
			end

			append_small_margin (Current)

				-- version part
			create l_frame.make_with_text (dial_cond_version)
			extend (l_frame)
			disable_item_expand (l_frame)
			create vb
			l_frame.extend (vb)
			vb.set_border_width (default_border_size)
			vb.set_padding (default_padding_size)
			create hb_version
			vb.extend (hb_version)
			vb.disable_item_expand (hb_version)
			create version_min_compiler
			hb_version.extend (version_min_compiler)
			hb_version.disable_item_expand (version_min_compiler)
			version_min_compiler.set_minimum_width (version_field_width)
			hb_version.extend (create {EV_CELL})
			create l_label.make_with_text (dial_cond_version_compiler)
			hb_version.extend (l_label)
			hb_version.disable_item_expand (l_label)
			hb_version.extend (create {EV_CELL})
			create version_max_compiler
			hb_version.extend (version_max_compiler)
			hb_version.disable_item_expand (version_max_compiler)
			version_max_compiler.set_minimum_width (version_field_width)
			fill_compiler_version

			append_small_margin (Current)

			create hb_version
			vb.extend (hb_version)
			vb.disable_item_expand (hb_version)
			create version_min_msil_clr
			hb_version.extend (version_min_msil_clr)
			hb_version.disable_item_expand (version_min_msil_clr)
			version_min_msil_clr.set_minimum_width (version_field_width)
			hb_version.extend (create {EV_CELL})
			create l_label.make_with_text (dial_cond_version_clr)
			hb_version.extend (l_label)
			hb_version.disable_item_expand (l_label)
			hb_version.extend (create {EV_CELL})
			create version_max_msil_clr
			hb_version.extend (version_max_msil_clr)
			hb_version.disable_item_expand (version_max_msil_clr)
			version_max_msil_clr.set_minimum_width (version_field_width)
			fill_msil_clr_version

				-- custom
			create l_frame.make_with_text (dial_cond_custom)
			extend (l_frame)
			create vb
			l_frame.extend (vb)
			vb.set_border_width (default_border_size)
			vb.set_padding (default_padding_size)
			create vb_grid
			vb.extend (vb_grid)
			vb_grid.set_border_width (1)
			vb_grid.set_background_color ((create {EV_STOCK_COLORS}).black)
			create custom
			vb_grid.extend (custom)
			fill_custom
			create hb
			vb.extend (hb)
			vb.disable_item_expand (hb)
			hb.extend (create {EV_CELL})
			create l_btn.make_with_text_and_action (plus_button_text, agent add_custom)
			l_btn.set_minimum_width (small_button_width)
			hb.extend (l_btn)
			hb.disable_item_expand (l_btn)
			create l_btn.make_with_text_and_action (minus_button_text, agent remove_custom)
			l_btn.set_minimum_width (small_button_width)
			hb.extend (l_btn)
			hb.disable_item_expand (l_btn)

				-- connect actions
				-- platform
			platforms.focus_out_actions.extend (agent on_platform)
			exclude_platforms.select_actions.extend (agent on_platform)
				--other
			build_enabled.select_actions.extend (agent on_build_enabled)
			builds.select_actions.extend (agent on_build)
			dotnet_enabled.select_actions.extend (agent on_dotnet_enabled)
			dotnet.change_actions.extend (agent on_dotnet)
			multithreaded_enabled.select_actions.extend (agent on_multithreaded_enabled)
			multithreaded.select_actions.extend (agent on_multithreaded)
			dynamic_runtime_enabled.select_actions.extend (agent on_dynamic_runtime_enabled)
			dynamic_runtime.select_actions.extend (agent on_dynamic_runtime)

				--version
			version_min_compiler.focus_out_actions.extend (agent on_compiler_version)
			version_max_compiler.focus_out_actions.extend (agent on_compiler_version)
			version_min_msil_clr.focus_out_actions.extend (agent on_msil_clr_version)
			version_max_msil_clr.focus_out_actions.extend (agent on_msil_clr_version)
		end

feature -- Access

	data: CONF_CONDITION
			-- Condition of this tab.

feature {NONE} -- GUI elements

	platforms: EV_CHECKABLE_LIST
			-- Platforms list.

	exclude_platforms: EV_CHECK_BUTTON
			-- Are the selected platforms excluded?

	build_enabled: EV_CHECK_BUTTON
			-- Is the build value set?

	builds: EV_COMBO_BOX
			-- Build.

	multithreaded_enabled: EV_CHECK_BUTTON
			-- Is the multithreaded value set?

	multithreaded: EV_COMBO_BOX
			-- Multithreaded.

	dotnet_enabled: EV_CHECK_BUTTON
			-- Is the .NET value set?

	dotnet: EV_COMBO_BOX
			-- .NET

	dynamic_runtime_enabled: EV_CHECK_BUTTON
			-- Is the dynamic runtime value set?

	dynamic_runtime: EV_COMBO_BOX
			-- dynamic runtime

	version_min_compiler: EV_TEXT_FIELD
	version_max_compiler: EV_TEXT_FIELD
	version_min_msil_clr: EV_TEXT_FIELD
	version_max_msil_clr: EV_TEXT_FIELD
			-- version conditions

	custom: ES_GRID

feature {NONE} -- Actions

	on_platform is
			-- Platform value was changed, update data.
		local
			l_pfs: LIST [EV_LIST_ITEM]
		do
			data.wipe_out_platform
			if exclude_platforms.is_selected then
				from
					l_pfs := platforms.checked_items
					l_pfs.start
				until
					l_pfs.after
				loop
					data.exclude_platform (get_platform (l_pfs.item.text))
					l_pfs.forth
				end
			else
				from
					l_pfs := platforms.checked_items
					l_pfs.start
				until
					l_pfs.after
				loop
					data.add_platform (get_platform (l_pfs.item.text))
					l_pfs.forth
				end
			end
		end

	on_dotnet_enabled is
			-- enable/disable combo box to choose a value for .NET.
		do
			if dotnet_enabled.is_selected then
				dotnet.enable_sensitive
				on_dotnet
			else
				dotnet.disable_sensitive
				data.unset_dotnet
			end
		end

	on_multithreaded_enabled is
			-- enable/disable combo box to choose a value for multithreaded.
		do
			if multithreaded_enabled.is_selected then
				multithreaded.enable_sensitive
				on_multithreaded
			else
				multithreaded.disable_sensitive
				data.unset_multithreaded
			end
		end

	on_dynamic_runtime_enabled is
			-- enable/disable combo box to choose a value for dynamic runtime.
		do
			if dynamic_runtime_enabled.is_selected then
				dynamic_runtime.enable_sensitive
				on_dynamic_runtime
			else
				dynamic_runtime.disable_sensitive
				data.unset_dynamic_runtime
			end
		end

	on_build_enabled is
			-- enable/disable combo box to choose a value for build.
		do
			if build_enabled.is_selected then
				builds.enable_sensitive
				on_build
			else
				builds.disable_sensitive
				data.wipe_out_build
			end
		end

	on_build is
			-- Build value was changed, update data.
		do
			data.wipe_out_build
			data.add_build (get_build (builds.text))
		end

	on_dotnet is
			-- Dotnet value was changed, update data.
		do
			data.set_dotnet (dotnet.text.to_boolean)
		end

	on_multithreaded is
			-- Multithreaded value hsas changed, udpate data.
		do
			data.set_multithreaded (multithreaded.text.to_boolean)
		end

	on_dynamic_runtime is
			-- Dynamic_runtime value was changed, update data.
		do
			data.set_dynamic_runtime (dynamic_runtime.text.to_boolean)
		end

	on_compiler_version is
			-- Compiler version was changed.
		local
			l_ver: STRING
			l_min, l_max: CONF_VERSION
			wd: EV_WARNING_DIALOG
		do
			l_ver := version_min_compiler.text
			if not l_ver.is_empty then
				create l_min.make_from_string (l_ver)
			end
			l_ver := version_max_compiler.text
			if not l_ver.is_empty then
				create l_max.make_from_string (l_ver)
			end

			if (l_min /= Void and then l_min.is_error) or (l_max /= Void and then l_max.is_error) then
				fill_compiler_version
				create wd.make_with_text (version_valid_format)
				wd.show_modal_to_window (parent_window)
			elseif l_min /= Void and l_max /= Void and l_min > l_max then
				fill_compiler_version
				create wd.make_with_text (version_min_max)
				wd.show_modal_to_window (parent_window)
			elseif l_min /= Void or l_max /= Void then
				data.add_version (l_min, l_max, v_compiler)
			else
				data.unset_version (v_compiler)
			end
		end

	on_msil_clr_version is
			-- MSIL CLR version was changed.
		local
			l_ver: STRING
			l_min, l_max: CONF_VERSION
			wd: EV_WARNING_DIALOG
		do
			l_ver := version_min_msil_clr.text
			if not l_ver.is_empty then
				create l_min.make_from_string (l_ver)
			end
			l_ver := version_max_msil_clr.text
			if not l_ver.is_empty then
				create l_max.make_from_string (l_ver)
			end

			if (l_min /= Void and then l_min.is_error) or (l_max /= Void and then l_max.is_error) then
				fill_msil_clr_version
				create wd.make_with_text (version_valid_format)
				wd.show_modal_to_window (parent_window)
			elseif l_min /= Void and l_max /= Void and l_min > l_max then
				fill_msil_clr_version
				create wd.make_with_text (version_min_max)
				wd.show_modal_to_window (parent_window)
			elseif l_min /= Void or l_max /= Void then
				data.add_version (l_min, l_max, v_msil_clr)
			else
				data.unset_version (v_msil_clr)
			end
		end

	update_variable (a_new_key: STRING; an_old_key: STRING) is
			-- Update variable name from `an_old_key' to `a_new_key'.
		require
			an_old_key_ok: an_old_key /= Void and then data.custom /= Void and then data.custom.has (an_old_key)
			a_new_key_ok: a_new_key /= Void
		do
			if not a_new_key.is_empty then
				data.custom.replace_key (a_new_key, an_old_key)
			end
			fill_custom
		end

	update_invert (a_value: STRING; a_key: STRING) is
			-- Update inversion status of custom condition of `a_key'.
		require
			a_key_ok: a_key /= Void and then data.custom /= Void and then data.custom.has (a_key)
			a_value_ok: a_value /= Void and then (a_value.is_equal ("=") or a_value.is_equal ("/="))
		do
			if a_value.is_equal ("=") then
				data.custom.item (a_key).invert := False
			else
				data.custom.item (a_key).invert := True
			end
		end

	update_value (a_value: STRING; a_key: STRING) is
			-- Update value of custom condition of `a_key'.
		require
			a_key_ok: a_key /= Void and then data.custom /= Void and then data.custom.has (a_key)
			a_value_not_void: a_value /= Void
		do
			if not a_value.is_empty then
				data.custom.item (a_key).value := a_value
			else
				fill_custom
			end
		end

	add_custom is
			-- Add a new custom condition.
		do
			if not data.custom.has (dial_cond_new_custom) then
				data.custom.force ([dial_cond_new_custom_value, False], dial_cond_new_custom)
			end
			fill_custom
		end

	remove_custom is
			-- Remove a custom condition.
		local
			l_item: TEXT_PROPERTY [STRING]
		do
			if not custom.selected_rows.is_empty then
				l_item ?= custom.selected_rows.first.item (1)
				check
					text_property: l_item /= Void
				end
				data.custom.remove (l_item.value)
				fill_custom
			end
		end



feature {NONE} -- Layout constants

	version_field_width: INTEGER is 100
			-- Width of version fields.

feature {NONE} -- Contract

	is_in_default_state: BOOLEAN is True
			-- Contract.

feature {NONE} -- Implementation

	fill_compiler_version is
			-- Fill fields with the constraints for the compiler version.
		local
			l_version: TUPLE [min: CONF_VERSION; max: CONF_VERSION]
		do
			l_version := data.version.item (v_compiler)
			if l_version = Void then
				version_min_compiler.set_text ("")
				version_max_compiler.set_text ("")
			else
				if l_version.min = Void then
					version_min_compiler.set_text ("")
				else
					version_min_compiler.set_text (l_version.min.version)
				end
				if l_version.max = Void then
					version_max_compiler.set_text ("")
				else
					version_max_compiler.set_text (l_version.max.version)
				end
			end
		end

	fill_msil_clr_version is
			-- Fill fields with the constraints for the msil clr version.
		local
			l_version: TUPLE [min: CONF_VERSION; max: CONF_VERSION]
		do
			l_version := data.version.item (v_msil_clr)
			if l_version = Void then
				version_min_msil_clr.set_text ("")
				version_max_msil_clr.set_text ("")
			else
				if l_version.min = Void then
					version_min_msil_clr.set_text ("")
				else
					version_min_msil_clr.set_text (l_version.min.version)
				end
				if l_version.max = Void then
					version_max_msil_clr.set_text ("")
				else
					version_max_msil_clr.set_text (l_version.max.version)
				end
			end
		end

	fill_custom is
			-- Fill custom conditions.
		local
			l_cust: HASH_TABLE [TUPLE [value: STRING; invert: BOOLEAN], STRING]
			l_text: STRING_PROPERTY [STRING]
			l_choice: STRING_CHOICE_PROPERTY [STRING]
			i: INTEGER
			l_key: STRING
		do
			custom.wipe_out
			custom.enable_last_column_use_all_width
			custom.enable_selection_on_single_button_click
			custom.enable_single_row_selection
			custom.set_column_count_to (3)
			custom.column (1).set_title (dial_cond_custom_variable)
			custom.column (3).set_title (dial_cond_custom_value)
			l_cust := data.custom
			if l_cust /= Void then
				from
					l_cust.start
					i := 1
				until
					l_cust.after
				loop
					l_key := l_cust.key_for_iteration
					create l_text.make ("")
					l_text.pointer_button_press_actions.wipe_out
					l_text.pointer_double_press_actions.force_extend (agent l_text.activate)
					l_text.set_value (l_key)
					l_text.change_value_actions.extend (agent update_variable (?, l_key))
					custom.set_item (1, i, l_text)
					create l_choice.make_with_choices ("", <<"=", "/=">>)
					if l_cust.item_for_iteration.invert then
						l_choice.set_value ("/=")
					else
						l_choice.set_value ("/=")
					end
					l_choice.change_value_actions.extend (agent update_invert (?, l_key))
					custom.set_item (2, i, l_choice)
					create l_text.make ("")
					l_text.pointer_button_press_actions.wipe_out
					l_text.pointer_double_press_actions.force_extend (agent l_text.activate)
					l_text.set_value (l_cust.item_for_iteration.value)
					l_text.change_value_actions.extend (agent update_value (?, l_key))
					custom.set_item (3, i, l_text)

					i := i + 1
					l_cust.forth
				end
			end
		end


	parent_window: EV_WINDOW is
			-- Return the parent window (if any).
		local
			l_parent: EV_CONTAINER
		do
			from
				l_parent := parent
			until
				Result /= Void or l_parent = Void
			loop
				Result ?= l_parent
				l_parent := l_parent.parent
			end
		end
end
