indexing
	description: "Button representing a CONTEXT_TYPE in %
				% the context catalog."
	id: "$Id$"
	date: "$Date$"
	revision: "$Revision$"

class
	CONTEXT_TYPE_BUTTON

inherit
	PICT_COLOR_B
		redefine
			make
		end

	FOCUSABLE
		redefine
			set_focus_string
		end

creation
	make

feature -- Initialization

	make (a_name: STRING; a_parent: COMPOSITE) is
			-- Creation routine
		do
			Precursor (a_name, a_parent)
		end

	focus_label: FOCUS_LABEL_I is
			-- has to be redefined, so that it returns correct toolkit initializer
			-- to which object belongs for every instance of this class
		local
			ti: TOOLTIP_INITIALIZER
		do
			ti ?= top
			check
				valid_tooltip_initializer: ti/= void
			end
			Result := ti.label
		end

	set_focus_string (a_string: STRING) is
		do
			Precursor (a_string)
			initialize_focus
		end

end -- class CONTEXT_TYPE_BUTTON
