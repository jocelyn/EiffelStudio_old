note
	description: "[
		Tool descriptor for EiffelStudio's entity favorites manager tool.
	]"
	legal: "See notice at end of class."
	status: "See notice at end of class.";
	date: "$date$";
	revision: "$revision$"

frozen class
	ES_FAVORITES_TOOL

inherit
	ES_STONABLE_TOOL [ES_FAVORITES_TOOL_PANEL]

create {NONE}
	default_create

feature -- Access

	icon: EV_PIXEL_BUFFER
			-- <Precursor>
		do
			Result := stock_pixmaps.tool_favorites_icon_buffer
		end

	icon_pixmap: EV_PIXMAP
			-- <Precursor>
		do
			Result := stock_pixmaps.tool_favorites_icon
		end

	title: !STRING_32
			-- <Precursor>
		do
			Result := locale_formatter.translation (t_tool_title)
		end

feature {NONE} -- Status report

	internal_is_stone_usable (a_stone: !like stone): BOOLEAN
			-- <Precursor>
		do
			Result := {l_cs: CLASSI_STONE} a_stone
		ensure then
			a_stone_is_class_stone: {el_cs: CLASSI_STONE} a_stone
		end

feature {NONE} -- Factory

	new_tool: !ES_FAVORITES_TOOL_PANEL
			-- <Precursor>
		do
			create Result.make (window, Current)
		end

feature {NONE} -- Internationalization

	t_tool_title: STRING = "Favorites"

;note
	copyright:	"Copyright (c) 1984-2009, Eiffel Software"
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
