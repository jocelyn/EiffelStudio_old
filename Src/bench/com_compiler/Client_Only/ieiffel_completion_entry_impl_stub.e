indexing
	description: "Implemented `IEiffelCompletionEntry' Interface."
	Note: "Automatically generated by the EiffelCOM Wizard."

class
	IEIFFEL_COMPLETION_ENTRY_IMPL_STUB

inherit
	IEIFFEL_COMPLETION_ENTRY_INTERFACE

	ECOM_STUB

feature -- Access

	name: STRING is
			-- Feature name.
		do
			-- Put Implementation here.
		end

	signature: STRING is
			-- Feature signature.
		do
			-- Put Implementation here.
		end

feature -- Basic Operations

	is_feature (return_value: BOOLEAN_REF) is
			-- Is entry a feature?
			-- `return_value' [out].  
		do
			-- Put Implementation here.
		end

	create_item is
			-- Initialize `item'
		do
			item := ccom_create_item (Current)
		end

feature {NONE}  -- Externals

	ccom_create_item (eif_object: IEIFFEL_COMPLETION_ENTRY_IMPL_STUB): POINTER is
			-- Initialize `item'
		external
			"C++ [new ecom_eiffel_compiler::IEiffelCompletionEntry_impl_stub %"ecom_eiffel_compiler_IEiffelCompletionEntry_impl_stub.h%"](EIF_OBJECT)"
		end

end -- IEIFFEL_COMPLETION_ENTRY_IMPL_STUB

