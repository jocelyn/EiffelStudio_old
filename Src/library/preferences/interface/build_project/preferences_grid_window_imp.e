indexing
	description: "Objects that represent an EV_DIALOG.%
		%The original version of this class was generated by EiffelBuild."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	PREFERENCES_GRID_WINDOW_IMP

inherit
	EV_DIALOG
		redefine
			initialize, is_in_default_state
		end

-- This class is the implementation of an EV_DIALOG generated by EiffelBuild.
-- You should not modify this code by hand, as it will be re-generated every time
-- modifications are made to the project.

feature {NONE}-- Initialization

	initialize is
			-- Initialize `Current'.
		do
			Precursor {EV_DIALOG}
			
				-- Create all widgets.
			create l_ev_vertical_box_1
			create l_ev_horizontal_split_area_1
			create left_list
			create l_ev_vertical_box_2
			create l_ev_vertical_split_area_1
			create grid_container
			create preference_frame
			create l_ev_vertical_box_3
			create description_text
			create l_ev_horizontal_separator_1
			create l_ev_horizontal_box_1
			create restore_button
			create l_ev_cell_1
			create close_button
			
				-- Build_widget_structure.
			extend (l_ev_vertical_box_1)
			l_ev_vertical_box_1.extend (l_ev_horizontal_split_area_1)
			l_ev_horizontal_split_area_1.extend (left_list)
			l_ev_horizontal_split_area_1.extend (l_ev_vertical_box_2)
			l_ev_vertical_box_2.extend (l_ev_vertical_split_area_1)
			l_ev_vertical_split_area_1.extend (grid_container)
			l_ev_vertical_split_area_1.extend (preference_frame)
			preference_frame.extend (l_ev_vertical_box_3)
			l_ev_vertical_box_3.extend (description_text)
			l_ev_vertical_box_1.extend (l_ev_horizontal_separator_1)
			l_ev_vertical_box_1.extend (l_ev_horizontal_box_1)
			l_ev_horizontal_box_1.extend (restore_button)
			l_ev_horizontal_box_1.extend (l_ev_cell_1)
			l_ev_horizontal_box_1.extend (close_button)
			
			l_ev_vertical_box_1.set_padding_width (5)
			l_ev_vertical_box_1.disable_item_expand (l_ev_horizontal_separator_1)
			l_ev_vertical_box_1.disable_item_expand (l_ev_horizontal_box_1)
			left_list.set_minimum_width (200)
			l_ev_vertical_box_2.set_padding_width (5)
			l_ev_vertical_box_2.set_border_width (5)
			preference_frame.set_text ("Details")
			l_ev_vertical_box_3.set_padding_width (5)
			l_ev_vertical_box_3.set_border_width (5)
			description_text.set_minimum_height (50)
			description_text.disable_edit
			l_ev_horizontal_box_1.set_padding_width (5)
			l_ev_horizontal_box_1.set_border_width (5)
			l_ev_horizontal_box_1.disable_item_expand (restore_button)
			l_ev_horizontal_box_1.disable_item_expand (close_button)
			restore_button.set_text ("Restore Defaults")
			restore_button.set_minimum_width (90)
			close_button.set_text ("Close")
			close_button.set_minimum_width (80)
			set_title ("Display window")
			
				--Connect events.
				-- Close the application when an interface close
				-- request is recieved on `Current'. i.e. the cross is clicked.

				-- Call `user_initialization'.
			user_initialization
		end

feature -- Access

	restore_button, close_button: EV_BUTTON
	description_text: EV_TEXT
	grid_container: EV_HORIZONTAL_BOX
	left_list: EV_TREE
	preference_frame: EV_FRAME

feature {NONE} -- Implementation

	l_ev_horizontal_separator_1: EV_HORIZONTAL_SEPARATOR
	l_ev_cell_1: EV_CELL
	l_ev_horizontal_split_area_1: EV_HORIZONTAL_SPLIT_AREA
	l_ev_vertical_split_area_1: EV_VERTICAL_SPLIT_AREA
	l_ev_horizontal_box_1: EV_HORIZONTAL_BOX
	l_ev_vertical_box_1,
	l_ev_vertical_box_2, l_ev_vertical_box_3: EV_VERTICAL_BOX

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
	
end -- class PREFERENCES_GRID_WINDOW_IMP
