indexing

	description: "Text in Scrolled Window which can have tabs set";
	status: "See notice at end of class";
	date: "$Date$";
	revision: "$Revision$"

class TABBED_TEXT_M

inherit

	TABBED_TEXT_I

	SCROLLED_T_M
		end

creation
	make, make_word_wrapped

feature -- Status report

	tab_positions: ARRAY [INTEGER] is
			-- Positions of tabs.
		do
		end

feature -- Status setting

	set_no_tabs is
				-- Turn off tabulation
		do
		end
	
	set_tab_position (tab_position: INTEGER) is
				-- Set tabs at every `tab_position'
		do
		end

	set_tab_positions (tab_position_array: ARRAY [INTEGER]) is
				-- Set tabs at positions specified in `tab_position_array'
		do
		end

end -- class TABBED_TEXT_M


--|----------------------------------------------------------------
--| EiffelVision: library of reusable components for ISE Eiffel 3.
--| Copyright (C) 1989, 1991, 1993, 1994, Interactive Software
--|   Engineering Inc.
--| All rights reserved. Duplication and distribution prohibited.
--|
--| 270 Storke Road, Suite 7, Goleta, CA 93117 USA
--| Telephone 805-685-1006
--| Fax 805-685-6869
--| Electronic mail <info@eiffel.com>
--| Customer support e-mail <support@eiffel.com>
--|----------------------------------------------------------------
