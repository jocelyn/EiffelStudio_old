indexing
	description: "Objects that represent an EV_TITLED_WINDOW generated by Build."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MAIN_WINDOW

inherit
	MAIN_WINDOW_IMP

feature {NONE} -- Implementation

	user_initialization is
			-- Called by `select_actions' of `execute'.
		local
			tree: TREE_FACTORY
			edit: EDIT_FACTORY
		do
			set_width (800)
			set_height (600)
			create tree.make (Current)
			tree.initialize
			show_actions.extend (agent l_horizontal_split_area_1.set_split_position (300))
			show_actions.extend (agent l_vertical_split_area.set_split_position (380))

			create edit.make (Current)
			l_vertical_scroll_bar_1.change_actions.force_extend (agent edit.color_refresh_type)
			l_horizontal_scroll_bar_1.change_actions.force_extend (agent edit.color_refresh_type)

			notebook.selection_actions.extend (agent on_change_notebook)

				-- pick and drop actions.
			color_edit_area.set_pick_and_drop_mode

				-- Menu
			find_net_feature_item.disable_sensitive
			import_item.disable_sensitive
			remove_assembly_item.disable_sensitive
			edit_type_item.disable_sensitive
			
				-- noteBook
			--notebook.last.disable_sensitive
		end

feature {NONE} -- Menu actions

	on_print is
			-- Called by `resize_actions' of `Current'.
		local
			print_dlg: EV_PRINT_DIALOG
		do
			create print_dlg
			print_dlg.print_actions.extend (agent ok_print (print_dlg))
			print_dlg.show_modal_to_window (Current)
		end

	ok_print (a_print_dialog: EV_PRINT_DIALOG) is
			-- Action performed when ok is clicked in `print_dlg'.
		local
			l_context: EV_PRINT_CONTEXT
			l_figure_list: EV_FIGURE_WORLD
			l_print_projector: EV_PRINT_PROJECTOR
			l_figure: EV_FIGURE_PICTURE
			l_print_area: EV_PIXMAP
			
			l_current_assembly: CONSUMED_ASSEMBLY
			l_current_type: CONSUMED_TYPE
		do
			l_current_assembly := (create {SESSION}).current_assembly
			l_current_type := (create {SESSION}).current_type
			
			if l_current_type /= Void then
				l_context := a_print_dialog.print_context
				create l_figure_list.default_create
				create l_print_area.default_create;
				l_print_area.set_size (300, 300)
				(create {PRINT_DISPLAY}.make (l_print_area)).print_type (l_current_assembly, l_current_type.dotnet_name)
				--(create {PRINT_DISPLAY}.make (l_print_area)).print_type (current_assembly, "System.Array")
				--l_print_area := clone (color_edit_area)
				color_edit_area := l_print_area
				create l_figure.make_with_pixmap (l_print_area)
				l_figure.set_pixmap (l_print_area)
				l_figure_list.extend (l_figure)
				create l_print_projector.make_with_context (l_figure_list, l_context)
				l_print_projector.project
			end
		end

	on_exit is
			-- Called by `select_actions' of `exit_item'.
		do
			((create {EV_ENVIRONMENT}).application).destroy
		end

	on_find_net_feature is
			-- Called by `select_actions' of `find_net_feature_item'.
		local
			titi: FIND_EIFFEL_FEATURE_NAME_DIALOG
		do
			create titi
			titi.set_parent_window (Current)
			titi.show_relative_to_window (Current)
		end

	on_find_eiffel_feature is
			-- Called by `select_actions' of `find_eiffel_feature_item'.
		local
			find_eiffel_feature_dlg: FIND_EIFFEL_FEATURE_NAME_DIALOG
		do
			create find_eiffel_feature_dlg
			find_eiffel_feature_dlg.set_parent_window (Current)
			find_eiffel_feature_dlg.show_relative_to_window (Current)
		end

	on_import_assembly is
			-- Called by `select_actions' of `import_item'.
		local
			file_dialog: EV_FILE_OPEN_DIALOG
		do
			create file_dialog
			file_dialog.set_filter ("*.dll")
			file_dialog.set_title ("Import assembly")
			file_dialog.show_modal_to_window (Current)
		end

	on_remove_assembly is
			-- Called by `select_actions' of `remove_assembly_item'.
		local
			remove_assembly_dialog: REMOVE_ASSEMBLY_DIALOG
		do
			create remove_assembly_dialog
			remove_assembly_dialog.show_modal_to_window (Current)
		end

	on_edit_type is
			-- Called by `select_actions' of `edit_type_item'.
		local
			dialog_box: CHANGE_EIFFEL_FEATURE_NAME_DIALOG
		do
			create dialog_box
			dialog_box.show_modal_to_window (Current)
		end

	on_about is
			-- Display the About dialog.
		local
			about_dialog: ABOUT_DIALOG
		do
			create about_dialog
			about_dialog.show_modal_to_window (Current)
		end

	on_resize (a_x, a_y, a_width, a_height: INTEGER) is
			-- Called by `resize_actions'.
		local
			edit: EDIT_FACTORY
		do
			if color_edit_area.is_displayed then
				if edit_area_box.width - l_vertical_scroll_bar_1.width > 0 and edit_area_box.height > 0 then
					color_edit_area.set_size (edit_area_box.width - l_vertical_scroll_bar_1.width, edit_area_box.height)
					create edit.make (Current)
					edit.color_refresh_type
				end
			end
		end

	on_resize_split_area is
			-- Called by `resize_actions'.
		do
			on_resize (0,0,0,0)
		end

	on_change_notebook is
		do
			if notebook.selected_item = informations then
				on_resize (0,0,0,0)
			end
		end

indexing
	copyright:	"Copyright (c) 1984-2006, Eiffel Software"
	license:	"GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options:	"http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful,	but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the	GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301  USA
		]"
	source: "[
			 Eiffel Software
			 356 Storke Road, Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"


end -- class MAIN_WINDOW

