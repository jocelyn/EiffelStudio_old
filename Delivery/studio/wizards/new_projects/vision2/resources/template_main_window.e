indexing
	description	: "Main window for this application"
	status		: "Generated by the Vision2 Wizard"
	date		: "<FL_DATE>"
	revision	: "1.0.0"

class
	MAIN_WINDOW

inherit
	EV_TITLED_WINDOW
		redefine
			initialize
		end

	INTERFACE_NAMES
		export
			{NONE} all
		undefine
			default_create
		end

create
	default_create

feature {NONE} -- Initialization

	initialize is
		do
			Precursor {EV_TITLED_WINDOW}
<FL_MENUBAR_ADD><FL_TOOLBAR_ADD><FL_STATUSBAR_ADD>

			build_main_container
			extend (main_container)

			set_title (Window_title)
			set_size (400, 400)
		end

<FL_MENUBAR_INIT><FL_TOOLBAR_INIT><FL_STATUSBAR_INIT><FL_ABOUTDIALOG_INIT>
feature {NONE} -- Implementation

	main_container: EV_VERTICAL_BOX
			-- Main container (contains all widgets displayed in this window)

	build_main_container is
			-- Create and populate `main_container'.
		require
			main_container_not_yet_created: main_container = Void
		do
			create main_container
	
			main_container.extend (create {EV_TEXT})
		ensure
			main_container_created: main_container /= Void
		end

feature {NONE} -- Implementation / Constants

	Window_title: STRING is "my_project"
			-- Title of the window.

end -- class MAIN_WINDOW
