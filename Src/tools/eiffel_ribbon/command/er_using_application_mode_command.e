note
	description: "[
					Using Application mode way or DLL way for multi Ribbon
					Windows in one applicaiton support?
																					]"
	date: "$Date$"
	revision: "$Revision$"

class
	ER_USING_APPLICATION_MODE_COMMAND

inherit
	ER_COMMAND

create
	make

feature {NONE} -- Initialization

	make (a_menu: EV_CHECK_MENU_ITEM)
			-- Creation method
		do
			init
			create shared_singleton
			menu_items.extend (a_menu)
		end

feature -- Command

	execute
			-- <Precursor>
		local
			l_constants: ER_MISC_CONSTANTS
			l_old_value: BOOLEAN
		do
			create l_constants
			l_old_value := l_constants.is_using_application_mode
			l_constants.set_using_application_mode (not l_old_value)

			update_gui
		end

	update_gui
			-- Update GUI with current states
		local
			l_constants: ER_MISC_CONSTANTS
		do
			if attached shared_singleton.main_window_cell.item as l_main_window then
				create l_constants
				if l_constants.is_using_application_mode then
					l_main_window.using_application_mode.enable_select
				else
					l_main_window.using_application_mode.disable_select
				end
			end
		end

feature {NONE} -- Implementation

	shared_singleton: ER_SHARED_SINGLETON
			--
end