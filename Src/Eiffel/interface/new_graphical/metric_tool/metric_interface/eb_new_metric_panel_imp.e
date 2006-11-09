indexing
	description: "[
		Objects that represent an EV_TITLED_WINDOW.
		The original version of this class was generated by EiffelBuild.
		This class is the implementation of an EV_TITLED_WINDOW generated by EiffelBuild.
		You should not modify this code by hand, as it will be re-generated every time
		 modifications are made to the project.
		 	]"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EB_NEW_METRIC_PANEL_IMP

inherit
	EV_VERTICAL_BOX
		redefine
			initialize, is_in_default_state
		end

feature {NONE}-- Initialization

	initialize is
			-- Initialize `Current'.
		do
			Precursor {EV_VERTICAL_BOX}
			
				-- Create all widgets.
			create toolbar_area
			create new_metric_toolbar
			create new_metric_btn
			create send_current_to_new_btn
			create l_ev_tool_bar_separator_1
			create metric_definition_toolbar
			create remove_metric_btn
			create save_metric_btn
			create l_ev_tool_bar_separator_2
			create open_metric_file_btn
			create reload_btn
			create import_btn
			create main_area
			create metric_selector_panel
			create select_metric_lbl
			create metric_selector_area
			create l_ev_horizontal_box_1
			create l_ev_cell_1
			create l_ev_vertical_box_1
			create empty_lbl
			create metric_definition_area
			create no_metric_frame
			create no_metric_area
			create no_metric_lbl
			
				-- Build widget structure.
			extend (toolbar_area)
			toolbar_area.extend (new_metric_toolbar)
			new_metric_toolbar.extend (new_metric_btn)
			new_metric_toolbar.extend (send_current_to_new_btn)
			new_metric_toolbar.extend (l_ev_tool_bar_separator_1)
			toolbar_area.extend (metric_definition_toolbar)
			metric_definition_toolbar.extend (remove_metric_btn)
			metric_definition_toolbar.extend (save_metric_btn)
			metric_definition_toolbar.extend (l_ev_tool_bar_separator_2)
			metric_definition_toolbar.extend (open_metric_file_btn)
			metric_definition_toolbar.extend (reload_btn)
			metric_definition_toolbar.extend (import_btn)
			extend (main_area)
			main_area.extend (metric_selector_panel)
			metric_selector_panel.extend (select_metric_lbl)
			metric_selector_panel.extend (metric_selector_area)
			main_area.extend (l_ev_horizontal_box_1)
			l_ev_horizontal_box_1.extend (l_ev_cell_1)
			l_ev_horizontal_box_1.extend (l_ev_vertical_box_1)
			l_ev_vertical_box_1.extend (empty_lbl)
			l_ev_vertical_box_1.extend (metric_definition_area)
			metric_definition_area.extend (no_metric_frame)
			no_metric_frame.extend (no_metric_area)
			no_metric_area.extend (no_metric_lbl)
			
			create string_constant_set_procedures.make (10)
			create string_constant_retrieval_functions.make (10)
			create integer_constant_set_procedures.make (10)
			create integer_constant_retrieval_functions.make (10)
			create pixmap_constant_set_procedures.make (10)
			create pixmap_constant_retrieval_functions.make (10)
			create integer_interval_constant_retrieval_functions.make (10)
			create integer_interval_constant_set_procedures.make (10)
			create font_constant_set_procedures.make (10)
			create font_constant_retrieval_functions.make (10)
			create pixmap_constant_retrieval_functions.make (10)
			create color_constant_set_procedures.make (10)
			create color_constant_retrieval_functions.make (10)
			toolbar_area.set_padding (3)
			toolbar_area.disable_item_expand (new_metric_toolbar)
			toolbar_area.disable_item_expand (metric_definition_toolbar)
			metric_definition_toolbar.disable_vertical_button_style
			main_area.disable_item_expand (metric_selector_panel)
			main_area.enable_item_expand (l_ev_horizontal_box_1)
			metric_selector_panel.set_padding (3)
			metric_selector_panel.disable_item_expand (select_metric_lbl)
			select_metric_lbl.align_text_left
			metric_selector_area.set_minimum_width (250)
			l_ev_horizontal_box_1.disable_item_expand (l_ev_cell_1)
			l_ev_cell_1.set_minimum_width (10)
			l_ev_cell_1.set_minimum_height (5)
			l_ev_vertical_box_1.set_padding (3)
			l_ev_vertical_box_1.disable_item_expand (empty_lbl)
			no_metric_area.set_border_width (10)
			no_metric_area.disable_item_expand (no_metric_lbl)
			no_metric_lbl.set_text ("No metric is selected.")
			no_metric_lbl.align_text_left
			set_padding (5)
			set_border_width (5)
			disable_item_expand (toolbar_area)
			
			set_all_attributes_using_constants
			
				-- Connect events.
				-- Close the application when an interface close
				-- request is recieved on `Current'. i.e. the cross is clicked.

				-- Call `user_initialization'.
			user_initialization
		end


feature -- Access

	new_metric_toolbar, metric_definition_toolbar: EV_TOOL_BAR
	new_metric_btn, send_current_to_new_btn,
	remove_metric_btn, save_metric_btn, open_metric_file_btn, reload_btn, import_btn: EV_TOOL_BAR_BUTTON
	main_area: EV_HORIZONTAL_SPLIT_AREA
	toolbar_area,
	metric_definition_area: EV_HORIZONTAL_BOX
	metric_selector_panel, metric_selector_area, no_metric_area: EV_VERTICAL_BOX
	select_metric_lbl,
	empty_lbl, no_metric_lbl: EV_LABEL
	no_metric_frame: EV_FRAME

feature {NONE} -- Implementation

	l_ev_tool_bar_separator_1, l_ev_tool_bar_separator_2: EV_TOOL_BAR_SEPARATOR
	l_ev_cell_1: EV_CELL
	l_ev_horizontal_box_1: EV_HORIZONTAL_BOX
	l_ev_vertical_box_1: EV_VERTICAL_BOX

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
	
feature {NONE} -- Constant setting

	set_attributes_using_string_constants is
			-- Set all attributes relying on string constants to the current
			-- value of the associated constant.
		local
			s: STRING_GENERAL
		do
			from
				string_constant_set_procedures.start
			until
				string_constant_set_procedures.off
			loop
				string_constant_retrieval_functions.i_th (string_constant_set_procedures.index).call (Void)
				s := string_constant_retrieval_functions.i_th (string_constant_set_procedures.index).last_result
				string_constant_set_procedures.item.call ([s])
				string_constant_set_procedures.forth
			end
		end
		
	set_attributes_using_integer_constants is
			-- Set all attributes relying on integer constants to the current
			-- value of the associated constant.
		local
			i: INTEGER
			arg1, arg2: INTEGER
			int: INTEGER_INTERVAL
		do
			from
				integer_constant_set_procedures.start
			until
				integer_constant_set_procedures.off
			loop
				integer_constant_retrieval_functions.i_th (integer_constant_set_procedures.index).call (Void)
				i := integer_constant_retrieval_functions.i_th (integer_constant_set_procedures.index).last_result
				integer_constant_set_procedures.item.call ([i])
				integer_constant_set_procedures.forth
			end
			from
				integer_interval_constant_retrieval_functions.start
				integer_interval_constant_set_procedures.start
			until
				integer_interval_constant_retrieval_functions.off
			loop
				integer_interval_constant_retrieval_functions.item.call (Void)
				arg1 := integer_interval_constant_retrieval_functions.item.last_result
				integer_interval_constant_retrieval_functions.forth
				integer_interval_constant_retrieval_functions.item.call (Void)
				arg2 := integer_interval_constant_retrieval_functions.item.last_result
				create int.make (arg1, arg2)
				integer_interval_constant_set_procedures.item.call ([int])
				integer_interval_constant_retrieval_functions.forth
				integer_interval_constant_set_procedures.forth
			end
		end
		
	set_attributes_using_pixmap_constants is
			-- Set all attributes relying on pixmap constants to the current
			-- value of the associated constant.
		local
			p: EV_PIXMAP
		do
			from
				pixmap_constant_set_procedures.start
			until
				pixmap_constant_set_procedures.off
			loop
				pixmap_constant_retrieval_functions.i_th (pixmap_constant_set_procedures.index).call (Void)
				p := pixmap_constant_retrieval_functions.i_th (pixmap_constant_set_procedures.index).last_result
				pixmap_constant_set_procedures.item.call ([p])
				pixmap_constant_set_procedures.forth
			end
		end
		
	set_attributes_using_font_constants is
			-- Set all attributes relying on font constants to the current
			-- value of the associated constant.
		local
			f: EV_FONT
		do
			from
				font_constant_set_procedures.start
			until
				font_constant_set_procedures.off
			loop
				font_constant_retrieval_functions.i_th (font_constant_set_procedures.index).call (Void)
				f := font_constant_retrieval_functions.i_th (font_constant_set_procedures.index).last_result
				font_constant_set_procedures.item.call ([f])
				font_constant_set_procedures.forth
			end	
		end
		
	set_attributes_using_color_constants is
			-- Set all attributes relying on color constants to the current
			-- value of the associated constant.
		local
			c: EV_COLOR
		do
			from
				color_constant_set_procedures.start
			until
				color_constant_set_procedures.off
			loop
				color_constant_retrieval_functions.i_th (color_constant_set_procedures.index).call (Void)
				c := color_constant_retrieval_functions.i_th (color_constant_set_procedures.index).last_result
				color_constant_set_procedures.item.call ([c])
				color_constant_set_procedures.forth
			end
		end
		
	set_all_attributes_using_constants is
			-- Set all attributes relying on constants to the current
			-- calue of the associated constant.
		do
			set_attributes_using_string_constants
			set_attributes_using_integer_constants
			set_attributes_using_pixmap_constants
			set_attributes_using_font_constants
			set_attributes_using_color_constants
		end
					
	string_constant_set_procedures: ARRAYED_LIST [PROCEDURE [ANY, TUPLE [STRING_GENERAL]]]
	string_constant_retrieval_functions: ARRAYED_LIST [FUNCTION [ANY, TUPLE [], STRING_GENERAL]]
	integer_constant_set_procedures: ARRAYED_LIST [PROCEDURE [ANY, TUPLE [INTEGER]]]
	integer_constant_retrieval_functions: ARRAYED_LIST [FUNCTION [ANY, TUPLE [], INTEGER]]
	pixmap_constant_set_procedures: ARRAYED_LIST [PROCEDURE [ANY, TUPLE [EV_PIXMAP]]]
	pixmap_constant_retrieval_functions: ARRAYED_LIST [FUNCTION [ANY, TUPLE [], EV_PIXMAP]]
	integer_interval_constant_retrieval_functions: ARRAYED_LIST [FUNCTION [ANY, TUPLE [], INTEGER]]
	integer_interval_constant_set_procedures: ARRAYED_LIST [PROCEDURE [ANY, TUPLE [INTEGER_INTERVAL]]]
	font_constant_set_procedures: ARRAYED_LIST [PROCEDURE [ANY, TUPLE [EV_FONT]]]
	font_constant_retrieval_functions: ARRAYED_LIST [FUNCTION [ANY, TUPLE [], EV_FONT]]
	color_constant_set_procedures: ARRAYED_LIST [PROCEDURE [ANY, TUPLE [EV_COLOR]]]
	color_constant_retrieval_functions: ARRAYED_LIST [FUNCTION [ANY, TUPLE [], EV_COLOR]]
	
	integer_from_integer (an_integer: INTEGER): INTEGER is
			-- Return `an_integer', used for creation of
			-- an agent that returns a fixed integer value.
		do
			Result := an_integer
		end

end
