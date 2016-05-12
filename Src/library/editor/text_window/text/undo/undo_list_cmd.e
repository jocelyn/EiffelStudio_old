note
	description: "Undo list of commands"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	UNDO_LIST_CMD [G -> UNDO_CMD]

inherit
	UNDO_CMD

create
	make

feature -- Initialization

	make
			-- Initialize
		do
			create items.make (1)
		end

feature -- Transformation

	add (urc: G)
			-- add the undo command to the items.
		do
			items.extend (urc)
		end

feature -- Basic operations

	redo
			-- undo this command
		do
			across
				items as ic
			loop
				ic.item.redo
			end
		end

	undo
			-- redo this command
		do
			across
				items as ic
			loop
				ic.item.undo
			end
		end

feature {NONE} -- Implementation

	items: ARRAYED_LIST [G];

note
	copyright:	"Copyright (c) 1984-2016, Eiffel Software and others"
	license:	"Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"




end -- class UNDO_REPLACE_ALL_CMD
