
indexing
	description: "EiffelVision drawable area. Implementation interface."
	status: "See notice at end of class"
	id: "$Id$"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EV_DRAWABLE_IMP

inherit
	EV_GTK_DRAWABLE_EXTERNALS

feature -- Access

	background_color: EV_COLOR is
			-- Color used for the background of the widget
		do
		end

	foreground_color: EV_COLOR is
			-- Color used for the foreground of the drawable,
			-- used for the text and the drawings.
		do
		end

	line_width: INTEGER is
			-- Width of line for device.
		do
		end

	logical_mode: INTEGER is
			-- Drawing mode
		do
		end

feature -- Status report

	is_drawable: BOOLEAN is
			-- Is the device drawable?
		do
		end

feature -- Element change

	set_background_color (color: EV_COLOR) is
			-- Make `color' the new `background_color'
		do
		end

	set_foreground_color (color: EV_COLOR) is
			-- Make `color' the new `foreground_color'
		do
		end

	set_line_width (value: INTEGER) is
			-- Set line to be displayed with width of `new_width'.
		do
		end

	set_logical_mode (value: INTEGER) is
			-- Set drawing logical function to `value'.
		do
		end

	set_font (ft: EV_FONT) is
			-- Set a font.
		do
		end

feature -- Clearing operations

	clear is
			-- Clear the entire area.
		do
		end

	clear_rect (left, top, right, bottom: INTEGER) is
			-- Clear the rectangular area defined by
			-- `left', `top', `right', `bottom'.
		do
		end

feature -- Drawing operations

	draw_point (pt: EV_POINT) is
			-- Draw a point at the position `pt'.
		do
		end

	draw_text (pt: EV_POINT; text: STRING) is
			-- Draw `text' at the position `pt'
		do
		end

	draw_segment (pt1, pt2: EV_POINT) is
			-- Draw a segment between `pt1' and `pt2'.
		do
		end

	draw_polyline (pts: ARRAY [EV_POINT]; is_closed: BOOLEAN) is
			-- Draw a polyline, close it automatically if `is_closed'.
		do
		end

	draw_rectangle (pt: EV_POINT; w, h: INTEGER; orientation: REAL) is
			-- Draw a rectangle whose center is `pt' and size is `w' and `h'
			-- and that has the orientation `orientation'.
		do
		end

	draw_arc (pt: EV_POINT; r1, r2: INTEGER; start_angle, aperture, orientation: REAL; style: INTEGER) is
			-- Draw an arc centered in `pt' with a great radius of `r1' and a small radius
			-- of `r2' beginnning at `start_angle' and finishing at `start_angle + aperture'
			-- and with an orientation of `orientation' using the style `style'.
			-- The meaning of the style is the following :
			--   -1 : no link between the first and the last point
			--    0 : the first point is linked to the last point
			--    1 : the first and the last point are linked to the center `pt'
		do
		end

	draw_pixmap (pt: EV_POINT; pix : EV_PIXMAP) is
			-- Copy `pix' into the drawable at the point `pt'.
			-- If there is not enough space to create auxiliery bitmap (DDB) 
			-- exception will be raised
		do
		end

feature -- filling operations

	fill_polygon (pts: ARRAY [EV_POINT]) is
			 -- Fill a polygon.
		do
		end

	fill_rectangle (pt: EV_POINT; w, h: INTEGER; orientation: REAL) is
			-- Fill a rectangle whose center is `pt' and size is `w' and `h'
			-- with an orientation `orientation'.
		do
		end

	fill_arc (pt: EV_POINT; r1, r2 : INTEGER; start_angle, aperture, orientation: REAL; style: INTEGER) is
			-- Fill an arc centered in `pt' with a great radius of `r1' and a small radius
			-- of `r2' beginnning at `start_angle' and finishing at `start_angle + aperture'
			-- and with an orientation of `orientation' using the style `style'.
			-- The meaning of the style is the following :
			--   -1 : no link between the first and the last point
			--    0 : the first point is linked to the last point
			--    1 : the first and the last point are linked to the center `pt'
		do
		end

end -- class EV_DRAWABLE_IMP

--|----------------------------------------------------------------
--| EiffelVision: library of reusable components for ISE Eiffel.
--| Copyright (C) 1986-1998 Interactive Software Engineering Inc.
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
--|----------------------------------------------------------------
