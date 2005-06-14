indexing
	description: "Objects that represent an EV_TITLED_WINDOW.%
		%The original version of this class was generated by EiffelBuild."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	DOC_BUILDER_WINDOW_IMP

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
		do
			Precursor {EV_TITLED_WINDOW}
			initialize_constants
			
				-- Create all widgets.
			create l_ev_menu_bar_1
			create file_menu
			create new_menu_item
			create l_ev_menu_separator_1
			create open_menu_item
			create open_project_menu_item
			create close_file_menu_item
			create l_ev_menu_separator_2
			create save_menu_item
			create l_ev_menu_separator_3
			create exit_menu_item
			create document_menu
			create cut_menu_item
			create copy_menu_item
			create paste_menu_item
			create l_ev_menu_separator_4
			create parser_menu_item
			create l_ev_menu_separator_5
			create search_menu_item
			create preferences_menu_item
			create view_menu
			create element_selector_menu
			create types_selector_menu
			create doc_selector_menu
			create attribute_selector_menu
			create sub_element_menu
			create project_menu
			create settings_menu_item
			create tool_menu
			create validator_menu_item
			create gen_menu_item
			create expression_menu_item
			create character_menu_item
			create shortcuts_menu_item
			create help_menu
			create about_menu_item
			create help_menu_item
			create l_ev_vertical_box_1
			create l_ev_frame_1
			create l_ev_horizontal_box_1
			create main_toolbar
			create toolbar_new
			create toolbar_open
			create toolbar_save
			create l_ev_tool_bar_separator_1
			create toolbar_cut
			create toolbar_copy
			create toolbar_paste
			create l_ev_tool_bar_separator_2
			create toolbar_xml_format
			create toolbar_code_format
			create l_ev_tool_bar_separator_3
			create toolbar_validate
			create toolbar_properties
			create toolbar_link_check
			create toolbar_html_generator
			create l_ev_tool_bar_separator_4
			create l_ev_label_1
			create output_combo
			create l_ev_cell_1
			create l_ev_vertical_split_area_1
			create l_ev_horizontal_split_area_1
			create left_tool
			create l_ev_vertical_box_2
			create main_tool
			create l_ev_horizontal_box_2
			create l_ev_label_2
			create l_ev_cell_2
			create l_ev_cell_3
			create l_ev_tool_bar_5
			create main_close
			create l_ev_vertical_split_area_2
			create selector
			create documentation_area
			create document_selector
			create toc_container
			create l_ev_vertical_split_area_3
			create l_ev_vertical_box_3
			create toc_area
			create toc_vertical_toolbar
			create toc_new_button
			create toc_open_button
			create toc_save_button
			create l_ev_cell_4
			create toc_new_heading
			create toc_new_page
			create toc_remove_topic
			create toc_move_up_button
			create toc_move_down_button
			create l_ev_cell_5
			create toc_list_button
			create toc_merge_button
			create toc_sort_button
			create l_ev_cell_6
			create document_toc
			create toc_status_bar
			create l_ev_frame_2
			create toc_status_report_label
			create node_properties_tool
			create node_properties_area
			create l_ev_frame_3
			create l_ev_horizontal_box_3
			create l_ev_label_3
			create l_ev_cell_7
			create l_ev_cell_8
			create l_ev_tool_bar_6
			create node_properties_close
			create node_properties_list
			create element_area
			create element_split_area
			create element_selector
			create attribute_list_tool
			create l_ev_vertical_box_4
			create l_ev_frame_4
			create l_ev_horizontal_box_4
			create l_ev_label_4
			create l_ev_cell_9
			create l_ev_cell_10
			create l_ev_tool_bar_7
			create attribute_list_close
			create attribute_list
			create type_area
			create type_selector
			create sub_element_tool
			create l_ev_vertical_box_5
			create l_ev_frame_5
			create l_ev_horizontal_box_5
			create title_label
			create l_ev_cell_11
			create l_ev_cell_12
			create l_ev_tool_bar_8
			create sub_element_close
			create sub_elements_list
			create editor_tool
			create l_ev_vertical_box_6
			create l_ev_vertical_split_area_4
			create document_area
			create editor_container
			create editor_notebook
			create document_status_bar
			create l_ev_frame_6
			create search_control_container
			create report_label
			create l_ev_frame_7
			create l_ev_horizontal_box_6
			create l_ev_horizontal_box_7
			create line_number
			create l_ev_horizontal_box_8
			create cursor_text_position
			create l_ev_horizontal_box_9
			create cursor_line_pos
			create browser_container
			
				-- Build_widget_structure.
			set_menu_bar (l_ev_menu_bar_1)
			l_ev_menu_bar_1.extend (file_menu)
			file_menu.extend (new_menu_item)
			file_menu.extend (l_ev_menu_separator_1)
			file_menu.extend (open_menu_item)
			file_menu.extend (open_project_menu_item)
			file_menu.extend (close_file_menu_item)
			file_menu.extend (l_ev_menu_separator_2)
			file_menu.extend (save_menu_item)
			file_menu.extend (l_ev_menu_separator_3)
			file_menu.extend (exit_menu_item)
			l_ev_menu_bar_1.extend (document_menu)
			document_menu.extend (cut_menu_item)
			document_menu.extend (copy_menu_item)
			document_menu.extend (paste_menu_item)
			document_menu.extend (l_ev_menu_separator_4)
			document_menu.extend (parser_menu_item)
			document_menu.extend (l_ev_menu_separator_5)
			document_menu.extend (search_menu_item)
			document_menu.extend (preferences_menu_item)
			l_ev_menu_bar_1.extend (view_menu)
			view_menu.extend (element_selector_menu)
			view_menu.extend (types_selector_menu)
			view_menu.extend (doc_selector_menu)
			view_menu.extend (attribute_selector_menu)
			view_menu.extend (sub_element_menu)
			l_ev_menu_bar_1.extend (project_menu)
			project_menu.extend (settings_menu_item)
			l_ev_menu_bar_1.extend (tool_menu)
			tool_menu.extend (validator_menu_item)
			tool_menu.extend (gen_menu_item)
			tool_menu.extend (expression_menu_item)
			tool_menu.extend (character_menu_item)
			tool_menu.extend (shortcuts_menu_item)
			l_ev_menu_bar_1.extend (help_menu)
			help_menu.extend (about_menu_item)
			help_menu.extend (help_menu_item)
			extend (l_ev_vertical_box_1)
			l_ev_vertical_box_1.extend (l_ev_frame_1)
			l_ev_frame_1.extend (l_ev_horizontal_box_1)
			l_ev_horizontal_box_1.extend (main_toolbar)
			main_toolbar.extend (toolbar_new)
			main_toolbar.extend (toolbar_open)
			main_toolbar.extend (toolbar_save)
			main_toolbar.extend (l_ev_tool_bar_separator_1)
			main_toolbar.extend (toolbar_cut)
			main_toolbar.extend (toolbar_copy)
			main_toolbar.extend (toolbar_paste)
			main_toolbar.extend (l_ev_tool_bar_separator_2)
			main_toolbar.extend (toolbar_xml_format)
			main_toolbar.extend (toolbar_code_format)
			main_toolbar.extend (l_ev_tool_bar_separator_3)
			main_toolbar.extend (toolbar_validate)
			main_toolbar.extend (toolbar_properties)
			main_toolbar.extend (toolbar_link_check)
			main_toolbar.extend (toolbar_html_generator)
			main_toolbar.extend (l_ev_tool_bar_separator_4)
			l_ev_horizontal_box_1.extend (l_ev_label_1)
			l_ev_horizontal_box_1.extend (output_combo)
			l_ev_horizontal_box_1.extend (l_ev_cell_1)
			l_ev_vertical_box_1.extend (l_ev_vertical_split_area_1)
			l_ev_vertical_split_area_1.extend (l_ev_horizontal_split_area_1)
			l_ev_horizontal_split_area_1.extend (left_tool)
			left_tool.extend (l_ev_vertical_box_2)
			l_ev_vertical_box_2.extend (main_tool)
			main_tool.extend (l_ev_horizontal_box_2)
			l_ev_horizontal_box_2.extend (l_ev_label_2)
			l_ev_horizontal_box_2.extend (l_ev_cell_2)
			l_ev_horizontal_box_2.extend (l_ev_cell_3)
			l_ev_horizontal_box_2.extend (l_ev_tool_bar_5)
			l_ev_tool_bar_5.extend (main_close)
			l_ev_vertical_box_2.extend (l_ev_vertical_split_area_2)
			l_ev_vertical_split_area_2.extend (selector)
			selector.extend (documentation_area)
			documentation_area.extend (document_selector)
			selector.extend (toc_container)
			toc_container.extend (l_ev_vertical_split_area_3)
			l_ev_vertical_split_area_3.extend (l_ev_vertical_box_3)
			l_ev_vertical_box_3.extend (toc_area)
			toc_area.extend (toc_vertical_toolbar)
			toc_vertical_toolbar.extend (toc_new_button)
			toc_vertical_toolbar.extend (toc_open_button)
			toc_vertical_toolbar.extend (toc_save_button)
			toc_vertical_toolbar.extend (l_ev_cell_4)
			toc_vertical_toolbar.extend (toc_new_heading)
			toc_vertical_toolbar.extend (toc_new_page)
			toc_vertical_toolbar.extend (toc_remove_topic)
			toc_vertical_toolbar.extend (toc_move_up_button)
			toc_vertical_toolbar.extend (toc_move_down_button)
			toc_vertical_toolbar.extend (l_ev_cell_5)
			toc_vertical_toolbar.extend (toc_list_button)
			toc_vertical_toolbar.extend (toc_merge_button)
			toc_vertical_toolbar.extend (toc_sort_button)
			toc_vertical_toolbar.extend (l_ev_cell_6)
			toc_area.extend (document_toc)
			l_ev_vertical_box_3.extend (toc_status_bar)
			toc_status_bar.extend (l_ev_frame_2)
			l_ev_frame_2.extend (toc_status_report_label)
			l_ev_vertical_split_area_3.extend (node_properties_tool)
			node_properties_tool.extend (node_properties_area)
			node_properties_area.extend (l_ev_frame_3)
			l_ev_frame_3.extend (l_ev_horizontal_box_3)
			l_ev_horizontal_box_3.extend (l_ev_label_3)
			l_ev_horizontal_box_3.extend (l_ev_cell_7)
			l_ev_horizontal_box_3.extend (l_ev_cell_8)
			l_ev_horizontal_box_3.extend (l_ev_tool_bar_6)
			l_ev_tool_bar_6.extend (node_properties_close)
			node_properties_area.extend (node_properties_list)
			selector.extend (element_area)
			element_area.extend (element_split_area)
			element_split_area.extend (element_selector)
			element_split_area.extend (attribute_list_tool)
			attribute_list_tool.extend (l_ev_vertical_box_4)
			l_ev_vertical_box_4.extend (l_ev_frame_4)
			l_ev_frame_4.extend (l_ev_horizontal_box_4)
			l_ev_horizontal_box_4.extend (l_ev_label_4)
			l_ev_horizontal_box_4.extend (l_ev_cell_9)
			l_ev_horizontal_box_4.extend (l_ev_cell_10)
			l_ev_horizontal_box_4.extend (l_ev_tool_bar_7)
			l_ev_tool_bar_7.extend (attribute_list_close)
			l_ev_vertical_box_4.extend (attribute_list)
			selector.extend (type_area)
			type_area.extend (type_selector)
			l_ev_vertical_split_area_2.extend (sub_element_tool)
			sub_element_tool.extend (l_ev_vertical_box_5)
			l_ev_vertical_box_5.extend (l_ev_frame_5)
			l_ev_frame_5.extend (l_ev_horizontal_box_5)
			l_ev_horizontal_box_5.extend (title_label)
			l_ev_horizontal_box_5.extend (l_ev_cell_11)
			l_ev_horizontal_box_5.extend (l_ev_cell_12)
			l_ev_horizontal_box_5.extend (l_ev_tool_bar_8)
			l_ev_tool_bar_8.extend (sub_element_close)
			l_ev_vertical_box_5.extend (sub_elements_list)
			l_ev_horizontal_split_area_1.extend (editor_tool)
			editor_tool.extend (l_ev_vertical_box_6)
			l_ev_vertical_box_6.extend (l_ev_vertical_split_area_4)
			l_ev_vertical_split_area_4.extend (document_area)
			document_area.extend (editor_container)
			editor_container.extend (editor_notebook)
			document_area.extend (document_status_bar)
			document_status_bar.extend (l_ev_frame_6)
			l_ev_frame_6.extend (search_control_container)
			search_control_container.extend (report_label)
			document_status_bar.extend (l_ev_frame_7)
			l_ev_frame_7.extend (l_ev_horizontal_box_6)
			l_ev_horizontal_box_6.extend (l_ev_horizontal_box_7)
			l_ev_horizontal_box_7.extend (line_number)
			l_ev_horizontal_box_6.extend (l_ev_horizontal_box_8)
			l_ev_horizontal_box_8.extend (cursor_text_position)
			l_ev_horizontal_box_6.extend (l_ev_horizontal_box_9)
			l_ev_horizontal_box_9.extend (cursor_line_pos)
			l_ev_vertical_split_area_4.extend (browser_container)
			
			file_menu.set_text ("File")
			new_menu_item.set_text ("New..")
			open_menu_item.disable_sensitive
			open_menu_item.set_text ("Open File..")
			open_menu_item.set_pixmap (icon_open_file_ico)
			open_project_menu_item.set_text ("Open Project..")
			close_file_menu_item.disable_sensitive
			close_file_menu_item.set_text ("Close")
			save_menu_item.disable_sensitive
			save_menu_item.set_text ("Save")
			save_menu_item.set_pixmap (icon_save_ico)
			exit_menu_item.set_text ("Exit")
			exit_menu_item.set_pixmap (icon_close_color_ico)
			document_menu.set_text ("Edit")
			cut_menu_item.disable_sensitive
			cut_menu_item.set_text ("Cut")
			copy_menu_item.disable_sensitive
			copy_menu_item.set_text ("Copy")
			paste_menu_item.disable_sensitive
			paste_menu_item.set_text ("Paste")
			parser_menu_item.set_text ("Parser...")
			search_menu_item.set_text ("Search...")
			preferences_menu_item.set_text ("Preferences...")
			view_menu.set_text ("View")
			element_selector_menu.enable_select
			element_selector_menu.set_text ("Schema elements")
			types_selector_menu.enable_select
			types_selector_menu.set_text ("Schema types")
			doc_selector_menu.enable_select
			doc_selector_menu.set_text ("Document Selector")
			attribute_selector_menu.enable_select
			attribute_selector_menu.set_text ("Element/Type attributes")
			sub_element_menu.enable_select
			sub_element_menu.set_text ("Sub element selector")
			project_menu.set_text ("Project")
			settings_menu_item.set_text ("Settings..")
			tool_menu.set_text ("Tools")
			validator_menu_item.set_text ("Validator..")
			gen_menu_item.set_text ("Generator..")
			expression_menu_item.set_text ("Expression Builder..")
			character_menu_item.set_text ("Character Codes..")
			shortcuts_menu_item.set_text ("Shortcuts..")
			help_menu.set_text ("Help")
			about_menu_item.set_text ("About...")
			help_menu_item.set_text ("Contents")
			l_ev_vertical_box_1.set_padding_width (2)
			l_ev_vertical_box_1.disable_item_expand (l_ev_frame_1)
			l_ev_frame_1.set_minimum_height (30)
			l_ev_horizontal_box_1.disable_item_expand (main_toolbar)
			l_ev_horizontal_box_1.disable_item_expand (l_ev_label_1)
			l_ev_horizontal_box_1.disable_item_expand (output_combo)
			main_toolbar.set_minimum_height (22)
			toolbar_new.disable_sensitive
			toolbar_new.set_tooltip ("New File")
			toolbar_new.set_pixmap (icon_new_doc_ico)
			toolbar_open.disable_sensitive
			toolbar_open.set_tooltip ("Open File")
			toolbar_open.set_pixmap (icon_open_file_ico)
			toolbar_save.disable_sensitive
			toolbar_save.set_tooltip ("Save (Ctrl+S)")
			toolbar_save.set_pixmap (icon_save_ico)
			toolbar_cut.disable_sensitive
			toolbar_cut.set_tooltip ("Cut (Ctrl+X)")
			toolbar_cut.set_pixmap (icon_cut_color_ico)
			toolbar_copy.disable_sensitive
			toolbar_copy.set_tooltip ("Copy (Ctrl+C)")
			toolbar_copy.set_pixmap (icon_copy_color_ico)
			toolbar_paste.disable_sensitive
			toolbar_paste.set_tooltip ("Paste (Ctrl+V)")
			toolbar_paste.set_pixmap (icon_paste_ico)
			toolbar_xml_format.disable_sensitive
			toolbar_xml_format.set_tooltip ("Pretty XML")
			toolbar_xml_format.set_pixmap (icon_format_text_color_ico)
			toolbar_code_format.disable_sensitive
			toolbar_code_format.set_tooltip ("Pretty code format")
			toolbar_code_format.set_pixmap (icon_code_format_ico)
			toolbar_validate.disable_sensitive
			toolbar_validate.set_tooltip ("Validate to XML/Schema (Ctrl+D)")
			toolbar_validate.set_pixmap (icon_validate_ico)
			toolbar_properties.disable_sensitive
			toolbar_properties.set_tooltip ("Document Properties")
			toolbar_properties.set_pixmap (icon_info_ico)
			toolbar_link_check.disable_sensitive
			toolbar_link_check.set_tooltip ("Validate Document Links")
			toolbar_link_check.set_pixmap (icon_link_check_ico_ico)
			toolbar_html_generator.disable_sensitive
			toolbar_html_generator.set_tooltip ("Refresh Output View (Ctrl+R)")
			toolbar_html_generator.set_pixmap (icon_ie_ico)
			l_ev_label_1.set_text ("Filter ")
			l_ev_label_1.align_text_left
			output_combo.set_tooltip ("Output filter transformation")
			output_combo.set_minimum_width (250)
			left_tool.set_style (1)
			l_ev_vertical_box_2.disable_item_expand (main_tool)
			main_tool.set_style (2)
			l_ev_horizontal_box_2.set_padding_width (5)
			l_ev_horizontal_box_2.set_border_width (2)
			l_ev_horizontal_box_2.disable_item_expand (l_ev_tool_bar_5)
			l_ev_label_2.set_text (" Browser")
			l_ev_label_2.align_text_left
			main_close.set_pixmap (icon_close_color_ico)
			selector.set_minimum_width (200)
			selector.set_minimum_height (400)
			selector.set_item_text (documentation_area, "Project Files")
			selector.set_item_text (toc_container, "TOC View")
			selector.set_item_text (element_area, "Schema Elements")
			selector.set_item_text (type_area, "Types")
			documentation_area.set_padding_width (5)
			documentation_area.set_border_width (2)
			toc_container.set_minimum_height (400)
			l_ev_vertical_split_area_3.set_minimum_height (400)
			l_ev_vertical_box_3.set_minimum_height (310)
			l_ev_vertical_box_3.disable_item_expand (toc_status_bar)
			toc_area.set_minimum_height (0)
			toc_area.set_padding_width (5)
			toc_area.set_border_width (2)
			toc_area.disable_item_expand (toc_vertical_toolbar)
			toc_vertical_toolbar.set_minimum_height (0)
			toc_vertical_toolbar.set_border_width (2)
			toc_vertical_toolbar.disable_item_expand (toc_new_button)
			toc_vertical_toolbar.disable_item_expand (toc_open_button)
			toc_vertical_toolbar.disable_item_expand (toc_save_button)
			toc_vertical_toolbar.disable_item_expand (l_ev_cell_4)
			toc_vertical_toolbar.disable_item_expand (toc_new_heading)
			toc_vertical_toolbar.disable_item_expand (toc_new_page)
			toc_vertical_toolbar.disable_item_expand (toc_remove_topic)
			toc_vertical_toolbar.disable_item_expand (toc_move_up_button)
			toc_vertical_toolbar.disable_item_expand (toc_move_down_button)
			toc_vertical_toolbar.disable_item_expand (l_ev_cell_5)
			toc_vertical_toolbar.disable_item_expand (toc_list_button)
			toc_vertical_toolbar.disable_item_expand (toc_merge_button)
			toc_vertical_toolbar.disable_item_expand (toc_sort_button)
			toc_new_button.set_tooltip ("New Table of Contents")
			toc_new_button.set_pixmap (icon_new_doc_ico)
			toc_open_button.set_tooltip ("Open Table of Contents")
			toc_open_button.set_pixmap (icon_open_file_ico)
			toc_save_button.set_tooltip ("Save")
			toc_save_button.set_minimum_width (24)
			toc_save_button.set_minimum_height (24)
			toc_save_button.set_pixmap (icon_save_ico)
			l_ev_cell_4.set_minimum_height (20)
			toc_new_heading.set_tooltip ("New Topic Heading")
			toc_new_heading.set_pixmap (icon_toc_folder_open_ico)
			toc_new_page.set_tooltip ("New Topic File")
			toc_new_page.set_pixmap (icon_format_text_color_ico)
			toc_remove_topic.set_tooltip ("Delete Topic")
			toc_remove_topic.set_pixmap (icon_file_close_ico)
			toc_move_up_button.set_pixmap (uparrow_png)
			toc_move_down_button.set_pixmap (downarrow_png)
			l_ev_cell_5.set_minimum_height (20)
			toc_list_button.set_tooltip ("Loaded Table of Contents")
			toc_list_button.set_pixmap (icon_down_triangle_ico)
			toc_merge_button.set_tooltip ("Merge Tables of Contents")
			toc_merge_button.set_pixmap (icon_merge_ico)
			toc_sort_button.disable_sensitive
			toc_sort_button.set_tooltip ("Sort/Filter Table of Contents")
			toc_sort_button.set_pixmap (icon_sorter_ico)
			toc_status_bar.set_minimum_height (25)
			toc_status_bar.set_padding_width (2)
			toc_status_bar.set_border_width (2)
			l_ev_frame_2.set_style (1)
			toc_status_report_label.set_minimum_width (250)
			toc_status_report_label.set_minimum_height (13)
			toc_status_report_label.align_text_left
			node_properties_tool.set_minimum_height (40)
			node_properties_tool.set_style (1)
			node_properties_area.set_minimum_height (0)
			node_properties_area.disable_item_expand (l_ev_frame_3)
			l_ev_frame_3.set_style (2)
			l_ev_horizontal_box_3.set_minimum_height (0)
			l_ev_horizontal_box_3.set_padding_width (5)
			l_ev_horizontal_box_3.set_border_width (2)
			l_ev_horizontal_box_3.disable_item_expand (l_ev_tool_bar_6)
			l_ev_label_3.set_text (" Properties")
			l_ev_label_3.align_text_left
			node_properties_close.set_pixmap (icon_close_color_ico)
			node_properties_list.set_minimum_height (0)
			element_area.set_minimum_height (20)
			element_area.set_padding_width (5)
			element_area.set_border_width (2)
			element_split_area.set_minimum_height (0)
			element_selector.set_minimum_height (200)
			attribute_list_tool.set_minimum_height (0)
			attribute_list_tool.set_style (1)
			l_ev_vertical_box_4.set_minimum_height (0)
			l_ev_vertical_box_4.disable_item_expand (l_ev_frame_4)
			l_ev_frame_4.set_minimum_height (0)
			l_ev_frame_4.set_style (2)
			l_ev_horizontal_box_4.set_minimum_height (0)
			l_ev_horizontal_box_4.disable_item_expand (l_ev_tool_bar_7)
			l_ev_label_4.set_text (" Attributes")
			l_ev_label_4.align_text_left
			attribute_list.set_minimum_height (0)
			type_area.set_padding_width (5)
			type_area.set_border_width (2)
			sub_element_tool.set_style (1)
			l_ev_vertical_box_5.disable_item_expand (l_ev_frame_5)
			l_ev_frame_5.set_style (2)
			l_ev_horizontal_box_5.set_padding_width (5)
			l_ev_horizontal_box_5.set_border_width (2)
			l_ev_horizontal_box_5.disable_item_expand (l_ev_tool_bar_8)
			title_label.set_text (" Sub Elements")
			title_label.align_text_left
			sub_element_close.set_pixmap (icon_close_color_ico)
			editor_tool.set_style (1)
			document_area.disable_item_expand (document_status_bar)
			editor_notebook.set_minimum_height (300)
			document_status_bar.set_padding_width (2)
			document_status_bar.set_border_width (2)
			document_status_bar.disable_item_expand (l_ev_frame_7)
			l_ev_frame_6.set_style (1)
			l_ev_frame_7.set_minimum_width (200)
			l_ev_frame_7.set_style (1)
			line_number.set_minimum_width (30)
			cursor_text_position.set_minimum_width (30)
			cursor_line_pos.set_minimum_width (30)
			cursor_line_pos.set_minimum_height (13)
			set_minimum_width (1024)
			set_minimum_height (768)
			set_title ("Document Builder")
			
				--Connect events.
				-- Close the application when an interface close
				-- request is recieved on `Current'. i.e. the cross is clicked.

				-- Call `user_initialization'.
			user_initialization
		end

feature -- Access

	element_selector_menu: EV_CHECK_MENU_ITEM
	types_selector_menu: EV_CHECK_MENU_ITEM
	doc_selector_menu: EV_CHECK_MENU_ITEM
	attribute_selector_menu: EV_CHECK_MENU_ITEM
	sub_element_menu: EV_CHECK_MENU_ITEM
	document_selector: EV_TREE
	document_toc: EV_TREE
	element_selector: EV_TREE
	type_selector: EV_TREE
	l_ev_menu_separator_1: EV_MENU_SEPARATOR
	l_ev_menu_separator_2: EV_MENU_SEPARATOR
	l_ev_menu_separator_3: EV_MENU_SEPARATOR
	l_ev_menu_separator_4: EV_MENU_SEPARATOR
	l_ev_menu_separator_5: EV_MENU_SEPARATOR
	l_ev_tool_bar_separator_1: EV_TOOL_BAR_SEPARATOR
	l_ev_tool_bar_separator_2: EV_TOOL_BAR_SEPARATOR
	l_ev_tool_bar_separator_3: EV_TOOL_BAR_SEPARATOR
	l_ev_tool_bar_separator_4: EV_TOOL_BAR_SEPARATOR
	node_properties_list: EV_MULTI_COLUMN_LIST
	attribute_list: EV_MULTI_COLUMN_LIST
	file_menu: EV_MENU
	document_menu: EV_MENU
	view_menu: EV_MENU
	project_menu: EV_MENU
	tool_menu: EV_MENU
	help_menu: EV_MENU
	output_combo: EV_COMBO_BOX
	toc_new_button: EV_BUTTON
	toc_open_button: EV_BUTTON
	toc_save_button: EV_BUTTON
	toc_new_heading: EV_BUTTON
	toc_new_page: EV_BUTTON
	toc_remove_topic: EV_BUTTON
	toc_move_up_button: EV_BUTTON
	toc_move_down_button: EV_BUTTON
	toc_list_button: EV_BUTTON
	toc_merge_button: EV_BUTTON
	toc_sort_button: EV_BUTTON
	main_toolbar: EV_TOOL_BAR
	l_ev_tool_bar_5: EV_TOOL_BAR
	l_ev_tool_bar_6: EV_TOOL_BAR
	l_ev_tool_bar_7: EV_TOOL_BAR
	l_ev_tool_bar_8: EV_TOOL_BAR
	sub_elements_list: EV_LIST
	toolbar_new: EV_TOOL_BAR_BUTTON
	toolbar_open: EV_TOOL_BAR_BUTTON
	toolbar_save: EV_TOOL_BAR_BUTTON
	toolbar_cut: EV_TOOL_BAR_BUTTON
	toolbar_copy: EV_TOOL_BAR_BUTTON
	toolbar_paste: EV_TOOL_BAR_BUTTON
	toolbar_xml_format: EV_TOOL_BAR_BUTTON
	toolbar_code_format: EV_TOOL_BAR_BUTTON
	toolbar_validate: EV_TOOL_BAR_BUTTON
	toolbar_properties: EV_TOOL_BAR_BUTTON
	toolbar_link_check: EV_TOOL_BAR_BUTTON
	toolbar_html_generator: EV_TOOL_BAR_BUTTON
	main_close: EV_TOOL_BAR_BUTTON
	node_properties_close: EV_TOOL_BAR_BUTTON
	attribute_list_close: EV_TOOL_BAR_BUTTON
	sub_element_close: EV_TOOL_BAR_BUTTON
	l_ev_cell_1: EV_CELL
	l_ev_cell_2: EV_CELL
	l_ev_cell_3: EV_CELL
	l_ev_cell_4: EV_CELL
	l_ev_cell_5: EV_CELL
	l_ev_cell_6: EV_CELL
	l_ev_cell_7: EV_CELL
	l_ev_cell_8: EV_CELL
	l_ev_cell_9: EV_CELL
	l_ev_cell_10: EV_CELL
	l_ev_cell_11: EV_CELL
	l_ev_cell_12: EV_CELL
	l_ev_horizontal_split_area_1: EV_HORIZONTAL_SPLIT_AREA
	l_ev_vertical_split_area_1: EV_VERTICAL_SPLIT_AREA
	l_ev_vertical_split_area_2: EV_VERTICAL_SPLIT_AREA
	l_ev_vertical_split_area_3: EV_VERTICAL_SPLIT_AREA
	element_split_area: EV_VERTICAL_SPLIT_AREA
	l_ev_vertical_split_area_4: EV_VERTICAL_SPLIT_AREA
	l_ev_horizontal_box_1: EV_HORIZONTAL_BOX
	l_ev_horizontal_box_2: EV_HORIZONTAL_BOX
	toc_area: EV_HORIZONTAL_BOX
	toc_status_bar: EV_HORIZONTAL_BOX
	l_ev_horizontal_box_3: EV_HORIZONTAL_BOX
	l_ev_horizontal_box_4: EV_HORIZONTAL_BOX
	l_ev_horizontal_box_5: EV_HORIZONTAL_BOX
	document_status_bar: EV_HORIZONTAL_BOX
	search_control_container: EV_HORIZONTAL_BOX
	l_ev_horizontal_box_6: EV_HORIZONTAL_BOX
	l_ev_horizontal_box_7: EV_HORIZONTAL_BOX
	l_ev_horizontal_box_8: EV_HORIZONTAL_BOX
	l_ev_horizontal_box_9: EV_HORIZONTAL_BOX
	l_ev_vertical_box_1: EV_VERTICAL_BOX
	l_ev_vertical_box_2: EV_VERTICAL_BOX
	documentation_area: EV_VERTICAL_BOX
	toc_container: EV_VERTICAL_BOX
	l_ev_vertical_box_3: EV_VERTICAL_BOX
	toc_vertical_toolbar: EV_VERTICAL_BOX
	node_properties_area: EV_VERTICAL_BOX
	element_area: EV_VERTICAL_BOX
	l_ev_vertical_box_4: EV_VERTICAL_BOX
	type_area: EV_VERTICAL_BOX
	l_ev_vertical_box_5: EV_VERTICAL_BOX
	l_ev_vertical_box_6: EV_VERTICAL_BOX
	document_area: EV_VERTICAL_BOX
	editor_container: EV_VERTICAL_BOX
	browser_container: EV_VERTICAL_BOX
	selector: EV_NOTEBOOK
	editor_notebook: EV_NOTEBOOK
	l_ev_label_1: EV_LABEL
	l_ev_label_2: EV_LABEL
	toc_status_report_label: EV_LABEL
	l_ev_label_3: EV_LABEL
	l_ev_label_4: EV_LABEL
	title_label: EV_LABEL
	report_label: EV_LABEL
	line_number: EV_LABEL
	cursor_text_position: EV_LABEL
	cursor_line_pos: EV_LABEL
	new_menu_item: EV_MENU_ITEM
	open_menu_item: EV_MENU_ITEM
	open_project_menu_item: EV_MENU_ITEM
	close_file_menu_item: EV_MENU_ITEM
	save_menu_item: EV_MENU_ITEM
	exit_menu_item: EV_MENU_ITEM
	cut_menu_item: EV_MENU_ITEM
	copy_menu_item: EV_MENU_ITEM
	paste_menu_item: EV_MENU_ITEM
	parser_menu_item: EV_MENU_ITEM
	search_menu_item: EV_MENU_ITEM
	preferences_menu_item: EV_MENU_ITEM
	settings_menu_item: EV_MENU_ITEM
	validator_menu_item: EV_MENU_ITEM
	gen_menu_item: EV_MENU_ITEM
	expression_menu_item: EV_MENU_ITEM
	character_menu_item: EV_MENU_ITEM
	shortcuts_menu_item: EV_MENU_ITEM
	about_menu_item: EV_MENU_ITEM
	help_menu_item: EV_MENU_ITEM
	l_ev_menu_bar_1: EV_MENU_BAR
	l_ev_frame_1: EV_FRAME
	left_tool: EV_FRAME
	main_tool: EV_FRAME
	l_ev_frame_2: EV_FRAME
	node_properties_tool: EV_FRAME
	l_ev_frame_3: EV_FRAME
	attribute_list_tool: EV_FRAME
	l_ev_frame_4: EV_FRAME
	sub_element_tool: EV_FRAME
	l_ev_frame_5: EV_FRAME
	editor_tool: EV_FRAME
	l_ev_frame_6: EV_FRAME
	l_ev_frame_7: EV_FRAME

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
	
end -- class DOC_BUILDER_WINDOW_IMP
