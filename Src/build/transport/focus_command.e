
class FOCUS_COMMAND 

inherit

	COMMAND
	
feature {NONE}

	last_focusable: FOCUSABLE;
	
feature 

	execute (argument: FOCUSABLE) is
		do
			if argument /= Void then
				last_focusable := argument;
				argument.set_focus;
			elseif last_focusable /= Void then
				last_focusable.reset_focus;
				last_focusable := Void;
			end;
		end;

end
