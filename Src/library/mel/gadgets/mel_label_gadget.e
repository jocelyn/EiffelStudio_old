indexing

	description: 
		"Motif Label Gadget.";
	status: "See notice at end of class.";
	date: "$Date$";
	revision: "$Revision$"

class
	MEL_LABEL_GADGET

inherit

	MEL_LABEL_GADGET_RESOURCES
		export
			{NONE} all
		end;

	MEL_GADGET

creation 
	make, make_from_existing

feature {NONE} -- Initialization

	make (a_name: STRING; a_parent: MEL_COMPOSITE; do_manage: BOOLEAN) is
			-- Create a motif label gadget.
		require
			a_name_exists: a_name /= Void
			a_parent_exists: a_parent /= Void and then not a_parent.is_destroyed
		local
			widget_name: ANY
		do
			parent := a_parent;
			widget_name := a_name.to_c;
			screen_object := xm_create_label_gadget (a_parent.screen_object, $widget_name, default_pointer, 0);
			Mel_widgets.put (Current, screen_object);
			set_default;
			if do_manage then
				manage
			end
		ensure
			exists: not is_destroyed
		end;

feature -- Status report

	label_as_string: STRING is
			-- Text of current label
		require
			exists: not is_destroyed
		local
			temp: MEL_STRING
		do 
			temp := get_xm_string (screen_object, XmNlabelString);
			Result := temp.to_eiffel_string;
			temp.free
		ensure
			text_not_void: Result /= Void
		end;

	label_string: MEL_STRING is
			-- Text of current label
		require
			exists: not is_destroyed
		do
			Result := get_xm_string (screen_object, XmNlabelString)
		ensure
			label_not_void: Result /= Void
		end;

	accelerator: STRING is
			-- Accelerator of label
		require
			exists: not is_destroyed;	
		do
			Result := get_xt_string (screen_object, XmNaccelerator)
		ensure
			accelerator_not_void: Result /= Void
		end;

	accelerator_text: MEL_STRING is
			-- Accelerator text of label
		require
			exists: not is_destroyed;	
		do
			Result := get_xm_string (screen_object, XmNacceleratorText)
		ensure
			accelerator_text_not_void: Result /= Void
		end;

	beginning_alignment: BOOLEAN is
			-- Is the text alignment to beginning?
		require
			exists: not is_destroyed
		do
			Result := alignment = XmALIGNMENT_BEGINNING
		end;

	center_alignment: BOOLEAN is
			-- Is the text alignment to center?
		require
			exists: not is_destroyed
		do
			Result := alignment = XmALIGNMENT_CENTER
		end;

	end_alignment: BOOLEAN is
			-- Is the text alignment to end?
		require
			exists: not is_destroyed
		do
			Result := alignment = XmALIGNMENT_END
		end;

	is_recomputing_size_allowed: BOOLEAN is
			-- Is the label allowed to recompute its size?
		require
			exists: not is_destroyed
		do
			Result := get_xt_boolean (screen_object, XmNrecomputeSize)
		end

	font_list: MEL_FONT_LIST is
			-- Return the font list of the label.
		require
			exists: not is_destroyed
		do
		ensure
		end;

	insensitive_pixmap: MEL_PIXMAP is
			-- Insensitive pixmap of label
		require
			exists: not is_destroyed
		do
			Result := get_xt_pixmap (screen_object, XmNlabelInsensitivePixmap)
		ensure
			insensitive_pixmap_is_valid: Result /= Void and then Result.is_valid
		end;

	pixmap: MEL_PIXMAP is
			-- Pixmap of the label
		require
			exists: not is_destroyed
		do
			Result := get_xt_pixmap (screen_object, XmNlabelPixmap)
		ensure
			pixmap_is_valid: Result /= Void and then Result.is_valid
		end;

	is_type_string: BOOLEAN is
			-- Is the type of the label a String?
		require
			exists: not is_destroyed
		do
			Result := get_xt_unsigned_char (screen_object, XmNlabelType) = XmSTRING
		end;

	is_type_pixmap: BOOLEAN is
			-- Is the type of the label a Pixmap?
		require
			exists: not is_destroyed
		do
			Result := get_xt_unsigned_char (screen_object, XmNlabelType) = XmPIXMAP
		end;

	margin_bottom: INTEGER is
			-- Amount of space between the bottom side of the text and
			-- the nearest margin
		require
			exists: not is_destroyed
		do
			Result := get_xt_dimension (screen_object, XmNmarginBottom)
		ensure
			margin_bottom_large_enough: Result >= 0
		end;

	margin_top: INTEGER is
			-- Amount of space between the top side of the text and
			-- the nearest margin
		require
			exists: not is_destroyed
		do
			Result := get_xt_dimension (screen_object, XmNmarginTop)
		ensure
			margin_top_large_enough: Result >= 0
		end;

	margin_left: INTEGER is
			-- Amount of space between the left side of the text and
			-- the nearest margin
		require
			exists: not is_destroyed
		do
			Result := get_xt_dimension (screen_object, XmNmarginLeft)
		ensure
			margin_left_large_enough: Result >= 0
		end;
 
	margin_right: INTEGER is
			-- Amount of space between the right side of the text and
			-- the nearest margin
		require
			exists: not is_destroyed
		do
			Result := get_xt_dimension (screen_object, XmNmarginRight)
		ensure
			margin_right_large_enough: Result >= 0
		end;

	margin_height: INTEGER is
			-- Spacing between one side of the label and the
			-- nearest edge of a shadow
		require
			exists: not is_destroyed
		do
			Result := get_xt_dimension (screen_object, XmNmarginHeight)
		ensure
			margin_height_large_enough: Result >= 0
		end;
 
	margin_width: INTEGER is
			-- Spacing between one side of the label and the
			-- nearest edge of a shadow
		require
			exists: not is_destroyed
		do
			Result := get_xt_dimension (screen_object, XmNmarginWidth)
		ensure
			margin_width_large_enough: Result >= 0
		end;

	mnemonic_char_set: STRING is
			-- Character set for the label's mnemonic
		require
			exists: not is_destroyed
		do
			Result := get_xt_string (screen_object, XmNmnemonicCharSet)
		end;

	is_string_direction_l_to_r: BOOLEAN is
			-- Is the string directory in which to draw the string left to right?		
		require
			exists: not is_destroyed
		do
			Result := get_xm_string_direction (screen_object, XmNstringDirection) = XmSTRING_DIRECTION_L_TO_R
		end;

feature -- Status setting

	set_label_as_string (a_text: STRING) is
			-- Set `label_as_string' to `a_text'.
		require
			exists: not is_destroyed;
			not_a_text_void: a_text /= Void
		local
			compound_string: MEL_STRING
		do
			!! compound_string.make_localized (a_text);
			set_xm_string (screen_object, XmNlabelString, compound_string);
			compound_string.free
		ensure
			text_set: label_as_string.is_equal (a_text)
		end;

	set_label_string (a_compound_string: MEL_STRING) is
			-- Set `a_compound_string' to `a_text'.
		require
			exists: not is_destroyed;
			a_compound_string_exists: a_compound_string /= Void and then not a_compound_string.is_destroyed
		do
			set_xm_string (screen_object, XmNlabelString, a_compound_string);
		ensure
			label_set: label_string.is_equal (a_compound_string)
		end;

	set_accelerator (a_text: STRING) is
			-- Set `accelerator' to `a_text'.
		require
			exists: not is_destroyed;	
			not_a_text_void: a_text /= Void
		do
			set_xt_string (screen_object, XmNaccelerator, a_text)
		ensure
			accelerator_set: accelerator.is_equal (a_text)
		end;

	set_accelerator_text (a_compound_string: MEL_STRING) is
			-- Set `accelerator_text' to `a_text'.
		require
			exists: not is_destroyed;	
			a_compound_string_exists: a_compound_string /= Void and then not a_compound_string.is_destroyed
		do
			set_xm_string (screen_object, XmNacceleratorText, a_compound_string)
		ensure
			accelerator_text_set: accelerator_text.is_equal (a_compound_string)
		end;

	set_recomputing_size_allowed (b: BOOLEAN) is
			-- Set `is_recomputing_size_allowed' to `b'.
		require
			exists: not is_destroyed
		do
			set_xt_boolean (screen_object, XmNrecomputeSize, b)
		ensure
			recompute_size_allowed: is_recomputing_size_allowed = b
		end;

	set_beginning_alignment is
			-- Set text alignment to beginning.
		require
			exists: not is_destroyed
		do
			set_xt_unsigned_char (screen_object, XmNalignment, XmALIGNMENT_BEGINNING)
		ensure
			beginning_alignment_set: beginning_alignment
		end;

	set_center_alignment is
			-- Set text alignment to center.
		require
			exists: not is_destroyed
		do
			set_xt_unsigned_char (screen_object, XmNalignment, XmALIGNMENT_CENTER)
		ensure
			center_alignment_set: center_alignment
		end;

	set_end_alignment is
			-- Set text alignment to end.
		require
			exists: not is_destroyed
		do
			set_xt_unsigned_char (screen_object, XmNalignment, XmALIGNMENT_END)
		ensure
			end_alignment_set: end_alignment
		end;

	set_font_list (a_font_list: MEL_FONT_LIST) is
			-- Set `font_list' to `a_font_list'.
		require
			exists: not is_destroyed
		do
		end;

	set_insensitive_pixmap (a_pixmap: MEL_PIXMAP) is
			-- Set `insensitive_pixmap' to `a_pixmap'.
		require
			exists: not is_destroyed;
			a_pixmap_is_valid: a_pixmap /= Void and then a_pixmap.is_valid
		do
			set_xt_pixmap (screen_object, XmNlabelInsensitivePixmap, a_pixmap)
		ensure
			insensitive_pixmap_set: insensitive_pixmap.is_equal (a_pixmap)
		end;

	set_pixmap (a_pixmap: MEL_PIXMAP) is
			-- Set `pixmap' to a `a_pixmap'.
		require
			exists: not is_destroyed;
			a_pixmap_is_valid: a_pixmap /= Void and then a_pixmap.is_valid
		do
			set_xt_pixmap (screen_object, XmNlabelPixmap, a_pixmap)
		ensure
			pixmap_set: pixmap.is_equal (a_pixmap)
		end;

	set_type_string is
			-- Set the type of the label to a String.
		require
			exists: not is_destroyed
		do
			set_xt_unsigned_char (screen_object, XmNlabelType, XmSTRING)
		ensure
			type_set: is_type_string
		end;

	set_type_pixmap is
			-- Set the type of the label to Pixmap.
		require
			exists: not is_destroyed
		do
			set_xt_unsigned_char (screen_object, XmNlabelType, XmPIXMAP)
		ensure
			type_set: is_type_pixmap
		end;

	set_margin_bottom (a_value: INTEGER) is
			-- Set `margin_bottom' to `a_value'.
		require
			exists: not is_destroyed;
			a_value_large_enough: a_value >= 0
		do
			set_xt_dimension (screen_object, XmNmarginBottom, a_value)
		ensure
			value_set: margin_bottom = a_value
		end;

	set_margin_top (a_value: INTEGER) is
			-- Set `margin_top' to `a_value'.
		require
			exists: not is_destroyed;
			a_value_large_enough: a_value >= 0
		do
			set_xt_dimension (screen_object, XmNmarginTop, a_value)
		ensure
			value_set: margin_top = a_value
		end;

	set_margin_left (a_value: INTEGER) is
			-- Set `margin_left' to `a_value'.
		require
			exists: not is_destroyed;
			a_value_large_enough: a_value >= 0
		do
			set_xt_dimension (screen_object, XmNmarginLeft, a_value)
		ensure
			value_set: margin_left = a_value
		end;

	set_margin_right (a_value: INTEGER) is
			-- Set `margin_right' to `a_value'.
		require
			exists: not is_destroyed;
			a_value_large_enough: a_value >= 0
		do
			set_xt_dimension (screen_object, XmNmarginRight, a_value)
		ensure
			value_set: margin_right = a_value
		end;

	set_margin_height (a_value: INTEGER) is
			-- Set `margin_height' to `a_value'.
		require
			exists: not is_destroyed;
			a_value_large_enough: a_value >= 0
		do
			set_xt_dimension (screen_object, XmNmarginHeight, a_value)
		ensure
			value_set: margin_height = a_value
		end;

	set_margin_width (a_value: INTEGER) is
			-- Set `margin_right' to `a_value'.
		require
			exists: not is_destroyed;
			a_value_large_enough: a_value >= 0
		do
			set_xt_dimension (screen_object, XmNmarginWidth, a_value)
		ensure
			value_set: margin_right = a_value
		end;

	set_string_direction_l_to_r is
			-- Set the direction in which to draw the string to left to right.
		require
			exists: not is_destroyed
		do
			set_xm_string_direction (screen_object, XmNstringDirection, XmSTRING_DIRECTION_L_TO_R)
		ensure
			string_direction_set: is_string_direction_l_to_r
		end;

	set_string_direction_r_to_l is
			-- Set the direction in which to draw the string to right to left.
		require
			exists: not is_destroyed
		do
			set_xm_string_direction (screen_object, XmNstringDirection, XmSTRING_DIRECTION_R_TO_L)
		ensure
			string_direction_set: not is_string_direction_l_to_r
		end;

feature {NONE} -- Implementation

	alignment: INTEGER is
			-- Current alignment of the label
		require
			exists: not is_destroyed
		do
			Result := get_xt_unsigned_char (screen_object, XmNalignment)
		end;

	xm_create_label_gadget (a_parent, a_name, arglist: POINTER; argcount: INTEGER): POINTER is
		external
			"C [macro <Xm/LabelG.h>] (Widget, String, ArgList, Cardinal): EIF_POINTER"
		alias
			"XmCreateLabelGadget"
		end

end -- class MEL_LABEL_GADGET

--|-----------------------------------------------------------------------
--| Motif Eiffel Library: library of reusable components for ISE Eiffel 3.
--| Copyright (C) 1996, Interactive Software Engineering, Inc.
--| All rights reserved. Duplication and distribution prohibited.
--|
--| 270 Storke Road, Suite 7, Goleta, CA 93117 USA
--| Telephone 805-685-1006
--| Fax 805-685-6869
--| Information e-mail <info@eiffel.com>
--| Customer support e-mail <support@eiffel.com>
--|-----------------------------------------------------------------------
