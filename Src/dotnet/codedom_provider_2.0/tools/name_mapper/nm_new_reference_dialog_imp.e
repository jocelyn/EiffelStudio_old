indexing
	description: "Objects that represent an EV_DIALOG.%
		%The original version of this class was generated by EiffelBuild."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	NM_NEW_REFERENCE_DIALOG_IMP

inherit
	EV_DIALOG
		redefine
			initialize, is_in_default_state
		end
			
	NM_CONSTANTS
		undefine
			is_equal, default_create, copy
		end

-- This class is the implementation of an EV_DIALOG generated by EiffelBuild.
-- You should not modify this code by hand, as it will be re-generated every time
-- modifications are made to the project.

feature {NONE}-- Initialization

	initialize is
			-- Initialize `Current'.
		local 
			l_ev_horizontal_box_1, l_ev_horizontal_box_2: EV_HORIZONTAL_BOX
			l_ev_cell_1, l_ev_cell_2, l_ev_cell_3: EV_CELL
			l_ev_horizontal_separator_1: EV_HORIZONTAL_SEPARATOR
		do
			Precursor {EV_DIALOG}
			initialize_constants
			
				-- Create all widgets.
			create main_box
			create reference_location_box
			create reference_location_label
			create l_ev_horizontal_box_1
			create reference_location_combo
			create browse_button
			create prefix_box
			create prefix_label
			create l_ev_horizontal_box_2
			create prefix_combo
			create l_ev_cell_1
			create l_ev_horizontal_separator_1
			create buttons_box
			create l_ev_cell_2
			create add_button
			create cancel_button
			create l_ev_cell_3
			
				-- Build_widget_structure.
			extend (main_box)
			main_box.extend (reference_location_box)
			reference_location_box.extend (reference_location_label)
			reference_location_box.extend (l_ev_horizontal_box_1)
			l_ev_horizontal_box_1.extend (reference_location_combo)
			l_ev_horizontal_box_1.extend (browse_button)
			main_box.extend (prefix_box)
			prefix_box.extend (prefix_label)
			prefix_box.extend (l_ev_horizontal_box_2)
			l_ev_horizontal_box_2.extend (prefix_combo)
			l_ev_horizontal_box_2.extend (l_ev_cell_1)
			main_box.extend (l_ev_horizontal_separator_1)
			main_box.extend (buttons_box)
			buttons_box.extend (l_ev_cell_2)
			buttons_box.extend (add_button)
			buttons_box.extend (cancel_button)
			buttons_box.extend (l_ev_cell_3)
			
			set_minimum_width (400)
			set_minimum_height (193)
			set_title ("Add Assembly Reference")
			main_box.set_padding_width (7)
			main_box.disable_item_expand (reference_location_box)
			main_box.disable_item_expand (prefix_box)
			main_box.disable_item_expand (l_ev_horizontal_separator_1)
			main_box.disable_item_expand (buttons_box)
			reference_location_box.set_padding_width (7)
			reference_location_box.set_border_width (7)
			reference_location_label.set_text ("Assembly location:")
			reference_location_label.align_text_left
			l_ev_horizontal_box_1.set_padding_width (7)
			l_ev_horizontal_box_1.disable_item_expand (browse_button)
			browse_button.set_text ("...")
			browse_button.set_minimum_width (35)
			prefix_box.set_padding_width (7)
			prefix_box.set_border_width (7)
			prefix_label.set_text ("Prefix:")
			prefix_label.align_text_left
			l_ev_horizontal_box_2.disable_item_expand (prefix_combo)
			prefix_combo.set_minimum_width (200)
			buttons_box.set_padding_width (7)
			buttons_box.disable_item_expand (add_button)
			buttons_box.disable_item_expand (cancel_button)
			add_button.disable_sensitive
			add_button.set_text ("Add")
			add_button.set_minimum_width (100)
			cancel_button.set_text ("Cancel")
			cancel_button.set_minimum_width (100)
			
				--Connect events.
			reference_location_combo.change_actions.extend (agent on_location_change)
			browse_button.select_actions.extend (agent on_browse)
			add_button.select_actions.extend (agent on_add)
			cancel_button.select_actions.extend (agent on_cancel)
				-- Close the application when an interface close
				-- request is recieved on `Current'. i.e. the cross is clicked.

				-- Call `user_initialization'.
			user_initialization
		end

feature -- Access

	main_box, reference_location_box, prefix_box: EV_VERTICAL_BOX
	reference_location_label, prefix_label: EV_LABEL
	reference_location_combo, prefix_combo: EV_COMBO_BOX
	browse_button, add_button, cancel_button: EV_BUTTON
	buttons_box: EV_HORIZONTAL_BOX

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
	
	on_location_change is
			-- Called by `change_actions' of `reference_location_combo'.
		deferred
		end
	
	on_browse is
			-- Called by `select_actions' of `browse_button'.
		deferred
		end
	
	on_add is
			-- Called by `select_actions' of `add_button'.
		deferred
		end
	
	on_cancel is
			-- Called by `select_actions' of `cancel_button'.
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
end -- class NM_NEW_REFERENCE_DIALOG_IMP
