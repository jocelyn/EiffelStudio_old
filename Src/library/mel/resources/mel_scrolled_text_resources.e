indexing

	description: 
		"Scrolled Text resources.";
	status: "See notice at end of class.";
	date: "$Date$";
	revision: "$Revision$"

class
	MEL_SCROLLED_TEXT_RESOURCES

feature -- Implementation

	XmNscrollHorizontal: POINTER is
		external
			"C [macro <Xm/Text.h>]: EIF_POINTER"
		alias
			"XmNscrollHorizontal"
		end;

	XmNscrollVertical: POINTER is
		external
			"C [macro <Xm/Text.h>]: EIF_POINTER"
		alias
			"XmNscrollVertical"
		end;

	XmNscrollLeftSide: POINTER is
		external
			"C [macro <Xm/Text.h>]: EIF_POINTER"
		alias
			"XmNscrollLeftSide"
		end;

	XmNscrollTopSide: POINTER is
		external
			"C [macro <Xm/Text.h>]: EIF_POINTER"
		alias
			"XmNscrollTopSide"
		end;

end -- class MEL_SCROLLED_TEXT_RESOURCES

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
