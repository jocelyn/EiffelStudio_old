-- This file has been generated by EWG. Do not edit. Changes will be lost!
-- functions wrapper
class HIGEOMETRY_FUNCTIONS_EXTERNAL

feature
	frozen higet_scale_factor_external: REAL is
		external
			"C [macro <ewg_carbon_function_c_glue_code.h>] :float"
		alias
			"ewg_function_macro_HIGetScaleFactor"
		end

	frozen higet_scale_factor_address_external: POINTER is
			-- Address of C function `HIGetScaleFactor'
		external
			"C [macro <Carbon/Carbon.h>]: void*"
		alias
			"(void*) HIGetScaleFactor"
		end

	frozen hipoint_convert_external (iopoint: POINTER; insourcespace: INTEGER; insourceobject: POINTER; indestinationspace: INTEGER; indestinationobject: POINTER) is
		external
			"C [macro <ewg_carbon_function_c_glue_code.h>] (HIPoint*, HICoordinateSpace, void*, HICoordinateSpace, void*)"
		alias
			"ewg_function_macro_HIPointConvert"
		end

	frozen hipoint_convert_address_external: POINTER is
			-- Address of C function `HIPointConvert'
		external
			"C [macro <Carbon/Carbon.h>]: void*"
		alias
			"(void*) HIPointConvert"
		end

	frozen hirect_convert_external (iorect: POINTER; insourcespace: INTEGER; insourceobject: POINTER; indestinationspace: INTEGER; indestinationobject: POINTER) is
		external
			"C [macro <ewg_carbon_function_c_glue_code.h>] (HIRect*, HICoordinateSpace, void*, HICoordinateSpace, void*)"
		alias
			"ewg_function_macro_HIRectConvert"
		end

	frozen hirect_convert_address_external: POINTER is
			-- Address of C function `HIRectConvert'
		external
			"C [macro <Carbon/Carbon.h>]: void*"
		alias
			"(void*) HIRectConvert"
		end

	frozen hisize_convert_external (iosize: POINTER; insourcespace: INTEGER; insourceobject: POINTER; indestinationspace: INTEGER; indestinationobject: POINTER) is
		external
			"C [macro <ewg_carbon_function_c_glue_code.h>] (HISize*, HICoordinateSpace, void*, HICoordinateSpace, void*)"
		alias
			"ewg_function_macro_HISizeConvert"
		end

	frozen hisize_convert_address_external: POINTER is
			-- Address of C function `HISizeConvert'
		external
			"C [macro <Carbon/Carbon.h>]: void*"
		alias
			"(void*) HISizeConvert"
		end

end
