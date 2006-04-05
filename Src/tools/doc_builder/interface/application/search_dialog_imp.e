indexing
	description: "Objects that represent an EV_DIALOG.%
		%The original version of this class was generated by EiffelBuild."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SEARCH_DIALOG_IMP

inherit
	EV_DIALOG
		redefine
			initialize, is_in_default_state
		end
			
	CONSTANTS
		undefine
			is_equal, default_create, copy
		end

-- This class is the implementation of an EV_DIALOG generated by EiffelBuild.
-- You should not modify this code by hand, as it will be re-generated every time
-- modifications are made to the project.

feature {NONE}-- Initialization

	initialize is
			-- Initialize `Current'.
		do
			Precursor {EV_DIALOG}
			initialize_constants
			
				-- Create all widgets.
			create l_ev_vertical_box_1
			create l_ev_horizontal_box_1
			create l_ev_label_1
			create search_text
			create l_ev_cell_1
			create l_ev_horizontal_box_2
			create l_ev_cell_2
			create find_but
			create cancel_but
			
				-- Build_widget_structure.
			extend (l_ev_vertical_box_1)
			l_ev_vertical_box_1.extend (l_ev_horizontal_box_1)
			l_ev_horizontal_box_1.extend (l_ev_label_1)
			l_ev_horizontal_box_1.extend (search_text)
			l_ev_vertical_box_1.extend (l_ev_cell_1)
			l_ev_vertical_box_1.extend (l_ev_horizontal_box_2)
			l_ev_horizontal_box_2.extend (l_ev_cell_2)
			l_ev_horizontal_box_2.extend (find_but)
			l_ev_horizontal_box_2.extend (cancel_but)
			
			l_ev_vertical_box_1.set_padding_width (5)
			l_ev_vertical_box_1.set_border_width (2)
			l_ev_vertical_box_1.disable_item_expand (l_ev_horizontal_box_1)
			l_ev_vertical_box_1.disable_item_expand (l_ev_horizontal_box_2)
			l_ev_horizontal_box_1.set_padding_width (5)
			l_ev_horizontal_box_1.set_border_width (2)
			l_ev_horizontal_box_1.disable_item_expand (l_ev_label_1)
			l_ev_label_1.set_text ("Find")
			l_ev_label_1.align_text_left
			l_ev_horizontal_box_2.set_padding_width (5)
			l_ev_horizontal_box_2.set_border_width (2)
			l_ev_horizontal_box_2.disable_item_expand (find_but)
			l_ev_horizontal_box_2.disable_item_expand (cancel_but)
			find_but.set_text (button_find_text)
			find_but.set_minimum_width (button_width)
			cancel_but.set_text (button_cancel_text)
			cancel_but.set_minimum_width (button_width)
			set_minimum_width (dialog_width)
			set_title ("Search")
			
				--Connect events.
				-- Close the application when an interface close
				-- request is recieved on `Current'. i.e. the cross is clicked.

				-- Call `user_initialization'.
			user_initialization
		end

feature -- Access

	l_ev_cell_1: EV_CELL
	l_ev_cell_2: EV_CELL
	find_but: EV_BUTTON
	cancel_but: EV_BUTTON
	l_ev_horizontal_box_1: EV_HORIZONTAL_BOX
	l_ev_horizontal_box_2: EV_HORIZONTAL_BOX
	l_ev_vertical_box_1: EV_VERTICAL_BOX
	l_ev_label_1: EV_LABEL
	search_text: EV_TEXT_FIELD

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
end -- class SEARCH_DIALOG_IMP
