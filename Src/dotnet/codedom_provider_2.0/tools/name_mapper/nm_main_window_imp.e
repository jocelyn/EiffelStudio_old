indexing
	description: "Objects that represent an EV_TITLED_WINDOW.%
		%The original version of this class was generated by EiffelBuild."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	NM_MAIN_WINDOW_IMP

inherit
	EV_TITLED_WINDOW
		redefine
			initialize, is_in_default_state
		end
			
	NM_CONSTANTS
		undefine
			is_equal, default_create, copy
		end

-- This class is the implementation of an EV_TITLED_WINDOW generated by EiffelBuild.
-- You should not modify this code by hand, as it will be re-generated every time
-- modifications are made to the project.

feature {NONE}-- Initialization

	initialize is
			-- Initialize `Current'.
		local 
			l_ev_menu_separator_1: EV_MENU_SEPARATOR
			l_ev_horizontal_box_1: EV_HORIZONTAL_BOX
			l_ev_cell_1: EV_CELL
		do
			Precursor {EV_TITLED_WINDOW}
			initialize_constants
			
				-- Create all widgets.
			create menu
			create file_menu
			create exit_menu_item
			create help_menu
			create help_menu_item
			create l_ev_menu_separator_1
			create about_menu_item
			create main_box
			create l_ev_horizontal_box_1
			create input_frame
			create input_box
			create input_type_box
			create input_type_label
			create input_type_combo_box
			create input_member_box
			create input_member_label
			create input_member_combo_box
			create output_frame
			create output_box
			create output_type_box
			create output_type_label
			create output_type_text_field
			create output_member_box
			create output_member_label
			create output_member_text_field
			create assemblies_frame
			create assemblies_box
			create assemblies_list
			create buttons_box
			create add_button
			create remove_button
			create l_ev_cell_1
			
				-- Build_widget_structure.
			set_menu_bar (menu)
			menu.extend (file_menu)
			file_menu.extend (exit_menu_item)
			menu.extend (help_menu)
			help_menu.extend (help_menu_item)
			help_menu.extend (l_ev_menu_separator_1)
			help_menu.extend (about_menu_item)
			extend (main_box)
			main_box.extend (l_ev_horizontal_box_1)
			l_ev_horizontal_box_1.extend (input_frame)
			input_frame.extend (input_box)
			input_box.extend (input_type_box)
			input_type_box.extend (input_type_label)
			input_type_box.extend (input_type_combo_box)
			input_box.extend (input_member_box)
			input_member_box.extend (input_member_label)
			input_member_box.extend (input_member_combo_box)
			l_ev_horizontal_box_1.extend (output_frame)
			output_frame.extend (output_box)
			output_box.extend (output_type_box)
			output_type_box.extend (output_type_label)
			output_type_box.extend (output_type_text_field)
			output_box.extend (output_member_box)
			output_member_box.extend (output_member_label)
			output_member_box.extend (output_member_text_field)
			main_box.extend (assemblies_frame)
			assemblies_frame.extend (assemblies_box)
			assemblies_box.extend (assemblies_list)
			assemblies_box.extend (buttons_box)
			buttons_box.extend (add_button)
			buttons_box.extend (remove_button)
			buttons_box.extend (l_ev_cell_1)
			
			set_minimum_width (400)
			set_minimum_height (280)
			set_title ("Name Mapper")
			file_menu.set_text ("File")
			exit_menu_item.set_text ("Exit")
			help_menu.set_text ("Help")
			help_menu_item.set_text ("Name Mapper Help")
			help_menu_item.set_pixmap (help_png)
			about_menu_item.set_text ("About Name Mapper")
			main_box.set_padding_width (7)
			main_box.set_border_width (7)
			main_box.disable_item_expand (l_ev_horizontal_box_1)
			l_ev_horizontal_box_1.set_padding_width (7)
			input_frame.set_text (".NET Names")
			input_box.set_padding_width (7)
			input_box.set_border_width (7)
			input_box.disable_item_expand (input_type_box)
			input_box.disable_item_expand (input_member_box)
			input_type_box.set_padding_width (5)
			input_type_box.disable_item_expand (input_type_label)
			input_type_box.disable_item_expand (input_type_combo_box)
			input_type_label.set_text (".NET Type:")
			input_type_label.align_text_left
			input_member_box.set_padding_width (5)
			input_member_box.disable_item_expand (input_member_label)
			input_member_box.disable_item_expand (input_member_combo_box)
			input_member_label.set_text ("Member:")
			input_member_label.align_text_left
			output_frame.set_text ("Eiffel Names")
			output_box.set_padding_width (7)
			output_box.set_border_width (7)
			output_box.disable_item_expand (output_type_box)
			output_box.disable_item_expand (output_member_box)
			output_type_box.set_padding_width (5)
			output_type_box.disable_item_expand (output_type_label)
			output_type_box.disable_item_expand (output_type_text_field)
			output_type_label.set_text ("Eiffel Class:")
			output_type_label.align_text_left
			output_type_text_field.disable_edit
			output_member_box.set_padding_width (5)
			output_member_box.disable_item_expand (output_member_label)
			output_member_box.disable_item_expand (output_member_text_field)
			output_member_label.set_text ("Feature:")
			output_member_label.align_text_left
			output_member_text_field.disable_edit
			assemblies_frame.set_text ("Assemblies")
			assemblies_box.set_padding_width (7)
			assemblies_box.set_border_width (7)
			assemblies_box.disable_item_expand (buttons_box)
			buttons_box.set_padding_width (7)
			buttons_box.disable_item_expand (add_button)
			buttons_box.disable_item_expand (remove_button)
			add_button.set_text ("Add")
			add_button.set_minimum_width (100)
			remove_button.disable_sensitive
			remove_button.set_text ("Remove")
			remove_button.set_minimum_width (100)
			
				--Connect events.
			resize_actions.extend (agent on_resize (?, ?, ?, ?))
			exit_menu_item.select_actions.extend (agent on_close)
			help_menu_item.select_actions.extend (agent on_help)
			about_menu_item.select_actions.extend (agent on_about)
			input_type_combo_box.change_actions.extend (agent on_type_change)
			input_member_combo_box.change_actions.extend (agent on_member_change)
			assemblies_list.select_actions.extend (agent on_assembly_select (?))
			assemblies_list.deselect_actions.extend (agent on_assembly_deselect (?))
			assemblies_list.column_resized_actions.extend (agent on_column_resize (?))
			add_button.select_actions.extend (agent on_add_assembly)
			remove_button.select_actions.extend (agent on_remove_assembly)
				-- Close the application when an interface close
				-- request is recieved on `Current'. i.e. the cross is clicked.

				-- Call `user_initialization'.
			user_initialization
		end

feature -- Access

	menu: EV_MENU_BAR
	file_menu, help_menu: EV_MENU
	exit_menu_item, help_menu_item, about_menu_item: EV_MENU_ITEM
	main_box, input_box, input_type_box, input_member_box, output_box, output_type_box, 
	output_member_box, assemblies_box: EV_VERTICAL_BOX
	input_frame, output_frame, assemblies_frame: EV_FRAME
	input_type_label, input_member_label, output_type_label, output_member_label: EV_LABEL
	input_type_combo_box, input_member_combo_box: EV_COMBO_BOX
	output_type_text_field, output_member_text_field: EV_TEXT_FIELD
	assemblies_list: EV_MULTI_COLUMN_LIST
	buttons_box: EV_HORIZONTAL_BOX
	add_button, remove_button: EV_BUTTON

feature {NONE} -- Implementation

	is_in_default_state: BOOLEAN is
			-- Is `Current' in its default state?
		do
			-- Re-implement if you wish to enable checking
			-- for `Current'.
			Result := True
		end
	
	user_initialization is
			-- Feature for custom initialization, called at end of `initialize'.
		deferred
		end
	
	on_resize (a_x, a_y, a_width, a_height: INTEGER) is
			-- Called by `resize_actions' of `Current'.
		deferred
		end
	
	on_close is
			-- Called by `select_actions' of `exit_menu_item'.
		deferred
		end
	
	on_help is
			-- Called by `select_actions' of `help_menu_item'.
		deferred
		end
	
	on_about is
			-- Called by `select_actions' of `about_menu_item'.
		deferred
		end
	
	on_type_change is
			-- Called by `change_actions' of `input_type_combo_box'.
		deferred
		end
	
	on_member_change is
			-- Called by `change_actions' of `input_member_combo_box'.
		deferred
		end
	
	on_assembly_select (an_item: EV_MULTI_COLUMN_LIST_ROW) is
			-- Called by `select_actions' of `assemblies_list'.
		deferred
		end
	
	on_assembly_deselect (an_item: EV_MULTI_COLUMN_LIST_ROW) is
			-- Called by `deselect_actions' of `assemblies_list'.
		deferred
		end
	
	on_column_resize (a_column: INTEGER) is
			-- Called by `column_resized_actions' of `assemblies_list'.
		deferred
		end
	
	on_add_assembly is
			-- Called by `select_actions' of `add_button'.
		deferred
		end
	
	on_remove_assembly is
			-- Called by `select_actions' of `remove_button'.
		deferred
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
end -- class NM_MAIN_WINDOW_IMP
