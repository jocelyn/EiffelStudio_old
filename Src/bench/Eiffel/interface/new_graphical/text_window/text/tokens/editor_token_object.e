indexing
	description	: "Token that describe the address of an Eiffel object"
	author		: "Arnaud PICHERY [ aranud@mail.dotcom.fr ]"
	date		: "$Date$"
	revision	: "$Revision$"

class
	EDITOR_TOKEN_OBJECT

inherit
	EDITOR_TOKEN_TEXT
		redefine
			text_color,
			background_color,
			editor_preferences
		end

create
	make

feature {NONE} -- Implementation
	
	text_color: EV_COLOR is
		do
			Result := editor_preferences.object_text_color
		end

	background_color: EV_COLOR is
		do
			Result := editor_preferences.object_background_color
		end
		
	editor_preferences: EB_EDITOR_DATA is
			-- 
		once
			Result ?= editor_preferences_cell.item
		end

end -- class EDITOR_TOKEN_OBJECT
