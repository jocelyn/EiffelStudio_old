class
	RECTANGLE_DEMO

inherit
	WEL_FRAME_WINDOW

	WEL_STANDARD_COLORS
		export
			{NONE} all
		end
creation
	make

feature {NONE} -- Initialization

	make is
		do
			make_top ("Rectangles demo")
			resize (500, 400)
			show
		end

feature -- Basic operations

	draw is
		local
			dc: WEL_CLIENT_DC
			r_left, r_top, r_right, r_bottom: INTEGER
			brush: WEL_BRUSH
			color: WEL_COLOR_REF
		do
			!! dc.make (Current)
			dc.get
			r_left := next_number (width)
			r_top := next_number (height)
			r_right := next_number (width)
			r_bottom := next_number (height)
			color := std_colors @ (next_number (std_colors.count))
			!! brush.make_solid (color)
			dc.select_brush (brush)
			dc.rectangle (r_left, r_top, r_right, r_bottom)
			dc.unselect_all
			dc.release
		end

feature {NONE} -- Implementation

	std_colors: ARRAY [WEL_COLOR_REF] is
		once
			Result := <<
				grey,
				blue,
				cyan,
				green,
				yellow,
				red,
				magenta,
				white,
				black,
				dark_grey,
				dark_blue,
				dark_cyan,
				dark_green,
				dark_yellow,
				dark_red,
				dark_magenta>>
		ensure
			result_not_void: Result /= Void
		end

	random: RANDOM is
			-- Initialize a randon number
		once
			!! Result.make
			random.start
		ensure
			result_not_void : Result /= Void
		end

	next_number (range: INTEGER): INTEGER is
			-- Random number between 1 and `range'
			--| Side effect function.
		do
			random.forth
			Result := random.item \\ range + 1
		ensure
			valid_result_inf: Result > 0
			valid_result_sup: Result <= range
		end

end -- class RECTANGLE_DEMO

--|-------------------------------------------------------------------------
--| Windows Eiffel Library: library of reusable components for ISE Eiffel 3.
--| Copyright (C) 1995, Interactive Software Engineering, Inc.
--| All rights reserved. Duplication and distribution prohibited.
--|
--| 270 Storke Road, Suite 7, Goleta, CA 93117 USA
--| Telephone 805-685-1006
--| Fax 805-685-6869
--| Information e-mail <info@eiffel.com>
--| Customer support e-mail <support@eiffel.com>
--|-------------------------------------------------------------------------
