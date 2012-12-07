note
	description: "[
					Like h2e.exe, translate a C header file (.h) to a Eiffel class
				]"
	date: "$Date$"
	revision: "$Revision$"

class
	ER_H_FILE_TRANSLATOR

create
	make

feature {NONE} -- Initialization

	make (a_dest_directory: like dest_directory; a_dest_class: like dest_class_name)
			-- Creation method
		require
			not_void: a_dest_class /= Void
			not_void: a_dest_directory /= Void
			valid: not a_dest_class.is_empty and not a_dest_directory.is_empty
		do
			create source_file_name.make_empty

			dest_directory := a_dest_directory
			dest_class_name := a_dest_class

			create name_value.make (300)
		ensure
			set: dest_directory = a_dest_directory
			set: dest_class_name = a_dest_class
		end

feature -- Command

	reset
			-- Reset internal data
		do
			name_value.wipe_out
		end

	translate (a_source_file: like source_file_name)
			-- Translate C header file into a Eiffel class
		require
			not_void: a_source_file /= Void
		do
			source_file_name := a_source_file
			parse_c_header_file
		ensure
			set: source_file_name = a_source_file
		end

	save_to_disk
			-- Save translated result to disk
		local
			l_file_content: STRING
			l_dest_file_name: PATH
			l_dest_file: RAW_FILE
		do
			l_file_content := generate_eiffel_class
			if not l_file_content.is_empty then
				l_dest_file_name := dest_directory.extended (dest_class_name + ".e")
				create l_dest_file.make_with_path (l_dest_file_name)
				l_dest_file.create_read_write
				l_dest_file.put_string (l_file_content)
				l_dest_file.close
			end
		end

feature {NONE} -- Implementation

	parse_c_header_file
			-- Parse C header file
		local
			l_source_file: RAW_FILE
			l_first_blank, l_second_blank: INTEGER
			l_name, l_value: STRING
		do
			create l_source_file.make_with_path (source_file_name)
			if l_source_file.exists then
				from
					l_source_file.open_read
					l_source_file.start
				until
					l_source_file.after
				loop

					l_source_file.read_line
					if attached l_source_file.last_string as l_last_string then
						if l_last_string.starts_with ("#define") then
							-- Found a line need to be translated
							l_first_blank := l_last_string.index_of (' ', 1)
							l_second_blank := l_last_string.index_of (' ', l_first_blank + 1)
							check valid: l_first_blank /= 0 and l_second_blank /= 0 end
							l_name := l_last_string.substring (l_first_blank + 1, l_second_blank - 1)
							l_value := l_last_string.substring (l_second_blank + 1, l_last_string.count)

							-- It's OK to ignore duplcaited names, since it's generated by UICC, but not user defined
							if not already_has_name (l_name) then
								name_value.extend ([l_name, l_value])
							end

						end
					end
				end
			end
		end

	already_has_name (a_name: STRING): BOOLEAN
			-- Does `name_value' already has `a_name'
		local
			l_name_value: like name_value
			l_item: TUPLE [name, value: STRING]
		do
			from
				l_name_value := name_value
				l_name_value.start
			until
				l_name_value.after or Result
			loop
				l_item := l_name_value.item
				if l_item.name.same_string (a_name) then
					Result := True
				end

				l_name_value.forth
			end
		end

	generate_eiffel_class: STRING
			-- Generate Eiffel class for C header file
		local
			l_template: PATH
			l_template_file: RAW_FILE
			l_last_string: STRING
			l_class_name: STRING
			l_eiffel_name_value: STRING
			u: UTF_CONVERTER
		do
			create Result.make_empty

			l_template := ((create {ER_MISC_CONSTANTS}).template).extended ("header_file_template.e")

			create l_template_file.make_with_path (l_template)
			if l_template_file.exists then
				if not name_value.is_empty then
					l_eiffel_name_value := prepare_name_value_for_eiffel
					-- Prepare Eiffel class from template
					from
						l_template_file.open_read
						l_template_file.start
						l_class_name := dest_class_name.twin
						l_class_name.to_upper
					until
						l_template_file.after
					loop
						l_template_file.read_line
						l_last_string := l_template_file.last_string

						l_last_string.replace_substring_all ("$SOURCE_FILE", u.utf_32_string_to_utf_8_string_8 (source_file_name.name))
						l_last_string.replace_substring_all ("$CLASS_NAME", l_class_name)
						l_last_string.replace_substring_all ("$GENERATED", l_eiffel_name_value)

						Result.append (l_last_string + "%N")
					end
				end
			end
		end

	prepare_name_value_for_eiffel: STRING
			-- Prepare name value pairs for Eiffel
		require
			valid: not name_value.is_empty
		local
			l_line: STRING
		do
			create Result.make_empty
			from
				name_value.start
			until
				name_value.after
			loop
				l_line := "%T" + name_value.item.a_name + ": NATURAL_32 = " + name_value.item.a_value + "%N"
				Result.append (l_line)
				name_value.forth
			end
		end

	source_file_name: PATH
			-- Full path name of source C header file will be translated

	dest_directory: PATH
			-- Directory path for destination Eiffel Class

	dest_class_name: STRING
			-- Eiffel class name that will be generated (.e is not needed)

	name_value: ARRAYED_LIST [TUPLE [a_name: STRING; a_value: STRING]]
			-- All names and values parsed from C header file

;note
	copyright: "Copyright (c) 1984-2012, Eiffel Software"
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
