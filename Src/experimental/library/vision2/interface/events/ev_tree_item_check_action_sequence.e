note
	description: "Action sequence for EV_CHECKABLE_LIST check events."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	EV_TREE_ITEM_CHECK_ACTION_SEQUENCE
	
inherit
	EV_ACTION_SEQUENCE [TUPLE [EV_TREE_NODE]]
	-- EV_ACTION_SEQUENCE [TUPLE [a_list_item: EV_TREE_ITEM]]
	-- (ETL3 TUPLE with named parameters)
	
create
	default_create

create {EV_TREE_ITEM_CHECK_ACTION_SEQUENCE}
	make_filled

feature -- Access

	force_extend (action: PROCEDURE)
			-- Extend without type checking.
		do
			extend (agent wrapper (?, action))
		end

	wrapper (a_tree_item: EV_TREE_NODE; action: PROCEDURE)
			-- Use this to circumvent tuple type checking. (at your own risk!)
			-- Calls `action' passing all other arguments.
		do
			action.call ([a_tree_item])
		end

feature {NONE} -- Implementation

	new_filled_list (n: INTEGER): like Current
			-- New list with `n' elements.
		do
			create Result.make_filled (n)
		end

note
	copyright:	"Copyright (c) 1984-2006, Eiffel Software and others"
	license:	"Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			 Eiffel Software
			 356 Storke Road, Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"




end

