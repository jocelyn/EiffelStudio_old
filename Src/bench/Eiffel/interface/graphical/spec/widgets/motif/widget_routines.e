indexing

	description: 
		"Routines applied to different widgets for a particalar toolkit. %
		%In some instances, it was not worth while to abstract separate %
		%classes to implement simple routines.";
	date: "$Date$";
	revision: "$Revision $"

class WIDGET_ROUTINES

feature -- Setting

	set_scrolled_text_background_color (a_widget: SCROLLED_T_I; a_color: COLOR) is
			-- Set the scrolled text widget `a_widget' background color
			-- to `a_color' 
		local
			mel_widget: MEL_SCROLLED_TEXT;
			color_x: COLOR_X;
		do
			mel_widget ?= a_widget;
			color_x ?= a_color.implementation;
			color_x.allocate_pixel;
			mel_widget.set_background_color (color_x)
		end;

end -- class WIDGET_ROUTINES
