note
	description: "[
		Objects that represent an EV_TITLED_WINDOW.
		The original version of this class was generated by EiffelBuild.
		This class is the implementation of an EV_TITLED_WINDOW generated by EiffelBuild.
		You should not modify this code by hand, as it will be re-generated every time
		 modifications are made to the project.
		 	]"
	generator: "EiffelBuild"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ER_MAIN_WINDOW_IMP

inherit
	EV_TITLED_WINDOW
		redefine
			create_interface_objects, initialize, is_in_default_state
		end
			
	CONSTANTS
		undefine
			is_equal, default_create, copy
		end

feature {NONE}-- Initialization

	frozen initialize
			-- Initialize `Current'.
		do
			Precursor {EV_TITLED_WINDOW}
			initialize_constants

			
				-- Build widget structure.
			set_menu_bar (l_ev_menu_bar_1)
			l_ev_menu_bar_1.extend (l_ev_menu_2)
			l_ev_menu_2.extend (new_project_menu)
			l_ev_menu_2.extend (open_project_menu)
			l_ev_menu_2.extend (save_project_menu)
			l_ev_menu_2.extend (l_ev_menu_separator_1)
			l_ev_menu_2.extend (new_ribbon_menu)
			l_ev_menu_2.extend (recent_projects)
			l_ev_menu_2.extend (l_ev_menu_separator_2)
			l_ev_menu_2.extend (exit_menu)
			l_ev_menu_bar_1.extend (l_ev_menu_5)
			l_ev_menu_5.extend (using_application_mode)

			l_ev_menu_2.set_text ("File")
			new_project_menu.set_text ("New Project")
			open_project_menu.set_text ("Open Project")
			save_project_menu.set_text ("Save Project")
			new_ribbon_menu.set_text ("New Ribbon")
			recent_projects.set_text ("Recent Projects")
			exit_menu.set_text ("Exit")
			l_ev_menu_5.set_text ("Project")
			using_application_mode.set_text ("Using Application Mode")
			set_title ("EiffelRibbon")

			set_all_attributes_using_constants
			
				-- Connect events.
			new_project_menu.select_actions.extend (agent on_new_project_selected)
			open_project_menu.select_actions.extend (agent on_open_project_selected)
			save_project_menu.select_actions.extend (agent on_save_project_selected)
			new_ribbon_menu.select_actions.extend (agent on_new_ribbon_selected)
			exit_menu.select_actions.extend (agent on_exit_selected)
			using_application_mode.select_actions.extend (agent on_using_application_mode_selected)
				-- Close the application when an interface close
				-- request is received on `Current'. i.e. the cross is clicked.
			close_request_actions.extend (agent destroy_and_exit_if_last)

				-- Call `user_initialization'.
			user_initialization
		end
		
	frozen create_interface_objects
			-- Create objects
		do
			
				-- Create all widgets.
			create l_ev_menu_bar_1
			create l_ev_menu_2
			create new_project_menu
			create open_project_menu
			create save_project_menu
			create l_ev_menu_separator_1
			create new_ribbon_menu
			create recent_projects
			create l_ev_menu_separator_2
			create exit_menu
			create l_ev_menu_5
			create using_application_mode

			create string_constant_set_procedures.make (10)
			create string_constant_retrieval_functions.make (10)
			create integer_constant_set_procedures.make (10)
			create integer_constant_retrieval_functions.make (10)
			create pixmap_constant_set_procedures.make (10)
			create pixmap_constant_retrieval_functions.make (10)
			create integer_interval_constant_retrieval_functions.make (10)
			create integer_interval_constant_set_procedures.make (10)
			create font_constant_set_procedures.make (10)
			create font_constant_retrieval_functions.make (10)
			create pixmap_constant_retrieval_functions.make (10)
			create color_constant_set_procedures.make (10)
			create color_constant_retrieval_functions.make (10)
			user_create_interface_objects
		end


feature -- Access

	new_project_menu, open_project_menu, save_project_menu, new_ribbon_menu, exit_menu: EV_MENU_ITEM
	recent_projects: EV_MENU
	using_application_mode: EV_CHECK_MENU_ITEM

feature {NONE} -- Implementation

	l_ev_menu_bar_1: EV_MENU_BAR
	l_ev_menu_2, l_ev_menu_5: EV_MENU
	l_ev_menu_separator_1, l_ev_menu_separator_2: EV_MENU_SEPARATOR

feature {NONE} -- Implementation

	is_in_default_state: BOOLEAN
			-- Is `Current' in its default state?
		do
			Result := True
		end

	user_create_interface_objects
			-- Feature for custom user interface object creation, called at end of `create_interface_objects'.
		deferred
		end

	user_initialization
			-- Feature for custom initialization, called at end of `initialize'.
		deferred
		end
	
	on_new_project_selected
			-- Called by `select_actions' of `new_project_menu'.
		deferred
		end
	
	on_open_project_selected
			-- Called by `select_actions' of `open_project_menu'.
		deferred
		end
	
	on_save_project_selected
			-- Called by `select_actions' of `save_project_menu'.
		deferred
		end
	
	on_new_ribbon_selected
			-- Called by `select_actions' of `new_ribbon_menu'.
		deferred
		end
	
	on_exit_selected
			-- Called by `select_actions' of `exit_menu'.
		deferred
		end
	
	on_using_application_mode_selected
			-- Called by `select_actions' of `using_application_mode'.
		deferred
		end
	

feature {NONE} -- Constant setting

	frozen set_attributes_using_string_constants
			-- Set all attributes relying on string constants to the current
			-- value of the associated constant.
		local
			s: detachable STRING_32
		do
			from
				string_constant_set_procedures.start
			until
				string_constant_set_procedures.off
			loop
				string_constant_retrieval_functions.i_th (string_constant_set_procedures.index).call (Void)
				s := string_constant_retrieval_functions.i_th (string_constant_set_procedures.index).last_result
				if s /= Void then
					string_constant_set_procedures.item.call ([s])
				end
				string_constant_set_procedures.forth
			end
		end

	frozen set_attributes_using_integer_constants
			-- Set all attributes relying on integer constants to the current
			-- value of the associated constant.
		local
			i: INTEGER
			arg1, arg2: INTEGER
			int: INTEGER_INTERVAL
		do
			from
				integer_constant_set_procedures.start
			until
				integer_constant_set_procedures.off
			loop
				integer_constant_retrieval_functions.i_th (integer_constant_set_procedures.index).call (Void)
				i := integer_constant_retrieval_functions.i_th (integer_constant_set_procedures.index).last_result
				integer_constant_set_procedures.item.call ([i])
				integer_constant_set_procedures.forth
			end
			from
				integer_interval_constant_retrieval_functions.start
				integer_interval_constant_set_procedures.start
			until
				integer_interval_constant_retrieval_functions.off
			loop
				integer_interval_constant_retrieval_functions.item.call (Void)
				arg1 := integer_interval_constant_retrieval_functions.item.last_result
				integer_interval_constant_retrieval_functions.forth
				integer_interval_constant_retrieval_functions.item.call (Void)
				arg2 := integer_interval_constant_retrieval_functions.item.last_result
				create int.make (arg1, arg2)
				integer_interval_constant_set_procedures.item.call ([int])
				integer_interval_constant_retrieval_functions.forth
				integer_interval_constant_set_procedures.forth
			end
		end

	frozen set_attributes_using_pixmap_constants
			-- Set all attributes relying on pixmap constants to the current
			-- value of the associated constant.
		local
			p: detachable EV_PIXMAP
		do
			from
				pixmap_constant_set_procedures.start
			until
				pixmap_constant_set_procedures.off
			loop
				pixmap_constant_retrieval_functions.i_th (pixmap_constant_set_procedures.index).call (Void)
				p := pixmap_constant_retrieval_functions.i_th (pixmap_constant_set_procedures.index).last_result
				if p /= Void then
					pixmap_constant_set_procedures.item.call ([p])
				end
				pixmap_constant_set_procedures.forth
			end
		end

	frozen set_attributes_using_font_constants
			-- Set all attributes relying on font constants to the current
			-- value of the associated constant.
		local
			f: detachable EV_FONT
		do
			from
				font_constant_set_procedures.start
			until
				font_constant_set_procedures.off
			loop
				font_constant_retrieval_functions.i_th (font_constant_set_procedures.index).call (Void)
				f := font_constant_retrieval_functions.i_th (font_constant_set_procedures.index).last_result
				if f /= Void then
					font_constant_set_procedures.item.call ([f])
				end
				font_constant_set_procedures.forth
			end	
		end

	frozen set_attributes_using_color_constants
			-- Set all attributes relying on color constants to the current
			-- value of the associated constant.
		local
			c: detachable EV_COLOR
		do
			from
				color_constant_set_procedures.start
			until
				color_constant_set_procedures.off
			loop
				color_constant_retrieval_functions.i_th (color_constant_set_procedures.index).call (Void)
				c := color_constant_retrieval_functions.i_th (color_constant_set_procedures.index).last_result
				if c /= Void then
					color_constant_set_procedures.item.call ([c])
				end
				color_constant_set_procedures.forth
			end
		end

	frozen set_all_attributes_using_constants
			-- Set all attributes relying on constants to the current
			-- calue of the associated constant.
		do
			set_attributes_using_string_constants
			set_attributes_using_integer_constants
			set_attributes_using_pixmap_constants
			set_attributes_using_font_constants
			set_attributes_using_color_constants
		end
	
	string_constant_set_procedures: ARRAYED_LIST [PROCEDURE [READABLE_STRING_GENERAL]]
	string_constant_retrieval_functions: ARRAYED_LIST [FUNCTION [STRING_32]]
	integer_constant_set_procedures: ARRAYED_LIST [PROCEDURE [INTEGER]]
	integer_constant_retrieval_functions: ARRAYED_LIST [FUNCTION [INTEGER]]
	pixmap_constant_set_procedures: ARRAYED_LIST [PROCEDURE [EV_PIXMAP]]
	pixmap_constant_retrieval_functions: ARRAYED_LIST [FUNCTION [EV_PIXMAP]]
	integer_interval_constant_retrieval_functions: ARRAYED_LIST [FUNCTION [INTEGER]]
	integer_interval_constant_set_procedures: ARRAYED_LIST [PROCEDURE [INTEGER_INTERVAL]]
	font_constant_set_procedures: ARRAYED_LIST [PROCEDURE [EV_FONT]]
	font_constant_retrieval_functions: ARRAYED_LIST [FUNCTION [EV_FONT]]
	color_constant_set_procedures: ARRAYED_LIST [PROCEDURE [EV_COLOR]]
	color_constant_retrieval_functions: ARRAYED_LIST [FUNCTION [EV_COLOR]]

	frozen integer_from_integer (an_integer: INTEGER): INTEGER
			-- Return `an_integer', used for creation of
			-- an agent that returns a fixed integer value.
		do
			Result := an_integer
		end

end
