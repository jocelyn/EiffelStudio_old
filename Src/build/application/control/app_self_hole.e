
class APP_SELF_HOLE 

inherit

	ICON_HOLE
		redefine
			stone
		end;
	LABELS
		export
			{NONE} all
		end;
	PIXMAPS
		export
			{NONE} all
		end

creation

	make
	
feature -- Creation

	make (editor: APP_EDITOR) is
			-- Create a self_hole.
		do
			set_label (Self_label);
			set_symbol (Self_label_pixmap);
		end; 

feature {NONE}

	stone: LABEL_SCR_L;

	process_stone is
			-- Update the transition to self. 
		local
			cut_label_command: APP_CUT_LABEL;
		do
			!!cut_label_command;
			cut_label_command.execute (stone.label)
		end; 

end 
