indexing
	description: "[
					Event list item which has data about a set of test cases run result
					Used by {ES_ALL_TEST_RUN_RESULTS_DIALOG} only.
																	]"
	status: "See notice at end of class."
	legal: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	EVENT_LIST_TEST_RUN_ITEM

inherit
	EVENT_LIST_TEST_ITEM_I

create
	make

feature {NONE} -- Redefine

	description: STRING_32 is
			-- Redefine
		do
			Result := "Event list item which has data about a set of test cases run result"
		end

	is_valid_data (a_data: ANY): BOOLEAN is
			-- Redefine
		do
			if a_data /= Void then
				Result := {l_test: ES_EWEASEL_TEST_RUN_DATA_ITEM} a_data
			end
		end

indexing
	copyright: "Copyright (c) 1984-2008, Eiffel Software"
	license:   "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
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
			 356 Storke Road, Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"

end
