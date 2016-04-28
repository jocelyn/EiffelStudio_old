note
	description: "[
			Specialization of {ES_FEATURE_TEXT_AST_MODIFIER} used by code template component(s).
			
			Mostly used to get "local" position.
		]"
	date: "$Date$"
	revision: "$Revision$"

class
	ES_FEATURE_TEMPLATE_TEXT_AST_MODIFIER

inherit
	ES_FEATURE_TEXT_AST_MODIFIER

create
	make


feature -- Access: AST

	template_ast: detachable ROUTINE_AS
		do
			if attached {ROUTINE_AS} ast_feature.body.content as l_routine then
				Result := l_routine
			end
		end

feature --  Access

	local_insertion_position: INTEGER
			-- <Precursor>
		do
			if attached {ROUTINE_AS} ast_feature.body.content as l_routine then
				if attached l_routine.internal_locals as l_locals then
					Result := ast_position (l_locals).end_position + 2
				else
						-- No locals, use routine body
					Result := ast_position (l_routine.routine_body).start_position
				end
				if Result > 0 then
					Result := modified_data.adjusted_position (Result)
				end
			end
		end

	code_insertion_position: INTEGER
		local
			l_compound: detachable EIFFEL_LIST [INSTRUCTION_AS]
		do
			if attached {ROUTINE_AS} ast_feature.body.content as l_routine then
				if
					l_routine.routine_body.is_empty and then
					attached l_routine.end_keyword as l_kw
				then
					Result := ast_position (l_kw).start_position
				else
					if attached {DO_AS} l_routine.routine_body as l_body then
						l_compound := l_body.compound
					elseif attached {ONCE_AS} l_routine.routine_body as l_body then
						l_compound := l_body.compound
					end

					if
						l_compound /= Void and then
						attached {INSTRUCTION_AS} l_compound.at (1) as l_instruction
					then
					   	Result := ast_position (l_instruction).start_position
					else
							-- ?
					end
				end
				if Result > 0 then
					Result := modified_data.adjusted_position (Result)
				end
			end
		end

feature -- Modifiy Code

	update_feature (a_locals: READABLE_STRING_GENERAL; a_template: READABLE_STRING_GENERAL)
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
