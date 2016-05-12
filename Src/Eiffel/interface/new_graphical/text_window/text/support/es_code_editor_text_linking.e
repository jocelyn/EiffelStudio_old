note
	description: "Get editor tokens and linking tokens from a given text"
	date: "$Date$"
	revision: "$Revision$"

class
	ES_CODE_EDITOR_TEXT_LINKING

inherit
	ES_CODE_EDITOR_LINKING
		redefine
			begin,
			finish,
			execute
		end

create
	make

feature {NONE} -- Initialization

	make (a_text: EDITABLE_TEXT; a_editor: EB_EDITOR)
			-- Create an instance with stone `a_stone'.
		do
			editor := a_editor
			text := a_text
			get_tokens
		end

	editor: EB_EDITOR

	text: EDITABLE_TEXT

feature -- Access

	editing_token: detachable ES_CODE_EDITOR_LINKED_ITEM

	linked_tokens: detachable ARRAYED_LIST [ES_CODE_EDITOR_LINKED_ITEM]
			-- tokens and their positions.

	is_active: BOOLEAN
			-- Is linked editing?
		do
			Result := linked_tokens /= Void and editing_token /= Void
		end

feature -- Execute

	begin
		local
			tok: EDITOR_TOKEN
			bgcol: EV_COLOR
			txt: like text
			pos: INTEGER
		do
			if
				attached linked_tokens as lst and
				attached editing_token as l_editing_token
			then
				print ("Begin linked editing [nb tokens:" + lst.count.out +", token=%"" + l_editing_token.token.wide_image + "%"].%N")

				create bgcol.make_with_8_bit_rgb (210, 255, 210)

				txt := text
				pos := txt.cursor.pos_in_text
				across
					lst as ic
				loop
					tok := ic.item.token
					print (" - " + ic.item.debug_output + " -> %"" + tok.wide_image + "%"%N")
					tok.set_background_color (bgcol)
				end
				refresh_related_lines
				txt.cursor.go_to_position (pos)
				txt.disable_selection

--				txt.cursor.go_end_word
			end
		end

	finish
		local
			tok: EDITOR_TOKEN
			bgcol: detachable EV_COLOR
			pos: INTEGER
		do
			if attached linked_tokens as lst and then attached text as txt then
				print ("Finish linked editing [nb tokens:" + lst.count.out + "].%N")
				if attached txt.cursor as curs then
					pos := curs.pos_in_text
					create bgcol.make_with_8_bit_rgb (0,0,0)
					across
						lst as ic
					loop
						tok := ic.item.token
						print (" - " + ic.item.debug_output + " -> %"" + tok.wide_image + "%"%N")
						tok.set_background_color (Void)
					end
					refresh_related_lines
					curs.go_to_position (pos)
				end

				linked_tokens := Void
			end
			editing_token := Void
		end

	execute (op: detachable READABLE_STRING_8)
		local
			bgcol: EV_COLOR
			tok: detachable EDITOR_TOKEN
			diff,off: INTEGER
			txt: like text
			s,cs: STRING_32
			pos,i,j,k: INTEGER
		do
			if
				attached linked_tokens as lst and
			 	attached editing_token as l_editing_token
			then
				txt := text
				create bgcol.make_with_8_bit_rgb (255, 0, 0)
--				l_editing_token.line.update_token_information

				pos := txt.cursor.pos_in_text
				if is_valid_editing_position (txt.cursor.pos_in_text) then
					tok := txt.cursor.token
				else
					tok := txt.cursor.token.previous
					update_pos_in_text (tok)
					if
						tok.pos_in_text > 0 and then
						not is_valid_editing_position (tok.pos_in_text)
					then
						tok := Void
					end
				end
				if tok /= Void then
					cs := tok.wide_image
					k := tok.pos_in_text
					if k = 0 then
						k := l_editing_token.start_pos
					end
					i := l_editing_token.start_pos
					j := l_editing_token.end_pos

					l_editing_token.start_pos := k
					l_editing_token.end_pos := l_editing_token.start_pos + tok.length
					off := (l_editing_token.end_pos - l_editing_token.start_pos) - (j - i)
					s := cs
	--				txt.select_region (i,j)
	--				s := txt.selected_wide_string
	--				txt.disable_selection
	--				off := 1
	--				txt.cursor.go_to_position (pos)

					print ("Execute linked editing [pos=" + pos.out + "].%N")
					print (" editing token " + l_editing_token.debug_output + " %"" + cs + "%".%N")
					print (" cursor token:%"" + cs + "%".%N")
	--				print (" editing token:%"" + s + "%".%N")

					across
						lst as ic
					loop
						tok := ic.item.token
						if is_editing_token (ic.item) then
							print ("%N!" + ic.item.debug_output + " [off=" + off.out + ",diff="+diff.out+"] Editing !!!%N")
						else
							ic.item.start_pos := ic.item.start_pos + off
							ic.item.end_pos := ic.item.end_pos + off
							diff := s.count - (ic.item.end_pos - ic.item.start_pos)

							txt.replace_for_replace_all (ic.item.start_pos, ic.item.end_pos, s)
							print ("%N " + ic.item.debug_output + " [off=" + off.out + ",diff="+diff.out+"] %"" + "..." + "%" replaced with %""+ s +"%".%N")
--							txt.select_region (ic.item.start_pos, ic.item.end_pos)
--							print ("%N " + ic.item.debug_output + " [off=" + off.out + ",diff="+diff.out+"] %"" + txt.selected_wide_string + "%" replaced with %""+ s +"%".%N")
----							txt.replace_selection (s)
--							txt.disable_selection
							off := off + diff
							ic.item.end_pos := ic.item.end_pos + diff
							tok.set_background_color (bgcol)
							ic.item.line.update_token_information
						end
					end
					refresh_related_lines
					txt.cursor.go_to_position (pos)
	--				editor.update_line_and_token_info
--					editor.flush

				else
					print ("Execute linked editing outside editing token %"" + txt.cursor.token.wide_image + "%"!!!%N")
					finish
				end
			end
		end

	update_pos_in_text (tok: EDITOR_TOKEN)
			-- Try updating `tok.pos_in_text` if missing.
		local
			prev_tok: detachable EDITOR_TOKEN
		do
			if tok.pos_in_text = 0 then
				prev_tok := tok.previous
				if prev_tok /= Void and then prev_tok.pos_in_text > 0 then
					tok.set_pos_in_text (prev_tok.pos_in_text + prev_tok.length)
				end
			end
		end

	refresh_related_lines
		local
			txt: like text
			pos: INTEGER
		do
			if attached linked_tokens as lst then
--				editor.flush
				txt := text
				pos := txt.cursor.pos_in_text
				across
					lst as ic
				loop
					if ic.item.end_pos > 0 then
						txt.cursor.go_to_position (ic.item.end_pos)
						editor.redraw_current_line
					elseif attached ic.item.line as l_line and then l_line.is_valid then
						txt.go_i_th (l_line.index)
						editor.redraw_current_line
					else
						editor.redraw_current_screen
					end
				end
				txt.cursor.go_to_position (pos)
			end
		end

feature {NONE} -- Implementation

	is_editing_token (a_item: like editing_token): BOOLEAN
		do
			if a_item /= Void and attached editing_token as l_editing_token then
				Result := a_item.start_pos = l_editing_token.start_pos --and l_editing_token.end_pos <= a_item.end_pos
				print (" " + l_editing_token.debug_output + " Check is_editing_token (" + a_item.debug_output + ") ? : " + Result.out + " .%N")
			end
		end

	is_valid_editing_position (a_pos_in_text: INTEGER): BOOLEAN
		do
			if a_pos_in_text > 0 and attached editing_token as l_editing_token then
				Result := l_editing_token.start_pos <= a_pos_in_text and a_pos_in_text <= l_editing_token.end_pos
				print (" " + l_editing_token.debug_output + " Check is_valid_editing_position (" + a_pos_in_text.out + ") ? : " + Result.out + " .%N")
			end
		end

	get_tokens
		local
			l_curr_line: EDITOR_LINE
			l_curr_token: EDITOR_TOKEN
			tok: detachable EDITOR_TOKEN
			l_line: EDITOR_LINE
			l_linked_tokens: like linked_tokens
			txt: like text
			l_editing_token: like editing_token
			l_item: ES_CODE_EDITOR_LINKED_ITEM
		do
			create l_linked_tokens.make (1)
			linked_tokens := l_linked_tokens

			txt := text
			l_curr_token := txt.cursor.token
			l_curr_line := txt.cursor.line
			if
				l_curr_token.is_text and then
				attached l_curr_token.wide_image as l_varname
			then
				create l_editing_token.make (l_curr_line, l_curr_token, l_curr_token.pos_in_text, l_curr_token.pos_in_text + l_curr_token.length)
				editing_token := l_editing_token

				print ("%NGet tokens %"" + l_varname + "%":%N")
				print (" -!" + l_editing_token.debug_output + " -> %"" + l_editing_token.token.wide_image + "%"%N")

				from
					l_line := l_curr_line
					tok := l_curr_token
				until
					tok = Void or l_line = Void--or attached {EDITOR_TOKEN_EOL} t
				loop
					if tok.wide_image.is_case_insensitive_equal (l_varname) then
						create l_item.make (l_line, tok, tok.pos_in_text, tok.pos_in_text + tok.length)
						print (" - " + l_item.debug_output + " -> %"" + tok.wide_image + "%"%N")
						l_linked_tokens.force (l_item)
					end
					tok := tok.next
					if tok = Void then
						if l_line /= Void then
							l_line := l_line.next
							if l_line /= Void then
								tok := l_line.first_token
							end
						end
					end
				end
				from
					tok := l_curr_token.previous
					l_line := l_curr_line
				until
					tok = Void or l_line = Void
				loop
					if tok.wide_image.is_case_insensitive_equal (l_varname) then
						create l_item.make (l_line, tok, tok.pos_in_text, tok.pos_in_text + tok.length)
						print (" - " + l_item.debug_output + " -> %"" + tok.wide_image + "%"%N")
						l_linked_tokens.put_front (l_item)
					end
					tok := tok.previous
					if tok = Void then
						if l_line /= Void then
							l_line := l_line.previous
							if l_line /= Void then
								from
									tok := l_line.first_token
								until
									attached {EDITOR_TOKEN_EOL} tok or tok = Void
								loop
									if tok /= Void then
										tok := tok.next
									end
								end
							end
						end
					end
				end
			end
		end

;note
	copyright: "Copyright (c) 1984-2016, Eiffel Software"
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
