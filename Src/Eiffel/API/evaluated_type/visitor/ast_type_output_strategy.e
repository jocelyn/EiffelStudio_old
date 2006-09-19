indexing
	description: "Formats TYPE_A instances using TEXT_FORMATTER"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	AST_TYPE_OUTPUT_STRATEGY

inherit
	TYPE_A_VISITOR

	COMPILER_EXPORTER
		export
			{NONE} all
		end

	SHARED_WORKBENCH
		export
			{NONE} all
		end

	SHARED_TEXT_ITEMS
		export
			{NONE} all
		end

	SHARED_NAMES_HEAP
		export
			{NONE} all
		end

create
	default_create

feature -- Initialization

	process (a_type: TYPE_A; a_text_formatter: TEXT_FORMATTER; a_class: CLASS_C; a_feature: FEATURE_I) is
			-- Output `a_type' into `a_text_formatter' using context of `a_class' and `a_feature'.
			-- `a_feature' is only used when resolving anchors to argument.
		require
			a_text_formatter_not_void: a_text_formatter /= Void
			a_class_not_void: a_class /= Void
		do
			text_formatter := a_text_formatter
			current_class := a_class
			current_feature := a_feature
			a_type.process (Current)
			text_formatter := Void
			current_class := Void
			current_feature := Void
		ensure
			no_state: text_formatter = Void and current_class = Void and current_feature = Void
		end

feature -- Access

	text_formatter: TEXT_FORMATTER
			-- Output formatter.

	current_class: CLASS_C
			-- Type is being viewed in this class.

	current_feature: FEATURE_I
			-- Current feature where type appears.

feature {NONE} -- Helper

	process_generic_in_gen_type (a_type: TYPE_A) is
			-- Process generic in generic type.
		require
			a_type_not_void: a_type /= Void
		local
			l_feature_i: TYPE_FEATURE_I
			l_formal: FORMAL_A
		do
			if not a_type.is_formal then
				a_type.process (Current)
			else
					-- Try solving a formal type.
				l_formal ?= a_type
				check l_formal_not_void: l_formal /= Void end
				l_feature_i := current_class.formal_at_position (l_formal.position)
				if l_feature_i /= Void then
					l_feature_i := current_class.generic_features.item (l_feature_i.rout_id_set.first)
					if l_feature_i /= Void then
						l_feature_i.type.process (Current)
					end
				end
				if l_feature_i = Void then
						-- Some errors occurred when trying to evaluate the type of the formal
						-- in `current_class', simply display the formal without trying to resolve it.
					a_type.process (Current)
				end
			end
		end

feature {TYPE_A} -- Visitors

	process_bits_a (a_type: BITS_A) is
			-- Process `a_type'.
		do
			text_formatter.process_keyword_text (ti_bit_class, Void)
			text_formatter.add_space
			text_formatter.add_int (a_type.bit_count)
		end

	process_bits_symbol_a (a_type: BITS_SYMBOL_A) is
			-- Process `a_type'.
		local
			l_feat : E_FEATURE
		do
			text_formatter.process_keyword_text (ti_bit_class, Void)
			text_formatter.add_space
			l_feat := current_class.feature_with_rout_id (a_type.rout_id)
			check
				l_feat_not_void: l_feat /= Void
			end
			text_formatter.process_feature_text (l_feat.name, l_feat, False)
		end

	process_boolean_a (a_type: BOOLEAN_A) is
			-- Process `a_type'.
		do
			process_cl_type_a (a_type)
		end

	process_character_a (a_type: CHARACTER_A) is
			-- Process `a_type'.
		do
			process_cl_type_a (a_type)
		end

	process_cl_type_a (a_type: CL_TYPE_A) is
			-- Process `a_type'.
		local
			l_class: CLASS_C
		do
			if a_type.has_expanded_mark then
				text_formatter.process_keyword_text (ti_expanded_keyword, Void)
				text_formatter.add_space
			elseif a_type.has_reference_mark then
				text_formatter.process_keyword_text (ti_reference_keyword, Void)
				text_formatter.add_space
			elseif a_type.has_separate_mark then
				text_formatter.process_keyword_text (ti_separate_keyword, Void)
				text_formatter.add_space
			end
			l_class := a_type.associated_class
			if l_class /= Void  then
				l_class.append_name (text_formatter)
			else
					-- Very rare case when a type refers to a class that has been removed
					-- from the universe.
				text_formatter.add ("Class_" + a_type.class_id.out + "_does_not_exist")
			end
		end

	process_formal_a (a_type: FORMAL_A) is
			-- Process `a_type'.
		do
			text_formatter.process_generic_text (current_class.generics.i_th (a_type.position).name.as_upper)
		end

	process_gen_type_a (a_type: GEN_TYPE_A) is
			-- Process `a_type'.
		local
			i, count: INTEGER
		do
			if a_type.is_separate then
				text_formatter.process_symbol_text (ti_separate_keyword)
				text_formatter.add_space
			end
			process_cl_type_a (a_type)
				-- TUPLE may have zero generic parameters
			count := a_type.generics.count
			if count > 0 then
				text_formatter.add_space
				text_formatter.process_symbol_text (ti_l_bracket)
				from
					i := 1
				until
					i > count
				loop
					process_generic_in_gen_type (a_type.generics.item (i))

					if i /= count then
						text_formatter.process_symbol_text (ti_comma)
						text_formatter.add_space
					end
					i := i + 1
				end
				text_formatter.process_symbol_text (ti_r_bracket)
			end
		end

	process_integer_a (a_type: INTEGER_A) is
			-- Process `a_type'.
		do
			process_cl_type_a (a_type)
		end

	process_like_argument (a_type: LIKE_ARGUMENT) is
			-- Process `a_type'.
		do
			text_formatter.process_keyword_text (ti_like_keyword, Void)
			text_formatter.add_space
			if current_feature /= Void and then current_feature.argument_count <= a_type.position then
				text_formatter.process_local_text (current_feature.arguments.item_name (a_type.position))
			else
				text_formatter.add (ti_argument_index)
				text_formatter.add_int (a_type.position)
			end
		end

	process_like_current (a_type: LIKE_CURRENT) is
			-- Process `a_type'.
		do
			text_formatter.process_keyword_text (ti_like_keyword, Void)
			text_formatter.add_space
			text_formatter.process_keyword_text (ti_current, Void)
		end

	process_like_feature (a_type: LIKE_FEATURE) is
			-- Process `a_type'.
		local
			l_feat: E_FEATURE
		do
			text_formatter.process_keyword_text (ti_like_keyword, Void)
			text_formatter.add_space
			l_feat := current_class.feature_with_rout_id (a_type.routine_id)
			check
				l_feat_not_void: l_feat /= Void
			end
			text_formatter.add_feature (l_feat, l_feat.name)
		end

	process_manifest_integer_a (a_type: MANIFEST_INTEGER_A) is
			-- Process `a_type'.
		do
			process_cl_type_a (a_type)
		end

	process_manifest_natural_64_a (a_type: MANIFEST_NATURAL_64_A) is
			-- Process `a_type'.
		do
			process_cl_type_a (a_type)
		end

	process_named_tuple_type_a (a_type: NAMED_TUPLE_TYPE_A) is
			-- Process `a_type'.
		local
			i, count: INTEGER
		do
			if a_type.is_separate then
				text_formatter.process_symbol_text (ti_separate_keyword)
				text_formatter.add_space
			end
			process_cl_type_a (a_type)
				-- TUPLE may have zero generic parameters
			count := a_type.generics.count
			if count > 0 then
				text_formatter.add_space
				text_formatter.process_symbol_text (ti_l_bracket)
				from
					i := 1
				until
					i > count
				loop
					text_formatter.process_local_text (a_type.label_name (i))
					text_formatter.process_symbol_text (ti_colon)
					text_formatter.add_space
					process_generic_in_gen_type (a_type.generics.item (i))
					if i /= count then
						text_formatter.process_symbol_text (ti_semi_colon)
						text_formatter.add_space
					end
					i := i + 1
				end
				text_formatter.process_symbol_text (ti_r_bracket)
			end
		end

	process_native_array_type_a (a_type: NATIVE_ARRAY_TYPE_A) is
			-- Process `a_type'.
		do
			process_gen_type_a (a_type)
		end

	process_natural_a (a_type: NATURAL_A) is
			-- Process `a_type'.
		do
			process_cl_type_a (a_type)
		end

	process_none_a (a_type: NONE_A) is
			-- Process `a_type'.
		do
			text_formatter.add (ti_none_class)
		end

	process_open_type_a (a_type: OPEN_TYPE_A) is
			-- Process `a_type'.
		do
			text_formatter.add (ti_open_arg)
		end

	process_pointer_a (a_type: POINTER_A) is
			-- Process `a_type'.
		do
			process_cl_type_a (a_type)
		end

	process_real_32_A (a_type: REAL_32_A) is
			-- Process `a_type'.
		do
			process_cl_type_a (a_type)
		end

	process_real_64_a (a_type: REAL_64_A) is
			-- Process `a_type'.
		do
			process_cl_type_a (a_type)
		end

	process_tuple_type_a (a_type: TUPLE_TYPE_A) is
			-- Process `a_type'.
		do
			process_gen_type_a (a_type)
		end

	process_typed_pointer_a (a_type: TYPED_POINTER_A) is
			-- Process `a_type'.
		do
			process_gen_type_a (a_type)
		end

	process_unevaluated_bits_symbol_a (a_type: UNEVALUATED_BITS_SYMBOL_A) is
			-- Process `a_type'.
		do
			text_formatter.process_keyword_text (ti_bit_class, Void)
			text_formatter.add_space
			text_formatter.add (a_type.symbol)
		end

	process_unevaluated_like_type (a_type: UNEVALUATED_LIKE_TYPE) is
			-- Process `a_type'.
		do
			text_formatter.process_keyword_text (ti_like_keyword, Void)
			text_formatter.add_space
			text_formatter.process_local_text (a_type.anchor)
		end

	process_void_a (a_type: VOID_A) is
			-- Process `a_type'.
		do
			text_formatter.process_keyword_text (ti_void, Void)
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
end
