indexing
	description	: "Root class for this application."
	status		: "Generated by the New Vision2 Application Wizard."
	date		: "$Date$"
	revision	: "1.0.0"

class
	APPLICATION

inherit
	EV_APPLICATION

create
	make_and_launch 

feature {NONE} -- Initialization

	make_and_launch is
			-- Initialize and launch application
		do
			default_create
			prepare
			launch
		end

	prepare is
			-- Prepare the first window to be displayed.
			-- Perform one call to first window in order to
			-- avoid to violate the invariant of class EV_APPLICATION.
		do
				-- create and initialize the first window.
			create first_window

				-- End the application when the first window is closed.
				--| TODO: Remove this line if you don't want the application
				--|       to end when the first window is closed..
			first_window.close_actions.extend (~end_application)

				-- Show the first window.
				--| TODO: Remove this line if you don't want the first 
				--|       window to be shown at the start of the program.
			first_window.show
		end

feature {NONE} -- Implementation

	first_window: MAIN_WINDOW
			-- Main window.
	
	end_application is
			-- End the current application.
		do
			(create {EV_ENVIRONMENT}).application.destroy
		end

end -- class APPLICATION
