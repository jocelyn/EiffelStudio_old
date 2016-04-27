note
	description: "Represents a code template context section."
	date: "$Date$"
	revision: "$Revision$"

class
	CODE_CONTEXT

inherit
	CODE_SUB_NODE [CODE_TEMPLATE_DEFINITION]

create
	make

feature {NONE} -- Initialization

	initialize_nodes (a_factory: like code_factory)
			-- <Precursor>
		do
			set_context (create {STRING_32}.make_empty)
		end

feature -- Access

	context: STRING_32 assign set_context
			-- Code template context, conforms_to.

feature -- Element change

	set_context (a_context: like context)
			-- Sets a code template context.
			--
			-- `a_context': The context for the code template.
		require
			a_context_attached: attached a_context
		do
			create context.make_from_string (a_context)
		ensure
			context_set: context ~ a_context
		end

feature -- Visitor

	process (a_visitor: CODE_TEMPLATE_VISITOR_I)
			-- <Precursor>
		do
			a_visitor.process_code_context (Current)
		end

invariant
	context_attached: is_initialized implies attached context
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
