indexing
	description	: "COMPARABLE_CONSUMED_MEMBER with comparaison on feature dotnet_name"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	author		: "Generated by the New Vision2 Application Wizard."
	date		: "$Date$"
	revision	: "1.0.0"

class
	COMPARABLE_CONSUMED_MEMBER

inherit
	CONSUMED_MEMBER
	
	COMPARABLE
		undefine
			default_create, is_equal, copy
		end

create
	make_with_consumed_member
	
feature -- Initialization
	
	make_with_consumed_member (a_consumed_member: CONSUMED_MEMBER) is
		require
			non_void_a_consumed_member: a_consumed_member /= Void
		do
			eiffel_name := a_consumed_member.eiffel_name
			dotnet_name := a_consumed_member.dotnet_name
			arguments := a_consumed_member.arguments
			declared_type := a_consumed_member.declared_type
			return_type := a_consumed_member.return_type
			internal_flags := a_consumed_field.internal_flags
		ensure
			dotnet_name_set: dotnet_name = a_consumed_member.dotnet_name
			arguments_set: arguments = a_consumed_member.arguments
			declared_type_set: declared_type = a_consumed_member.declared_type
			return_type_set: return_type = a_consumed_member.return_type
			internal_flags_set: internal_flags = a_consumed_member.internal_flags
		end

feature -- Implementation
	
	infix "<" (other: like Current): BOOLEAN is
			-- Is current object less than `other'?
		do
			Result := dotnet_name < other.dotnet_name
		end

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


end -- class COMPARABLE_CONSUMED_MEMBER
