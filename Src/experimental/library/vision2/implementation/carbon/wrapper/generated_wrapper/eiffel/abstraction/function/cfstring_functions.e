-- This file has been generated by EWG. Do not edit. Changes will be lost!
-- functions wrapper
class CFSTRING_FUNCTIONS

obsolete
	"Use class CFSTRING_FUNCTIONS_EXTERNAL instead."

inherit

	CFSTRING_FUNCTIONS_EXTERNAL

feature
	cfstring_get_type_id: INTEGER is
		local
		do
			Result := cfstring_get_type_id_external
		end

	cfstring_create_with_pascal_string (alloc: POINTER; pstr: POINTER; encoding: INTEGER): POINTER is
		local
		do
			Result := cfstring_create_with_pascal_string_external (alloc, pstr, encoding)
		end

	cfstring_create_with_cstring (alloc: POINTER; cstr: STRING; encoding: INTEGER): POINTER is
		local
			cstr_c_string: EWG_ZERO_TERMINATED_STRING
		do
			create cstr_c_string.make_shared_from_string (cstr)
			Result := cfstring_create_with_cstring_external (alloc, cstr_c_string.item, encoding)
		end

	cfstring_create_with_characters (alloc: POINTER; chars: POINTER; numchars: INTEGER): POINTER is
		local
		do
			Result := cfstring_create_with_characters_external (alloc, chars, numchars)
		end

	cfstring_create_with_pascal_string_no_copy (alloc: POINTER; pstr: POINTER; encoding: INTEGER; contentsdeallocator: POINTER): POINTER is
		local
		do
			Result := cfstring_create_with_pascal_string_no_copy_external (alloc, pstr, encoding, contentsdeallocator)
		end

	cfstring_create_with_cstring_no_copy (alloc: POINTER; cstr: STRING; encoding: INTEGER; contentsdeallocator: POINTER): POINTER is
		local
			cstr_c_string: EWG_ZERO_TERMINATED_STRING
		do
			create cstr_c_string.make_shared_from_string (cstr)
			Result := cfstring_create_with_cstring_no_copy_external (alloc, cstr_c_string.item, encoding, contentsdeallocator)
		end

	cfstring_create_with_characters_no_copy (alloc: POINTER; chars: POINTER; numchars: INTEGER; contentsdeallocator: POINTER): POINTER is
		local
		do
			Result := cfstring_create_with_characters_no_copy_external (alloc, chars, numchars, contentsdeallocator)
		end

	cfstring_create_with_substring (alloc: POINTER; str: POINTER; range: POINTER): POINTER is
		local
		do
			Result := cfstring_create_with_substring_external (alloc, str, range)
		end

	cfstring_create_copy (alloc: POINTER; thestring: POINTER): POINTER is
		local
		do
			Result := cfstring_create_copy_external (alloc, thestring)
		end

	cfstring_create_with_format (alloc: POINTER; formatoptions: POINTER; format: POINTER): POINTER is
		local
		do
			Result := cfstring_create_with_format_external (alloc, formatoptions, format)
		end

	cfstring_create_mutable (alloc: POINTER; maxlength: INTEGER): POINTER is
		local
		do
			Result := cfstring_create_mutable_external (alloc, maxlength)
		end

	cfstring_create_mutable_copy (alloc: POINTER; maxlength: INTEGER; thestring: POINTER): POINTER is
		local
		do
			Result := cfstring_create_mutable_copy_external (alloc, maxlength, thestring)
		end

	cfstring_create_mutable_with_external_characters_no_copy (alloc: POINTER; chars: POINTER; numchars: INTEGER; capacity: INTEGER; externalcharactersallocator: POINTER): POINTER is
		local
		do
			Result := cfstring_create_mutable_with_external_characters_no_copy_external (alloc, chars, numchars, capacity, externalcharactersallocator)
		end

	cfstring_get_length (thestring: POINTER): INTEGER is
		local
		do
			Result := cfstring_get_length_external (thestring)
		end

	cfstring_get_character_at_index (thestring: POINTER; idx: INTEGER): INTEGER is
		local
		do
			Result := cfstring_get_character_at_index_external (thestring, idx)
		end

	cfstring_get_characters (thestring: POINTER; range: POINTER; buffer: POINTER) is
		local
		do
			cfstring_get_characters_external (thestring, range, buffer)
		end

	cfstring_get_pascal_string (thestring: POINTER; buffer: POINTER; buffersize: INTEGER; encoding: INTEGER): INTEGER is
		local
		do
			Result := cfstring_get_pascal_string_external (thestring, buffer, buffersize, encoding)
		end

	cfstring_get_cstring (thestring: POINTER; buffer: STRING; buffersize: INTEGER; encoding: INTEGER): INTEGER is
		local
			buffer_c_string: EWG_ZERO_TERMINATED_STRING
		do
			create buffer_c_string.make_shared_from_string (buffer)
			Result := cfstring_get_cstring_external (thestring, buffer_c_string.item, buffersize, encoding)
		end

	cfstring_get_pascal_string_ptr (thestring: POINTER; encoding: INTEGER): POINTER is
		local
		do
			Result := cfstring_get_pascal_string_ptr_external (thestring, encoding)
		end

	cfstring_get_cstring_ptr (thestring: POINTER; encoding: INTEGER): POINTER is
		local
		do
			Result := cfstring_get_cstring_ptr_external (thestring, encoding)
		end

	cfstring_get_characters_ptr (thestring: POINTER): POINTER is
		local
		do
			Result := cfstring_get_characters_ptr_external (thestring)
		end

	cfstring_get_bytes (thestring: POINTER; range: POINTER; encoding: INTEGER; lossbyte: INTEGER; isexternalrepresentation: INTEGER; buffer: STRING; maxbuflen: INTEGER; usedbuflen: POINTER): INTEGER is
		local
			buffer_c_string: EWG_ZERO_TERMINATED_STRING
		do
			create buffer_c_string.make_shared_from_string (buffer)
			Result := cfstring_get_bytes_external (thestring, range, encoding, lossbyte, isexternalrepresentation, buffer_c_string.item, maxbuflen, usedbuflen)
		end

	cfstring_create_with_bytes (alloc: POINTER; bytes: STRING; numbytes: INTEGER; encoding: INTEGER; isexternalrepresentation: INTEGER): POINTER is
		local
			bytes_c_string: EWG_ZERO_TERMINATED_STRING
		do
			create bytes_c_string.make_shared_from_string (bytes)
			Result := cfstring_create_with_bytes_external (alloc, bytes_c_string.item, numbytes, encoding, isexternalrepresentation)
		end

	cfstring_create_from_external_representation (alloc: POINTER; data: POINTER; encoding: INTEGER): POINTER is
		local
		do
			Result := cfstring_create_from_external_representation_external (alloc, data, encoding)
		end

	cfstring_create_external_representation (alloc: POINTER; thestring: POINTER; encoding: INTEGER; lossbyte: INTEGER): POINTER is
		local
		do
			Result := cfstring_create_external_representation_external (alloc, thestring, encoding, lossbyte)
		end

	cfstring_get_smallest_encoding (thestring: POINTER): INTEGER is
		local
		do
			Result := cfstring_get_smallest_encoding_external (thestring)
		end

	cfstring_get_fastest_encoding (thestring: POINTER): INTEGER is
		local
		do
			Result := cfstring_get_fastest_encoding_external (thestring)
		end

	cfstring_get_system_encoding: INTEGER is
		local
		do
			Result := cfstring_get_system_encoding_external
		end

	cfstring_get_maximum_size_for_encoding (length: INTEGER; encoding: INTEGER): INTEGER is
		local
		do
			Result := cfstring_get_maximum_size_for_encoding_external (length, encoding)
		end

	cfstring_get_file_system_representation (a_string: POINTER; buffer: STRING; maxbuflen: INTEGER): INTEGER is
		local
			buffer_c_string: EWG_ZERO_TERMINATED_STRING
		do
			create buffer_c_string.make_shared_from_string (buffer)
			Result := cfstring_get_file_system_representation_external (a_string, buffer_c_string.item, maxbuflen)
		end

	cfstring_get_maximum_size_of_file_system_representation (a_string: POINTER): INTEGER is
		local
		do
			Result := cfstring_get_maximum_size_of_file_system_representation_external (a_string)
		end

	cfstring_create_with_file_system_representation (alloc: POINTER; buffer: STRING): POINTER is
		local
			buffer_c_string: EWG_ZERO_TERMINATED_STRING
		do
			create buffer_c_string.make_shared_from_string (buffer)
			Result := cfstring_create_with_file_system_representation_external (alloc, buffer_c_string.item)
		end

	cfstring_compare_with_options (thestring1: POINTER; thestring2: POINTER; rangetocompare: POINTER; compareoptions: INTEGER): INTEGER is
		local
		do
			Result := cfstring_compare_with_options_external (thestring1, thestring2, rangetocompare, compareoptions)
		end

	cfstring_compare (thestring1: POINTER; thestring2: POINTER; compareoptions: INTEGER): INTEGER is
		local
		do
			Result := cfstring_compare_external (thestring1, thestring2, compareoptions)
		end

	cfstring_find_with_options (thestring: POINTER; stringtofind: POINTER; rangetosearch: POINTER; searchoptions: INTEGER; a_result: POINTER): INTEGER is
		local
		do
			Result := cfstring_find_with_options_external (thestring, stringtofind, rangetosearch, searchoptions, a_result)
		end

	cfstring_create_array_with_find_results (alloc: POINTER; thestring: POINTER; stringtofind: POINTER; rangetosearch: POINTER; compareoptions: INTEGER): POINTER is
		local
		do
			Result := cfstring_create_array_with_find_results_external (alloc, thestring, stringtofind, rangetosearch, compareoptions)
		end

-- Ignoring cfstring_find since its return type is a composite type

	cfstring_has_prefix (thestring: POINTER; a_prefix: POINTER): INTEGER is
		local
		do
			Result := cfstring_has_prefix_external (thestring, a_prefix)
		end

	cfstring_has_suffix (thestring: POINTER; suffix: POINTER): INTEGER is
		local
		do
			Result := cfstring_has_suffix_external (thestring, suffix)
		end

-- Ignoring cfstring_get_range_of_composed_characters_at_index since its return type is a composite type

	cfstring_find_character_from_set (thestring: POINTER; theset: POINTER; rangetosearch: POINTER; searchoptions: INTEGER; a_result: POINTER): INTEGER is
		local
		do
			Result := cfstring_find_character_from_set_external (thestring, theset, rangetosearch, searchoptions, a_result)
		end

	cfstring_get_line_bounds (thestring: POINTER; range: POINTER; linebeginindex: POINTER; lineendindex: POINTER; contentsendindex: POINTER) is
		local
		do
			cfstring_get_line_bounds_external (thestring, range, linebeginindex, lineendindex, contentsendindex)
		end

	cfstring_create_by_combining_strings (alloc: POINTER; thearray: POINTER; separatorstring: POINTER): POINTER is
		local
		do
			Result := cfstring_create_by_combining_strings_external (alloc, thearray, separatorstring)
		end

	cfstring_create_array_by_separating_strings (alloc: POINTER; thestring: POINTER; separatorstring: POINTER): POINTER is
		local
		do
			Result := cfstring_create_array_by_separating_strings_external (alloc, thestring, separatorstring)
		end

	cfstring_get_int_value (str: POINTER): INTEGER is
		local
		do
			Result := cfstring_get_int_value_external (str)
		end

	cfstring_get_double_value (str: POINTER): DOUBLE is
		local
		do
			Result := cfstring_get_double_value_external (str)
		end

	cfstring_append (thestring: POINTER; appendedstring: POINTER) is
		local
		do
			cfstring_append_external (thestring, appendedstring)
		end

	cfstring_append_characters (thestring: POINTER; chars: POINTER; numchars: INTEGER) is
		local
		do
			cfstring_append_characters_external (thestring, chars, numchars)
		end

	cfstring_append_pascal_string (thestring: POINTER; pstr: POINTER; encoding: INTEGER) is
		local
		do
			cfstring_append_pascal_string_external (thestring, pstr, encoding)
		end

	cfstring_append_cstring (thestring: POINTER; cstr: STRING; encoding: INTEGER) is
		local
			cstr_c_string: EWG_ZERO_TERMINATED_STRING
		do
			create cstr_c_string.make_shared_from_string (cstr)
			cfstring_append_cstring_external (thestring, cstr_c_string.item, encoding)
		end

	cfstring_append_format (thestring: POINTER; formatoptions: POINTER; format: POINTER) is
		local
		do
			cfstring_append_format_external (thestring, formatoptions, format)
		end

	cfstring_insert (str: POINTER; idx: INTEGER; insertedstr: POINTER) is
		local
		do
			cfstring_insert_external (str, idx, insertedstr)
		end

	cfstring_delete (thestring: POINTER; range: POINTER) is
		local
		do
			cfstring_delete_external (thestring, range)
		end

	cfstring_replace (thestring: POINTER; range: POINTER; replacement: POINTER) is
		local
		do
			cfstring_replace_external (thestring, range, replacement)
		end

	cfstring_replace_all (thestring: POINTER; replacement: POINTER) is
		local
		do
			cfstring_replace_all_external (thestring, replacement)
		end

	cfstring_find_and_replace (thestring: POINTER; stringtofind: POINTER; replacementstring: POINTER; rangetosearch: POINTER; compareoptions: INTEGER): INTEGER is
		local
		do
			Result := cfstring_find_and_replace_external (thestring, stringtofind, replacementstring, rangetosearch, compareoptions)
		end

	cfstring_set_external_characters_no_copy (thestring: POINTER; chars: POINTER; length: INTEGER; capacity: INTEGER) is
		local
		do
			cfstring_set_external_characters_no_copy_external (thestring, chars, length, capacity)
		end

	cfstring_pad (thestring: POINTER; padstring: POINTER; length: INTEGER; indexintopad: INTEGER) is
		local
		do
			cfstring_pad_external (thestring, padstring, length, indexintopad)
		end

	cfstring_trim (thestring: POINTER; trimstring: POINTER) is
		local
		do
			cfstring_trim_external (thestring, trimstring)
		end

	cfstring_trim_whitespace (thestring: POINTER) is
		local
		do
			cfstring_trim_whitespace_external (thestring)
		end

	cfstring_lowercase (thestring: POINTER; locale: POINTER) is
		local
		do
			cfstring_lowercase_external (thestring, locale)
		end

	cfstring_uppercase (thestring: POINTER; locale: POINTER) is
		local
		do
			cfstring_uppercase_external (thestring, locale)
		end

	cfstring_capitalize (thestring: POINTER; locale: POINTER) is
		local
		do
			cfstring_capitalize_external (thestring, locale)
		end

	cfstring_normalize (thestring: POINTER; theform: INTEGER) is
		local
		do
			cfstring_normalize_external (thestring, theform)
		end

	cfstring_transform (a_string: POINTER; range: POINTER; transform: POINTER; reverse: INTEGER): INTEGER is
		local
		do
			Result := cfstring_transform_external (a_string, range, transform, reverse)
		end

	cfstring_is_encoding_available (encoding: INTEGER): INTEGER is
		local
		do
			Result := cfstring_is_encoding_available_external (encoding)
		end

	cfstring_get_list_of_available_encodings: POINTER is
		local
		do
			Result := cfstring_get_list_of_available_encodings_external
		end

	cfstring_get_name_of_encoding (encoding: INTEGER): POINTER is
		local
		do
			Result := cfstring_get_name_of_encoding_external (encoding)
		end

	cfstring_convert_encoding_to_nsstring_encoding (encoding: INTEGER): INTEGER is
		local
		do
			Result := cfstring_convert_encoding_to_nsstring_encoding_external (encoding)
		end

	cfstring_convert_nsstring_encoding_to_encoding (encoding: INTEGER): INTEGER is
		local
		do
			Result := cfstring_convert_nsstring_encoding_to_encoding_external (encoding)
		end

	cfstring_convert_encoding_to_windows_codepage (encoding: INTEGER): INTEGER is
		local
		do
			Result := cfstring_convert_encoding_to_windows_codepage_external (encoding)
		end

	cfstring_convert_windows_codepage_to_encoding (codepage: INTEGER): INTEGER is
		local
		do
			Result := cfstring_convert_windows_codepage_to_encoding_external (codepage)
		end

	cfstring_convert_ianachar_set_name_to_encoding (thestring: POINTER): INTEGER is
		local
		do
			Result := cfstring_convert_ianachar_set_name_to_encoding_external (thestring)
		end

	cfstring_convert_encoding_to_ianachar_set_name (encoding: INTEGER): POINTER is
		local
		do
			Result := cfstring_convert_encoding_to_ianachar_set_name_external (encoding)
		end

	cfstring_get_most_compatible_mac_string_encoding (encoding: INTEGER): INTEGER is
		local
		do
			Result := cfstring_get_most_compatible_mac_string_encoding_external (encoding)
		end

	cfshow (obj: POINTER) is
		local
		do
			cfshow_external (obj)
		end

	cfshow_str (str: POINTER) is
		local
		do
			cfshow_str_external (str)
		end

	cfstring_make_constant_string (cstr: STRING): POINTER is
		local
			cstr_c_string: EWG_ZERO_TERMINATED_STRING
		do
			create cstr_c_string.make_shared_from_string (cstr)
			Result := cfstring_make_constant_string_external (cstr_c_string.item)
		end

end
