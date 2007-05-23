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
	TOOL_BAR_CONTROL_PANEL_IMP

inherit
	EV_VERTICAL_BOX
		redefine
			initialize, is_in_default_state
		end
			
	CONSTANTS
		undefine
			is_equal, default_create, copy
		end

feature {NONE}-- Initialization

	initialize is
			-- Initialize `Current'.
		do
			Precursor {EV_VERTICAL_BOX}
			initialize_constants
			
				-- Create all widgets.
			create l_ev_horizontal_box_1
			create l_ev_frame_1
			create toolbar_list
			create l_ev_vertical_box_1
			create l_ev_frame_2
			create l_ev_vertical_box_2
			create create_toolbar_button
			create l_ev_horizontal_box_2
			create l_ev_vertical_box_3
			create add_button_button
			create add_toggle_button
			create add_radio_button
			create add_menu_button_button
			create l_ev_vertical_box_4
			create add_build_in_widget_button
			create add_resizable_button
			create add_separator_button
			create l_ev_frame_3
			create l_ev_vertical_box_5
			create l_ev_horizontal_box_3
			create show_button
			create hide_button
			create close_button
			create l_ev_horizontal_box_4
			create set_title_button
			create l_ev_cell_1
			create title_field
			create l_ev_horizontal_box_5
			create set_top_button
			create l_ev_cell_2
			create up_radio_button
			create down_radio_button
			create left_radio_button
			create right_radio_button
			
				-- Build widget structure.
			extend (l_ev_horizontal_box_1)
			l_ev_horizontal_box_1.extend (l_ev_frame_1)
			l_ev_frame_1.extend (toolbar_list)
			l_ev_horizontal_box_1.extend (l_ev_vertical_box_1)
			l_ev_vertical_box_1.extend (l_ev_frame_2)
			l_ev_frame_2.extend (l_ev_vertical_box_2)
			l_ev_vertical_box_2.extend (create_toolbar_button)
			l_ev_vertical_box_2.extend (l_ev_horizontal_box_2)
			l_ev_horizontal_box_2.extend (l_ev_vertical_box_3)
			l_ev_vertical_box_3.extend (add_button_button)
			l_ev_vertical_box_3.extend (add_toggle_button)
			l_ev_vertical_box_3.extend (add_radio_button)
			l_ev_vertical_box_3.extend (add_menu_button_button)
			l_ev_horizontal_box_2.extend (l_ev_vertical_box_4)
			l_ev_vertical_box_4.extend (add_build_in_widget_button)
			l_ev_vertical_box_4.extend (add_resizable_button)
			l_ev_vertical_box_4.extend (add_separator_button)
			l_ev_vertical_box_1.extend (l_ev_frame_3)
			l_ev_frame_3.extend (l_ev_vertical_box_5)
			l_ev_vertical_box_5.extend (l_ev_horizontal_box_3)
			l_ev_horizontal_box_3.extend (show_button)
			l_ev_horizontal_box_3.extend (hide_button)
			l_ev_horizontal_box_3.extend (close_button)
			l_ev_vertical_box_5.extend (l_ev_horizontal_box_4)
			l_ev_horizontal_box_4.extend (set_title_button)
			l_ev_horizontal_box_4.extend (l_ev_cell_1)
			l_ev_horizontal_box_4.extend (title_field)
			l_ev_vertical_box_5.extend (l_ev_horizontal_box_5)
			l_ev_horizontal_box_5.extend (set_top_button)
			l_ev_horizontal_box_5.extend (l_ev_cell_2)
			l_ev_horizontal_box_5.extend (up_radio_button)
			l_ev_horizontal_box_5.extend (down_radio_button)
			l_ev_horizontal_box_5.extend (left_radio_button)
			l_ev_horizontal_box_5.extend (right_radio_button)
			
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
			l_ev_frame_1.set_text ("Existing Tool Bars")
			l_ev_vertical_box_1.disable_item_expand (l_ev_frame_2)
			l_ev_vertical_box_1.disable_item_expand (l_ev_frame_3)
			l_ev_frame_2.set_text ("Creation")
			l_ev_vertical_box_2.disable_item_expand (create_toolbar_button)
			l_ev_vertical_box_2.disable_item_expand (l_ev_horizontal_box_2)
			create_toolbar_button.set_text ("Create Tool Bar")
			l_ev_horizontal_box_2.disable_item_expand (l_ev_vertical_box_3)
			l_ev_horizontal_box_2.disable_item_expand (l_ev_vertical_box_4)
			l_ev_vertical_box_3.disable_item_expand (add_button_button)
			l_ev_vertical_box_3.disable_item_expand (add_toggle_button)
			l_ev_vertical_box_3.disable_item_expand (add_radio_button)
			add_button_button.set_text ("Add Button")
			add_toggle_button.set_text ("Add Toggle Button")
			add_radio_button.set_text ("Add Radio Button")
			add_menu_button_button.set_text ("Add Menu Button")
			l_ev_vertical_box_4.disable_item_expand (add_build_in_widget_button)
			l_ev_vertical_box_4.disable_item_expand (add_resizable_button)
			l_ev_vertical_box_4.disable_item_expand (add_separator_button)
			add_build_in_widget_button.set_text ("Add Build-in Widget")
			add_resizable_button.set_text ("Add Build-in Resizable")
			add_separator_button.set_text ("Add Separator")
			l_ev_frame_3.set_text ("Control")
			l_ev_vertical_box_5.disable_item_expand (l_ev_horizontal_box_3)
			l_ev_horizontal_box_3.disable_item_expand (show_button)
			l_ev_horizontal_box_3.disable_item_expand (hide_button)
			l_ev_horizontal_box_3.disable_item_expand (close_button)
			show_button.set_text ("Show")
			hide_button.set_text ("Hide")
			close_button.set_text ("Close")
			l_ev_horizontal_box_4.disable_item_expand (set_title_button)
			l_ev_horizontal_box_4.disable_item_expand (l_ev_cell_1)
			set_title_button.set_text ("Set Title")
			l_ev_cell_1.set_minimum_width (5)
			l_ev_horizontal_box_5.disable_item_expand (set_top_button)
			l_ev_horizontal_box_5.disable_item_expand (l_ev_cell_2)
			l_ev_horizontal_box_5.disable_item_expand (up_radio_button)
			l_ev_horizontal_box_5.disable_item_expand (down_radio_button)
			l_ev_horizontal_box_5.disable_item_expand (left_radio_button)
			l_ev_horizontal_box_5.disable_item_expand (right_radio_button)
			set_top_button.set_text ("Set Top")
			l_ev_cell_2.set_minimum_width (5)
			up_radio_button.set_text ("Up")
			down_radio_button.set_text ("Down")
			left_radio_button.set_text ("Left")
			right_radio_button.set_text ("Right")
			
			set_all_attributes_using_constants
			
				-- Connect events.
			toolbar_list.select_actions.extend (agent on_toolbar_selected)
			create_toolbar_button.select_actions.extend (agent on_create_toolbar_item_selected)
			add_button_button.select_actions.extend (agent on_add_button_button_selected)
			add_toggle_button.select_actions.extend (agent on_add_toggle_button_selected)
			add_radio_button.select_actions.extend (agent on_add_radio_button_selected)
			add_menu_button_button.select_actions.extend (agent on_add_menu_button_button_selected)
			add_build_in_widget_button.select_actions.extend (agent on_add_build_in_widget_button_selected)
			add_resizable_button.select_actions.extend (agent on_add_resizable_button_selected)
			add_separator_button.select_actions.extend (agent on_add_separator_button_selected)
			show_button.select_actions.extend (agent on_show_button_selected)
			hide_button.select_actions.extend (agent on_hide_button_selected)
			close_button.select_actions.extend (agent on_close_button_selected)
			set_title_button.select_actions.extend (agent on_set_title_button_selected)
			set_top_button.select_actions.extend (agent on_set_top_button_selected)

				-- Call `user_initialization'.
			user_initialization
		end


feature -- Access

	toolbar_list: EV_LIST
	create_toolbar_button, add_button_button, add_toggle_button, add_radio_button,
	add_menu_button_button, add_build_in_widget_button, add_resizable_button, add_separator_button,
	show_button, hide_button, close_button, set_title_button, set_top_button: EV_BUTTON
	up_radio_button,
	down_radio_button, left_radio_button, right_radio_button: EV_RADIO_BUTTON
	title_field: EV_TEXT_FIELD

feature {NONE} -- Implementation

	l_ev_cell_1, l_ev_cell_2: EV_CELL
	l_ev_horizontal_box_1, l_ev_horizontal_box_2, l_ev_horizontal_box_3,
	l_ev_horizontal_box_4, l_ev_horizontal_box_5: EV_HORIZONTAL_BOX
	l_ev_vertical_box_1, l_ev_vertical_box_2,
	l_ev_vertical_box_3, l_ev_vertical_box_4, l_ev_vertical_box_5: EV_VERTICAL_BOX
	l_ev_frame_1, l_ev_frame_2,
	l_ev_frame_3: EV_FRAME

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
	
	on_toolbar_selected is
			-- Called by `select_actions' of `toolbar_list'.
		deferred
		end
	
	on_create_toolbar_item_selected is
			-- Called by `select_actions' of `create_toolbar_button'.
		deferred
		end
	
	on_add_button_button_selected is
			-- Called by `select_actions' of `add_button_button'.
		deferred
		end
	
	on_add_toggle_button_selected is
			-- Called by `select_actions' of `add_toggle_button'.
		deferred
		end
	
	on_add_radio_button_selected is
			-- Called by `select_actions' of `add_radio_button'.
		deferred
		end
	
	on_add_menu_button_button_selected is
			-- Called by `select_actions' of `add_menu_button_button'.
		deferred
		end
	
	on_add_build_in_widget_button_selected is
			-- Called by `select_actions' of `add_build_in_widget_button'.
		deferred
		end
	
	on_add_resizable_button_selected is
			-- Called by `select_actions' of `add_resizable_button'.
		deferred
		end
	
	on_add_separator_button_selected is
			-- Called by `select_actions' of `add_separator_button'.
		deferred
		end
	
	on_show_button_selected is
			-- Called by `select_actions' of `show_button'.
		deferred
		end
	
	on_hide_button_selected is
			-- Called by `select_actions' of `hide_button'.
		deferred
		end
	
	on_close_button_selected is
			-- Called by `select_actions' of `close_button'.
		deferred
		end
	
	on_set_title_button_selected is
			-- Called by `select_actions' of `set_title_button'.
		deferred
		end
	
	on_set_top_button_selected is
			-- Called by `select_actions' of `set_top_button'.
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
