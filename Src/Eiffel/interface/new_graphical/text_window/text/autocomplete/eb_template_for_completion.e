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
			make as make_old,
			code as code_completion
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

	EB_SHARED_PIXMAPS
		undefine
			out, copy, is_equal
		end

create
	make

create {EB_TEMPLATE_FOR_COMPLETION}
	make_old

feature {NONE} -- Initialization

	make (a_template: CODE_TEMPLATE; a_stone: FEATURE_STONE; a_target: STRING_32)
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
			target_name := a_target
		ensure
			insert_name_internal_set: insert_name_internal = a_template.definition.metadata.title
			associated_template_definition_set: associated_template_definition = a_template.definition
			target_set: target_name = a_target
		end

feature -- Test


feature -- Access

	target_name:  STRING_32
			-- Target name where we want to apply code completion.

	is_class: BOOLEAN = False
			-- Is completion feature a class, of course not.	

	insert_name: STRING_32
			-- Name to insert in editor
		do
			Result := insert_name_internal
		end

	template: CODE_TEMPLATE
			-- Full template to insert in editor

	code_texts: TUPLE [locals: STRING_32; code: STRING_32]
			-- Local and code from template.
		local
			l_locals: STRING_32
			l_code: STRING_32
		do
			l_locals := locals
			l_code := code
			add_comments (l_code)
			if attached update_tokens (l_code, l_locals) as l_new_code then
				Result := [l_locals, l_new_code]
			else
				Result := [l_locals, l_code]
			end
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
			Result := icon_pixmaps.information_affected_resource_icon
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

feature {NONE} -- String Utility

	new_name (a_string: STRING_32): STRING_32
			-- Create a new name
		local
			l_r: RANDOM
			i: INTEGER
			l_time: TIME
			l_seed: INTEGER
		do
			create l_time.make_now
		    l_seed := l_time.hour
		    l_seed := l_seed * 60 + l_time.minute
		    l_seed := l_seed * 60 + l_time.second
		    l_seed := l_seed * 1000 + l_time.milli_second
		  	create l_r.set_seed (l_seed)

		   	i:= l_r.item \\ 20
			create Result.make_from_string (a_string)
			Result.append (i.out)
		end

	new_name_locals(a_string: STRING_32): STRING_32
			-- Create a new name
		local
			l_r: RANDOM
			i: INTEGER
			l_time: TIME
			l_seed: INTEGER
		do
			create l_time.make_now
		    l_seed := l_time.hour
		    l_seed := l_seed * 60 + l_time.minute
		    l_seed := l_seed * 60 + l_time.second
		    l_seed := l_seed * 1000 + l_time.milli_second
		  	create l_r.set_seed (l_seed)

		   	i:= (l_r.item \\ 20) + 21
			create Result.make_from_string (a_string)
			Result.append (i.out)
		end


feature {NONE} -- Template implementation.

	code: STRING_32
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
		do
			create Result.make_empty
			across
					local_definitions as ic

			loop
				Result.append_string_general ("%N%T%T%T")
				Result.append_string_general (ic.key)
				Result.append (": ")
				Result.append_string_general (ic.item)
			end
		end

	locals: STRING_32
			-- Local text.
		local
			l_locals:  STRING_TABLE [TYPE_AS]
			l_arguments: STRING_TABLE [TYPE_A]
			l_read_only_locals: STRING_TABLE [STRING]
			l_code_tb: CODE_TEMPLATE_BUILDER
			l_value: CODE_SYMBOL_VALUE
			l_name: STRING_32
			l_context_name: READABLE_STRING_GENERAL
		do
				l_context_name := context_variable_name

					-- Replace context name with target name and update code symbol table.
				if code_symbol_table.has_id (l_context_name.as_string_32) then
					l_value := code_symbol_table.item (l_context_name.as_string_32)
					l_value.set_value (target_name)
				end
				internal_code_symbol_table := code_symbol_table

				create l_code_tb
				l_locals := l_code_tb.locals (e_feature)
				l_arguments := l_code_tb.arguments (e_feature)
				l_code_tb.process_read_only_locals (e_feature)
				l_read_only_locals := l_code_tb.read_only_locals


				create Result.make_empty
				across
					local_definitions as ic
				loop
					if l_arguments /= Void and then l_arguments.has (ic.key) then
						if
							not l_code_tb.string_type_as_conformance (ic.item, l_locals.item (ic.key), class_c) and then
							not l_context_name.is_case_insensitive_equal (ic.key)
						then

								-- the current argument variable does not conforms to the variable in the template
								-- for example b: STRING; b: INTEGER
								-- we generate a new variable name for the template.
							from
								l_name := new_name (ic.key.as_string_32)
							until
								not l_locals.has (l_name) and then
								not l_arguments.has (l_name) and then
								not l_read_only_locals.has (l_name)
							loop
								l_name := new_name (ic.key.as_string_32)
							end
							if code_symbol_table.has_id (ic.key.as_string_32) then
								l_value := code_symbol_table.item (ic.key.as_string_32)
								l_value.set_value (l_name)
							end
							internal_code_symbol_table := code_symbol_table

							Result.append_string_general ("%N%T%T%T")
							Result.append_string_general (ic.key)
							Result.append (": ")
							Result.append_string_general (ic.item)
						end
					elseif l_locals /= Void and then l_locals.has (ic.key) and then not l_context_name.is_case_insensitive_equal (ic.key) then
							-- the current local variable conforms to the variable in the template
						if not l_code_tb.string_type_as_conformance (ic.item, l_locals.item (ic.key), class_c) then
							-- the current local variable does not conforms to the variable in the template
							-- for example b: STRING; b: INTEGER
							-- we generate a new variable name for the template.
							from
								l_name := new_name (ic.key.as_string_32)
							until
								not l_locals.has (l_name) and then
								not l_arguments.has (l_name) and then
								not l_read_only_locals.has (l_name)
							loop
								l_name := new_name (ic.key.as_string_32)
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
					elseif l_read_only_locals /= Void and then l_read_only_locals.has (ic.key) and then not l_context_name.is_case_insensitive_equal (ic.key) then
							-- The current local variable from the template has the same name as a read only variable
							-- We need to generate a new variable for the template.
						from
							l_name := new_name (ic.key.as_string_32)
						until
							not l_locals.has (l_name) and then
							not l_arguments.has (l_name) and then
							not l_read_only_locals.has (l_name)
						loop
							l_name := new_name (ic.key.as_string_32)
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

					elseif not l_context_name.same_string (ic.key) then
						Result.append_string_general ("%N%T%T%T")
						Result.append_string_general (ic.key)
						Result.append (": ")
						Result.append_string_general (ic.item)
					end
				end
		end

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

	stone: FEATURE_STONE
		do
			Result := internal_stone
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

feature -- Implementation: Update tokens

	update_tokens (a_code: STRING_32; a_locals: STRING_32): STRING_32
			-- Update tokens: read only locals token found in
			-- the template.
			--! For example if we have a template like this
			--! ${low}  := ${a}.lower
			--! ${high} := ${a}.upper
			--! across
			--!	(${low} + 1) |..| ${high} as i
			--!	from
			--!		${target} := ${a}[${low}]
			--!	loop
			--!		${target} := ${target}.max (${a}[i.item])
			--!	end
			--! the variable i is already used in the context (ie the feature)
			--! we rename it.
		local
			l_scanner: EDITOR_EIFFEL_SCANNER
			l_token: EDITOR_TOKEN
			l_code_tb: CODE_TEMPLATE_BUILDER
			l_locals: STRING_TABLE [TYPE_AS]
			l_arguments: STRING_TABLE [TYPE_A]
			l_read_only_locals_template: STRING_TABLE [STRING]
			l_rename_table: STRING_TABLE [STRING]
			l_name: STRING_32
		do
				-- Prepare table with renaming read only locals.

			create l_code_tb
			l_locals := l_code_tb.locals (e_feature)
			l_arguments := l_code_tb.arguments (e_feature)
			l_code_tb.process_only_locals_template (feature_template_code (a_code, a_locals))
			l_read_only_locals_template := l_code_tb.read_only_locals_template

			create l_rename_table.make_caseless (2)
			across l_read_only_locals_template  as ic
			loop
				if l_locals.has (ic.key) or else l_arguments.has (ic.key) then
					from
						l_name := new_name_locals (ic.key.as_string_32)
					until
						not l_locals.has (l_name) and then
						not l_arguments.has (l_name)
					loop
						l_name := new_name_locals (ic.key.as_string_32)
					end
					l_rename_table.force (l_name, ic.key)
				end
			end

				-- Rename loclas if needed

			if not l_rename_table.is_empty  then
				create Result.make_empty
				create l_scanner.make
				from
					l_scanner.execute (a_code)
					l_token := l_scanner.first_token
				until
					l_token = Void
				loop
					if l_rename_table.has (l_token.wide_image) then
						Result.append (l_rename_table.item (l_token.wide_image))
					else
						Result.append (l_token.wide_image)
					end
					l_token := l_token.next
				end
			end
		end



feature {NONE} -- Implementation: STONE

	internal_stone: FEATURE_STONE

feature {NONE} -- Implementation


	add_comments (a_code: STRING_32)
			-- Add comments to the code `a_code' iff
			-- the tag description is filled in the
			-- Template definition in the metada section.
			-- In other case just add default
			-- start and end comments for the template.
			--! <metadata> ... <description>Some description</description> ....</metadata>
		local
			l_string: STRING
		do
			if attached associated_template_definition.metadata.description as l_description then

				if
					attached l_description.split ('%N') as l_lines and then l_lines.count > 1
				then
					create l_string.make_from_string ("%N%T%T%T")
					across l_lines as ic loop
						l_string.append("%N%T%T%T%T-- ")
						l_string.append(ic.item)
					end
					l_string.append (" `" + target_name + "'")
					a_code.prepend (l_string)
				else
					if l_description.is_empty then
						a_code.prepend ("%T%T%T")
						a_code.prepend ("%N%T%T%T%T-- start of template%N")
					else
						a_code.prepend ("%N%T%T%T")
						a_code.prepend (" `" + target_name + "'")
						a_code.prepend (l_description)
						a_code.prepend ("--")
						a_code.prepend ("%N%T%T%T%T")
					end
				end
				a_code.append ("%T%T%T%T-- end of template%N")
			else
				a_code.prepend ("%N%T%T%T")
				a_code.prepend ("%T%T%T%T-- start of template%N")
				a_code.append ("%T%T%T%T-- end of template%N")
			end
		end


	context_variable_name: READABLE_STRING_GENERAL
				-- Name of the context variable in the template.
		local
			l_context: STRING_32
			l_cb: CODE_TEMPLATE_BUILDER
		do
			create l_cb
			l_context := associated_template_definition.context.context
			across
				local_definitions as c
			until
				Result /= Void
			loop
				if l_cb.string_type_string_conformance (c.item, l_context, class_c) then
					Result := c.key
				end
			end
		end

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


	feature_template_code (a_template: STRING_32; a_locals: STRING_32): STRING_32
			-- Wrap template `a_template' into a feature.
		do
			create Result.make_from_string ("f_567")
			Result.append_string ("%Nlocal")
			Result.append_string ("%N" + a_locals)
			Result.append_string ("%Ndo")
			Result.append_string ("%N" + a_template)
			Result.append_string ("%Nend")
			Result.adjust
		end


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
