indexing
	description: "Implemented `IEiffelCompletionInfo' Interface."
	Note: "Automatically generated by the EiffelCOM Wizard."

class
	IEIFFEL_COMPLETION_INFO_IMPL_PROXY

inherit
	IEIFFEL_COMPLETION_INFO_INTERFACE

	ECOM_QUERIABLE

creation
	make_from_other,
	make_from_pointer

feature {NONE}  -- Initialization

	make_from_pointer (cpp_obj: POINTER) is
			-- Make from pointer
		do
			initializer := ccom_create_ieiffel_completion_info_impl_proxy_from_pointer(cpp_obj)
			item := ccom_item (initializer)
		end

feature -- Status Report

	last_error_code: INTEGER is
			-- Last error code.
		do
			Result := ccom_last_error_code (initializer)
		end

	last_error_description: STRING is
			-- Last error description.
		do
			Result := ccom_last_error_description (initializer)
		end

	last_error_help_file: STRING is
			-- Last error help file.
		do
			Result := ccom_last_error_help_file (initializer)
		end

	last_source_of_exception: STRING is
			-- Last source of exception.
		do
			Result := ccom_last_source_of_exception (initializer)
		end

feature -- Basic Operations

	add_local (bstr_name: STRING; bstr_type: STRING) is
			-- Add a local variable used for solving member completion list
			-- `bstr_name' [in].  
			-- `bstr_type' [in].  
		do
			ccom_add_local (initializer, bstr_name, bstr_type)
		end

	add_argument (bstr_name: STRING; bstr_type: STRING) is
			-- Add an argument used for solving member completion list
			-- `bstr_name' [in].  
			-- `bstr_type' [in].  
		do
			ccom_add_argument (initializer, bstr_name, bstr_type)
		end

	target_features (bstr_target: STRING; bstr_feature_name: STRING; bstr_file_name: STRING; pvar_names: ECOM_VARIANT; pvar_signatures: ECOM_VARIANT; pvar_image_indexes: ECOM_VARIANT) is
			-- Features accessible from target.
			-- `bstr_target' [in].  
			-- `bstr_feature_name' [in].  
			-- `bstr_file_name' [in].  
			-- `pvar_names' [out].  
			-- `pvar_signatures' [out].  
			-- `pvar_image_indexes' [out].  
		do
			ccom_target_features (initializer, bstr_target, bstr_feature_name, bstr_file_name, pvar_names.item, pvar_signatures.item, pvar_image_indexes.item)
		end

	target_feature (bstr_target: STRING; bstr_feature_name: STRING; bstr_file_name: STRING): IEIFFEL_FEATURE_DESCRIPTOR_INTERFACE is
			-- Feature information
			-- `bstr_target' [in].  
			-- `bstr_feature_name' [in].  
			-- `bstr_file_name' [in].  
		do
			Result := ccom_target_feature (initializer, bstr_target, bstr_feature_name, bstr_file_name)
		end

	flush_completion_features (bstr_file_name: STRING) is
			-- Flush temporary completion features for a specific file
			-- `bstr_file_name' [in].  
		do
			ccom_flush_completion_features (initializer, bstr_file_name)
		end

	initialize_feature (bstr_name: STRING; var_arguments: ECOM_VARIANT; var_argument_types: ECOM_VARIANT; bstr_return_type: STRING; ul_feature_type: INTEGER; bstr_file_name: STRING) is
			-- Initialize a feature for completion without compiltation
			-- `bstr_name' [in].  
			-- `var_arguments' [in].  
			-- `var_argument_types' [in].  
			-- `bstr_return_type' [in].  
			-- `ul_feature_type' [in].  
			-- `bstr_file_name' [in].  
		do
			ccom_initialize_feature (initializer, bstr_name, var_arguments.item, var_argument_types.item, bstr_return_type, ul_feature_type, bstr_file_name)
		end

feature {NONE}  -- Implementation

	delete_wrapper is
			-- Delete wrapper
		do
			ccom_delete_ieiffel_completion_info_impl_proxy(initializer)
		end

feature {NONE}  -- Externals

	ccom_add_local (cpp_obj: POINTER; bstr_name: STRING; bstr_type: STRING) is
			-- Add a local variable used for solving member completion list
		external
			"C++ [ecom_EiffelComCompiler::IEiffelCompletionInfo_impl_proxy %"ecom_EiffelComCompiler_IEiffelCompletionInfo_impl_proxy_s.h%"](EIF_OBJECT,EIF_OBJECT)"
		end

	ccom_add_argument (cpp_obj: POINTER; bstr_name: STRING; bstr_type: STRING) is
			-- Add an argument used for solving member completion list
		external
			"C++ [ecom_EiffelComCompiler::IEiffelCompletionInfo_impl_proxy %"ecom_EiffelComCompiler_IEiffelCompletionInfo_impl_proxy_s.h%"](EIF_OBJECT,EIF_OBJECT)"
		end

	ccom_target_features (cpp_obj: POINTER; bstr_target: STRING; bstr_feature_name: STRING; bstr_file_name: STRING; pvar_names: POINTER; pvar_signatures: POINTER; pvar_image_indexes: POINTER) is
			-- Features accessible from target.
		external
			"C++ [ecom_EiffelComCompiler::IEiffelCompletionInfo_impl_proxy %"ecom_EiffelComCompiler_IEiffelCompletionInfo_impl_proxy_s.h%"](EIF_OBJECT,EIF_OBJECT,EIF_OBJECT,VARIANT *,VARIANT *,VARIANT *)"
		end

	ccom_target_feature (cpp_obj: POINTER; bstr_target: STRING; bstr_feature_name: STRING; bstr_file_name: STRING): IEIFFEL_FEATURE_DESCRIPTOR_INTERFACE is
			-- Feature information
		external
			"C++ [ecom_EiffelComCompiler::IEiffelCompletionInfo_impl_proxy %"ecom_EiffelComCompiler_IEiffelCompletionInfo_impl_proxy_s.h%"](EIF_OBJECT,EIF_OBJECT,EIF_OBJECT): EIF_REFERENCE"
		end

	ccom_flush_completion_features (cpp_obj: POINTER; bstr_file_name: STRING) is
			-- Flush temporary completion features for a specific file
		external
			"C++ [ecom_EiffelComCompiler::IEiffelCompletionInfo_impl_proxy %"ecom_EiffelComCompiler_IEiffelCompletionInfo_impl_proxy_s.h%"](EIF_OBJECT)"
		end

	ccom_initialize_feature (cpp_obj: POINTER; bstr_name: STRING; var_arguments: POINTER; var_argument_types: POINTER; bstr_return_type: STRING; ul_feature_type: INTEGER; bstr_file_name: STRING) is
			-- Initialize a feature for completion without compiltation
		external
			"C++ [ecom_EiffelComCompiler::IEiffelCompletionInfo_impl_proxy %"ecom_EiffelComCompiler_IEiffelCompletionInfo_impl_proxy_s.h%"](EIF_OBJECT,VARIANT *,VARIANT *,EIF_OBJECT,EIF_INTEGER,EIF_OBJECT)"
		end

	ccom_delete_ieiffel_completion_info_impl_proxy (a_pointer: POINTER) is
			-- Release resource
		external
			"C++ [delete ecom_EiffelComCompiler::IEiffelCompletionInfo_impl_proxy %"ecom_EiffelComCompiler_IEiffelCompletionInfo_impl_proxy_s.h%"]()"
		end

	ccom_create_ieiffel_completion_info_impl_proxy_from_pointer (a_pointer: POINTER): POINTER is
			-- Create from pointer
		external
			"C++ [new ecom_EiffelComCompiler::IEiffelCompletionInfo_impl_proxy %"ecom_EiffelComCompiler_IEiffelCompletionInfo_impl_proxy_s.h%"](IUnknown *)"
		end

	ccom_item (cpp_obj: POINTER): POINTER is
			-- Item
		external
			"C++ [ecom_EiffelComCompiler::IEiffelCompletionInfo_impl_proxy %"ecom_EiffelComCompiler_IEiffelCompletionInfo_impl_proxy_s.h%"]():EIF_POINTER"
		end

	ccom_last_error_code (cpp_obj: POINTER): INTEGER is
			-- Last error code
		external
			"C++ [ecom_EiffelComCompiler::IEiffelCompletionInfo_impl_proxy %"ecom_EiffelComCompiler_IEiffelCompletionInfo_impl_proxy_s.h%"]():EIF_INTEGER"
		end

	ccom_last_error_description (cpp_obj: POINTER): STRING is
			-- Last error description
		external
			"C++ [ecom_EiffelComCompiler::IEiffelCompletionInfo_impl_proxy %"ecom_EiffelComCompiler_IEiffelCompletionInfo_impl_proxy_s.h%"]():EIF_REFERENCE"
		end

	ccom_last_error_help_file (cpp_obj: POINTER): STRING is
			-- Last error help file
		external
			"C++ [ecom_EiffelComCompiler::IEiffelCompletionInfo_impl_proxy %"ecom_EiffelComCompiler_IEiffelCompletionInfo_impl_proxy_s.h%"]():EIF_REFERENCE"
		end

	ccom_last_source_of_exception (cpp_obj: POINTER): STRING is
			-- Last source of exception
		external
			"C++ [ecom_EiffelComCompiler::IEiffelCompletionInfo_impl_proxy %"ecom_EiffelComCompiler_IEiffelCompletionInfo_impl_proxy_s.h%"]():EIF_REFERENCE"
		end

end -- IEIFFEL_COMPLETION_INFO_IMPL_PROXY

