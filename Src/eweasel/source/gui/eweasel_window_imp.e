indexing
	description: "Objects that represent an EV_TITLED_WINDOW.%
		%The original version of this class was generated by EiffelBuild."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EWEASEL_WINDOW_IMP

inherit
	EV_TITLED_WINDOW
		redefine
			initialize, is_in_default_state
		end
			
	CONSTANTS
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
			l_ev_menu_bar_1: EV_MENU_BAR
			l_ev_menu_2: EV_MENU
			l_ev_menu_separator_1, l_ev_menu_separator_2: EV_MENU_SEPARATOR
			l_ev_vertical_split_area_1: EV_VERTICAL_SPLIT_AREA
			l_ev_vertical_box_1, l_ev_vertical_box_2, l_ev_vertical_box_3, l_ev_vertical_box_4, 
			l_ev_vertical_box_5, l_ev_vertical_box_6, l_ev_vertical_box_7, l_ev_vertical_box_8: EV_VERTICAL_BOX
			l_ev_notebook_1: EV_NOTEBOOK
			l_ev_frame_1, l_ev_frame_2, l_ev_frame_3, l_ev_frame_4: EV_FRAME
			l_ev_horizontal_box_1, l_ev_horizontal_box_2, l_ev_horizontal_box_3, l_ev_horizontal_box_4, 
			l_ev_horizontal_box_5, l_ev_horizontal_box_6, l_ev_horizontal_box_7, l_ev_horizontal_box_8: EV_HORIZONTAL_BOX
			l_ev_cell_1, l_ev_cell_2: EV_CELL
			l_ev_label_1, l_ev_label_2, l_ev_label_3, l_ev_label_4, l_ev_label_5, l_ev_label_6: EV_LABEL
		do
			Precursor {EV_TITLED_WINDOW}
			initialize_constants
			
				-- Create all widgets.
			create l_ev_menu_bar_1
			create l_ev_menu_2
			create configuration_menu_item
			create save_menu_item
			create save_as_menu_item
			create l_ev_menu_separator_1
			create recent_menu_item
			create l_ev_menu_separator_2
			create exit_menu_item
			create l_ev_vertical_split_area_1
			create l_ev_vertical_box_1
			create l_ev_notebook_1
			create test_list_box
			create l_ev_frame_1
			create l_ev_vertical_box_2
			create tests_list
			create test_description_label
			create l_ev_horizontal_box_1
			create l_ev_cell_1
			create test_load_button
			create tests_save_button
			create tests_run_button
			create options_box
			create l_ev_frame_2
			create l_ev_vertical_box_3
			create l_ev_horizontal_box_2
			create l_ev_label_1
			create platform_combo_box
			create windows_combo_item
			create dotnet_combo_item
			create unix_combo_item
			create l_ev_horizontal_box_3
			create l_ev_label_2
			create include_directory_text_field
			create include_directory_browse_button
			create l_ev_horizontal_box_4
			create l_ev_label_3
			create control_file_text_field
			create control_file_browse_button
			create l_ev_horizontal_box_5
			create l_ev_label_4
			create ise_eiffel_var_text_field
			create ise_eiffel_var_browse_button
			create l_ev_horizontal_box_6
			create l_ev_label_5
			create eweasel_directory_text_field
			create eweasel_directory_browse_button
			create l_ev_frame_3
			create l_ev_vertical_box_4
			create l_ev_horizontal_box_7
			create l_ev_label_6
			create test_output_directory_text_field
			create test_output_directory_browse_button
			create l_ev_vertical_box_5
			create keep_check_button
			create keep_options_radio_box
			create all_test_keep_radio
			create passed_test_keep_radio
			create failed_test_keep_radio
			create l_ev_vertical_box_6
			create keep_eifgen_check_buttons
			create l_ev_vertical_box_7
			create l_ev_frame_4
			create l_ev_vertical_box_8
			create output_text
			create l_ev_horizontal_box_8
			create l_ev_cell_2
			create clear_output_button
			create save_output_button
			
				-- Build_widget_structure.
			set_menu_bar (l_ev_menu_bar_1)
			l_ev_menu_bar_1.extend (l_ev_menu_2)
			l_ev_menu_2.extend (configuration_menu_item)
			l_ev_menu_2.extend (save_menu_item)
			l_ev_menu_2.extend (save_as_menu_item)
			l_ev_menu_2.extend (l_ev_menu_separator_1)
			l_ev_menu_2.extend (recent_menu_item)
			l_ev_menu_2.extend (l_ev_menu_separator_2)
			l_ev_menu_2.extend (exit_menu_item)
			extend (l_ev_vertical_split_area_1)
			l_ev_vertical_split_area_1.extend (l_ev_vertical_box_1)
			l_ev_vertical_box_1.extend (l_ev_notebook_1)
			l_ev_notebook_1.extend (test_list_box)
			test_list_box.extend (l_ev_frame_1)
			l_ev_frame_1.extend (l_ev_vertical_box_2)
			l_ev_vertical_box_2.extend (tests_list)
			l_ev_vertical_box_2.extend (test_description_label)
			l_ev_vertical_box_2.extend (l_ev_horizontal_box_1)
			l_ev_horizontal_box_1.extend (l_ev_cell_1)
			l_ev_horizontal_box_1.extend (test_load_button)
			l_ev_horizontal_box_1.extend (tests_save_button)
			l_ev_horizontal_box_1.extend (tests_run_button)
			l_ev_notebook_1.extend (options_box)
			options_box.extend (l_ev_frame_2)
			l_ev_frame_2.extend (l_ev_vertical_box_3)
			l_ev_vertical_box_3.extend (l_ev_horizontal_box_2)
			l_ev_horizontal_box_2.extend (l_ev_label_1)
			l_ev_horizontal_box_2.extend (platform_combo_box)
			platform_combo_box.extend (windows_combo_item)
			platform_combo_box.extend (dotnet_combo_item)
			platform_combo_box.extend (unix_combo_item)
			l_ev_vertical_box_3.extend (l_ev_horizontal_box_3)
			l_ev_horizontal_box_3.extend (l_ev_label_2)
			l_ev_horizontal_box_3.extend (include_directory_text_field)
			l_ev_horizontal_box_3.extend (include_directory_browse_button)
			l_ev_vertical_box_3.extend (l_ev_horizontal_box_4)
			l_ev_horizontal_box_4.extend (l_ev_label_3)
			l_ev_horizontal_box_4.extend (control_file_text_field)
			l_ev_horizontal_box_4.extend (control_file_browse_button)
			l_ev_vertical_box_3.extend (l_ev_horizontal_box_5)
			l_ev_horizontal_box_5.extend (l_ev_label_4)
			l_ev_horizontal_box_5.extend (ise_eiffel_var_text_field)
			l_ev_horizontal_box_5.extend (ise_eiffel_var_browse_button)
			l_ev_vertical_box_3.extend (l_ev_horizontal_box_6)
			l_ev_horizontal_box_6.extend (l_ev_label_5)
			l_ev_horizontal_box_6.extend (eweasel_directory_text_field)
			l_ev_horizontal_box_6.extend (eweasel_directory_browse_button)
			options_box.extend (l_ev_frame_3)
			l_ev_frame_3.extend (l_ev_vertical_box_4)
			l_ev_vertical_box_4.extend (l_ev_horizontal_box_7)
			l_ev_horizontal_box_7.extend (l_ev_label_6)
			l_ev_horizontal_box_7.extend (test_output_directory_text_field)
			l_ev_horizontal_box_7.extend (test_output_directory_browse_button)
			l_ev_vertical_box_4.extend (l_ev_vertical_box_5)
			l_ev_vertical_box_5.extend (keep_check_button)
			l_ev_vertical_box_5.extend (keep_options_radio_box)
			keep_options_radio_box.extend (all_test_keep_radio)
			keep_options_radio_box.extend (passed_test_keep_radio)
			keep_options_radio_box.extend (failed_test_keep_radio)
			l_ev_vertical_box_4.extend (l_ev_vertical_box_6)
			l_ev_vertical_box_6.extend (keep_eifgen_check_buttons)
			l_ev_vertical_split_area_1.extend (l_ev_vertical_box_7)
			l_ev_vertical_box_7.extend (l_ev_frame_4)
			l_ev_frame_4.extend (l_ev_vertical_box_8)
			l_ev_vertical_box_8.extend (output_text)
			l_ev_vertical_box_8.extend (l_ev_horizontal_box_8)
			l_ev_horizontal_box_8.extend (l_ev_cell_2)
			l_ev_horizontal_box_8.extend (clear_output_button)
			l_ev_horizontal_box_8.extend (save_output_button)
			
			set_minimum_width (700)
			set_minimum_height (600)
			set_title ("Eweasel")
			l_ev_menu_2.set_text ("File")
			configuration_menu_item.set_text ("Load configuration..")
			save_menu_item.disable_sensitive
			save_menu_item.set_text ("Save configuration")
			save_as_menu_item.set_text ("Save configuration as..")
			recent_menu_item.set_text ("Recent")
			exit_menu_item.set_text ("Exit")
			l_ev_vertical_box_1.set_padding_width (padding_width)
			l_ev_vertical_box_1.set_border_width (border_width)
			l_ev_notebook_1.set_item_text (test_list_box, "Test")
			l_ev_notebook_1.set_item_text (options_box, "Configuration")
			test_list_box.set_padding_width (padding_width)
			test_list_box.set_border_width (border_width)
			l_ev_frame_1.set_text ("Tests")
			l_ev_vertical_box_2.set_padding_width (padding_width)
			l_ev_vertical_box_2.set_border_width (border_width)
			l_ev_vertical_box_2.disable_item_expand (test_description_label)
			l_ev_vertical_box_2.disable_item_expand (l_ev_horizontal_box_1)
			tests_list.set_minimum_height (150)
			test_description_label.align_text_left
			l_ev_horizontal_box_1.set_padding_width (padding_width)
			l_ev_horizontal_box_1.set_border_width (border_width)
			l_ev_horizontal_box_1.disable_item_expand (test_load_button)
			l_ev_horizontal_box_1.disable_item_expand (tests_save_button)
			l_ev_horizontal_box_1.disable_item_expand (tests_run_button)
			test_load_button.set_text ("Load..")
			test_load_button.set_minimum_width (button_width)
			tests_save_button.set_text ("Save..")
			tests_save_button.set_minimum_width (button_width)
			tests_run_button.set_text ("Run")
			tests_run_button.set_minimum_width (button_width)
			options_box.set_minimum_height (0)
			options_box.set_padding_width (padding_width)
			options_box.set_border_width (border_width)
			options_box.disable_item_expand (l_ev_frame_2)
			options_box.disable_item_expand (l_ev_frame_3)
			l_ev_frame_2.set_text ("Compile options")
			l_ev_vertical_box_3.set_padding_width (padding_width)
			l_ev_vertical_box_3.set_border_width (border_width)
			l_ev_vertical_box_3.disable_item_expand (l_ev_horizontal_box_2)
			l_ev_vertical_box_3.disable_item_expand (l_ev_horizontal_box_3)
			l_ev_vertical_box_3.disable_item_expand (l_ev_horizontal_box_4)
			l_ev_vertical_box_3.disable_item_expand (l_ev_horizontal_box_5)
			l_ev_vertical_box_3.disable_item_expand (l_ev_horizontal_box_6)
			l_ev_horizontal_box_2.set_padding_width (padding_width)
			l_ev_horizontal_box_2.set_border_width (border_width)
			l_ev_horizontal_box_2.disable_item_expand (l_ev_label_1)
			l_ev_horizontal_box_2.disable_item_expand (platform_combo_box)
			l_ev_label_1.set_text ("Platform ")
			platform_combo_box.set_text ("windows")
			platform_combo_box.set_minimum_width (80)
			platform_combo_box.disable_edit
			windows_combo_item.enable_select
			windows_combo_item.set_text ("windows")
			dotnet_combo_item.set_text ("dotnet")
			unix_combo_item.set_text ("unix")
			l_ev_horizontal_box_3.set_padding_width (padding_width)
			l_ev_horizontal_box_3.set_border_width (border_width)
			l_ev_horizontal_box_3.disable_item_expand (l_ev_label_2)
			l_ev_horizontal_box_3.disable_item_expand (include_directory_browse_button)
			l_ev_label_2.set_text ("Include directory ")
			include_directory_browse_button.set_text ("Browse..")
			include_directory_browse_button.set_minimum_width (button_width)
			l_ev_horizontal_box_4.set_padding_width (2)
			l_ev_horizontal_box_4.set_border_width (5)
			l_ev_horizontal_box_4.disable_item_expand (l_ev_label_3)
			l_ev_horizontal_box_4.disable_item_expand (control_file_browse_button)
			l_ev_label_3.set_text ("Initial control file ")
			control_file_browse_button.set_text ("Browse..")
			control_file_browse_button.set_minimum_width (80)
			l_ev_horizontal_box_5.set_padding_width (2)
			l_ev_horizontal_box_5.set_border_width (5)
			l_ev_horizontal_box_5.disable_item_expand (l_ev_label_4)
			l_ev_horizontal_box_5.disable_item_expand (ise_eiffel_var_browse_button)
			l_ev_label_4.set_text ("ISE_EIFFEL ")
			ise_eiffel_var_browse_button.set_text ("Browse..")
			ise_eiffel_var_browse_button.set_minimum_width (80)
			l_ev_horizontal_box_6.set_padding_width (padding_width)
			l_ev_horizontal_box_6.set_border_width (border_width)
			l_ev_horizontal_box_6.disable_item_expand (l_ev_label_5)
			l_ev_horizontal_box_6.disable_item_expand (eweasel_directory_browse_button)
			l_ev_label_5.set_text ("EWEASEL ")
			eweasel_directory_browse_button.set_text ("Browse..")
			eweasel_directory_browse_button.set_minimum_width (80)
			l_ev_frame_3.set_text ("Output options")
			l_ev_vertical_box_4.set_padding_width (padding_width)
			l_ev_vertical_box_4.set_border_width (border_width)
			l_ev_vertical_box_4.disable_item_expand (l_ev_horizontal_box_7)
			l_ev_vertical_box_4.disable_item_expand (l_ev_vertical_box_5)
			l_ev_vertical_box_4.disable_item_expand (l_ev_vertical_box_6)
			l_ev_horizontal_box_7.set_padding_width (padding_width)
			l_ev_horizontal_box_7.set_border_width (border_width)
			l_ev_horizontal_box_7.disable_item_expand (l_ev_label_6)
			l_ev_horizontal_box_7.disable_item_expand (test_output_directory_browse_button)
			l_ev_label_6.set_text ("Create test directories in ")
			test_output_directory_browse_button.set_text ("Browse..")
			test_output_directory_browse_button.set_minimum_width (button_width)
			l_ev_vertical_box_5.set_padding_width (padding_width)
			l_ev_vertical_box_5.set_border_width (border_width)
			keep_check_button.set_text ("Keep test directories after execution")
			keep_options_radio_box.disable_sensitive
			keep_options_radio_box.set_padding_width (padding_width)
			keep_options_radio_box.set_border_width (border_width)
			keep_options_radio_box.disable_item_expand (all_test_keep_radio)
			keep_options_radio_box.disable_item_expand (passed_test_keep_radio)
			keep_options_radio_box.disable_item_expand (failed_test_keep_radio)
			all_test_keep_radio.set_text ("All tests")
			passed_test_keep_radio.set_text ("Passed tests")
			failed_test_keep_radio.set_text ("Failed tests")
			l_ev_vertical_box_6.set_padding_width (padding_width)
			l_ev_vertical_box_6.set_border_width (border_width)
			keep_eifgen_check_buttons.set_text ("Keep test EIFGEN directories")
			l_ev_vertical_box_7.set_padding_width (padding_width)
			l_ev_vertical_box_7.set_border_width (border_width)
			l_ev_frame_4.set_text ("Output")
			l_ev_vertical_box_8.set_padding_width (padding_width)
			l_ev_vertical_box_8.set_border_width (border_width)
			l_ev_vertical_box_8.disable_item_expand (l_ev_horizontal_box_8)
			output_text.disable_edit
			l_ev_horizontal_box_8.set_padding_width (padding_width)
			l_ev_horizontal_box_8.set_border_width (border_width)
			l_ev_horizontal_box_8.disable_item_expand (clear_output_button)
			l_ev_horizontal_box_8.disable_item_expand (save_output_button)
			clear_output_button.set_text ("Clear")
			clear_output_button.set_minimum_width (button_width)
			save_output_button.set_text ("Save")
			save_output_button.set_minimum_width (button_width)
			
				--Connect events.
				-- Close the application when an interface close
				-- request is recieved on `Current'. i.e. the cross is clicked.

				-- Call `user_initialization'.
			user_initialization
		end

feature -- Access

	configuration_menu_item, save_menu_item, save_as_menu_item, exit_menu_item: EV_MENU_ITEM
	recent_menu_item: EV_MENU
	test_list_box, options_box, keep_options_radio_box: EV_VERTICAL_BOX
	tests_list: EV_MULTI_COLUMN_LIST
	test_description_label: EV_LABEL
	test_load_button, tests_save_button, tests_run_button, include_directory_browse_button, 
	control_file_browse_button, ise_eiffel_var_browse_button, eweasel_directory_browse_button, 
	test_output_directory_browse_button, clear_output_button, save_output_button: EV_BUTTON
	platform_combo_box: EV_COMBO_BOX
	windows_combo_item, dotnet_combo_item, unix_combo_item: EV_LIST_ITEM
	include_directory_text_field, control_file_text_field, ise_eiffel_var_text_field, 
	eweasel_directory_text_field, test_output_directory_text_field: EV_TEXT_FIELD
	keep_check_button, keep_eifgen_check_buttons: EV_CHECK_BUTTON
	all_test_keep_radio, passed_test_keep_radio, failed_test_keep_radio: EV_RADIO_BUTTON
	output_text: EV_RICH_TEXT

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
	copyright: "[
			Copyright (c) 1984-2007, University of Southern California and contributors.
			All rights reserved.
			]"
	license:   "Your use of this work is governed under the terms of the GNU General Public License version 2"
	copying: "[
			This file is part of the EiffelWeasel Eiffel Regression Tester.

			The EiffelWeasel Eiffel Regression Tester is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License version 2 as published
			by the Free Software Foundation.

			The EiffelWeasel Eiffel Regression Tester is
			distributed in the hope that it will be useful, but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the GNU General Public License version 2 for more details.

			You should have received a copy of the GNU General Public
			License version 2 along with the EiffelWeasel Eiffel Regression Tester
			if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA
		]"


end -- class EWEASEL_WINDOW_IMP
