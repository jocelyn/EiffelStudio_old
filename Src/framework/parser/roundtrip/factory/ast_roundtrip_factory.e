note
	description: "[
					Roundtrip AST factory

					It will setup all indexes used by roundtrip and also, it will generate `match_list'.
					Call `match_list' after parsing to get the list.
					]"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AST_ROUNDTRIP_FACTORY

inherit
	AST_ROUNDTRIP_LIGHT_FACTORY
		redefine
			create_match_list,
			new_keyword_as,
			new_keyword_id_as,
			new_symbol_as,
			new_current_as,
			new_deferred_as,
			new_boolean_as,
			new_result_as,
			new_retry_as,
			new_unique_as,
			new_void_as,
			new_filled_id_as,

			new_character_as,
			new_once_string_keyword_as,
			new_integer_as,
			new_integer_hexa_as,
			new_integer_octal_as,
			new_integer_binary_as,
			new_real_as,
			new_filled_bit_id_as,
			new_string_as,
			new_verbatim_string_as,
			create_break_as,
			create_break_as_with_data,
			extend_match_list_with_stub,
			extend_match_list,

			set_buffer,
			append_text_to_buffer,
			append_character_to_buffer,
			append_two_characters_to_buffer
		end

feature -- Buffer operation

	set_buffer (a_buf: STRING; a_scn: YY_SCANNER_SKELETON)
		do
			a_buf.wipe_out
			a_buf.append (a_scn.text)
		ensure then
			a_buf_set: a_buf.is_equal (a_scn.text)
		end

	append_text_to_buffer (a_buf: STRING; a_scn: YY_SCANNER_SKELETON)
			-- Append `a_scn'.text to end of buffer `a_buf'.
		do
			a_scn.append_text_to_string (a_buf)
		end

	append_character_to_buffer (a_buf: STRING; c: CHARACTER)
			-- Append `c' to end of buffer `a_buf'.
		do
			a_buf.append_character (c)
		end

	append_two_characters_to_buffer (a_buf: STRING; a, b: CHARACTER)
			-- Append `a' and `b' to end of buffer `a_buf'.
		do
			a_buf.append_character (a)
			a_buf.append_character (b)
		end

feature -- Match list maintaining

	create_match_list (l_size: INTEGER)
			-- Create a new `match_list' with initial `l_size'.
		do
			create match_list.make (l_size)
			match_list_count := 0
		ensure then
			match_list_not_void: match_list /= Void
		end

	extend_match_list (a_match: LEAF_AS)
			-- Extend `match_list' with `a_match'.
		do
			if attached match_list as l_list and is_match_list_extension_enabled then
				l_list.extend (a_match)
			end
		end

	extend_match_list_with_stub (a_stub: LEAF_STUB_AS)
			-- Extend `match_list' with stub `a_stub',
			-- and set index in `a_match'.
		do
			if attached match_list as l_list and is_match_list_extension_enabled then
				a_stub.set_index (match_list_count)
				l_list.extend (a_stub)
			end
		end

feature -- Leaf Nodes

	new_character_as (c: CHARACTER_32; l, co, p, n: INTEGER; a_text: STRING): detachable CHAR_AS
			-- New CHARACTER AST node
		do
			Result := Precursor (c, l, co, p, n, a_text)
			extend_match_list_with_stub (create{LEAF_STUB_AS}.make (a_text.twin, l, co, p, a_text.count))
		end

	new_string_as (s: detachable STRING; l, c, p, n: INTEGER; buf: STRING): detachable STRING_AS
			-- New STRING AST node
		do
			Result := Precursor (s, l, c, p, n, buf)
			if Result /= Void then
				extend_match_list_with_stub (create{LEAF_STUB_AS}.make (buf.string, l, c, p, n))
			end
		end

	new_verbatim_string_as (s, marker: STRING; is_indentable: BOOLEAN; l, c, p, n, cc: INTEGER; buf: STRING): detachable VERBATIM_STRING_AS
			-- New VERBATIM_STRING AST node
		do
			Result := Precursor (s, marker, is_indentable, l, c, p, n, cc, buf)
			if Result /= Void then
				extend_match_list_with_stub (create{LEAF_STUB_AS}.make (buf.string, l, c, p, n))
			end
		end

	new_integer_as (t: detachable TYPE_AS; s: BOOLEAN; v: detachable STRING; buf: STRING; s_as: detachable SYMBOL_AS; l, c, p, n: INTEGER): detachable INTEGER_AS
			-- New INTEGER_AS node
		do
			Result := Precursor (t, s, v, buf, s_as, l, c, p, n)
			if Result /= Void then
				extend_match_list_with_stub (create{LEAF_STUB_AS}.make (buf.string, l, c, p, n))
			end
		end

	new_integer_hexa_as (t: detachable TYPE_AS; s: CHARACTER; v: detachable STRING; buf: STRING; s_as: detachable SYMBOL_AS; l, c, p, n: INTEGER): detachable INTEGER_AS
			-- New INTEGER_AS node
		do
			Result := Precursor (t, s, v, buf, s_as, l, c, p, n)
			if Result /= Void then
				extend_match_list_with_stub (create{LEAF_STUB_AS}.make (buf.string, l, c, p, n))
			end
		end

	new_integer_octal_as (t: detachable TYPE_AS; s: CHARACTER; v: detachable STRING; buf: STRING; s_as: detachable SYMBOL_AS; l, c, p, n: INTEGER): detachable INTEGER_AS
			-- New INTEGER_AS node
		do
			Result := Precursor (t, s, v, buf, s_as, l, c, p, n)
			if Result /= Void then
				extend_match_list_with_stub (create{LEAF_STUB_AS}.make (buf.string, l, c, p, n))
			end
		end

	new_integer_binary_as (t: detachable TYPE_AS; s: CHARACTER; v: detachable STRING; buf: STRING; s_as: detachable SYMBOL_AS; l, c, p, n: INTEGER): detachable INTEGER_AS
			-- New INTEGER_AS node
		do
			Result := Precursor (t, s, v, buf, s_as, l, c, p, n)
			if Result /= Void then
				extend_match_list_with_stub (create{LEAF_STUB_AS}.make (buf.string, l, c, p, n))
			end
		end

	new_real_as (t: detachable TYPE_AS; v: detachable STRING; buf: STRING; s_as: detachable SYMBOL_AS; l, c, p, n: INTEGER): detachable REAL_AS
			-- New REAL AST node
		do
			Result := Precursor (t, v, buf, s_as, l, c, p, n)
			if Result /= Void then
				extend_match_list_with_stub (create {LEAF_STUB_AS}.make (buf.string, l, c, p, n))
			end
		end

	new_filled_id_as (a_scn: EIFFEL_SCANNER_SKELETON): detachable ID_AS
		do
			Result := Precursor (a_scn)
			extend_match_list_with_stub (create {LEAF_STUB_AS}.make (a_scn.text, a_scn.line, a_scn.column, a_scn.position, a_scn.text_count))
		end

	new_filled_bit_id_as (a_scn: EIFFEL_SCANNER_SKELETON): detachable ID_AS
			-- New empty ID AST node.
		do
			Result := Precursor (a_scn)
			extend_match_list_with_stub (create{LEAF_STUB_AS}.make (a_scn.text, a_scn.line, a_scn.column, a_scn.position, a_scn.text_count))
		end

	new_void_as (a_scn: EIFFEL_SCANNER_SKELETON): detachable VOID_AS
		do
			Result := Precursor (a_scn)
			extend_match_list_with_stub (create{KEYWORD_STUB_AS}.make ({EIFFEL_TOKENS}.te_void, a_scn.text, a_scn.line, a_scn.column, a_scn.position, a_scn.text_count))
		end

	new_unique_as (a_scn: EIFFEL_SCANNER_SKELETON): detachable UNIQUE_AS
		do
			Result := Precursor (a_scn)
			extend_match_list_with_stub (create{KEYWORD_STUB_AS}.make ({EIFFEL_TOKENS}.te_unique, a_scn.text, a_scn.line, a_scn.column, a_scn.position, a_scn.text_count))
		end

	new_retry_as (a_scn: EIFFEL_SCANNER_SKELETON): detachable RETRY_AS
		do
			Result := Precursor (a_scn)
			extend_match_list_with_stub (create{KEYWORD_STUB_AS}.make ({EIFFEL_TOKENS}.te_retry, a_scn.text, a_scn.line, a_scn.column, a_scn.position, a_scn.text_count))
		end

	new_result_as (a_scn: EIFFEL_SCANNER_SKELETON): detachable RESULT_AS
		do
			Result := Precursor (a_scn)
			extend_match_list_with_stub (create{KEYWORD_STUB_AS}.make ({EIFFEL_TOKENS}.te_result, a_scn.text, a_scn.line, a_scn.column, a_scn.position, a_scn.text_count))
		end

	new_boolean_as (b: BOOLEAN; a_scn: EIFFEL_SCANNER_SKELETON): detachable BOOL_AS
		do
			Result := Precursor (b, a_scn)
			if b then
				extend_match_list_with_stub (create{KEYWORD_STUB_AS}.make (
					{EIFFEL_TOKENS}.te_true, a_scn.text, a_scn.line, a_scn.column, a_scn.position, a_scn.text_count))
			else
				extend_match_list_with_stub (create{KEYWORD_STUB_AS}.make (
					{EIFFEL_TOKENS}.te_false, a_scn.text, a_scn.line, a_scn.column, a_scn.position, a_scn.text_count))
			end
		end

	new_current_as (a_scn: EIFFEL_SCANNER_SKELETON): detachable CURRENT_AS
		do
			Result := Precursor (a_scn)
			extend_match_list_with_stub (create{KEYWORD_STUB_AS}.make ({EIFFEL_TOKENS}.te_current, a_scn.text, a_scn.line, a_scn.column, a_scn.position, a_scn.text_count))
		end

	new_deferred_as (a_scn: EIFFEL_SCANNER_SKELETON): detachable DEFERRED_AS
		do
			Result := Precursor (a_scn)
			extend_match_list_with_stub (create{KEYWORD_STUB_AS}.make ({EIFFEL_TOKENS}.te_deferred, a_scn.text, a_scn.line, a_scn.column, a_scn.position, a_scn.text_count))
		end

	new_keyword_as (a_code: INTEGER; a_scn: EIFFEL_SCANNER_SKELETON): detachable KEYWORD_AS
			-- New KEYWORD AST node
		do
			Result := Precursor (a_code, a_scn)
			extend_match_list_with_stub (create {KEYWORD_STUB_AS}.make (a_code, a_scn.text, a_scn.line, a_scn.column, a_scn.position, a_scn.text_count))
		end

	new_keyword_id_as (a_code: INTEGER; a_scn: EIFFEL_SCANNER_SKELETON): like keyword_id_type
		do
			Result := Precursor (a_code, a_scn)
				-- It is ok to create a KEYWORD_STUB_AS because it inherits from LEAF_STUB_AS and thus
 				-- when the keyword is actually used as an identifier it should be just fine.
 			extend_match_list_with_stub (create {KEYWORD_STUB_AS}.make (a_code, a_scn.text, a_scn.line, a_scn.column, a_scn.position, a_scn.text_count))
		end

	new_once_string_keyword_as (a_text: STRING; l, c, p, n: INTEGER): detachable KEYWORD_AS
			-- New KEYWORD AST node
		do
			Result := Precursor (a_text, l, c, p, n)
			extend_match_list_with_stub (create{KEYWORD_STUB_AS}.make ({EIFFEL_TOKENS}.te_once_string, a_text.string, l, c, p, n))
		end

	new_symbol_as (a_code: INTEGER; a_scn: EIFFEL_SCANNER_SKELETON): detachable SYMBOL_AS
			-- New KEYWORD AST node		
		do
			Result := Precursor (a_code, a_scn)
			extend_match_list_with_stub (create{SYMBOL_STUB_AS}.make (a_code, a_scn.line, a_scn.column, a_scn.position, a_scn.text_count))
		end

	create_break_as (a_scn: EIFFEL_SCANNER_SKELETON)
			-- NEw BREAK_AS node
		local
			b_as: BREAK_AS
		do
			increase_match_list_count
			create b_as.make (a_scn.text, a_scn.line, a_scn.column, a_scn.position, a_scn.text_count)
			b_as.set_index (match_list_count)
			extend_match_list (b_as)
		end

	create_break_as_with_data (a_text: STRING; l, c, p, n: INTEGER)
			-- New COMMENT_AS node
		local
			b_as: BREAK_AS
		do
			increase_match_list_count
			create b_as.make (a_text.string, l, c, p, n)
			b_as.set_index (match_list_count)
			extend_match_list (b_as)
		end

note
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

