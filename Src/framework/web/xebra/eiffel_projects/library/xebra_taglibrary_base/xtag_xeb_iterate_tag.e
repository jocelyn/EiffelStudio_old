note
	description: "Summary description for {XEB_ITERATE_TAG}."
	date: "$Date$"
	revision: "$Revision$"

class
	XTAG_XEB_ITERATE_TAG

inherit
	XTAG_TAG_SERIALIZER

create
	make

feature {NONE} -- Initialization

	make
		do
			make_base
			list := ""
			variable := ""
			type := ""
		end

feature {NONE} -- Access

	list: STRING
			-- The items over which we want to iterate

	variable: STRING
			-- Name of the variable

	type: STRING
			-- Type of the variable

feature {NONE} -- Implementation

	internal_generate (a_servlet_class: XEL_SERVLET_CLASS_ELEMENT; variable_table: TABLE [STRING, STRING])
			-- <Precursor>
		local
			temp_list: STRING
		do
			temp_list := a_servlet_class.render_feature.new_local ("LIST [" + type + "]")
			a_servlet_class.render_feature.append_expression (temp_list + " := " + Controller_variable + "." + list)
			a_servlet_class.render_feature.append_expression ("from")
			a_servlet_class.render_feature.append_expression (temp_list + ".start")
			a_servlet_class.render_feature.append_expression ("until")
			a_servlet_class.render_feature.append_expression (temp_list + ".after")
			a_servlet_class.render_feature.append_expression ("loop")
			a_servlet_class.render_feature.append_expression (variable + " := " + temp_list + ".item")
			generate_children (a_servlet_class, variable_table)
			a_servlet_class.render_feature.append_expression (temp_list + ".forth")
			a_servlet_class.render_feature.append_expression ("end")
		end

	internal_put_attribute (id: STRING; a_attribute: STRING)
			-- <Precursor>
		do
			if id.is_equal ("list") then
				list := a_attribute
			end
			if id.is_equal ("variable") then
				variable := a_attribute
			end
			if id.is_equal ("type") then
				type := a_attribute
			end
		end


note
	copyright: "Copyright (c) 1984-2009, Eiffel Software"
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
