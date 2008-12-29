note
	description: "[
					Style generator for pick-and-dropable grid items
				]"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EB_EDITOR_TOKEN_STYLE

inherit
	EB_SHARED_EDITOR_TOKEN_UTILITY

feature -- Status report

	is_text_ready: BOOLEAN
			-- Is `text' ready to be returned?
		deferred
		end

feature -- Text

	text: LIST [EDITOR_TOKEN]
			-- Editor token text generated by `Current' style
		require
			text_ready: is_text_ready
		deferred
		ensure
			result_attached: Result /= Void
		end

feature -- Access

	infix "+" (other: EB_EDITOR_TOKEN_STYLE): EB_BIN_EDITOR_TOKEN_STYLE
			-- Boolean conjunction with `other'
		require
			other_attached: other /= Void
		do
			create Result.make (Current, other)
		ensure
			result_attached: Result /= Void
		end

note
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

end
