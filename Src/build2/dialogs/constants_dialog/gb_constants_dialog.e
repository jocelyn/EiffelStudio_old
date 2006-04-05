indexing
	description: "Objects that represent an EV_DIALOG generated by Build."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GB_CONSTANTS_DIALOG

inherit
	GB_CONSTANTS_DIALOG_IMP
		undefine
			copy
		end

	GB_ICONABLE_TOOL
		export
			{NONE} all
		undefine
			default_create, copy
		end

	EIFFEL_RESERVED_WORDS
		export
			{NONE} all
		undefine
			default_create, copy, is_equal
		end

	BUILD_RESERVED_WORDS
		export
			{NONE} all
		undefine
			default_create, copy, is_equal
		end

	GB_NAMING_UTILITIES
		export
			{NONE} all
		undefine
			default_create, copy, is_equal
		end

	EV_STOCK_COLORS
		rename
			implementation as stock_colors_implementation
		export
			{NONE} all
		undefine
			copy, is_equal, default_create
		end

	GB_CONSTANTS
		export
			{NONE} all
		undefine
			copy, is_equal, default_create
		end

	GB_WIDGET_UTILITIES
		export
			{NONE} all
		undefine
			default_create
		end

	GB_SHARED_PREFERENCES
		export
			{NONE} all
		undefine
			default_create
		end

	GB_SHARED_PIXMAPS
		export
			{NONE} all
		undefine
			default_create
		end

create
	make_with_components

feature {NONE} -- Initialization

	components: GB_INTERNAL_COMPONENTS
		-- Access to a set of internal components for an EiffelBuild instance.

	make_with_components (a_components: GB_INTERNAL_COMPONENTS) is
			-- Create `Current' and assign `a_components' to `components'.
		require
			a_components_not_void: a_components /= Void
		do
			components := a_components
			default_create
		ensure
			components_set: components = a_components
		end

feature {NONE} -- Initialization

	user_initialization is
			-- called by `initialize'.
			-- Any custom user initialization that
			-- could not be performed in `initialize',
			-- (due to regeneration of implementation class)
			-- can be added here.
		do
			set_default_push_button (ok_button)
			set_default_cancel_button (ok_button)
			create string_input
			string_input.change_actions.extend (agent update_buttons)
			create integer_input
			integer_input.value_range.adapt (create {INTEGER_INTERVAL}.make (-32000, 32000))
			integer_input.change_actions.force_extend (agent update_buttons)
			integer_input.text_change_actions.force_extend (agent update_buttons)
			create directory_input
			directory_input.disable_edit
			directory_input.change_actions.extend (agent update_buttons)
			create color_input
			color_input.disable_edit
			color_input.change_actions.extend (agent update_buttons)
			create font_input
			font_input.disable_edit
			font_input.change_actions.extend (agent update_buttons)
			create filename_input
			filename_input.change_actions.extend (agent update_buttons)
			string_item.enable_select
				-- The default selected constants type is STRING.
			constants_list.enable_multiple_selection
			constants_list.set_column_titles (<<"Name", "Type", "Value">>)
			set_icon_pixmap (icon)
		end

feature -- Access

	sorted_by_name: BOOLEAN
		-- Are items in `constants_list' sorted by name?

	sorted_by_type: BOOLEAN
		-- Are items in `constants_list' sorted by type?

	sorted_by_value: BOOLEAN
		-- Are items in `constants_list' sorted by value?

feature -- Basic operation

	update_for_addition (constant: GB_CONSTANT) is
			-- Update constants displayed in `Current' to reflect
			-- addition of `constant'.
		do
			constants_list.extend (constant.as_multi_column_list_row)
		end

	update_for_removal (constant: GB_CONSTANT) is
			-- Update constants displayed in `Current' to reflect
		require
			constant_not_void: constant /= Void
		local
			removed: BOOLEAN
		do
			from
				constants_list.start
			until
				constants_list.off or removed
			loop
				if constants_list.item.data = constant then
					constants_list.remove
					removed := True
				else
					constants_list.forth
				end
			end
		end

feature {GB_CONSTANTS_HANDLER} -- Implementation

	reset_contents is
			-- Ensure `constants_list' is empty and clear constants.
		do
			constants_list.wipe_out
			modify_constant := Void
			name_field.remove_text
			string_input.remove_text
			integer_input.remove_text
			directory_input.remove_text
			filename_input.remove_text
			color_input.remove_text
			font_input.remove_text
			remove_button.disable_sensitive
			type_combo_box.first.enable_select
			update_buttons
		ensure
			constants_list_empty: constants_list.is_empty
		end

feature {NONE} -- Implementation

	modify_constant: GB_CONSTANT
		-- Constant that is to be modified.

	modify_constant_index: INTEGER
		-- Index of `modify_constant', only valid if
		-- `modify_constant' /= Void.

	string_input: EV_TEXT_FIELD
		-- Input field for STRING constants.

	integer_input: EV_SPIN_BUTTON
		-- Input field for INTEGER constants.

	directory_input: EV_TEXT_FIELD
		-- Input field for DIRECTORY constants.

	filename_input: EV_TEXT_FIELD
		-- Input field for FILENAME constants.

	color_input: EV_TEXT_FIELD
		-- Input field for COLOR constants.

	font_input: EV_TEXT_FIELD
		-- Input field for FONT constants.

	remove_displayed_input_field is
			-- Ensure that `entry_selection_parent' is empty
		do
			entry_selection_parent.wipe_out
		ensure
			is_empty: entry_selection_parent.is_empty
		end

	validate_constant_name is
			-- Called by `change_actions' of `name_field'.
		local
			current_text: STRING
		do
			current_text := name_field.text.as_lower
			if not valid_class_name (current_text) or not components.object_handler.valid_constant_name (current_text) or
				reserved_words.has (current_text) or Build_reserved_words.has (current_text) or
				(components.constants.string_is_constant_name (current_text) and then not components.constants.all_constants.item (current_text).type.is_equal (type_combo_box.text)) then
				name_field.set_foreground_color (red)
				new_button.disable_sensitive
				modify_button.disable_sensitive
			else
				name_field.set_foreground_color (black)
				update_buttons
			end
		end

	name_field_valid: BOOLEAN is
			-- Are contents of `name_field' valid?
			-- The quick method is to check the color.
		do
			Result := name_field.foreground_color.is_equal (Black)
		end

	entry_valid: BOOLEAN is
			-- Is current entry valid?
		do
				-- As only one entry field may be parented, we check the
				-- `parent' to determine which one must be validated
			if string_input.parent /= Void then
				Result := not string_input.text.is_empty
			elseif filename_input.parent /= Void then
				Result := not filename_input.text.is_empty
			else
				Result := True
			end
		end

	update_buttons is
			-- Update status of `add_button' based on state of current input.
		do
			if modify_constant /= Void then
				if type_combo_box.selected_item.text.is_equal (String_constant_type) then
					if modify_constant.name.is_equal (name_field.text) then
						new_button.disable_sensitive
						if string_input.text.is_equal (modify_constant.value_as_string) then
							modify_button.disable_sensitive
						elseif name_field_valid then
							modify_button.enable_sensitive
						end
					else
						new_button.enable_sensitive
						modify_button.disable_sensitive
					end
				elseif type_combo_box.selected_item.text.is_equal (Integer_constant_type) and modify_constant /= Void then
					if modify_constant.name.is_equal (name_field.text) then
						new_button.disable_sensitive
					if integer_input.text.is_equal (modify_constant.value_as_string) then
							modify_button.disable_sensitive
						elseif name_field_valid then
							modify_button.enable_sensitive
						end
					else
						new_button.enable_sensitive
						modify_button.disable_sensitive
					end
				elseif type_combo_box.selected_item.text.is_equal (directory_constant_type) and modify_constant /= Void then
					if modify_constant.name.is_equal (name_field.text) then
						new_button.disable_sensitive
						modify_button.enable_sensitive
					else
						new_button.enable_sensitive
						modify_button.disable_sensitive
					end
				elseif type_combo_box.selected_item.text.is_equal (color_constant_type) and modify_constant /= Void then
					if modify_constant.name.is_equal (name_field.text) then
						new_button.disable_sensitive
						modify_button.enable_sensitive
					else
						new_button.enable_sensitive
						modify_button.disable_sensitive
					end
				elseif type_combo_box.selected_item.text.is_equal (font_constant_type) and modify_constant /= Void then
					if modify_constant.name.is_equal (name_field.text) then
						new_button.disable_sensitive
						modify_button.enable_sensitive
					else
						new_button.enable_sensitive
						modify_button.disable_sensitive
					end
				elseif type_combo_box.selected_item.text.is_equal (Pixmap_constant_type) then
					new_button.enable_sensitive
					modify_button.enable_sensitive
				end
			elseif name_field_valid and entry_valid and components.constants.all_constants.item (name_field.text.as_lower) = Void then
				new_button.enable_sensitive
				modify_button.disable_sensitive
			else
				new_button.disable_sensitive
				modify_button.disable_sensitive
			end
		end

	string_item_selected is
			-- Called by `select_actions' of `string_item'.
		do
			name_field.enable_edit
			name_field.enable_sensitive
			name_field.remove_text
			new_button.set_text (New_button_add_text)
			new_button.disable_sensitive
			remove_displayed_input_field
			if not string_item.select_actions.state.is_equal (string_item.select_actions.blocked_state) then
				constants_list.remove_selection
				string_input.remove_text
			end
			remove_displayed_input_field
			entry_selection_parent.extend (string_input)
			if not display_all_types.is_selected and not currently_selected_type.is_equal (String_constant_type) then
				rebuild_for_selected_type (string_item.text)
			end
			currently_selected_type := String_constant_type
		end

	integer_item_selected is
			-- Called by `select_actions' of `integer_item'.
		do
			name_field.enable_edit
			name_field.enable_sensitive
			name_field.remove_text
			new_button.disable_sensitive
			new_button.set_text (New_button_add_text)
			if not integer_item.select_actions.state.is_equal (integer_item.select_actions.blocked_state) then
				constants_list.remove_selection
				integer_input.set_value (0)
			end
			remove_displayed_input_field
			entry_selection_parent.extend (integer_input)
			if not display_all_types.is_selected and not currently_selected_type.is_equal (Integer_constant_type) then
				rebuild_for_selected_type (integer_item.text)
			end
			currently_selected_type := Integer_constant_type
		end

	color_item_selected is
			-- Called by `select_actions' of `color_item'.
		do
			name_field.enable_edit
			name_field.enable_sensitive
			name_field.remove_text
			new_button.disable_sensitive
			new_button.set_text (New_button_text)
			if not color_item.select_actions.state.is_equal (color_item.select_actions.blocked_state) then
				constants_list.remove_selection
				color_input.remove_text
			end
			remove_displayed_input_field
			entry_selection_parent.extend (color_input)
			if not display_all_types.is_selected and not currently_selected_type.is_equal (color_constant_type) then
				rebuild_for_selected_type (color_item.text)
			end
			currently_selected_type := Color_constant_type
		end

	font_item_selected is
			-- Called by `select_actions' of `font_item'.
		do
			name_field.enable_edit
			name_field.enable_sensitive
			name_field.remove_text
			new_button.disable_sensitive
			new_button.set_text (New_button_text)
			if not font_item.select_actions.state.is_equal (font_item.select_actions.blocked_state) then
				constants_list.remove_selection
				font_input.remove_text
			end
			remove_displayed_input_field
			entry_selection_parent.extend (font_input)
			if not display_all_types.is_selected and not currently_selected_type.is_equal (font_constant_type) then
				rebuild_for_selected_type (font_item.text)
			end
			currently_selected_type := Font_constant_type
		end

	directory_item_selected is
			-- Called by `select_actions' of `directory_item'.
		do
			name_field.enable_edit
			name_field.enable_sensitive
			name_field.remove_text
			new_button.disable_sensitive
			new_button.set_text (New_button_text)
			if not directory_item.select_actions.state.is_equal (directory_item.select_actions.blocked_state) then
				constants_list.remove_selection
				directory_input.remove_text
			end
			remove_displayed_input_field
			entry_selection_parent.extend (directory_input)
			if not display_all_types.is_selected and not currently_selected_type.is_equal (Directory_constant_type) then
				rebuild_for_selected_type (directory_item.text)
			end
			currently_selected_type := Directory_constant_type
		end

	pixmap_item_selected is
			-- Called by `select_actions' of `pixmap_item'.
		local
			pixmap: EV_PIXMAP
			pixmap_constant: GB_PIXMAP_CONSTANT
			box: EV_HORIZONTAL_BOX
		do
			name_field.disable_edit
			name_field.disable_sensitive
			name_field.remove_text
			new_button.disable_sensitive
			new_button.set_text (New_button_text)
			if not pixmap_item.select_actions.state.is_equal (pixmap_item.select_actions.blocked_state) then
				constants_list.remove_selection
				new_button.enable_sensitive
			end
			remove_displayed_input_field
			if modify_constant /= Void then
					-- Only display pixmap if `modify_constant' is not `Void' which may occur
					-- when selecting the pixmap list item from the combo box.
				pixmap_constant ?= modify_constant
				check
					pixmap_constant_selected: pixmap_constant /= Void
				end
				create pixmap
				pixmap.copy (pixmap_constant.small_pixmap)
					-- `pixmap' is inserted in a box, so it can be displayed to the left hand side of
					-- `entry_selection_parent'.
				create box
				box.extend (pixmap)
				pixmap.set_minimum_size (pixmap.width, pixmap.height)
				box.disable_item_expand (box.first)
				entry_selection_parent.extend (box)
			end

			if not display_all_types.is_selected and not currently_selected_type.is_equal (Pixmap_constant_type) then
				rebuild_for_selected_type (pixmap_item.text)
			end
			currently_selected_type := Pixmap_constant_type
		end

	new_button_selected is
			-- `new_button' has been selected, so add a new constant accordingly.
		local
			add_constant_command: GB_COMMAND_ADD_CONSTANT
			a_directory_dialog: EV_DIRECTORY_DIALOG
			a_color_dialog: EV_COLOR_DIALOG
			a_font_dialog: EV_FONT_DIALOG
		do
				-- As only one entry field may be parented, we check the
				-- `parent' to determine which one must be validated
			if string_input.parent /= Void then
				create add_constant_command.make (create {GB_STRING_CONSTANT}.make_with_name_and_value (name_field.text.as_lower, string_input.text), components)
				add_constant_command.execute
				string_input.remove_text
				new_button.disable_sensitive
			elseif integer_input.parent /= Void then
				create add_constant_command.make (create {GB_INTEGER_CONSTANT}.make_with_name_and_value (name_field.text.as_lower, integer_input.value), components)
				add_constant_command.execute
				new_button.disable_sensitive
			elseif directory_input.parent /= Void then
				create a_directory_dialog
				a_directory_dialog.show_modal_to_window (Current)
				if not a_directory_dialog.directory.is_empty then
					create add_constant_command.make (create {GB_DIRECTORY_CONSTANT}.make_with_name_and_value (name_field.text.as_lower, a_directory_dialog.directory), components)
					add_constant_command.execute
					name_field.remove_text
				end
			elseif color_input.parent /= Void then
				create a_color_dialog
				a_color_dialog.show_modal_to_window (Current)
				if not a_color_dialog.selected_button.is_equal ((create {EV_DIALOG_CONSTANTS}).ev_cancel) then
					create add_constant_command.make (create {GB_COLOR_CONSTANT}.make_with_name_and_value (name_field.text.as_lower, a_color_dialog.color), components)
					add_constant_command.execute
					name_field.remove_text
				end
			elseif font_input.parent /= Void then
				create a_font_dialog
				a_font_dialog.show_modal_to_window (Current)
				if not a_font_dialog.selected_button.is_equal ((create {EV_DIALOG_CONSTANTS}).ev_cancel) then
					create add_constant_command.make (create {GB_FONT_CONSTANT}.make_with_name_and_value (name_field.text.as_lower, a_font_dialog.font), components)
					add_constant_command.execute
					name_field.remove_text
				end
			elseif type_combo_box.selected_item.text.is_equal (Pixmap_constant_type) then
				select_pixmap
			end
		end

	modify_button_selected is
			-- Called by `select_actions' of `add_button'.
		local
			an_integer_constant: GB_INTEGER_CONSTANT
			a_string_constant: GB_STRING_CONSTANT
			error_dialog: EV_ERROR_DIALOG
			row: EV_MULTI_COLUMN_LIST_ROW
			pixmap_constant: GB_PIXMAP_CONSTANT
			pixmap_dialog: GB_PIXMAP_SETTINGS_DIALOG
			directory_constant: GB_DIRECTORY_CONSTANT
			directory_dialog: EV_DIRECTORY_DIALOG
			color_constant: GB_COLOR_CONSTANT
			a_color_dialog: EV_COLOR_DIALOG
			font_constant: GB_FONT_CONSTANT
			a_font_dialog: EV_FONT_DIALOG
		do
				-- An existing constant must now be modified.
			an_integer_constant ?= modify_constant
			a_string_constant ?= modify_constant
			pixmap_constant ?= modify_constant
			directory_constant ?= modify_constant
			color_constant ?= modify_constant
			font_constant ?= modify_constant
			if an_integer_constant /= Void and then an_integer_constant.can_modify_to_value (integer_input.value) then
					an_integer_constant.modify_value (integer_input.value)
						-- Now update the representation of the constant in the list.
					row := constants_list.i_th (modify_constant_index)
					row.put_i_th (an_integer_constant.value_as_string, 3)
			elseif a_string_constant /= Void and then a_string_constant.can_modify_to_value (string_input.text) then
				a_string_constant.modify_value (string_input.text)
					-- Now update the representation of the constant in the list.
				row := constants_list.i_th (modify_constant_index)
				row.put_i_th (a_string_constant.value_as_string, 3)
			elseif pixmap_constant /= Void then
				create pixmap_dialog.make_in_modify_mode (pixmap_constant.name, components)
				pixmap_dialog.show_modal_to_window (Current)
				row := constants_list.i_th (modify_constant_index)
				row.set_pixmap (pixmap_constant.small_pixmap)
			elseif color_constant /= Void then
				create a_color_dialog
				a_color_dialog.set_title (select_color_location_modify_string + color_constant.name + "%"")
				a_color_dialog.set_color (color_constant.value)
				a_color_dialog.show_modal_to_window (Current)
				if not a_color_dialog.selected_button.is_equal ((create {EV_DIALOG_CONSTANTS}).ev_cancel) then
					color_constant.modify_value (a_color_dialog.color)
				end
					-- Now update the representation of the constant in the list.
				row := constants_list.i_th (modify_constant_index)
				row.set_pixmap (color_constant.small_pixmap)
			elseif font_constant /= Void then
				create a_font_dialog
				a_font_dialog.set_title (select_font_location_modify_string + font_constant.name + "%"")
				a_font_dialog.set_font (font_constant.value)
				a_font_dialog.show_modal_to_window (Current)
				if not a_font_dialog.selected_button.is_equal ((create {EV_DIALOG_CONSTANTS}).ev_cancel) then
					font_constant.modify_value (a_font_dialog.font)
				end
			elseif directory_constant /= Void then
				create directory_dialog
				directory_dialog.set_title (select_directory_location_modify_string + directory_constant.name + "%"")
				if (create {DIRECTORY}.make (directory_constant.value)).exists then
						-- Only set the start directory if it is a valid directory.
					directory_dialog.set_start_directory (directory_constant.value)
				end
				directory_dialog.show_modal_to_window (Current)
				if not directory_dialog.directory.is_empty then
					directory_constant.modify_value (directory_dialog.directory)
						-- Now update the representation of the constant in the list.
					row := constants_list.i_th (modify_constant_index)
					row.put_i_th (directory_constant.value_as_string, 3)
					directory_input.set_text (directory_constant.value)
						-- Now must update all pixmaps in `Current' relying on `directory_constant'.
					from
						constants_list.start
					until
						constants_list.off
					loop
						pixmap_constant ?= constants_list.item.data
						if pixmap_constant /= Void and then not pixmap_constant.is_absolute and then
							pixmap_constant.directory.is_equal (directory_constant.name) then
							constants_list.item.set_pixmap (pixmap_constant.pixmap)
						end
						constants_list.forth
					end
				end
			else
				create error_dialog.make_with_text ("Unable to change as one or more refers may not be set to this value.")
				error_dialog.set_icon_pixmap (Icon_build_window @ 1)
				error_dialog.show_modal_to_window (Current)
			end
				-- Update system to reflect a change.
			components.system_status.mark_as_dirty
		end

	key_pressed_on_constants_list (a_key: EV_KEY) is
			-- Called by `key_press_actions' of `constants_list'.
		do
			if a_key.code = (create {EV_KEY_CONSTANTS}).key_delete then
				remove_selected_constant
			end
		end

	remove_selected_constant is
			-- Called by `select_actions' of `remove_button'.
		require else
			items_selected: not constants_list.selected_items.is_empty
		local
			constant: GB_CONSTANT
			selected_items: DYNAMIC_LIST [EV_MULTI_COLUMN_LIST_ROW]
			delete_constant_command: GB_COMMAND_DELETE_CONSTANT
			cross_referer_dialog: EV_WARNING_DIALOG
			cancelled: BOOLEAN_REF
			referers_dialog_already_displayed: BOOLEAN
			cross_referers_dialog_already_displayed: BOOLEAN
			directory_constant: GB_DIRECTORY_CONSTANT
			all_pixmap_constants: ARRAYED_LIST [GB_PIXMAP_CONSTANT]
			pixmap_constant: GB_PIXMAP_CONSTANT
			ordered_selected_items: ARRAYED_LIST [GB_CONSTANT]
			counted_pixmaps: INTEGER
			warning_dialog: STANDARD_DISCARDABLE_CONFIRMATION_DIALOG
		do
			create cancelled
				-- We must use a boolean ref so that it may be set from an agent.
			selected_items := constants_list.selected_items
			create ordered_selected_items.make (4)
			create all_pixmap_constants.make (1)
				-- We store all pixmap constants that are being deleted, so that
				-- we can ignore directory dependencies on these constants, as they
				-- are being deleted also. We also build `ordered_selected_items' with
				-- the constants to be removed ordered as follows:
				-- 1. Pixmap constants.
				-- 2. Directory constants.
				-- 3. All other constants
			from
				selected_items.start
			until
				selected_items.off
			loop
				pixmap_constant ?= selected_items.item.data
				if pixmap_constant /= Void then
					all_pixmap_constants.extend (pixmap_constant)
					ordered_selected_items.put_front (pixmap_constant)
					counted_pixmaps := counted_pixmaps + 1
				else
					directory_constant ?= selected_items.item.data
					if directory_constant /= Void then
						ordered_selected_items.go_i_th (counted_pixmaps)
						ordered_selected_items.put_right (directory_constant)
					else
						constant ?= selected_items.item.data
						ordered_selected_items.force (constant)
					end
				end

				selected_items.forth
			end
			if ordered_selected_items.count /= 1 then
					-- As there are multiple constants, we must perform two loops.
					-- The first checks to see if there are any references to one or more of the constants.
					-- The second performs the deletion unless there were references and a user cancelled.
				from
					ordered_selected_items.start
				until
					ordered_selected_items.off or cancelled.item
				loop
					constant := ordered_selected_items.item
					directory_constant ?= constant
					if directory_constant /= Void and not cross_referers_dialog_already_displayed then
						if not directory_constant_deletable (directory_constant, all_pixmap_constants) then
							create cross_referer_dialog.make_with_text ("One or more constants you are deleting are still required by other constants in the system.%NPlease removed any such dependencies before trying to delete these constants.")
							cross_referer_dialog.set_icon_pixmap (Icon_build_window @ 1)
							cross_referer_dialog.show_modal_to_window (Current)
							cross_referers_dialog_already_displayed := True
							cancelled.set_item (True)
						end
					end
					if not constant.referers.is_empty and not referers_dialog_already_displayed and not cross_referers_dialog_already_displayed then
						create warning_dialog.make_initialized (2, show_constant_manifest_conversion_warning, "One or more constants are still referenced by objects in the system.%NIf you delete then, all references will be converted to manifest values.%NAre you sure you wish to perform this?", "Always convert, and do not show again.", preferences.preferences)
						warning_dialog.set_icon_pixmap (Icon_build_window @ 1)
						warning_dialog.set_ok_action (agent do_nothing)
						warning_dialog.set_title ("Constant still referenced")
						warning_dialog.set_cancel_action (agent cancelled.set_item (True))
						warning_dialog.show_modal_to_window (Current)
						preferences.preferences.save_resources
						referers_dialog_already_displayed := True
					end
					ordered_selected_items.forth
				end

				if not cancelled.item then
					from
						ordered_selected_items.start
					until
						ordered_selected_items.off
					loop
						constant ?= ordered_selected_items.item
						check
							data_was_constant: constant /= Void
						end
						create delete_constant_command.make (constant, components)
						delete_constant_command.execute
						ordered_selected_items.forth
					end
				end
			else
				constant ?= constants_list.selected_item.data
				check
					data_was_constant: constant /= Void
				end
					directory_constant ?= constant
					if directory_constant /= Void and not cross_referers_dialog_already_displayed then
						if not directory_constant_deletable (directory_constant, all_pixmap_constants) then
							create cross_referer_dialog.make_with_text ("The constant you are deleting is still required by other constants in the system.%NPlease removed any such dependencies before trying to delete this constant.")
							cross_referer_dialog.set_icon_pixmap (Icon_build_window @ 1)
							cross_referer_dialog.show_modal_to_window (Current)
							cross_referers_dialog_already_displayed := True
							cancelled := True
						end
					end
				if not constant.referers.is_empty and not cross_referers_dialog_already_displayed then
					create warning_dialog.make_initialized (2, show_constant_manifest_conversion_warning, "Constant named `" + constant.name + "' is still referenced by one or more objects in the system.%NIf you delete it, all references will be converted to manifest values.%NAre you sure you wish to perform this?", "Always convert, and do not show again.", preferences.preferences)
					warning_dialog.set_icon_pixmap (Icon_build_window @ 1)
					warning_dialog.set_ok_action (agent do_nothing)
					warning_dialog.set_title ("Constant still referenced")
					warning_dialog.set_cancel_action (agent cancelled.set_item (True))
					warning_dialog.show_modal_to_window (Current)
				end
				if not cancelled.item then
					create delete_constant_command.make (constant, components)
					delete_constant_command.execute
				end
			end
			if not cancelled.item then
					-- Now clear input fields
				name_field.remove_text
				string_input.remove_text
				integer_input.remove_text

					-- Update system to reflect a change.
				components.system_status.mark_as_dirty
			end
		end

	directory_constant_deletable (directory_constant: GB_DIRECTORY_CONSTANT; all_pixmaps_for_deletion: ARRAYED_LIST [GB_CONSTANT]): BOOLEAN is
			-- Is `directory_constant' deletable if contents of `all_pixmaps_for_deletion' are also deleted at the same time?
			-- Checks that no cross referers still exist that are not being deleted.
		require
			directory_constant_not_void: directory_constant /= Void
			all_pixmaps_not_void: all_pixmaps_for_deletion /= Void
		local
			all_cross_referers: ARRAYED_LIST [GB_CONSTANT]
			counted_referers: INTEGER
		do
			all_cross_referers := directory_constant.cross_referers
			from
				all_cross_referers.start
			until
				all_cross_referers.off
			loop
				if all_pixmaps_for_deletion.has (all_cross_referers.item) then
					counted_referers := counted_referers + 1
				end
				all_cross_referers.forth
			end
			Result := directory_constant.cross_referers.count = counted_referers
			check
				counted_refers_less_than_referers: directory_constant.cross_referers.count >= counted_referers
			end
		end

	display_all_types_changed is
			-- Called by `select_actions' of `display_all_types'.
		do
			if display_all_types.is_selected then
				rebuild_for_selected_type (all_constant_type)
			else
				rebuild_for_selected_type (type_combo_box.text)
			end
		end

	column_clicked (a_column: INTEGER) is
			-- Called by `column_title_click_actions' of `constants_list'.
		do
				-- Reset all sorted values
			sorted_by_type := False
			sorted_by_name := False
			sorted_by_value := False

				-- Set sorted by corresponding to `a_column'.
			inspect a_column
			when 1 then
				sorted_by_type := True
			when 2 then
				sorted_by_name := True
			when 3 then
				sorted_by_value := True
			else
			end
			perform_sort (a_column)
		end

	perform_sort (a_column: INTEGER) is
			-- Perform sort of information displayed in `constants_list',
			-- sorted by column index `a_column',
		local
			sorter: DS_ARRAY_QUICK_SORTER [EV_MULTI_COLUMN_LIST_ROW]
			comparator: MULTI_COLUMN_LIST_ROW_STRING_COMPARATOR
			lconstants: ARRAYED_LIST [EV_MULTI_COLUMN_LIST_ROW]
		do
			if last_selected_column = a_column then
					-- Reverse the sort if this column has already been clicked.
				reverse_sort := not reverse_sort
			else
				reverse_sort := False
			end
			last_selected_column := a_column

				-- Lock window updates, and display a wait cursor.
			constants_list.set_pointer_style ((create {EV_STOCK_PIXMAPS}).busy_cursor)
			parent_window (constants_list).lock_update

			create lconstants.make (constants_list.count)
				-- Place all items in `lconstants' ready for sorting.
			from
				constants_list.start
			until
				constants_list.count = lconstants.count
			loop
				lconstants.force (constants_list.i_th (lconstants.count + 1))
			end

				-- Initialize `sorter' and `comparator'
			create comparator
			comparator.set_sort_column (a_column)
			create sorter.make (comparator)
			if reverse_sort then
				sorter.reverse_sort (lconstants)
			else
				sorter.sort (lconstants)
			end

				-- Clear `constants_list' and rebuild rows in sorted order.		
			constants_list.wipe_out
			from
				lconstants.start
			until
				lconstants.off
			loop
				constants_list.extend (lconstants.item)
				lconstants.forth
			end

				-- Unlock window, and restore cursor.
			parent_window (constants_list).unlock_update
			constants_list.set_pointer_style ((create {EV_STOCK_PIXMAPS}).standard_cursor)
		end

	last_selected_column: INTEGER
		-- Last column selected by user.

	reverse_sort: BOOLEAN
		-- Should sort opertion be reversed?

	currently_selected_type: STRING
		-- Type currently selected in `Current'.

	select_pixmap is
			-- Display a pixmap dialog permitting addition of pixmap constants.
		local
			pixmap_dialog: GB_PIXMAP_SETTINGS_DIALOG
		do
			create pixmap_dialog.make (components)
			pixmap_dialog.show_modal_to_window (Current)
		end

	cancel_pressed is
			-- Called by `select_actions' of `cancel_button'.
		do
			components.commands.Show_hide_constants_dialog_command.execute
		end

	ok_pressed is
			-- Called by `select_actions' of `ok_button'.
		do
			components.commands.Show_hide_constants_dialog_command.execute
		end

	item_selected_in_list (an_item: EV_MULTI_COLUMN_LIST_ROW) is
			-- Called by `select_actions' of `constants_list'.
		do
			lock_update
			modify_constant ?= an_item.data
			modify_constant_index := an_item.parent.index_of (an_item, 1)
			check
				modify_constant_not_void: modify_constant /= Void
			end
			type_combo_box.select_actions.block
			string_item.select_actions.block
			integer_item.select_actions.block
			pixmap_item.select_actions.block
			directory_item.select_actions.block
			color_item.select_actions.block
			font_item.select_actions.block
			select_named_combo_item (type_combo_box, modify_constant.type)
			if modify_constant.type.is_equal (String_constant_type) then
				string_item_selected
			elseif modify_constant.type.is_equal (Integer_constant_type) then
				integer_item_selected
			elseif modify_constant.type.is_equal (Directory_constant_type) then
				directory_item_selected
			elseif modify_constant.type.is_equal (Pixmap_constant_type) then
				pixmap_item_selected
			elseif modify_constant.type.is_equal (Color_constant_type) then
				color_item_selected
			elseif modify_constant.type.is_equal (Font_constant_type) then
				font_item_selected
			end
			string_item.select_actions.resume
			integer_item.select_actions.resume
			pixmap_item.select_actions.resume
			directory_item.select_actions.resume
			type_combo_box.select_actions.resume
			color_item.select_actions.resume
			font_item.select_actions.resume
			remove_button.enable_sensitive
			name_field.set_text (an_item.i_th (1))
			if string_input.parent /= Void then
				string_input.set_text (an_item.i_th (3))
			elseif directory_input.parent /= Void then
				directory_input.set_text (an_item.i_th (3))
			elseif integer_input.parent /= Void then
				integer_input.set_value ((an_item.i_th (3)).to_integer)
			elseif color_input.parent /= Void then
				color_input.set_text (an_item.i_th (3))
			elseif font_input.parent /= Void then
				font_input.set_text (an_item.i_th (3))
			end
			unlock_update
		end

	item_deselected_in_list (an_item: EV_MULTI_COLUMN_LIST_ROW) is
			-- Called by `deselect_actions' of `constants_list'.
		do
			modify_constant := Void
			if constants_list.selected_items.is_empty then
				remove_button.disable_sensitive
			end
		end

	icon: EV_PIXMAP is
			-- Icon displayed in title of `Current'.
		once
			Result := (create {GB_SHARED_PIXMAPS}).Icon_format_onces @ 1
		end

	rebuild_for_selected_type (a_type: STRING) is
			-- Rebuild `constants_list' to only show types corresponding to `a_type'.
		require
			type_valid: a_type.is_equal (all_constant_type) or components.constants.Supported_types.has (a_type)
		local
			temp_constants: HASH_TABLE [GB_CONSTANT, STRING]
		do
			parent_window (constants_list).lock_update
			constants_list.wipe_out
			temp_constants := components.constants.all_constants
			from
				temp_constants.start
			until
				temp_constants.off
			loop
				if a_type.is_equal (All_constant_type) or temp_constants.item (temp_constants.key_for_iteration).type.is_equal (a_type) then
					constants_list.extend (temp_constants.item (temp_constants.key_for_iteration).as_multi_column_list_row)
				end
				temp_constants.forth
			end
			parent_window (constants_list).unlock_update
		end

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


end -- class GB_CONSTANTS_DIALOG

