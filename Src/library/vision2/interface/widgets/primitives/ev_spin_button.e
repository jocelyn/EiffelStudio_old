indexing
	description:
		"Displays `value' and two buttons that allow it to be adjusted up and%
		%down within `range'."
	status: "See notice at end of class"
	keywords: "gauge, edit, text, number, up, down"
	date: "$Date$"
	revision: "$Revision$"

class
	EV_SPIN_BUTTON

inherit
	EV_GAUGE
		redefine
			create_implementation,
			implementation,
			is_in_default_state
		end

	EV_TEXT_FIELD
		rename
			change_actions as text_change_actions
		redefine
			create_implementation,
			implementation,
			is_in_default_state
		end

create
	default_create,
	make_with_value_range,
	make_with_text
	
feature {NONE} -- Contract support

	is_in_default_state: BOOLEAN is
			-- Is `Current' in its default state.
		do
			Result := Precursor {EV_GAUGE} and then
				text.is_equal ("0")
		end

feature {EV_ANY_I} -- Implementation

	implementation: EV_SPIN_BUTTON_I
			-- Responsible for interaction with native graphics toolkit.

feature {NONE} -- Implementation

	create_implementation is
			-- See `{EV_ANY}.create_implementation'.
		do
			create {EV_SPIN_BUTTON_IMP} implementation.make (Current)
		end

end -- class EV_SPIN_BUTTON

--|-----------------------------------------------------------------------------
--| EiffelVision2: library of reusable components for ISE Eiffel.
--| Copyright (C) 1986-2000 Interactive Software Engineering Inc.
--| All rights reserved. Duplication and distribution prohibited.
--| May be used only with ISE Eiffel, under terms of user license. 
--| Contact ISE for any other use.
--|
--| Interactive Software Engineering Inc.
--| ISE Building, 2nd floor
--| 270 Storke Road, Goleta, CA 93117 USA
--| Telephone 805-685-1006, Fax 805-685-6869
--| Electronic mail <info@eiffel.com>
--| Customer support e-mail <support@eiffel.com>
--| For latest info see award-winning pages: http://www.eiffel.com
--|-----------------------------------------------------------------------------
