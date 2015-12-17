note
	description: "[
		Objects that represent an EV_DIALOG.
		The original version of this class was generated by EiffelBuild.
		This class is the implementation of an EV_DIALOG generated by EiffelBuild.
		You should not modify this code by hand, as it will be re-generated every time
		 modifications are made to the project.
		 	]"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	GENERATION_DIALOG_IMP

inherit
	EV_DIALOG
		redefine
			initialize, is_in_default_state
		end
			
	GB_INTERFACE_CONSTANTS
		undefine
			is_equal, default_create, copy
		end

feature {NONE}-- Initialization

	initialize
			-- Initialize `Current'.
		do
			Precursor {EV_DIALOG}
			initialize_constants
			
				-- Create all widgets.
			create l_ev_vertical_box_1
			create l_ev_horizontal_box_1
			create message_label
			create l_ev_horizontal_box_2
			create select_directory_button
			create directory_display
			create l_ev_cell_1
			create l_ev_horizontal_box_3
			create ok_button
			create cancel_button
			
				-- Build widget structure.
			extend (l_ev_vertical_box_1)
			l_ev_vertical_box_1.extend (l_ev_horizontal_box_1)
			l_ev_horizontal_box_1.extend (message_label)
			l_ev_vertical_box_1.extend (l_ev_horizontal_box_2)
			l_ev_horizontal_box_2.extend (select_directory_button)
			l_ev_horizontal_box_2.extend (directory_display)
			l_ev_vertical_box_1.extend (l_ev_cell_1)
			l_ev_vertical_box_1.extend (l_ev_horizontal_box_3)
			l_ev_horizontal_box_3.extend (ok_button)
			l_ev_horizontal_box_3.extend (cancel_button)
			
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
			l_ev_vertical_box_1.set_background_color (create {EV_COLOR}.make_with_8_bit_rgb (255, 255, 255))
			l_ev_vertical_box_1.disable_item_expand (l_ev_cell_1)
			l_ev_vertical_box_1.disable_item_expand (l_ev_horizontal_box_3)
			l_ev_horizontal_box_1.set_background_color (create {EV_COLOR}.make_with_8_bit_rgb (255, 255, 255))
			l_ev_horizontal_box_1.set_border_width (10)
			message_label.set_background_color (create {EV_COLOR}.make_with_8_bit_rgb (255, 255, 255))
			l_ev_horizontal_box_2.set_background_color (create {EV_COLOR}.make_with_8_bit_rgb (255, 255, 255))
			l_ev_horizontal_box_2.set_padding (10)
			l_ev_horizontal_box_2.set_border_width (10)
			l_ev_horizontal_box_2.disable_item_expand (select_directory_button)
			select_directory_button.set_text ("Select Directory")
			directory_display.disable_edit
			l_ev_cell_1.set_background_color (create {EV_COLOR}.make_with_8_bit_rgb (255, 255, 255))
			l_ev_cell_1.set_minimum_height (25)
			l_ev_horizontal_box_3.set_background_color (create {EV_COLOR}.make_with_8_bit_rgb (255, 255, 255))
			l_ev_horizontal_box_3.set_minimum_width (87)
			l_ev_horizontal_box_3.set_padding (10)
			l_ev_horizontal_box_3.set_border_width (10)
			l_ev_horizontal_box_3.disable_item_expand (ok_button)
			l_ev_horizontal_box_3.disable_item_expand (cancel_button)
			ok_button.disable_sensitive
			ok_button.set_text ("Ok")
			ok_button.set_minimum_width (60)
			cancel_button.set_text ("Cancel")
			cancel_button.set_minimum_width (60)
			set_background_color (create {EV_COLOR}.make_with_8_bit_rgb (255, 255, 255))
			disable_user_resize
			set_title ("Test Generation")
			
			set_all_attributes_using_constants
			
				-- Connect events.
			select_directory_button.select_actions.extend (agent display_directory_dialog)
			ok_button.select_actions.extend (agent ok_pressed)
			cancel_button.select_actions.extend (agent cancel_pressed)
				-- Close the application when an interface close
				-- request is received on `Current'. i.e. the cross is clicked.

				-- Call `user_initialization'.
			user_initialization
		end


feature -- Access

	l_ev_cell_1: EV_CELL
	select_directory_button, ok_button, cancel_button: EV_BUTTON
	l_ev_horizontal_box_1,
	l_ev_horizontal_box_2, l_ev_horizontal_box_3: EV_HORIZONTAL_BOX
	l_ev_vertical_box_1: EV_VERTICAL_BOX
	message_label: EV_LABEL
	directory_display: EV_TEXT_FIELD

feature {NONE} -- Implementation

	is_in_default_state: BOOLEAN
			-- Is `Current' in its default state?
		do
			-- Re-implement if you wish to enable checking
			-- for `Current'.
			Result := True
		end
	
	user_initialization
			-- Feature for custom initialization, called at end of `initialize'.
		deferred
		end
	
	display_directory_dialog
			-- Called by `select_actions' of `select_directory_button'.
		deferred
		end
	
	ok_pressed
			-- Called by `select_actions' of `ok_button'.
		deferred
		end
	
	cancel_pressed
			-- Called by `select_actions' of `cancel_button'.
		deferred
		end
	
	
feature {NONE} -- Constant setting

	set_attributes_using_string_constants
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
		
	set_attributes_using_integer_constants
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
		
	set_attributes_using_pixmap_constants
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
		
	set_attributes_using_font_constants
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
		
	set_attributes_using_color_constants
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
		
	set_all_attributes_using_constants
			-- Set all attributes relying on constants to the current
			-- calue of the associated constant.
		do
			set_attributes_using_string_constants
			set_attributes_using_integer_constants
			set_attributes_using_pixmap_constants
			set_attributes_using_font_constants
			set_attributes_using_color_constants
		end
					
	string_constant_set_procedures: ARRAYED_LIST [PROCEDURE [STRING_GENERAL]]
	string_constant_retrieval_functions: ARRAYED_LIST [FUNCTION [STRING_GENERAL]]
	integer_constant_set_procedures: ARRAYED_LIST [PROCEDURE [INTEGER]]
	integer_constant_retrieval_functions: ARRAYED_LIST [FUNCTION [INTEGER]]
	pixmap_constant_set_procedures: ARRAYED_LIST [PROCEDURE [EV_PIXMAP]]
	pixmap_constant_retrieval_functions: ARRAYED_LIST [FUNCTION [EV_PIXMAP]]
	integer_interval_constant_retrieval_functions: ARRAYED_LIST [FUNCTION [INTEGER]]
	integer_interval_constant_set_procedures: ARRAYED_LIST [PROCEDURE [INTEGER_INTERVAL]]
	font_constant_set_procedures: ARRAYED_LIST [PROCEDURE [EV_FONT]]
	font_constant_retrieval_functions: ARRAYED_LIST [FUNCTION [EV_FONT]]
	color_constant_set_procedures: ARRAYED_LIST [PROCEDURE [EV_COLOR]]
	color_constant_retrieval_functions: ARRAYED_LIST [FUNCTION [EV_COLOR]]
	
	integer_from_integer (an_integer: INTEGER): INTEGER
			-- Return `an_integer', used for creation of
			-- an agent that returns a fixed integer value.
		do
			Result := an_integer
		end

note
	copyright:	"Copyright (c) 1984-2006, Eiffel Software and others"
	license:	"Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			 Eiffel Software
			 356 Storke Road, Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"

end
