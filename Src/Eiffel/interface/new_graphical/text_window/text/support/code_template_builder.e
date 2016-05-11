note
	description: "Utility class to retrieve useful information for code template at feature level"
	author: "javierv"
	date: "$Date$"
	revision: "$Revision$"

class
	CODE_TEMPLATE_BUILDER

inherit

	SHARED_EIFFEL_PARSER

	SHARED_STATELESS_VISITOR

feature -- Access

	arguments (e_feature: E_FEATURE): detachable STRING_TABLE [TYPE_A]
			-- Given a feature `e_feature' return
			-- a Table of pair, variable name (key)
			-- variable Type if it has arguments.
		local
			l_arguments: E_FEATURE_ARGUMENTS
			i: INTEGER
		do
			if e_feature.argument_count > 0 then
				create Result.make_caseless (2)
				from
					i := 1
					l_arguments := e_feature.arguments
				until
					i > e_feature.argument_count
				loop
					Result.force (l_arguments.at (i), l_arguments.argument_names.at (i))
					i := i + 1
				end
			end
		end

	locals (e_feature: E_FEATURE): detachable STRING_TABLE [TYPE_AS]
			-- Given a feature `e_feature' return
			-- a Table of pair, variable name (key)
			-- variable Type if it has locals.
		local
			l_locals: EIFFEL_LIST [LIST_DEC_AS]
			i, j: INTEGER
			l_dec: LIST_DEC_AS
			l_type: TYPE_AS
			l_name: STRING_32
			l_id_list: IDENTIFIER_LIST
			l_count : INTEGER
		do
			if e_feature.locals_count > 0 then
				create Result.make_caseless (5)
				from
					l_locals := e_feature.locals
					l_count := l_locals.count
					i := 1
				until
					i > l_count
				loop
					l_dec := l_locals.at (i)
					l_type := l_dec.type
					l_id_list := l_dec.id_list
					if l_id_list.count > 0 then
						from
							j := 1
						until
							j > l_id_list.count
						loop
							l_name := l_dec.item_name (j)
							j := j + 1
							Result.force (l_type, l_name)
						end
					end
					i := i + 1
				end
			end
		end

	read_only_locals (e_feature: E_FEATURE): STRING_TABLE [STRING]
			-- Given a feature `e_feature' return the names of the locals to
			-- `across', `object test locals'.
		do
			if
				attached {BODY_AS} e_feature.ast.body as l_body and then
				attached {ROUTINE_AS} l_body.content as l_content and then
				attached {DO_AS} l_content.routine_body as l_routine_body and then
				attached {EIFFEL_LIST [INSTRUCTION_AS]} l_routine_body.compound as l_compound
			then
				Result := compute_read_only_locals (l_compound)
			else
				create Result.make (0)
			end
		end

	read_only_locals_template (a_code: STRING_32): detachable STRING_TABLE [STRING]
			-- Given a code template `a_code' return the names of the locals to
			-- `across', `object test locals
		do
			if
				attached {FEATURE_AS} feature_template_ast (a_code) as l_feature_ast and then
				attached {BODY_AS} l_feature_ast.body as l_body and then
				attached {ROUTINE_AS} l_body.content as l_content and then
				attached {DO_AS} l_content.routine_body as l_routine_body and then
				attached {EIFFEL_LIST [INSTRUCTION_AS]} l_routine_body.compound as l_compound
			then
				Result := compute_read_only_locals (l_compound)
			end
		end


feature -- Conformance

	string_type_string_conformance (a_string: STRING_32; a_string2: STRING_32; a_class_c: CLASS_C): BOOLEAN
			-- Is the type represented by `a_string' conforms_to type `a_string_2'
		do
			if not a_string.is_empty then
				type_parser.parse_from_string_32 ({STRING_32} "type " + a_string, Void)
				if attached type_parser.type_node as l_class_type_as then
					type_parser.parse_from_string_32 ({STRING_32} "type " + a_string2, Void)
					if attached type_parser.type_node as l_class_type_as_2 then
						if
							attached type_a_generator.evaluate_type (l_class_type_as, a_class_c) as l_type_a and then
							attached type_a_generator.evaluate_type (l_class_type_as_2, a_class_c) as l_type_a_2
						then
							Result := l_type_a.conform_to (a_class_c, l_type_a_2)
						end
					end
				end
			end
		end

	string_type_as_conformance (a_string: STRING_32; a_type_as: TYPE_AS; a_class_c: CLASS_C): BOOLEAN
			-- Is the type represented by `a_string' conforms_to type `a_type_as'
		do
			if not a_string.is_empty then
				type_parser.parse_from_string_32 ({STRING_32} "type " + a_string, Void)
				if attached type_parser.type_node as l_class_type_as then
						-- Convert TYPE_AS into TYPE_A.
					if
						attached type_a_generator.evaluate_type (l_class_type_as, a_class_c) as s_type_a and then
						attached type_a_generator.evaluate_type (a_type_as, a_class_c) as l_type_a
					then
						Result := l_type_a.conform_to (a_class_c, s_type_a)
					end
				end
			end
		end

	string_type_a_conformance (a_string: STRING_32; a_type_a: TYPE_A; a_class_c: CLASS_C): BOOLEAN
			-- Is the type represented by `a_string' conforms_to type `a_type_a'
		do
			if not a_string.is_empty then
				type_parser.parse_from_string_32 ({STRING_32} "type " + a_string, Void)
				if attached type_parser.type_node as l_class_type_as then
						-- Convert TYPE_AS into TYPE_A.
					if
						attached type_a_generator.evaluate_type (l_class_type_as, a_class_c) as s_type_a
					then
						Result := a_type_a.conform_to (a_class_c, s_type_a)
					end
				end
			end
		end


feature {NONE} -- Template Implementation.

	compute_read_only_locals (a_compound: EIFFEL_LIST [INSTRUCTION_AS]): STRING_TABLE[STRING]
			-- Return a list of read only names in the compound `a_compound'.
		do
			create Result.make_caseless (2)
			across a_compound as ic  loop
				if attached {IF_AS} ic.item as l_if then
					evaluate_if_as (l_if.condition, Result)
				end
				if attached {LOOP_AS} ic.item as l_loop then
					if
						attached {ITERATION_AS} l_loop.iteration as l_iteration and then
						attached {ID_AS} l_iteration.identifier as l_id
					then
						Result.force ("", l_id.name_32)
					end
				end
			end
		end

	evaluate_if_as (a_condition: EXPR_AS; a_result: STRING_TABLE [STRING])
			-- Populate object test locals names from `a_condition' into `a_result'.
		do
			if
				attached {OBJECT_TEST_AS} a_condition as l_cond
			then
				a_result.force ("", l_cond.name.name_32)
			else
				if
					attached {BIN_AND_THEN_AS} a_condition as l_condition
				then
					evaluate_if_as (l_condition.left, a_result)
					evaluate_if_as (l_condition.right, a_result)
				end
			end
		end

	feature_template_ast (a_code: STRING_32): FEATURE_AS
			-- Return a feature AST from the code template `a_code'.
		local
			epw: EIFFEL_PARSER_WRAPPER
		do
			create epw
			epw.parse_with_option_32 (entity_feature_parser,{STRING_32} "feature " + a_code, create {CONF_OPTION}, True, Void)
			if attached {FEATURE_AS} epw.ast_node as l_feature_node then
				Result := l_feature_node
			end
		end

note
	copyright: "Copyright (c) 1984-2016, Eiffel Software"
	license: "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options: "http://www.eiffel.com/licensing"
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
