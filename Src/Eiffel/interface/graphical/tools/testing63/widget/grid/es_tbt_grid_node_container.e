indexing
	description: "[
		Objects that support insertion and removal of grid rows in a {ES_TBT_GRID}, based on the changes
		of an underlaying {TAG_BASED_TREE}.
		
		Insertion and removal of child nodes and items in {TAG_BASED_TREE_NODE_CONTAINER} are redefined to
		keep grid synchronized.
		
		See {ES_TBT_GRID} and {TAG_BASED_TREE} for more information.
	]"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ES_TBT_GRID_NODE_CONTAINER [G -> TAGABLE_I]

inherit
	TAG_BASED_TREE_NODE_CONTAINER [G]
		redefine
			parent,
			child_for_token,
			tree,
			add_child,
			add_item,
			remove_child,
			remove_item
		end

feature -- Access

	parent: !ES_TBT_GRID_NODE_CONTAINER [G]
			-- <Precursor>
		do
		end

	row: !EV_GRID_ROW
			-- <Precursor>
		require
			not_root: not is_root
		do
		end

feature {TAG_BASED_TREE_NODE_CONTAINER} -- Access

	tree: !ES_TBT_GRID [G]
			-- <Precursor>
		deferred
		end

feature {NONE} -- Access

	first_item_subrow: ?EV_GRID_ROW
			-- First subrow that contains an item, Void if `Current' does not contain any items

	first_child_index: INTEGER
			-- First valid index for child item row
		deferred
		end

	last_child_index: INTEGER
			-- Last valid index for child row
		do
			Result := first_item_index
		end

	first_item_index: INTEGER
			-- First valid index for item rows
		do
			if first_item_subrow /= Void then
				Result := first_item_subrow.index
			else
				Result := last_item_index
			end
		end

	last_item_index: INTEGER
			-- Last valid index for item row
		deferred
		end

feature -- Query

	child_for_token (a_token: !STRING): !ES_TBT_GRID_NODE [G]
			-- <Precursor>
		do
			Result := cached_children.item (a_token)
		end

feature {NONE} -- Element change

	add_child (a_token: !STRING)
			-- <Precursor>
		local
			i: INTEGER
			l_new: ES_TBT_GRID_NODE [G]
			l_row: !EV_GRID_ROW
		do
			from
				i := first_child_index
			until
				i = last_child_index or else ({l_item: ES_TBT_GRID_NODE [G]} tree.row (i).data and then
					l_item.token > a_token)
			loop
				i := i + tree.row (i).subrow_count_recursive + 1
			end
			if is_root then
				tree.insert_new_row (i)
			else
				tree.insert_new_row_parented (i, row)
			end
			l_row ?= tree.row (i)
			l_row.ensure_expandable
			create l_new.make (l_row, Current, a_token)
			cached_children.put (l_new, a_token)
		end

	add_item (a_item: !G) is
			-- <Precursor>
		local
			i: INTEGER
			l_row: !EV_GRID_ROW
			l_new: ES_TBT_GRID_TAGABLE [G]
		do
			from
				i := first_item_index
			until
				i = last_item_index or else ({l_data: ES_TBT_GRID_TAGABLE [G]} tree.row (i).data and then
					l_data.item.name > a_item.name)
			loop
				i := i + tree.row (i).subrow_count_recursive + 1
			end
			if is_root then
				tree.insert_new_row (i)
			else
				tree.insert_new_row_parented (i, row)
			end
			l_row ?= tree.row (i)
			if first_item_subrow = Void or else first_item_subrow.index > l_row.index then
				first_item_subrow := l_row
			end
			create l_new.make (l_row, a_item)
			Precursor (a_item)
		end

	remove_child (a_token: !STRING)
			-- <Precursor>
		local
			l_node: like child_for_token
		do
			l_node := child_for_token (a_token)
			tree.remove_row (l_node.row.index)
			Precursor (a_token)
		end

	remove_item (a_item: !G)
			-- <Precursor>
		local
			i: INTEGER
		do
			Precursor (a_item)
			from
				i := first_item_index
			until
				{l_data: ES_TBT_GRID_TAGABLE [G]} tree.row (i).data and then
					l_data.item = a_item
			loop
				i := i + tree.row (i).subrow_count_recursive + 1
			end
			if cached_items.is_empty then
				first_item_subrow := Void
			elseif tree.row (i) = first_item_subrow then
				first_item_subrow := tree.row (i + 1)
			end
			tree.remove_row (i)
		end

invariant
	contains_items_implies_subrow_attached: (is_evaluated and then not items.is_empty) implies
		first_item_subrow /= Void

end
