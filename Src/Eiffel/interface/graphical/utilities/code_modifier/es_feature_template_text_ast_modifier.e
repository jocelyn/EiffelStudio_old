note
	description: "Summary description for {ES_FEATURE_TEMPLATE_TEXT_AST_MODIFIER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ES_FEATURE_TEMPLATE_TEXT_AST_MODIFIER

inherit

	ES_FEATURE_TEXT_AST_MODIFIER

create
	make


feature -- AST


	template_ast: detachable ROUTINE_AS
		do
			if attached {ROUTINE_AS} ast_feature.body.content as l_routine then
				Result := l_routine
			end
		end

feature --  Access

	local_insertion_position: INTEGER
			-- <Precursor>
		local
			l_ast: like template_ast
			l_locals: detachable LOCAL_DEC_LIST_AS
		do
			if attached {ROUTINE_AS} ast_feature.body.content as l_routine then
				l_locals := l_routine.internal_locals
				if attached l_locals then
					Result := ast_position (l_locals).end_position + 2
				else
					-- No locals, use routine body
					Result := ast_position (l_routine.routine_body).start_position
				end
			end
			Result := modified_data.adjusted_position (Result)
		end

	code_insertion_position: INTEGER
		local
			l_ast: like template_ast
			l_routine_ast: ROUT_BODY_AS
			l_kw: KEYWORD_AS
		do
			if attached {ROUTINE_AS} ast_feature.body.content as l_routine then
				if l_routine.routine_body.is_empty then
					l_kw := l_routine.end_keyword
					Result := ast_position (l_kw).start_position
				elseif attached {DO_AS} l_routine.routine_body as l_body then
					if attached l_body.compound as l_compound and then
					   attached {INSTRUCTION_AS} l_compound.at (1) as l_instruccion then
					   	Result := ast_position (l_instruccion).start_position
					end
				end
			end
			Result := modified_data.adjusted_position (Result)
		end


feature -- Modifiy Code

	update_feature (a_locals: STRING_32; a_template: STRING_32)
		local
			l_local_pos: INTEGER
			l_body_pos: INTEGER
		do
			l_local_pos := local_insertion_position
			l_body_pos := code_insertion_position
			insert_code (l_local_pos, a_locals)
			insert_code (l_body_pos, a_template)
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
