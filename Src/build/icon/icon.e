--=========================== class XXXXXXXX ========================
--
-- Author: Deramat
-- Last revision: 03/30/92
--
-- Icon: Picture symbol and text label.
--
--===================================================================

class ICON 

inherit

	CONSTANTS;
	BULLETIN
		rename
			make as bulletin_make,
			make_unmanaged as bulletin_make_unmanaged,
			identifier as oui_identifier
		redefine
			set_managed,
			add_button_press_action
		end;

feature 

	init_y: INTEGER is 29;	

	source_button: PICT_COLOR_B is
		do
			Result := button
		end;

	symbol: PIXMAP;
			-- Icon picture

	label: STRING;
			-- Icon label

	set_symbol (s: PIXMAP) is
			-- Set icon symbol.
		require
			valid_argument: s /= Void;
		local
			was_managed: BOOLEAN;
		do
			symbol := s;
			if s.is_valid and then widget_created then
				button.unmanage;
				button.set_pixmap (s);
				button.manage;
			end;
		end;

	set_label (s: STRING) is
			-- Set icon label.
		require
			not_void: s /= Void;
		local
			was_managed: BOOLEAN;
		do
			label := clone (s);
			if widget_created then
				icon_label.unmanage;
				icon_label.set_y (init_y);
				icon_label.set_text (label);
				icon_label.manage;
			end;
		end;

	widget_created: BOOLEAN is
		do
			Result := button /= Void
		end;
	
feature {NONE} -- Interface section

	button: PICT_COLOR_B;
	icon_label: LABEL_G;
	
	update_label is
		do
			if label.empty then
				icon_label.unmanage;
			else
				icon_label.manage;
			end;
		end;

feature  -- Interface section

	frozen make_unmanaged (a_parent: COMPOSITE) is
			-- Create current unmanaged.
			--| It is frozen since it is called by
			--| the icon box.
		require
			not_created: not widget_created
		do
			bulletin_make_unmanaged (Widget_names.bulletin, a_parent);
			!! button.make_unmanaged (Widget_names.pcbutton, Current);
			button.set_x_y (1, 1);
			if 
				symbol /= Void and
				symbol.is_valid
			then 
				button.set_pixmap (symbol)
			end;
			!!icon_label.make_unmanaged (Widget_names.label, Current);
			icon_label.set_left_alignment;
			icon_label.allow_recompute_size;
			if (label /= Void) and then not label.empty then
				icon_label.set_y (init_y);
				icon_label.set_text (label);
			else
				icon_label.set_text ("");
			end;
			set_widget_default
		end;

	frozen make_visible (a_parent: COMPOSITE) is
			-- Create current unmanaged.
			--| It is frozen since it is called by
			--| the icon box.
		require
			not_created: not widget_created
		do
			make_unmanaged (a_parent);
			set_managed (true);	
		end;

	set_widget_default is
			-- Set default behaviour after widget
			-- has been created
		do
			-- Do nothing
		end;

	add_activate_action (a_command: COMMAND; an_argument: ANY) is
		do
			button.add_activate_action (a_command, an_argument)
		end;

	add_button_press_action (i: INTEGER; a_command: COMMAND; an_argument: ANY) is
		do
			button.add_button_press_action (i, a_command, an_argument)
		end;

	set_managed (b: BOOLEAN) is
		do
			if b then 
				manage;
				if not icon_label.text.empty then
					icon_label.manage;
				end;
				button.manage;
			else unmanage;
				if button.managed then
					button.unmanage;
				end;
				if icon_label.managed then
					icon_label.unmanage;
				end;
			end;
		end;

end
