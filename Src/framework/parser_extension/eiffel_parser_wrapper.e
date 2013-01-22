note
	description: "[
			An Eiffel parser wrapper for optionally contain errors/warnings within a parser. Parsers can be
			performed with a set of configuration options also.
		]"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	EIFFEL_PARSER_WRAPPER

inherit
	ANY

	SHARED_ERROR_HANDLER
		export
			{NONE} all
		end

	SHARED_ENCODING_CONVERTER

	INTERNAL_COMPILER_STRING_EXPORTER

feature -- Access

	ast_node: detachable AST_EIFFEL
			-- Last AST node set from a parse operation.

	ast_match_list: detachable LEAF_AS_LIST
			-- Last match list generated by the parser.

feature {NONE} -- Element change

	set_last_ast (a_parser: EIFFEL_PARSER)
			-- Sets the current's state from a parser.
		require
			a_parser_attached: a_parser /= Void
			not_has_error: not has_error
		do
			if a_parser.indexing_parser then
				ast_node := a_parser.indexing_node
			elseif a_parser.expression_parser then
				ast_node := a_parser.expression_node
			elseif a_parser.entity_declaration_parser then
				ast_node := a_parser.entity_declaration_node
			elseif a_parser.feature_parser then
				ast_node := a_parser.feature_node
			elseif a_parser.invariant_parser then
				ast_node := a_parser.invariant_node
			elseif a_parser.type_parser then
				ast_node := a_parser.type_node
			else
				ast_node := a_parser.root_node
			end
			ast_match_list := a_parser.match_list
		end

feature -- Status report

	has_error: BOOLEAN
			-- Indicates the last parser had an error

feature -- Basic operation

	parse_32 (a_parser: EIFFEL_PARSER; a_text: READABLE_STRING_GENERAL; a_ignore_errors: BOOLEAN; a_context_class: ABSTRACT_CLASS_C)
			-- Performs a parse using an Eiffel parser.
			--
			-- `a_parser'       : The Eiffel parser to perform a parse with.
			-- `a_text'         : The Eiffel text to parse using the supplied parser. In UTF-32.
			-- `a_ignore_errors': True to remove all errors and warnings from the error handler after a
			--                    parse has been completed; False to retain them.
		require
			a_parser_attached: a_parser /= Void
			a_text_attached: a_text /= Void
		local
			u: UTF_CONVERTER
		do
			parse (a_parser, u.utf_32_string_to_utf_8_string_8 (a_text), a_ignore_errors, a_context_class)
		end

	parse_with_option_32 (a_parser: EIFFEL_PARSER; a_text: READABLE_STRING_GENERAL; a_options: CONF_OPTION; a_ignore_errors: BOOLEAN; a_context_class: ABSTRACT_CLASS_C)
			-- Performs a parse using an Eiffel parser.
			--
			-- `a_parser'       : The Eiffel parser to perform a parse with.
			-- `a_text'         : The Eiffel text to parse using the supplied parser. In UTF-32.
			-- `a_options'      : The configuration options to apply to the parser before parsing.
			-- `a_ignore_errors': True to remove all errors and warnings from the error handler after a
			--                    parse has been completed; False to retain them.
		require
			a_parser_attached: a_parser /= Void
			a_text_attached: a_text /= Void
		local
			u: UTF_CONVERTER
		do
			parse_with_option (a_parser, u.utf_32_string_to_utf_8_string_8 (a_text), a_options, a_ignore_errors, a_context_class)
		end

feature {INTERNAL_COMPILER_STRING_EXPORTER} -- Basic operation

	parse (a_parser: EIFFEL_PARSER; a_text: READABLE_STRING_8; a_ignore_errors: BOOLEAN; a_context_class: ABSTRACT_CLASS_C)
			-- Performs a parse using an Eiffel parser.
			--
			-- `a_parser'       : The Eiffel parser to perform a parse with.
			-- `a_text'         : The Eiffel text to parse using the supplied parser. In UTF-8.
			-- `a_ignore_errors': True to remove all errors and warnings from the error handler after a
			--                    parse has been completed; False to retain them.
		require
			a_parser_attached: a_parser /= Void
			a_text_attached: a_text /= Void
		local
			retried: BOOLEAN
			l_level: NATURAL_32
		do
			if not retried then
				reset
				l_level := error_handler.error_level
				if a_ignore_errors then
					error_handler.save
				else
					check not_error_handler_has_error: error_handler.has_error end
				end

					-- Perform parse
				if a_context_class /= Void then
					a_parser.set_filename (a_context_class.file_name)
				end
				a_parser.parse_from_utf8_string (a_text.as_string_8, a_context_class)

				has_error := error_handler.error_level /= l_level
				if a_ignore_errors then
						-- Remove any added errors
					error_handler.restore
				end

				if not has_error then
					set_last_ast (a_parser)
				end
			else
				has_error := True
			end
		ensure
			error_handler_has_error_unchanged: error_handler.has_error = old error_handler.has_error
			error_handler_has_warning_unchanged: error_handler.has_warning = old error_handler.has_warning
		end

	parse_with_option (a_parser: EIFFEL_PARSER; a_text: READABLE_STRING_8; a_options: CONF_OPTION; a_ignore_errors: BOOLEAN; a_context_class: ABSTRACT_CLASS_C)
			-- Performs a parse using an Eiffel parser.
			--
			-- `a_parser'       : The Eiffel parser to perform a parse with.
			-- `a_text'         : The Eiffel text to parse using the supplied parser. In UTF-8.
			-- `a_options'      : The configuration options to apply to the parser before parsing.
			-- `a_ignore_errors': True to remove all errors and warnings from the error handler after a
			--                    parse has been completed; False to retain them.
		require
			a_parser_attached: a_parser /= Void
			a_text_attached: a_text /= Void
		do
			inspect a_options.syntax.index
			when {CONF_OPTION}.syntax_index_obsolete then
				a_parser.set_syntax_version ({EIFFEL_SCANNER}.obsolete_syntax)
			when {CONF_OPTION}.syntax_index_transitional then
				a_parser.set_syntax_version ({EIFFEL_SCANNER}.transitional_syntax)
			when {CONF_OPTION}.syntax_index_provisional then
				a_parser.set_syntax_version ({EIFFEL_SCANNER}.provisional_syntax)
			else
				a_parser.set_syntax_version ({EIFFEL_SCANNER}.ecma_syntax)
			end
			a_parser.set_is_ignoring_attachment_marks (a_options.void_safety.index = {CONF_OPTION}.void_safety_index_none)
			parse (a_parser, a_text, a_ignore_errors, a_context_class)
		end

feature {NONE} -- Basic operations

	reset
			-- Resets the current parser's state
		do
			ast_node := Void
			ast_match_list := Void
			has_error := False
		ensure
			ast_node_detached: ast_node = Void
			ast_match_list_detached: ast_match_list = Void
			not_has_error: not has_error
		end

;note
	copyright: "Copyright (c) 1984-2013, Eiffel Software"
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
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"

end
