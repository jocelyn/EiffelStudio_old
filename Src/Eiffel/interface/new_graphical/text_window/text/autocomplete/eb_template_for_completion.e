note
	description: "A template to be inserted into the auto-complete list"
	author: "javierv"
	date: "$Date$"
	revision: "$Revision$"

class
	EB_TEMPLATE_FOR_COMPLETION

inherit
	EB_NAME_FOR_COMPLETION
		rename
			make as make_old
		redefine
			icon,
			tooltip_text,
			is_class,
			insert_name,
			grid_item,
			is_obsolete
		end

	PREFIX_INFIX_NAMES
		undefine
			out, copy, is_equal
		end

	EB_SHARED_EDITOR_TOKEN_UTILITY
		undefine
			out, copy, is_equal
		end

create
	make

create {EB_TEMPLATE_FOR_COMPLETION}
	make_old

feature {NONE} -- Initialization

	make (a_template: CODE_TEMPLATE; a_stone: FEATURE_STONE)
			-- Create and initialize a new completion template using `a_template' ...
		require
			a_stone_not_void: a_stone /= Void
			a_template_not_void: a_template /= Void
		do
			template := a_template
			make_old (a_template.definition.metadata.title)
			insert_name_internal := a_template.definition.metadata.title
			associated_template_definition := a_template.definition
			internal_stone := a_stone.twin
		ensure
			insert_name_internal_set: insert_name_internal = a_template.definition.metadata.title
			associated_template_definition_set: associated_template_definition = a_template.definition
		end

feature -- Access

	is_class: BOOLEAN = False
			-- Is completion feature a class, of course not.	

	insert_name: STRING_32
			-- Name to insert in editor
		do
			Result := insert_name_internal
		end

	template: CODE_TEMPLATE
			-- Full template to insert in editor

	code_text: STRING_32
			-- template code.
		local
			l_renderer: like template_renderer
		do
			l_renderer := template_renderer
			l_renderer.render_template (template, code_symbol_table)
				-- Note: it should be safe to use `l_renderer.code' directly without cloning the string.
			create Result.make_from_string (l_renderer.code)
			Result.append_character ('%N')
		end

	local_text: STRING_32
			-- Local text.
		local
			l_locals:  STRING_TABLE [TYPE_AS]
			l_arguments: STRING_TABLE [TYPE_A]
			l_code_tb: CODE_TEMPLATE_BUILDER
			l_value: CODE_SYMBOL_VALUE
			l_name: STRING_32
			n: NATURAL
		do
			create l_code_tb
			l_locals := l_code_tb.locals (e_feature)
			l_arguments := l_code_tb.arguments (e_feature)

			create Result.make_empty
			across
				local_definitions as ic
			loop
				if l_arguments /= Void and then l_arguments.has (ic.key) then
					if not l_code_tb.string_type_as_conformance (ic.item, l_locals.item (ic.key), class_c) then
						Result.append_string_general ("%N%T%T%T")
						Result.append_string_general (ic.key)
						Result.append (": ")
						Result.append_string_general (ic.item)
					else
						-- the current local variable does not conforms to the variable in the template
						-- for example b: STRING; b: INTEGER
						-- we generate a new variable name for the template.
					end
				elseif l_locals /= Void and then l_locals.has (ic.key) then
						-- the current local variable conforms to the variable in the template
					if not l_code_tb.string_type_as_conformance (ic.item, l_locals.item (ic.key), class_c) then
						-- the current local variable does not conforms to the variable in the template
						-- for example b: STRING; b: INTEGER
						-- we generate a new variable name for the template.
						from
							n := 1
							create l_name.make_from_string_general (ic.key)
							l_name.append_string_general (n.out)
						until
							not l_locals.has (l_name) and then not l_arguments.has (l_name)
						loop
							n := n + 1
							l_name.append_string_general (n.out)
						end
						if code_symbol_table.has_id (ic.key.as_string_32) then
							l_value := code_symbol_table.item (ic.key.as_string_32)
							l_value.set_value (l_name)
						end
						internal_code_symbol_table := code_symbol_table

						Result.append_string_general ("%N%T%T%T")
						Result.append_string_general (l_name)
						Result.append (": ")
						Result.append_string_general (ic.item)

					end
				else
					Result.append_string_general ("%N%T%T%T")
					Result.append_string_general (ic.key)
					Result.append (": ")
					Result.append_string_general (ic.item)
				end
			end
			Result.append_character ('%N')
		end

	local_definitions: STRING_TABLE [STRING]
			-- Local variables definitions for the given template.
		local
			l_declarations: like local_declarations
			l_cursor:  DS_BILINEAR_CURSOR [CODE_DECLARATION]
		do
			create Result.make (2)
			l_declarations := local_declarations
			l_cursor := l_declarations.new_cursor
			if not l_declarations.is_empty then
				from l_cursor.start until l_cursor.after loop
					if
						not l_cursor.item.is_built_in and then
						attached {CODE_LITERAL_DECLARATION} l_cursor.item as l_literal and then
						attached {CODE_OBJECT_DECLARATION} l_literal as l_object
					then
						Result.force (l_object.must_conform_to, l_object.id)
					end
					l_cursor.forth
				end
			end
		end

	local_declarations: DS_BILINEAR [CODE_DECLARATION]
			-- Declarations for a given code template.
		do
			Result := associated_template_definition.declarations.items
		end

	icon: EV_PIXMAP
			-- Associated icon based on data
		do
			Result := configuration_pixmaps.view_flat_icon
		end

	configuration_pixmaps: attached ES_CONFIGURATION_PIXMAPS
			-- Configuration system pixmaps (16px)
		once
			create Result.make ("16x16")
		end

	tooltip_text: STRING_32
			-- Text for tooltip of Current.  The tooltip shall display information which is not included in the
			-- actual output of Current.
		local
			l_text: STRING_32
		do
			create Result.make_empty
			if attached associated_template_definition.applicable_item then
				l_text := associated_template_definition.metadata.description
				Result.append (l_text)
			end

			if Result.is_empty then
				Result := string
			end
		end

	grid_item : EB_GRID_EDITOR_TOKEN_ITEM
			-- Corresponding grid item
		do
			create Result
			Result.set_overriden_fonts (label_font_table, label_font_height)
			Result.set_pixmap (icon)
			Result.set_text (insert_name)
		end


	associated_template_definition: CODE_TEMPLATE_DEFINITION
			-- Corresponding template definition.

feature -- Feature

	class_c: CLASS_C
			-- Compiled class
		do
			Result := internal_stone.e_class
		end

	class_i: CLASS_I
			-- Internal representation.

	e_feature: E_FEATURE
			--  Feature associated with stone.
		do
			Result := internal_stone.e_feature
		end

feature -- Status report

	set_class_i (a_class_i: like class_i)
		do
			class_i := a_class_i.twin
		end


	is_obsolete: BOOLEAN
			-- Is item obsolete?
		do
			Result := False
		end

feature -- Setting

	set_insert_name (a_name: like insert_name)
			-- Set `insert_name' with `a_name'.
		require
			a_name_attached: a_name /= Void
		do
			insert_name_internal := a_name.twin
		ensure
			insert_name_set: insert_name /= Void and then insert_name.is_equal (a_name)
		end

feature {NONE} -- Implementation: STONE

	internal_stone: FEATURE_STONE

feature {NONE} -- Implementation

	insert_name_internal: STRING_32

	create_code_symbol_table (a_template: CODE_TEMPLATE_DEFINITION): CODE_SYMBOL_TABLE
			-- Creates a symbol table for a given template.
		local
			l_builder: CODE_SYMBOL_TABLE_BUILDER
		do
			create l_builder.make (a_template)
			Result := l_builder.symbol_table
		end

	frozen template_renderer: CODE_TEMPLATE_STRING_RENDERER
			-- Renderer used for evaluating the code template.
		do
			if attached {like template_renderer} internal_template_renderer as l_renderer then
				Result := l_renderer
			else
				Result := create_template_renderer
				internal_template_renderer := Result
			end
		ensure
			result_consistent: Result = template_renderer
		end

	create_template_renderer: CODE_TEMPLATE_STRING_RENDERER
			-- Creates a new template renderer for code template evaluation
		do
			create Result
		end

	internal_template_renderer: detachable like template_renderer
			-- Cached version of `template_renderer'
			-- Note: Do not use directly!


	frozen code_symbol_table: CODE_SYMBOL_TABLE
			-- Symbol table used to evaluate the code template.
		do
			if attached {like code_symbol_table} internal_code_symbol_table as l_table then
				Result := l_table
			else
				Result := create_code_symbol_table (template.definition)
				internal_code_symbol_table := Result
			end
		ensure
			result_consistent: Result = code_symbol_table
		end

	internal_code_symbol_table: detachable like code_symbol_table
			-- Cached version of `code_symbol_table'
			-- Note: Do not use directly!

;note
	copyright:	"Copyright (c) 1984-2016, Eiffel Software"
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
			distributed in the hope that it will be useful, but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
		]"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"

end
