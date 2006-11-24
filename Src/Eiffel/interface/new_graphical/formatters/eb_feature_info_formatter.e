indexing
	description: "Formatter that displays information about a feature."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	author: "Xavier Rousselot"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EB_FEATURE_INFO_FORMATTER

inherit
	EB_FORMATTER

feature -- Properties

	associated_feature: E_FEATURE
			-- Feature about which information is displayed.

feature {NONE} -- Implementation

	element_name: STRING is
			-- name of associated element in current formatter.
			-- For exmaple, if a class stone is associated to current, `element_name' would be the class name.
		do
			if associated_feature /= Void then
				Result := associated_feature.name.twin
			end
		end

	temp_header: STRING is
			-- Temporary header displayed during the format processing.
		do
			Result := Interface_names.l_Working_formatter.twin
			Result.append (command_name)
			Result.append (Interface_names.l_Of_feature)
			Result.append (associated_feature.name)
			Result.append (Interface_names.l_Three_dots)
		end

	header: STRING is
			-- Header displayed when current formatter is selected.
		do
			if associated_feature /= Void then
				Result := capital_command_name.twin
				Result.append (Interface_names.l_Of_feature)
				Result.append (associated_feature.name)
				Result.append (Interface_names.l_Of_class)
				Result.append (associated_feature.associated_class.name_in_upper)
			else
				Result := Interface_names.l_No_feature
			end
		end

	line_numbers_allowed: BOOLEAN is False;
		-- Does it make sense to show line numbers in Current?

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

end -- class EB_FEATURE_INFO_FORMATTER
