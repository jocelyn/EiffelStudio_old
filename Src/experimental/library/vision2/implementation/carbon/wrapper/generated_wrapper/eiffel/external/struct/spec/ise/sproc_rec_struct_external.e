-- This file has been generated by EWG. Do not edit. Changes will be lost!
-- wrapper for struct: struct SProcRec

class SPROC_REC_STRUCT_EXTERNAL

feature {NONE} -- Implementation

	sizeof_external: INTEGER is
		external
			"C [macro <Carbon/Carbon.h>]: EIF_INTEGER"
		alias
			"sizeof(struct SProcRec)"
		end

	get_nxtsrch_external (an_item: POINTER): POINTER is
		require
			an_item_not_null: an_item /= default_pointer
		external
			"C [macro <ewg_carbon_struct_c_glue_code.h>]"
		alias
			"ewg_struct_macro_struct_SProcRec_member_get_nxtSrch"
		end

	set_nxtsrch_external (an_item: POINTER; a_value: POINTER) is
		require
			an_item_not_null: an_item /= default_pointer
		external
			"C [macro <ewg_carbon_struct_c_glue_code.h>]"
		alias
			"ewg_struct_macro_struct_SProcRec_member_set_nxtSrch"
		ensure
			a_value_set: a_value = get_nxtsrch_external (an_item)
		end

	get_srchproc_external (an_item: POINTER): POINTER is
		require
			an_item_not_null: an_item /= default_pointer
		external
			"C [macro <ewg_carbon_struct_c_glue_code.h>]"
		alias
			"ewg_struct_macro_struct_SProcRec_member_get_srchProc"
		end

	set_srchproc_external (an_item: POINTER; a_value: POINTER) is
		require
			an_item_not_null: an_item /= default_pointer
		external
			"C [macro <ewg_carbon_struct_c_glue_code.h>]"
		alias
			"ewg_struct_macro_struct_SProcRec_member_set_srchProc"
		ensure
			a_value_set: a_value = get_srchproc_external (an_item)
		end

end

