indexing
	description: "Implemented `IEnumObjectFiles' Interface."
	Note: "Automatically generated by the EiffelCOM Wizard."

class
	IENUM_OBJECT_FILES_IMPL_STUB

inherit
	IENUM_OBJECT_FILES_INTERFACE

	ECOM_STUB

feature -- Access

	count: INTEGER is
			-- Retrieve enumerator item count.
		do
			-- Put Implementation here.
		end

feature -- Basic Operations

	next (pbstr_object_file: CELL [STRING]; pul_fetched: INTEGER_REF) is
			-- Go to next item in enumerator
			-- `pbstr_object_file' [out].  
			-- `pul_fetched' [out].  
		do
			-- Put Implementation here.
		end

	skip (ul_count: INTEGER) is
			-- Skip `ulCount' items.
			-- `ul_count' [in].  
		do
			-- Put Implementation here.
		end

	reset is
			-- Reset enumerator.
		do
			-- Put Implementation here.
		end

	clone1 (pp_ienum_object_files: CELL [IENUM_OBJECT_FILES_INTERFACE]) is
			-- Clone enumerator.
			-- `pp_ienum_object_files' [out].  
		do
			-- Put Implementation here.
		end

	ith_item (ul_index: INTEGER; pbstr_object_file: CELL [STRING]) is
			-- Retrieve enumerators ith item at `ulIndex'.
			-- `ul_index' [in].  
			-- `pbstr_object_file' [out].  
		do
			-- Put Implementation here.
		end

	create_item is
			-- Initialize `item'
		do
			item := ccom_create_item (Current)
		end

feature {NONE}  -- Externals

	ccom_create_item (eif_object: IENUM_OBJECT_FILES_IMPL_STUB): POINTER is
			-- Initialize `item'
		external
			"C++ [new ecom_EiffelComCompiler::IEnumObjectFiles_impl_stub %"ecom_EiffelComCompiler_IEnumObjectFiles_impl_stub_s.h%"](EIF_OBJECT)"
		end

end -- IENUM_OBJECT_FILES_IMPL_STUB

