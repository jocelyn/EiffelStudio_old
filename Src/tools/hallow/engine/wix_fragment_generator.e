indexing
	description: "[
		A WiX generator used to generate XML content fragments adhearing to the WiX schema.
	]"
	legal: "See notice at end of class."
	status: "See notice at end of class.";
	date: "$date$";
	revision: "$revision$"

class
	WIX_FRAGMENT_GENERATOR

inherit
	SYSTEM_OBJECT

	I_WIX_FRAGMENT_GENERATOR

feature -- Basic operations

	generate (a_options: I_OPTIONS; a_stream: TEXT_WRITER) is
			-- Generate fragment XML with options `a_options'
		local
			l_writer: XML_TEXT_WRITER
		do
			reset
			create l_writer.make (a_stream)
			l_writer.set_formatting ({FORMATTING}.indented)
			generate_root (a_options, l_writer)
			l_writer.flush
		end

	reset is
			-- Resets internal for new generation
		do
			create name_table.make (512, {STRING_COMPARER}.invariant_culture_ignore_case)
			component_count := 1
			directory_count := 1
			file_count := 1
		ensure
			name_table_attached: name_table /= Void
		end

feature {NONE} -- Element generation

	generate_root (a_options: I_OPTIONS; a_writer: XML_TEXT_WRITER) is
			-- Generates a WiX fragment.
			--
			-- `a_options': The options that determine how all elements are generated.
			-- `a_writer': The writer that all generated elements will be written to.
		require
			a_options_attached: a_options /= Void
			can_read_options_a_options: a_options.can_read_options
			a_writer_attached: a_writer /= Void
		local
			l_dir: DIRECTORY_INFO
		do
				-- Start generation					
			a_writer.write_start_document

			if a_options.generate_as_include then
				a_writer.write_start_element ({WIX_CONSTANTS}.include_tag, {WIX_CONSTANTS}.wix_ns)
			else
				a_writer.write_start_element ({WIX_CONSTANTS}.wix_tag, {WIX_CONSTANTS}.wix_ns)
			end
			a_writer.write_start_element ({WIX_CONSTANTS}.fragment_tag)
			a_writer.write_start_element ({WIX_CONSTANTS}.directory_ref_tag)
			a_writer.write_attribute_string ({WIX_CONSTANTS}.id_attribute, a_options.directory_ref_name)

			create l_dir.make (a_options.directory)
			if not a_options.use_src_specifier then

				a_writer.write_attribute_string ({WIX_CONSTANTS}.file_source_attribute, format_path (l_dir.full_name, a_options))
			end

			generate_directory_content (l_dir, a_options, a_writer)

				-- End generation
			a_writer.write_end_element
			a_writer.write_end_element
			a_writer.write_end_element
			a_writer.write_end_document
		end

	generate_directory (a_dir: DIRECTORY_INFO; a_options: I_OPTIONS; a_writer: XML_TEXT_WRITER) is
			-- Generates a single WiX Directory element.
			--
			-- `a_dir': Directory to generate an element for.
			-- `a_options': The options that determine how the element is generated.
			-- `a_writer': The writer that the generated element will be written to.
		require
			a_options_attached: a_options /= Void
			can_read_options_a_options: a_options.can_read_options
			a_writer_attached: a_writer /= Void
			a_dir_attached: a_dir /= Void
			a_dir_exists: a_dir.exists
		local
			l_name: SYSTEM_STRING
		do
			a_writer.write_start_element ({WIX_CONSTANTS}.directory_tag)
			a_writer.write_attribute_string ({WIX_CONSTANTS}.id_attribute, semantic_name (a_dir.full_name, a_options, {WIX_CONSTANTS}.directory_tag, directory_prefix))

			l_name := get_short_path_name (a_dir.full_name, a_options)
			a_writer.write_attribute_string ({WIX_CONSTANTS}.name_attribute, l_name)
			if {SYSTEM_STRING}.compare (l_name, a_dir.name, True, {CULTURE_INFO}.invariant_culture) /= 0 then
				a_writer.write_attribute_string ({WIX_CONSTANTS}.long_name_attribute, a_dir.name)
			end

			if not a_options.use_src_specifier then
				a_writer.write_attribute_string ({WIX_CONSTANTS}.file_source_attribute, format_path (a_dir.full_name, a_options))
			end

			generate_directory_content (a_dir, a_options, a_writer)

			a_writer.write_end_element
		end

	generate_directory_content (a_dir: DIRECTORY_INFO; a_options: I_OPTIONS; a_writer: XML_TEXT_WRITER) is
			-- Generates WiX Compent, File and Directory elements based on the content of a directory.
			--
			-- `a_dir': A directory to scan and generated XML elements base on content.
			-- `a_options': The options that determine how the element is generated.
			-- `a_writer': The writer that the generated element will be written to.
		require
			a_options_attached: a_options /= Void
			can_read_options_a_options: a_options.can_read_options
			a_writer_attached: a_writer /= Void
			a_dir_attached: a_dir /= Void
			a_dir_exists: a_dir.exists
		local
			l_files: NATIVE_ARRAY [FILE_INFO]
			l_dirs: NATIVE_ARRAY [DIRECTORY_INFO]
			l_count, i: INTEGER
		do
				-- Generate files
			l_files := a_dir.get_files

			if l_files.count > 0 then
				l_files := files_for_options (l_files, a_options)
				l_count := l_files.count
				if l_count > 0 then
					if a_options.generate_single_file_components then
						from i := 0 until i = l_count loop
							generate_component (l_files.item (i).full_name, agent generate_file (l_files.item (i), ?, ?), a_options, a_writer)
							i := i + 1
						end
					else
						generate_component (a_dir.full_name, agent generate_files (l_files, ?, ?), a_options, a_writer)
					end
				end
			end

				-- Generate directories
			if a_options.include_subdirectories then
				l_dirs := a_dir.get_directories
				if l_dirs.count > 0 then
					l_dirs := directories_for_options (l_dirs, a_options)
					if l_dirs.count > 0 then
						generate_directories (l_dirs, a_options, a_writer)
					end
				end
			end
		end

	generate_directories (a_dirs: NATIVE_ARRAY [DIRECTORY_INFO]; a_options: I_OPTIONS; a_writer: XML_TEXT_WRITER) is
			-- Generates WiX Directory elements.
			--
			-- `a_dirs': An array of directories to generate Directory elements for
			-- `a_options': The options that determine how the element is generated.
			-- `a_writer': The writer that the generated element will be written to.
		require
			a_options_attached: a_options /= Void
			can_read_options_a_options: a_options.can_read_options
			a_writer_attached: a_writer /= Void
			a_dirs_attached: a_dirs /= Void
			not_a_dirs_is_empty: a_dirs.count > 0
		local
			l_di: DIRECTORY_INFO
			l_count, i: INTEGER
		do
			l_count := a_dirs.count
			from i := 0 until i = l_count loop
				l_di := a_dirs.item (i)
				if l_di /= Void then
					generate_directory (l_di, a_options, a_writer)
				end
				i := i + 1
			end
		end

	generate_component (a_path: SYSTEM_STRING; a_content_gen: PROCEDURE [WIX_FRAGMENT_GENERATOR, TUPLE [I_OPTIONS, XML_TEXT_WRITER]]; a_options: I_OPTIONS; a_writer: XML_TEXT_WRITER) is
			-- Generates a single WiX Component element and its content using a generator agent.
			--
			-- `a_path': Full path to a disk entity that the component is generated for.
			-- `a_content_gen': An agent used to generate the Component element's content.
			-- `a_options': The options that determine how the element is generated.
			-- `a_writer': The writer that the generated element will be written to.
		require
			a_options_attached: a_options /= Void
			can_read_options_a_options: a_options.can_read_options
			a_writer_attached: a_writer /= Void
			a_content_gen_attached: a_content_gen /= Void
			a_content_gen_has_attached_target: a_content_gen.target /= Void
		do
			a_writer.write_start_element ({WIX_CONSTANTS}.component_tag)
			a_writer.write_attribute_string ({WIX_CONSTANTS}.name_attribute, semantic_name (a_path, a_options, {WIX_CONSTANTS}.component_tag, component_prefix))
			a_writer.write_attribute_string ({WIX_CONSTANTS}.guid_attribute, guid (a_options))

			a_content_gen.call ([a_options, a_writer])

			a_writer.write_end_element
		end

	generate_files (a_files: NATIVE_ARRAY [FILE_INFO]; a_options: I_OPTIONS; a_writer: XML_TEXT_WRITER) is
			-- Generates WiX File elements.
			--
			-- `a_files': An array of files to generate File elements for
			-- `a_options': The options that determine how the element is generated.
			-- `a_writer': The writer that the generated element will be written to.
		require
			a_options_attached: a_options /= Void
			can_read_options_a_options: a_options.can_read_options
			a_writer_attached: a_writer /= Void
			a_files_attached: a_files /= Void
			not_a_files_is_empty: a_files.count > 0
		local
			l_fi: FILE_INFO
			l_count, i: INTEGER
		do
			l_count := a_files.count
			from i := 0 until i = l_count loop
				l_fi := a_files.item (i)
				if l_fi /= Void then
					generate_file (a_files.item (i), a_options, a_writer)
				end
				i := i + 1
			end
		end

	generate_file (a_file: FILE_INFO; a_options: I_OPTIONS; a_writer: XML_TEXT_WRITER) is
			-- Generates a single WiX File element.
			--
			-- `a_file': File to generate an element for.
			-- `a_options': The options that determine how the element is generated.
			-- `a_writer': The writer that the generated element will be written to.
		require
			a_options_attached: a_options /= Void
			can_read_options_a_options: a_options.can_read_options
			a_writer_attached: a_writer /= Void
			a_file_attached: a_file /= Void
			a_file_exists: a_file.exists
		local
			l_name: SYSTEM_STRING
		do
			a_writer.write_start_element ({WIX_CONSTANTS}.file_tag)
			a_writer.write_attribute_string ({WIX_CONSTANTS}.id_attribute, semantic_name (a_file.full_name, a_options, {WIX_CONSTANTS}.file_tag, Void))

			l_name := get_short_path_name (a_file.full_name, a_options)
			a_writer.write_attribute_string ({WIX_CONSTANTS}.name_attribute, l_name)
			if {SYSTEM_STRING}.compare (l_name, a_file.name, True, {CULTURE_INFO}.invariant_culture) /= 0 then
				a_writer.write_attribute_string ({WIX_CONSTANTS}.long_name_attribute, a_file.name)
			end
			if a_options.use_disk_id then
				a_writer.write_attribute_string ({WIX_CONSTANTS}.disk_id_attribute, {SYSTEM_CONVERT}.to_string (a_options.disk_id))
			end
			if a_options.use_src_specifier then
				a_writer.write_attribute_string ({WIX_CONSTANTS}.src_attribute, format_path (a_file.full_name, a_options))
			end

			a_writer.write_end_element
		end

feature {NONE} -- Attribute generation

	guid (a_options: I_OPTIONS): SYSTEM_STRING is
			-- Create a GUID based on `a_options'
			--
			-- `a_options': Options that determine how the resulting GUID string is generated
			-- `Result': A string representation of a GUID.
			--           Note: This may not be a valid GUID string.
		require
			a_options_attached: a_options /= Void
			can_read_options_a_options: a_options.can_read_options
		do
			if a_options.generate_guids then
				Result := {GUID}.new_guid.to_string ("D").to_upper
			else
				Result := default_guid
			end
		ensure
			not_result_is_empty: not {SYSTEM_STRING}.is_null_or_empty (Result)
		end

	semantic_name (a_path: SYSTEM_STRING; a_options: I_OPTIONS; a_tag_name: SYSTEM_STRING; a_prefix: SYSTEM_STRING): SYSTEM_STRING is
			-- Create a name based on specified user options `a_options'
			--
			-- `a_path': Full path to disk item to create a semantic name for.
			-- `a_options': Options that determine how the resulting name should be generated.
			-- `a_tag_name': A XML element tag name representing the name of the element the name is generated for.
			-- `a_prefix': An optional prefix to prepend a semantic generated name.
			-- `Result': A generated name
		require
			not_a_path_is_empty: not {SYSTEM_STRING}.is_null_or_empty (a_path)
			a_options_attached: a_options /= Void
			can_read_options_a_options: a_options.can_read_options
			not_a_tag_name_is_empty: not {SYSTEM_STRING}.is_null_or_empty (a_tag_name)
		local
			l_name: SYSTEM_STRING
			l_prefix: SYSTEM_STRING
			l_base_name: SYSTEM_STRING
			l_sb: STRING_BUILDER
			i: NATURAL_64
		do
			if a_options.use_semantic_names then

					-- Removed root directory and separator/device character from path
				if a_options.directory.length < a_path.length then
					create l_sb.make (a_path.substring (a_options.directory.length + 1))
					l_sb := l_sb.replace ({PATH}.directory_separator_char, '.')
					l_sb := l_sb.replace ({PATH}.alt_directory_separator_char, '.')
					l_sb := l_sb.replace ({PATH}.volume_separator_char, '.')
					l_name := l_sb.to_string
				else
					l_name := {PATH}.get_file_name (a_path)
				end

					-- Ensure we have a default prefix
				l_prefix := a_prefix
				if l_prefix = Void then
					l_prefix := {SYSTEM_STRING}.empty
				end

					-- Create name
				if a_options.has_semantic_name_prefix then
					Result := {SYSTEM_STRING}.concat (l_prefix, a_options.semantic_name_prefix, l_name)
				else
					Result := {SYSTEM_STRING}.concat (l_prefix, l_name)
				end

					-- Ensure path uniqueness
				l_base_name := Result
				from i := 2 until not name_table.contains (Result) loop
					Result := {SYSTEM_STRING}.concat (l_base_name, i)
				end
				name_table.add (Result, True)
			else
				Result := {SYSTEM_STRING}.concat (a_tag_name.to_lower ({CULTURE_INFO}.invariant_culture), underscore, get_count (a_tag_name))
				increase_count (a_tag_name)
			end
		ensure
			not_result_is_empty: not {SYSTEM_STRING}.is_null_or_empty (Result)
		end

	format_path (a_path: SYSTEM_STRING; a_options: I_OPTIONS): SYSTEM_STRING is
			-- Retrieves directory path for `a_path' given user options `a_options'
			--
			-- `a_path': Full path to an entity on disk to format.
			-- `a_options': The options to used to determine how the resulting path is formatted.
			-- `Result': A formatted path.
		require
			not_a_path_is_empty: not {SYSTEM_STRING}.is_null_or_empty (a_path)
			a_options_attached: a_options /= Void
			can_read_options_a_options: a_options.can_read_options
		local
			l_end_path: SYSTEM_STRING
		do
			if a_options.use_directory_alias then
				l_end_path := a_path.substring (a_options.directory.length)
				Result := {SYSTEM_STRING}.concat (a_options.directory_alias, l_end_path)
			else
				Result := a_path
			end
		ensure
			not_result_is_empty: not {SYSTEM_STRING}.is_null_or_empty (Result)
		end

feature {NONE} --

	files_for_options (a_files: NATIVE_ARRAY [FILE_INFO]; a_options: I_OPTIONS): NATIVE_ARRAY [FILE_INFO] is
			-- Processes files based on expression in the passed options to remove an invalid files.
			--
			-- `a_files': Files to process
			-- `a_options': Options to use to determin what files are added or removed
		require
			a_files_attached: a_files /= Void
			not_a_files_is_empty: a_files.count > 0
			a_options_attached: a_options /= Void
		local
			l_inc, l_ex: BOOLEAN
			l_ep_priority: BOOLEAN
			l_iexp, l_eexp: REGEX
			l_fi: FILE_INFO
			l_name: SYSTEM_STRING
			l_result: ARRAYED_LIST [FILE_INFO]
			l_add: BOOLEAN
			l_count, i: INTEGER
		do
			l_inc := a_options.use_file_include_pattern
			l_ex := a_options.use_file_exclude_pattern
			if l_inc or l_ex then
				if l_inc and l_ex then
					l_ep_priority := a_options.use_exclude_pattern_priority
				end
				if l_inc then
					l_iexp := a_options.file_include_pattern
				end
				if l_ex then
					l_eexp := a_options.file_excluded_pattern
				end

				l_count := a_files.count
				create l_result.make (l_count)
				from i := 0 until i = l_count loop
					l_add := True

					l_fi := a_files.item (i)
					l_name := l_fi.name
					if l_ex then
						l_add := not l_eexp.is_match (l_name)
					end
					if l_inc and then (l_ex implies not l_add) then
						if l_ep_priority implies l_add then
							l_add := l_iexp.is_match (l_name)
						end
					end

					if l_add then
						l_result.extend (l_fi)
					end

					i := i + 1
				end
				create Result.make (l_result.count)
				{SYSTEM_ARRAY}.copy_array_array_integer_32 (({NATIVE_ARRAY [FILE_INFO]}) [({ARRAY [FILE_INFO]}) #? l_result], Result, l_result.count)
			else
				Result := a_files
			end
		end

	directories_for_options (a_dirs: NATIVE_ARRAY [DIRECTORY_INFO]; a_options: I_OPTIONS): NATIVE_ARRAY [DIRECTORY_INFO] is
			-- Processes directories based on expression in the passed options to remove an invalid directory.
			--
			-- `a_dirs': Directories to process
			-- `a_options': Options to use to determin what files are added or removed
		require
			a_dirs_attached: a_dirs /= Void
			not_a_dirs_is_empty: a_dirs.count > 0
			a_options_attached: a_options /= Void
		local
			l_inc, l_ex: BOOLEAN
			l_ep_priority: BOOLEAN
			l_iexp, l_eexp: REGEX
			l_di: DIRECTORY_INFO
			l_name: SYSTEM_STRING
			l_result: ARRAYED_LIST [DIRECTORY_INFO]
			l_add: BOOLEAN
			l_count, i: INTEGER
		do
			l_inc := a_options.use_directory_include_pattern
			l_ex := a_options.use_directory_exclude_pattern
			if l_inc or l_ex then
				if l_inc and l_ex then
					l_ep_priority := a_options.use_exclude_pattern_priority
				end

				if l_inc then
					l_iexp := a_options.directory_include_pattern
				end
				if l_ex then
					l_eexp := a_options.directory_excluded_pattern
				end

				l_count := a_dirs.count
				create l_result.make (l_count)
				from i := 0 until i = l_count loop
					l_add := True

					l_di := a_dirs.item (i)
					l_name := l_di.name
					if l_ex then
						l_add := not l_eexp.is_match (l_name)
					end
					if l_inc and then (l_ex implies not l_add) then
						if l_ep_priority implies l_add then
							l_add := l_iexp.is_match (l_name)
						end
					end

					if l_add then
						l_result.extend (l_di)
					end

					i := i + 1
				end
				create Result.make (l_result.count)
				{SYSTEM_ARRAY}.copy_array_array_integer_32 (({NATIVE_ARRAY [DIRECTORY_INFO]}) [({ARRAY [DIRECTORY_INFO]}) #? l_result], Result, l_result.count)
			else
				Result := a_dirs
			end
		end

feature {NONE} -- Tables

	name_table: HASHTABLE
			-- Table used to prevent name clashes.
			-- Key: Name
			-- Value: Boolean, always True if table contain a name

feature {NONE} -- Counters

	get_count (a_name: SYSTEM_STRING): NATURAL_32 is
			-- Retrieve counter for `a_name'
			--
			-- `a_name': A XML tag name to retrieve the count for.
			-- `Result': A count based on `a_name'.
		require
			not_a_name_is_empty: not {SYSTEM_STRING}.is_null_or_empty (a_name)
		do
			if a_name = {WIX_CONSTANTS}.file_tag then
				Result := file_count
			elseif a_name = {WIX_CONSTANTS}.directory_tag then
				Result := directory_count
			elseif a_name = {WIX_CONSTANTS}.component_tag then
				Result := component_count
			else
				check False end
			end
		end

	increase_count (a_name: SYSTEM_STRING) is
			-- Increase counter, for `a_name', by one.
			--
			-- `a_name': A XML tag name to increment the count for.
		require
			not_a_name_is_empty: not {SYSTEM_STRING}.is_null_or_empty (a_name)
		do
			if a_name = {WIX_CONSTANTS}.file_tag then
				file_count := file_count + 1
			elseif a_name = {WIX_CONSTANTS}.directory_tag then
				directory_count := directory_count + 1
			elseif a_name = {WIX_CONSTANTS}.component_tag then
				component_count := component_count + 1
			else
				check False end
			end
		ensure
			count_increased: get_count (a_name) = old get_count (a_name) + 1
		end

	component_count: NATURAL_32
			-- Component name counter

	directory_count: NATURAL_32
			-- Directory name counter

	file_count: NATURAL_32
			-- File name counter

feature {NONE} -- Native methods

	frozen get_short_path_name (a_path: SYSTEM_STRING; a_options: I_OPTIONS): SYSTEM_STRING is
			-- Retrieves the short path file or directory name or `a_path' using the options `a_options' to indicate
			-- how the path is returned.
		require
			not_a_path_is_empty: not {SYSTEM_STRING}.is_null_or_empty (a_path)
			a_path_exists: {SYSTEM_FILE}.exists (a_path) or {SYSTEM_DIRECTORY}.exists (a_path)
			a_options_attached: a_options /= Void
			can_read_options_a_options: a_options.can_read_options
		local
			l_long: POINTER
			l_short: POINTER
			l_len: INTEGER
			retried: BOOLEAN
		do
			if not retried then
				l_len := {NATIVE_METHODS}.max_path

					-- Allocate resources
				l_long := {MARSHAL}.string_to_co_task_mem_uni (a_path)
				l_short := {MARSHAL}.alloc_co_task_mem ({NATIVE_METHODS}.sizeof_tchar * (l_len + 1))

				l_len := {NATIVE_METHODS}.get_short_path_name (l_long, l_short, l_len)
				check l_len_positive: l_len > 0 end
				if l_len > 0 then
					Result := {PATH}.get_file_name ({MARSHAL}.ptr_to_string_uni (l_short, l_len))
					if a_options.swap_tilda then
						Result := Result.replace ("~", "_")
					end
				end
			end

				-- Clean up allocated resources
			if l_long /= default_pointer then
				{MARSHAL}.free_co_task_mem (l_long)
			end
			if l_long /= default_pointer then
				{MARSHAL}.free_co_task_mem (l_short)
			end
		ensure
			not_result_is_empty: not {SYSTEM_STRING}.is_null_or_empty (Result)
		rescue
			retried := True
			retry
		end

feature {NONE} -- Constants

	default_guid: SYSTEM_STRING = "PUT-GUID-HERE"
	directory_prefix: SYSTEM_STRING = "Dir."
	component_prefix: SYSTEM_STRING = "Comp."
	underscore: SYSTEM_STRING = "_"

;indexing
	copyright:	"Copyright (c) 1984-2007, Eiffel Software"
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
