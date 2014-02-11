note
	description: "[
		Objects that represent an EV_TITLED_WINDOW.
		The original version of this class was generated by EiffelBuild.
		This class is the implementation of an EV_TITLED_WINDOW generated by EiffelBuild.
		You should not modify this code by hand, as it will be re-generated every time
		 modifications are made to the project.
		 	]"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SD_ZONE_NAVIGATION_DIALOG_IMP

inherit
	EV_POPUP_WINDOW
		redefine
			initialize, is_in_default_state
		end

feature {NONE}-- Initialization

	initialize
			-- Initialize `Current'
		local
			internal_font: EV_FONT
			l_vertical_box: EV_VERTICAL_BOX
			l_shared: SD_SHARED
		do
			create l_shared

			Precursor {EV_POPUP_WINDOW}

				-- Build widget structure
			extend (internal_vertical_box_top_top)
			internal_vertical_box_top_top.extend (internal_vertical_box_top)
			internal_vertical_box_top.extend (internal_label_box)
			internal_vertical_box_top.disable_item_expand (internal_label_box)
			create l_vertical_box
			internal_label_box.extend (l_vertical_box)
			l_vertical_box.extend (internal_tools_label)
			l_vertical_box.disable_item_expand (internal_tools_label)
			l_vertical_box.extend (scroll_area_tools)
			l_vertical_box.disable_item_expand (scroll_area_tools)
			scroll_area_tools.extend (internal_tools_box)

			internal_tools_box.extend (tools_column)
			internal_tools_box.disable_item_expand (tools_column)
			create l_vertical_box
			internal_label_box.extend (l_vertical_box)
			l_vertical_box.extend (internal_files_label)
			l_vertical_box.disable_item_expand (internal_files_label)
			l_vertical_box.extend (scroll_area_files)
			l_vertical_box.disable_item_expand (scroll_area_files)
			scroll_area_files.extend (internal_files_box)

			internal_files_box.extend (files_column)
			internal_files_box.disable_item_expand (files_column)
			internal_vertical_box_top.extend (internal_info_box_border)
			internal_vertical_box_top.disable_item_expand (internal_info_box_border)
			internal_info_box_border.extend (internal_info_box)
			internal_info_box.extend (full_title)
			internal_info_box.extend (description)
			internal_info_box.extend (detail)

			create internal_font
			internal_font.set_family ({EV_FONT_CONSTANTS}.Family_sans)
			internal_font.set_weight ({EV_FONT_CONSTANTS}.Weight_bold)
			internal_font.set_shape ({EV_FONT_CONSTANTS}.Shape_regular)
			internal_font.set_height_in_points (8)
			internal_font.preferred_families.extend ("Microsoft Sans Serif")
			internal_tools_label.set_font (internal_font)
			internal_tools_label.set_text (l_shared.interface_names.Zone_navigation_left_column_name)
			create internal_font
			internal_font.set_family ({EV_FONT_CONSTANTS}.Family_sans)
			internal_font.set_weight ({EV_FONT_CONSTANTS}.Weight_bold)
			internal_font.set_shape ({EV_FONT_CONSTANTS}.Shape_regular)
			internal_font.set_height_in_points (8)
			internal_font.preferred_families.extend ("Microsoft Sans Serif")
			internal_files_label.set_font (internal_font)
			internal_files_label.set_text (l_shared.interface_names.Zone_navigation_right_column_name)
			internal_info_box.disable_item_expand (full_title)
			internal_info_box.disable_item_expand (description)
			internal_info_box.disable_item_expand (detail)
			full_title.align_text_left
			description.align_text_left
			detail.align_text_left
			set_title ("SD_ZONE_NAVIGATION_DIALOG_IMP")

			set_all_attributes_using_constants

				-- Connect events.
				-- Close the application when an interface close
				-- request is received on `Current'. i.e. the cross is clicked

				-- Call `user_initialization'.
			user_initialization

			create internal_shared
		end

feature -- Access

	scroll_area_tools, scroll_area_files: EV_SCROLLABLE_AREA

	internal_label_box: EV_HORIZONTAL_BOX
	tools_column, files_column: SD_TOOL_BAR

	internal_info_box_border: EV_VERTICAL_BOX
	internal_vertical_box_top, internal_info_box: EV_VERTICAL_BOX
	internal_tools_box, internal_files_box: EV_HORIZONTAL_BOX
	internal_tools_label, internal_files_label, full_title,
	description, detail: EV_LABEL

	internal_vertical_box_top_top: EV_HORIZONTAL_BOX

feature {NONE} -- Implementation

	is_in_default_state: BOOLEAN
			-- Is `Current' in its default state?
		do
			-- Re-implement if you wish to enable checking
			-- for `Current'
			Result := True
		end

	user_initialization
			-- Feature for custom initialization, called at end of `initialize'
		deferred
		end

feature {NONE} -- Constant setting

	set_attributes_using_string_constants
			-- Set all attributes relying on string constants to the current
			-- value of the associated constant
		local
			l_s: detachable READABLE_STRING_GENERAL
		do
			from
				string_constant_set_procedures.start
			until
				string_constant_set_procedures.off
			loop
				string_constant_retrieval_functions.i_th (string_constant_set_procedures.index).call (Void)
				l_s := string_constant_retrieval_functions.i_th (string_constant_set_procedures.index).last_result
				if l_s /= Void then
					string_constant_set_procedures.item.call ([l_s])
				end
				string_constant_set_procedures.forth
			end
		end

	set_attributes_using_integer_constants
			-- Set all attributes relying on integer constants to the current
			-- value of the associated constant
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

	set_attributes_using_pixmap_constants
			-- Set all attributes relying on pixmap constants to the current
			-- value of the associated constant
		local
			l_p: detachable EV_PIXMAP
		do
			from
				pixmap_constant_set_procedures.start
			until
				pixmap_constant_set_procedures.off
			loop
				pixmap_constant_retrieval_functions.i_th (pixmap_constant_set_procedures.index).call (Void)
				l_p := pixmap_constant_retrieval_functions.i_th (pixmap_constant_set_procedures.index).last_result
				if l_p /= Void then
					pixmap_constant_set_procedures.item.call ([l_p])
				end
				pixmap_constant_set_procedures.forth
			end
		end

	set_attributes_using_font_constants
			-- Set all attributes relying on font constants to the current
			-- value of the associated constant
		local
			l_f: detachable EV_FONT
		do
			from
				font_constant_set_procedures.start
			until
				font_constant_set_procedures.off
			loop
				font_constant_retrieval_functions.i_th (font_constant_set_procedures.index).call (Void)
				l_f := font_constant_retrieval_functions.i_th (font_constant_set_procedures.index).last_result
				if l_f /= Void then
					font_constant_set_procedures.item.call ([l_f])
				end
				font_constant_set_procedures.forth
			end
		end

	set_attributes_using_color_constants
			-- Set all attributes relying on color constants to the current
			-- value of the associated constant
		local
			l_c: detachable EV_COLOR
		do
			from
				color_constant_set_procedures.start
			until
				color_constant_set_procedures.off
			loop
				color_constant_retrieval_functions.i_th (color_constant_set_procedures.index).call (Void)
				l_c := color_constant_retrieval_functions.i_th (color_constant_set_procedures.index).last_result
				if l_c /= Void then
					color_constant_set_procedures.item.call ([l_c])
				end
				color_constant_set_procedures.forth
			end
		end

	set_all_attributes_using_constants
			-- Set all attributes relying on constants to the current
			-- calue of the associated constant
		do
			set_attributes_using_string_constants
			set_attributes_using_integer_constants
			set_attributes_using_pixmap_constants
			set_attributes_using_font_constants
			set_attributes_using_color_constants
		end

	string_constant_set_procedures: ARRAYED_LIST [PROCEDURE [ANY, TUPLE [READABLE_STRING_GENERAL]]]
	string_constant_retrieval_functions: ARRAYED_LIST [FUNCTION [ANY, TUPLE, READABLE_STRING_GENERAL]]
	integer_constant_set_procedures: ARRAYED_LIST [PROCEDURE [ANY, TUPLE [INTEGER]]]
	integer_constant_retrieval_functions: ARRAYED_LIST [FUNCTION [ANY, TUPLE, INTEGER]]
	pixmap_constant_set_procedures: ARRAYED_LIST [PROCEDURE [ANY, TUPLE [EV_PIXMAP]]]
	pixmap_constant_retrieval_functions: ARRAYED_LIST [FUNCTION [ANY, TUPLE, EV_PIXMAP]]
	integer_interval_constant_retrieval_functions: ARRAYED_LIST [FUNCTION [ANY, TUPLE, INTEGER]]
	integer_interval_constant_set_procedures: ARRAYED_LIST [PROCEDURE [ANY, TUPLE [INTEGER_INTERVAL]]]
	font_constant_set_procedures: ARRAYED_LIST [PROCEDURE [ANY, TUPLE [EV_FONT]]]
	font_constant_retrieval_functions: ARRAYED_LIST [FUNCTION [ANY, TUPLE, EV_FONT]]
	color_constant_set_procedures: ARRAYED_LIST [PROCEDURE [ANY, TUPLE [EV_COLOR]]]
	color_constant_retrieval_functions: ARRAYED_LIST [FUNCTION [ANY, TUPLE, EV_COLOR]]

	integer_from_integer (an_integer: INTEGER): INTEGER
			-- Return `an_integer', used for creation of
			-- an agent that returns a fixed integer value
		do
			Result := an_integer
		end

feature {NONE}  -- Implementation

	internal_shared: SD_SHARED
			-- All singletons

invariant

	internal_shared_not_void: internal_shared /= Void

note
	library:	"SmartDocking: Library of reusable components for Eiffel."
	copyright:	"Copyright (c) 1984-2006, Eiffel Software and others"
	license:	"Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			 Eiffel Software
			 356 Storke Road, Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"






end -- class SD_ZONE_NAVIGATION_DIALOG_IMP
