indexing

	description: 
		"Formatting context for class ast (produces image for class_ast).";
	date: "$Date$";
	revision: "$Revision $"

class FORMAT_CONTEXT

inherit

	SHARED_ERROR_HANDLER;
	SHARED_OPERATOR_TABLE;
	SHARED_TEXT_ITEMS

creation

	make, make_for_case

feature -- Initialization

	make_for_case is
			-- Initialize current for simple
			-- format for eiffelcase (to get
			-- image of precondition and postcondition).
		do
			!! format_stack.make;
			!! text.make;
			format_stack.extend (format);
			!! format;
			format_stack.extend (format);
		end;

	make (ast: CLASS_AS) is
			-- Initialize current for simple
			-- format.
		require
			valid_ast: ast /= Void
		do
			make_for_case;
			class_ast := ast
		ensure
			set: class_ast = ast
		end;

feature -- Properties

	class_ast: CLASS_AS
			-- Class ast being formatted

 	format: LOCAL_FORMAT;
			-- Current internal formatting directives.

	format_stack: LINKED_STACK [like format];
			-- Stack to keep track of all formats.
			-- Push at begin, pop at commit and rollback.

	text: STRUCTURED_TEXT;
			-- Formatted text

	name_of_current_feature: STRING;
			-- Name of feature currently being processed

	arguments: AST_EIFFEL;
			-- Argument for feature being adapted

feature -- Access

	formal_name (pos: INTEGER): ID_AS is
			-- Formal name of `class_ast'
		require
			valid_pos: pos > 0;
		do
			Result := clone (class_ast.generics.i_th (pos).formal_name)
			Result.to_upper;
		end;

	is_feature_visible: BOOLEAN is
			-- Is Current analyzed feature visible?
			-- (Yes it is)
		do
			Result := True
		end;

feature -- Local format setting details

	set_separator (s: TEXT_ITEM) is
			-- Set current separator to `s'.
		do
			format.set_separator (s);
		ensure
			format.separator = s
		end;

	set_new_line_between_tokens is
			-- Use a new line between tokens.
		local
			f: like format
		do
			f := format;
			f.set_new_line_between_tokens (True);
			f.set_space_between_tokens (False)
		ensure
			format.new_line_between_tokens;
			not format.space_between_tokens;
		end;

	set_space_between_tokens is
			-- Add a space character after the separator.
		local
			f: like format
		do
			f := format;
			f.set_new_line_between_tokens (false);
			f.set_space_between_tokens (true)
		ensure
			not format.new_line_between_tokens;
			format.space_between_tokens
		end;

	set_no_new_line_between_tokens is
			-- Neither new line nor space between tokens.
		local
			f: like format
		do
			f := format;
			f.set_new_line_between_tokens (false);
			f.set_space_between_tokens (false)
		ensure
			not format.new_line_between_tokens;
			not format.space_between_tokens
		end;

	indent is
			-- Indent next output line by one tab.
		do
			format.indent;
		end;

	exdent is
			-- Remove one leading tab for next line.
		require
			valid_indent: format.indent_depth > 0
		do
			format.exdent;
		end;

	need_dot is
			-- Formatting needs dot.
		do
			format.set_dot_needed (true);
		ensure
			format.dot_needed
		end;

feature -- Update

	begin is
			-- Save current format before a change.
			-- (To keep track of indent depth, separator etc.)
		local
			new_format: like format;
		do
			new_format := clone (format);
			format_stack.extend (new_format);
			format := new_format;
		ensure
			valid_format: format /= Void and then
					format = format_stack.item
		end;

	commit is
			-- Go back to previous format. 
			-- Keep text modifications.
		do
			format_stack.remove;
			format := format_stack.item;
		ensure
			format_removed: not format_stack.has (old format)
		end;

feature -- Indentation

	tabs_emitted: BOOLEAN;
			-- Have leading tabs already been emitted?

	emit_tabs is
			-- Emit tabs according to indent depth of current `format'.
		require
			not_tabs_emitted: not tabs_emitted	
		local
			i: INTEGER
		do
			i := format.indent_depth;
			if i > 0 then
				text.add (tab_with (i));
			end;
			tabs_emitted := True;
		end;

feature -- Element change

	prepare_for_current is
			-- Prepare for Current.
		do
			arguments := Void;
		ensure
			arguments = Void
		end;

	prepare_for_feature (name: STRING; arg: EIFFEL_LIST [EXPR_AS]) is
			-- Prepare for features within main features.
		do
			name_of_current_feature := clone (name);
			arguments := arg
		ensure
			arguments = arg;
		end;

	prepare_for_main_infix is
			-- Prepare for class features.
		do
			arguments := Void;
		end;

	prepare_for_main_feature is
			-- Prepare for class features.
		do
			arguments := Void
		end;

	prepare_for_main_prefix is
			-- Prepare for class features.
		do
			arguments := Void
		end;

	prepare_for_result is
			-- Prepare for Result.
		do
			arguments := Void
		end;

	prepare_for_infix (internal_name: STRING; right: EXPR_AS) is
			-- Prepare for infix feature.
		local
			name: STRING
		do
			name := clone (internal_name);
			name.tail (name.count - 7);
			name_of_current_feature := operator_table.name (name);
			arguments := right
		end;

	prepare_for_prefix (internal_name: STRING) is
			-- Prepare for prefix feature.
		local
			name: STRING
		do
			name := clone (internal_name);
			name.tail (name.count - 8);
			name_of_current_feature := operator_table.name (name);
			arguments := Void
		end;

feature -- Output

	reversed_format_list (list: EIFFEL_LIST [AST_EIFFEL]) is
			-- Format `list' in reverse order.
		require
			valid_list: list /= Void
		do
			list.reversed_simple_format (Current)
		end;

	format_ast (ast: AST_EIFFEL) is
			-- Call simple_for on `ast'.
		require
			valid_ast: ast /= Void
		do
			ast.simple_format (Current)
		end;

	put_breakable is
			-- Put breakable point.
			--| Do nothing - convenience routine.
		do
		end;

	put_string (s: STRING) is
			-- Append `s' to `text'.
		require
			s_exists: s /= Void;
		local
			item: BASIC_TEXT	
		do
			if not tabs_emitted then
				emit_tabs;
			end;
			!! item.make (s);
			text.add (item);
		end;

	put_special (s: STRING) is
			-- Append `s' to `text', known as a special character.
		local
			item: BASIC_TEXT;
		do
			!! item.make (s);
			item.set_is_special;
			text.add (item);	
		end;

	put_space is
			-- Append space.
		do
			text.add (ti_Space)
		end;

	put_separator is
			-- Append the current separator to `text'.
		local
			f: like format
		do
			f := format;
			if f.separator /= Void then
				text.add (f.separator)
			end;
			if f.space_between_tokens then
				text.add (ti_Space)
			elseif f.new_line_between_tokens then
				new_line
			end;
		end;

	new_line is
			-- Go to beginning of next line in `text'.
		do
			text.add (ti_New_line);
			tabs_emitted := False
		end;

	put_text_item_without_tabs (t: TEXT_ITEM) is
			-- Append `t' to `text'. Do not emit tabs.
		do
			text.add (t)
		end

	put_text_item (t: TEXT_ITEM) is
			-- Append `t' to `text'. Emit tabs if needed.
		require
			t_not_void: t /= Void
		do
			if not tabs_emitted then
				emit_tabs;
			end
			text.add (t)
		end;

	new_expression is
			-- Prepare for a new expression.
		do
			format.set_dot_needed (False)
		ensure
			not format.dot_needed
		end;
			
	put_current_feature, put_normal_feature is
			-- Put a normal feature.
		local
			arg: EIFFEL_LIST [EXPR_AS];
			item: BASIC_TEXT;
			i, nb: INTEGER;
		do
			if format.dot_needed then
				text.add (ti_Dot)
			elseif not tabs_emitted then
				emit_tabs
			end;
			!! item.make (name_of_current_feature)
			text.add (item);
			arg ?= arguments;
			if arg /= void then
				begin;
				set_separator (ti_Comma);
				set_space_between_tokens;
				text.add (ti_Space)
				text.add (ti_L_parenthesis);
				arguments.simple_format (Current);
				text.add (ti_R_parenthesis);
				commit;
				from
					arg.start;
					nb := arg.count;
					i := 1;
				until
					i > nb
				loop
					i := i + i
				end
			end;
		end;

	put_prefix_feature is
			-- Put prefix feature in `text'.
		local
			item: BASIC_TEXT;
		do
			if not tabs_emitted then
				emit_tabs
			end;
			!! item.make (name_of_current_feature)
			text.add (item);
		end;

	put_infix_feature is
			-- Put infix feature in `text'.
		local
			arg: EXPR_AS;
			item: BASIC_TEXT
		do
			text.add (ti_Space);
			!! item.make (operator_table.name (name_of_current_feature))
			text.add (item);
			text.add (ti_Space);
			arg ?= arguments;
			if arg /= void then
				begin;
				new_expression;
				arg.simple_format (Current);
				commit;
			end;
		end;

	put_comment (comment: EIFFEL_COMMENTS) is
			-- Put `comment' in `text'.
		require
			valid_comment: comment /= Void
		local
			i: INTEGER;
		do
			from
				from
					i := 1
				until
					i > comment.count or else
					comment.text.item (i).empty or else
					comment.text.item (i).item (1) /= '|'
				loop
					i := i + 1
				end;
				if i <= comment.count then
					put_text_item (ti_Dashdash);
					put_comment_text (comment.text.item (i))
					new_line;
				end;
				i := i + 1
			until
				i > comment.count
			loop
				if 
					comment.text.item (i).empty or else
					comment.text.item (i).item (1) /= '|' 
				then
					put_text_item (ti_Dashdash);
					put_comment_text (comment.text.item (i))
					new_line;
				end;
				i := i + 1
			end
		end;

	put_origin_comment is
		do
		end;

	put_comment_text (c: STRING) is
			-- Interprete the ` and ' signs of the comment
			-- and append it to `text'.
		require
			c_not_void: c /= Void
		local
			item: BASIC_TEXT;
			i, c_count: INTEGER;
			c_area: SPECIAL [CHARACTER];
			between_quotes: BOOLEAN;
			s: STRING
		do
			from
				!!s.make (0);
				c_count := c.count;
				c_area := c.area
			until
				i >= c_count
			loop
				if between_quotes and c_area.item (i) = '%'' then
					if not s.empty then
						!!item.make (s);
						put_text_item (item);
						!!s.make (0)
					end;
					between_quotes := false
				elseif not between_quotes and c_area.item (i) = '`' then
					if not s.empty then
						!!item.make (s);
						item.set_is_comment;
						put_text_item (item);
						!!s.make (0)
					end;
					between_quotes := true
				else
					s.extend (c_area.item (i))
				end;
				i := i + 1
			end;
			if not s.empty then
				!! item.make (s);
				item.set_is_comment;
				text.add (item)
			end
		end;

feature {NONE} -- Implementation

	tabs_array: ARRAY [INDENT_TEXT] is
			-- Array of five tab texts
		once
			Result := <<ti_Tab1, ti_Tab2, ti_Tab3, ti_Tab4, ti_Tab5>>
		end;

	tab_with (i: INTEGER): INDENT_TEXT is
			-- Tab text with indent depth of `i'
		require
			positive_i: i > 0
		do
			if i > 5 then
				!! Result.make (i)
			else
				Result := tabs_array @ i
			end
		ensure
			valid_result: Result /= Void
		end;

invariant

	valid_stack: format_stack /= Void;
	valid_format: format /= Void and then format_stack.item = format
	valid_text: text /= Void

end	-- class FORMAT_CONTEXT
