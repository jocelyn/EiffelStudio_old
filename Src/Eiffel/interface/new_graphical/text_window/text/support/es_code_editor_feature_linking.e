note
	description: "Get editor tokens and linking tokens from a given feature"
	author: "javierv"
	date: "$Date$"
	revision: "$Revision$"

class
	ES_CODE_EDITOR_FEATURE_LINKING

inherit
	ES_CODE_EDITOR_LINKING

create
	make

feature {NONE} -- Initialization

	make (a_text: READABLE_STRING_32; a_feature: E_FEATURE)
			-- Create an instance with stone `a_stone'.
		do
			origin_text := a_text
			e_feature := a_feature

			get_tokens
		ensure
			associated_feature_set:  e_feature = a_feature
		end

	origin_text: READABLE_STRING_32

	e_feature: E_FEATURE

feature -- Access

	is_active: BOOLEAN
			-- Is linked editing?
		do
			Result := False -- Not Yet Implemented
		end

	linked_tokens: STRING_TABLE [LIST [INTEGER]]
			-- tokens and their positions.	

	content_tokens: LIST [EDITOR_TOKEN]
			-- Content tokens in code_text

	linking_definitions: STRING_TABLE [STRING]
			-- Linking definitions arguments and locals names.
		local
			l_code_tb: CODE_TEMPLATE_BUILDER
		do
			if internal_linking_definitions /= Void then
				Result := internal_linking_definitions
			else
				create l_code_tb
				create Result.make_caseless (5)
				if attached l_code_tb.arguments (e_feature) as l_arguments then
					across
						l_arguments as c
					loop
						Result.force ("", c.key)
					end
				end
				if attached l_code_tb.locals (e_feature) as l_locals then
					across
						l_locals as c
					loop
						Result.force ("", c.key)
					end
				end
				internal_linking_definitions := Result
			end
		end

feature -- Execute	

	get_tokens
		local
			l_lines:  LIST [STRING_32]
			l_scanner: EDITOR_EIFFEL_SCANNER
			l_token: EDITOR_TOKEN
			l_list: LIST [INTEGER]
		do
			create linked_tokens.make (5)
			create {ARRAYED_LIST [EDITOR_TOKEN]} content_tokens.make (5)
			create l_scanner.make
			from
				l_scanner.execute (origin_text) -- this is not the correct way.
				l_token := l_scanner.first_token
			until
				l_token = Void
			loop
				if linking_definitions.has (l_token.wide_image) then
					if linked_tokens.has (l_token.wide_image) then
						l_list := linked_tokens.item (l_token.wide_image)
						if l_list /= Void then
							l_list.force (l_token.pos_in_text)
						else
							create {ARRAYED_LIST [INTEGER]} l_list.make (1)
							l_list.force (l_token.pos_in_text)
							linked_tokens.force (l_list, l_token.wide_image)
						end
					else
						create {ARRAYED_LIST [INTEGER]} l_list.make (1)
						l_list.force (l_token.pos_in_text)
						linked_tokens.force (l_list, l_token.wide_image)
					end
				end
				content_tokens.force (l_token)
				l_token := l_token.next
			end
		end

feature {NONE} -- Implementation

	internal_linking_definitions: like linking_definitions
			-- cache linking definitions for the current feature
			-- arguments and locals variables.

;note
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
