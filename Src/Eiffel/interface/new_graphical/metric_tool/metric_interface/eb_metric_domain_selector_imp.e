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
	EB_METRIC_DOMAIN_SELECTOR_IMP

inherit
	EV_HORIZONTAL_BOX
		redefine
			create_interface_objects, initialize, is_in_default_state
		end

feature {NONE}-- Initialization

	frozen initialize
			-- Initialize `Current'.
		do
			Precursor {EV_HORIZONTAL_BOX}

			
				-- Build widget structure.
			extend (main_area)
			main_area.extend (domain_area)
			domain_area.extend (domain_type_area)
			domain_area.extend (domain_manage_area)
			domain_manage_area.extend (domain_selector_area)
			domain_selector_area.extend (l_ev_vertical_box_1)
			l_ev_vertical_box_1.extend (domain_grid_area)
			l_ev_vertical_box_1.extend (toolbar_area)
			toolbar_area.extend (address_manager_toolbar)
			address_manager_toolbar.extend (open_address_manager_btn)
			toolbar_area.extend (l_ev_cell_1)
			toolbar_area.extend (domain_type_toolbar)
			domain_type_toolbar.extend (add_application_scope_btn)
			domain_type_toolbar.extend (add_input_scope_btn)
			domain_type_toolbar.extend (add_delayed_scope_btn)
			toolbar_area.extend (separator_toolbar)
			separator_toolbar.extend (l_ev_tool_bar_separator_1)
			toolbar_area.extend (add_item_toolbar)
			add_item_toolbar.extend (add_item_btn)
			toolbar_area.extend (remove_item_toolbar)
			remove_item_toolbar.extend (remove_item_btn)
			toolbar_area.extend (remove_all_toolbar)
			remove_all_toolbar.extend (remove_all_btn)
			domain_manage_area.extend (address_manager_area)

			domain_area.disable_item_expand (domain_type_area)
			domain_type_area.set_padding (5)
			domain_manage_area.disable_item_expand (address_manager_area)
			l_ev_vertical_box_1.disable_item_expand (toolbar_area)
			toolbar_area.disable_item_expand (address_manager_toolbar)
			toolbar_area.disable_item_expand (domain_type_toolbar)
			toolbar_area.disable_item_expand (separator_toolbar)
			toolbar_area.disable_item_expand (add_item_toolbar)
			toolbar_area.disable_item_expand (remove_item_toolbar)
			toolbar_area.disable_item_expand (remove_all_toolbar)

			set_all_attributes_using_constants

				-- Call `user_initialization'.
			user_initialization
		end
		
	frozen create_interface_objects
			-- Create objects
		do
			
				-- Create all widgets.
			create main_area
			create domain_area
			create domain_type_area
			create domain_manage_area
			create domain_selector_area
			create l_ev_vertical_box_1
			create domain_grid_area
			create toolbar_area
			create address_manager_toolbar
			create open_address_manager_btn
			create l_ev_cell_1
			create domain_type_toolbar
			create add_application_scope_btn
			create add_input_scope_btn
			create add_delayed_scope_btn
			create separator_toolbar
			create l_ev_tool_bar_separator_1
			create add_item_toolbar
			create add_item_btn
			create remove_item_toolbar
			create remove_item_btn
			create remove_all_toolbar
			create remove_all_btn
			create address_manager_area

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

	main_area, domain_type_area, domain_selector_area, toolbar_area: EV_HORIZONTAL_BOX
	domain_area, domain_manage_area: EV_VERTICAL_BOX
	domain_grid_area,
	address_manager_area: EV_CELL
	address_manager_toolbar, domain_type_toolbar, separator_toolbar,
	add_item_toolbar, remove_item_toolbar, remove_all_toolbar: EV_TOOL_BAR
	open_address_manager_btn,
	add_application_scope_btn, add_input_scope_btn, add_delayed_scope_btn, add_item_btn,
	remove_item_btn, remove_all_btn: EV_TOOL_BAR_BUTTON

feature {NONE} -- Implementation

	l_ev_vertical_box_1: EV_VERTICAL_BOX
	l_ev_cell_1: EV_CELL
	l_ev_tool_bar_separator_1: EV_TOOL_BAR_SEPARATOR

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

feature {NONE} -- Constant setting

	frozen set_attributes_using_string_constants
			-- Set all attributes relying on string constants to the current
			-- value of the associated constant.
		local
			s: STRING_32
		do
			from
				string_constant_set_procedures.start
			until
				string_constant_set_procedures.off
			loop
				s := string_constant_retrieval_functions.i_th (string_constant_set_procedures.index).item (Void)
				string_constant_set_procedures.item.call ([s])
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
				i := integer_constant_retrieval_functions.i_th (integer_constant_set_procedures.index).item (Void)
				integer_constant_set_procedures.item.call ([i])
				integer_constant_set_procedures.forth
			end
			from
				integer_interval_constant_retrieval_functions.start
				integer_interval_constant_set_procedures.start
			until
				integer_interval_constant_retrieval_functions.off
			loop
				arg1 := integer_interval_constant_retrieval_functions.item.item (Void)
				integer_interval_constant_retrieval_functions.forth
				arg2 := integer_interval_constant_retrieval_functions.item.item (Void)
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
			p: EV_PIXMAP
		do
			from
				pixmap_constant_set_procedures.start
			until
				pixmap_constant_set_procedures.off
			loop
				p := pixmap_constant_retrieval_functions.i_th (pixmap_constant_set_procedures.index).item (Void)
				pixmap_constant_set_procedures.item.call ([p])
				pixmap_constant_set_procedures.forth
			end
		end

	frozen set_attributes_using_font_constants
			-- Set all attributes relying on font constants to the current
			-- value of the associated constant.
		local
			f: EV_FONT
		do
			from
				font_constant_set_procedures.start
			until
				font_constant_set_procedures.off
			loop
				f := font_constant_retrieval_functions.i_th (font_constant_set_procedures.index).item (Void)
				font_constant_set_procedures.item.call ([f])
				font_constant_set_procedures.forth
			end	
		end

	frozen set_attributes_using_color_constants
			-- Set all attributes relying on color constants to the current
			-- value of the associated constant.
		local
			c: EV_COLOR
		do
			from
				color_constant_set_procedures.start
			until
				color_constant_set_procedures.off
			loop
				c := color_constant_retrieval_functions.i_th (color_constant_set_procedures.index).item (Void)
				color_constant_set_procedures.item.call ([c])
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
