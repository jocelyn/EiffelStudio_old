indexing
	description: "Objects that represent an EV_DIALOG.%
		%The original version of this class was generated by EiffelBuild."
	date: "$Date$"
	revision: "$Revision$"

class
	TOC_NEW_DIALOG

inherit
	TOC_NEW_DIALOG_IMP
	
	SHARED_OBJECTS
		undefine
			copy,
			default_create
		end


feature {NONE} -- Initialization

	user_initialization is
			-- called by `initialize'.
			-- Any custom user initialization that
			-- could not be performed in `initialize',
			-- (due to regeneration of implementation class)
			-- can be added here.
		do
			okay_button.select_actions.extend (agent okay)
		end

feature {NONE} -- Implementation

	okay is
			-- Okay pressed
		do
			if project_radio.is_selected then
				Shared_toc_manager.build_toc (create {DIRECTORY}.make (Shared_project.root_directory))
			else
				Shared_toc_manager.new_toc
			end
			hide
		end
		

end -- class TOC_NEW_DIALOG

