-- This file has been generated by EWG. Do not edit. Changes will be lost!
-- wrapper for struct: struct MeasureWindowTitleRec

class MEASURE_WINDOW_TITLE_REC_STRUCT_EXTERNAL

feature {NONE} -- Implementation

	sizeof_external: INTEGER is
		external
			"C [macro <Carbon/Carbon.h>]: EIF_INTEGER"
		alias
			"sizeof(struct MeasureWindowTitleRec)"
		end

	get_fulltitlewidth_external (an_item: POINTER): INTEGER is
		require
			an_item_not_null: an_item /= default_pointer
		external
			"C [macro <ewg_carbon_struct_c_glue_code.h>]"
		alias
			"ewg_struct_macro_struct_MeasureWindowTitleRec_member_get_fullTitleWidth"
		end

	set_fulltitlewidth_external (an_item: POINTER; a_value: INTEGER) is
		require
			an_item_not_null: an_item /= default_pointer
		external
			"C [macro <ewg_carbon_struct_c_glue_code.h>]"
		alias
			"ewg_struct_macro_struct_MeasureWindowTitleRec_member_set_fullTitleWidth"
		ensure
			a_value_set: a_value = get_fulltitlewidth_external (an_item)
		end

	get_titletextwidth_external (an_item: POINTER): INTEGER is
		require
			an_item_not_null: an_item /= default_pointer
		external
			"C [macro <ewg_carbon_struct_c_glue_code.h>]"
		alias
			"ewg_struct_macro_struct_MeasureWindowTitleRec_member_get_titleTextWidth"
		end

	set_titletextwidth_external (an_item: POINTER; a_value: INTEGER) is
		require
			an_item_not_null: an_item /= default_pointer
		external
			"C [macro <ewg_carbon_struct_c_glue_code.h>]"
		alias
			"ewg_struct_macro_struct_MeasureWindowTitleRec_member_set_titleTextWidth"
		ensure
			a_value_set: a_value = get_titletextwidth_external (an_item)
		end

	get_isunicodetitle_external (an_item: POINTER): INTEGER is
		require
			an_item_not_null: an_item /= default_pointer
		external
			"C [macro <ewg_carbon_struct_c_glue_code.h>]"
		alias
			"ewg_struct_macro_struct_MeasureWindowTitleRec_member_get_isUnicodeTitle"
		end

	set_isunicodetitle_external (an_item: POINTER; a_value: INTEGER) is
		require
			an_item_not_null: an_item /= default_pointer
		external
			"C [macro <ewg_carbon_struct_c_glue_code.h>]"
		alias
			"ewg_struct_macro_struct_MeasureWindowTitleRec_member_set_isUnicodeTitle"
		ensure
			a_value_set: a_value = get_isunicodetitle_external (an_item)
		end

	get_unused_external (an_item: POINTER): INTEGER is
		require
			an_item_not_null: an_item /= default_pointer
		external
			"C [macro <ewg_carbon_struct_c_glue_code.h>]"
		alias
			"ewg_struct_macro_struct_MeasureWindowTitleRec_member_get_unused"
		end

	set_unused_external (an_item: POINTER; a_value: INTEGER) is
		require
			an_item_not_null: an_item /= default_pointer
		external
			"C [macro <ewg_carbon_struct_c_glue_code.h>]"
		alias
			"ewg_struct_macro_struct_MeasureWindowTitleRec_member_set_unused"
		ensure
			a_value_set: a_value = get_unused_external (an_item)
		end

end

