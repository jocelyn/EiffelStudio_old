
-- REG_POLYGON: Description of a regular polygon (square, pentagon,...).

indexing
	copyright: "See notice at end of class"

class REG_POLYGON 

inherit

	CLOSED_FIG
		redefine
			conf_recompute
		end;

	JOINABLE;

	ANGLE_ROUT
		export
			{NONE} all
		end

creation

	make

feature -- Initialization

	make  is
			-- Create a reg_polygon.
		do
			init_fig (Void);
			!! center;
			!! path.make ;
			!! interior.make ;
			interior.set_no_op_mode;
			radius := 1;
			number_of_sides := 3;
			orientation := 0;
		end;


feature -- Access 

	center: COORD_XY_FIG;
			-- Center of the reg_polygon.

	number_of_sides: INTEGER;
			-- Number of sides

	orientation: REAL;
			-- Orientation in degree of the reg_polygon

	origin: COORD_XY_FIG is
			-- Origin of reg_polygon
		do
			inspect
				origin_user_type
			when 0 then
			when 1 then
				Result := origin_user
			when 2 then
				Result := center
			end
		end;

	radius: INTEGER;
			-- Radius of the circle who contains all the point of the polygon

	size_of_side: INTEGER is
			-- Size of a side
		do
			Result := real_to_integer (2*radius*cos (180.0/number_of_sides))
		end;

feature -- Modification & Insertion


	set_center (a_point: like center) is
			-- Set `center' to `a_point'.
		require
			a_point_exits: not (a_point = Void)
		do
			center := a_point;
			set_conf_modified
		ensure
			center = a_point
		end;

	set_number_of_sides (new_number_of_sides: like number_of_sides) is
			-- Set `number_of_sides' to `new_number_of_sides'.
		require
			at_least_three_sides: new_number_of_sides >= 3
		do
			number_of_sides := new_number_of_sides;
			set_conf_modified
		ensure
			number_of_sides = new_number_of_sides
		end;

	set_orientation (new_orientation: like orientation) is
			-- Set `orientation' to `new_orientation'.
		require
			orientation_positive: new_orientation >= 0;
			orientation_smaller_than_360: new_orientation < 360
		do
			orientation := new_orientation;
			set_conf_modified
		ensure
			orientation = new_orientation
		end;

	set_origin_to_center is
			-- Set origin to `center'.
		do
			origin_user_type := 2;
		ensure then
			origin.is_surimposable (center)
		end; 

	set_radius (new_radius: like radius) is
			-- Set `radius' to `new_radius', change `size_of_side'.
		require
			size_positive: new_radius >= 0
		do
			radius := new_radius;
			set_conf_modified
		ensure
			radius = new_radius
		end;

	set_size_of_side (a_size: INTEGER) is
			-- Set `size_of_side' to `a_size', change `radius'.
		require
			a_size_positive: a_size >= 0
		do
			radius := real_to_integer (a_size*cos (180.0/number_of_sides)/2);
			set_conf_modified
		ensure
			size_of_side = a_size
		end;

	xyrotate (a: REAL; px, py: INTEGER) is
			-- Rotate figure by `a' relative to (`px', `py').
			-- Angle `a' is measured in degrees.
		do
			orientation := mod360 (orientation+a);
			center.xyrotate (a, px, py);
			set_conf_modified
		end;

	xyscale (f: REAL; px,py: INTEGER) is
			-- Scale figure by `f' relative to (`px', `py').
		require else
			scale_factor_positive: f > 0.0
		do
			radius := real_to_integer (f*radius);
			center.xyscale (f, px, py);
			set_conf_modified
		end;

	xytranslate (vx, vy: INTEGER) is
			-- Translate by `vx' horizontally and `vy' vertically.
		do
			center.xytranslate (vx, vy);
			set_conf_modified
		end

feature -- Output

	draw is
			-- Draw the reg_polygon.
		local
			polygon: POLYGON;
			a_point: COORD_XY_FIG;
			i: INTEGER;
			angle: INTEGER;
		do
			if drawing.is_drawable then
				!! polygon.make ;
				polygon.set_conf_not_notify;
				from
					i := 0
				until
					i >= number_of_sides
				loop
					!! a_point;
					angle := i*(360//number_of_sides)+real_to_integer (orientation);
					a_point.set (	center.x+
									real_to_integer (radius*cosine (double_to_real(Pi*angle/180.0))), 
									center.y+
									real_to_integer (radius*sine (double_to_real(Pi*angle/180.0))));
					if polygon.off then
						polygon.add (a_point)
					else
						polygon.add_left (a_point);
					end;
					i := i+1
				end;
				polygon.attach_drawing_imp (drawing);
				drawing.set_join_style (join_style);
				if not (interior = Void) then
					interior.set_drawing_attributes (drawing);
					drawing.fill_polygon (polygon)
				end;
				if not (path = Void) then
					path.set_drawing_attributes (drawing);
					drawing.draw_polyline (polygon, true)
				end;
				--polygon.draw
			end
		end;

 feature -- Status report

	is_surimposable (other: like Current): BOOLEAN is
			-- Is the current reg_polygon surimposable to `other' ?
			--| not finished
		require else
			other_exists: not (other = Void)
		do
			Result := center.is_surimposable (other.center) and (number_of_sides = other.number_of_sides) and (radius = other.radius) and (orientation = other.orientation)
		end;



feature {CONFIGURE_NOTIFY} -- Updating

	conf_recompute is
		local
			diameter: INTEGER;
		do
			diameter := radius + radius;
			surround_box.set (center.x -radius, center.y -radius, diameter, diameter);
			unset_conf_modified
		end;



invariant

	origin_user_type <= 2;
	radius >= 0;
	size_of_side >= 0;
	number_of_sides >= 3;
	orientation < 360;
	orientation >= 0;
	not (center = Void)

end -- class REG_POLYGON


--|----------------------------------------------------------------
--| EiffelVision: library of reusable components for ISE Eiffel 3.
--| Copyright (C) 1989, 1991, 1993, Interactive Software
--|   Engineering Inc.
--| All rights reserved. Duplication and distribution prohibited.
--|
--| 270 Storke Road, Suite 7, Goleta, CA 93117 USA
--| Telephone 805-685-1006
--| Fax 805-685-6869
--| Electronic mail <info@eiffel.com>
--| Customer support e-mail <eiffel@eiffel.com>
--|----------------------------------------------------------------
