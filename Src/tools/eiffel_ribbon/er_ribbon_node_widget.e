note
	description: "EiffelVision Widget ER_RIBBON_NODE_WIDGET.%
		%The original version of this class was generated by EiffelBuild."
	generator: "EiffelBuild"
	date: "$Date$"
	revision: "$Revision$"

class
	ER_RIBBON_NODE_WIDGET

inherit
	ER_RIBBON_NODE_WIDGET_IMP


feature {NONE} -- Initialization

	user_create_interface_objects
			-- Create any auxilliary objects needed for ER_RIBBON_NODE_WIDGET.
			-- Initialization for these objects must be performed in `user_initialization'.
		do
				-- Create attached types defined in class here, initialize them in `user_initialization'.
		end

	user_initialization
			-- Perform any initialization on objects created by `user_create_interface_objects'
			-- and from within current class itself.
		do
				-- Initialize types defined in current class
		end

feature -- Command

	set_tree_node_data (a_data: detachable ER_TREE_NODE_RIBBON_DATA)
			--
		do
			tree_node_data := a_data
			if attached a_data as l_data then
				if attached a_data.command_name as l_command_name then
					command_name.set_text (l_command_name)
				else
					command_name.remove_text
				end
			end
		end

feature -- Query

	tree_node_data: detachable ER_TREE_NODE_RIBBON_DATA
			--

feature {NONE} -- Implementation

	on_command_name_text_change
			-- <Precursor>
		local
			l_checker: ER_IDENTIFIER_UNIQUENESS_CHECKER
		do
			create l_checker
			l_checker.on_identifier_name_change (command_name, tree_node_data)
		end

end
