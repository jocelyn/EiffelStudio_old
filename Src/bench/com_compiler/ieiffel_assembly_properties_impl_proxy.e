indexing
	description: "Implemented `IEiffelAssemblyProperties' Interface."
	Note: "Automatically generated by the EiffelCOM Wizard."

class
	IEIFFEL_ASSEMBLY_PROPERTIES_IMPL_PROXY

inherit
	IEIFFEL_ASSEMBLY_PROPERTIES_INTERFACE

	ECOM_QUERIABLE

creation
	make_from_other,
	make_from_pointer

feature {NONE}  -- Initialization

	make_from_pointer (cpp_obj: POINTER) is
			-- Make from pointer
		do
			initializer := ccom_create_ieiffel_assembly_properties_impl_proxy_from_pointer(cpp_obj)
			item := ccom_item (initializer)
		end

feature -- Access

	name: STRING is
			-- Assembly name.
		do
			Result := ccom_name (initializer)
		end

	version: STRING is
			-- Assembly version.
		do
			Result := ccom_version (initializer)
		end

	culture: STRING is
			-- Assembly culture.
		do
			Result := ccom_culture (initializer)
		end

	public_key_token: STRING is
			-- Assembly public key token
		do
			Result := ccom_public_key_token (initializer)
		end

	is_local: BOOLEAN is
			-- Is the assembly local
		do
			Result := ccom_is_local (initializer)
		end

	cluster_name: STRING is
			-- Assembly cluster name.
		do
			Result := ccom_cluster_name (initializer)
		end

	prefix1: STRING is
			-- Prefix.
		do
			Result := ccom_prefix1 (initializer)
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

	set_prefix (pbstr_prefix: STRING) is
			-- Prefix.
			-- `pbstr_prefix' [in].  
		do
			ccom_set_prefix (initializer, pbstr_prefix)
		end

feature {NONE}  -- Implementation

	delete_wrapper is
			-- Delete wrapper
		do
			ccom_delete_ieiffel_assembly_properties_impl_proxy(initializer)
		end

feature {NONE}  -- Externals

	ccom_name (cpp_obj: POINTER): STRING is
			-- Assembly name.
		external
			"C++ [ecom_EiffelComCompiler::IEiffelAssemblyProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelAssemblyProperties_impl_proxy_s.h%"](): EIF_REFERENCE"
		end

	ccom_version (cpp_obj: POINTER): STRING is
			-- Assembly version.
		external
			"C++ [ecom_EiffelComCompiler::IEiffelAssemblyProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelAssemblyProperties_impl_proxy_s.h%"](): EIF_REFERENCE"
		end

	ccom_culture (cpp_obj: POINTER): STRING is
			-- Assembly culture.
		external
			"C++ [ecom_EiffelComCompiler::IEiffelAssemblyProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelAssemblyProperties_impl_proxy_s.h%"](): EIF_REFERENCE"
		end

	ccom_public_key_token (cpp_obj: POINTER): STRING is
			-- Assembly public key token
		external
			"C++ [ecom_EiffelComCompiler::IEiffelAssemblyProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelAssemblyProperties_impl_proxy_s.h%"](): EIF_REFERENCE"
		end

	ccom_is_local (cpp_obj: POINTER): BOOLEAN is
			-- Is the assembly local
		external
			"C++ [ecom_EiffelComCompiler::IEiffelAssemblyProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelAssemblyProperties_impl_proxy_s.h%"](): EIF_BOOLEAN"
		end

	ccom_cluster_name (cpp_obj: POINTER): STRING is
			-- Assembly cluster name.
		external
			"C++ [ecom_EiffelComCompiler::IEiffelAssemblyProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelAssemblyProperties_impl_proxy_s.h%"](): EIF_REFERENCE"
		end

	ccom_prefix1 (cpp_obj: POINTER): STRING is
			-- Prefix.
		external
			"C++ [ecom_EiffelComCompiler::IEiffelAssemblyProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelAssemblyProperties_impl_proxy_s.h%"](): EIF_REFERENCE"
		end

	ccom_set_prefix (cpp_obj: POINTER; pbstr_prefix: STRING) is
			-- Prefix.
		external
			"C++ [ecom_EiffelComCompiler::IEiffelAssemblyProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelAssemblyProperties_impl_proxy_s.h%"](EIF_OBJECT)"
		end

	ccom_delete_ieiffel_assembly_properties_impl_proxy (a_pointer: POINTER) is
			-- Release resource
		external
			"C++ [delete ecom_EiffelComCompiler::IEiffelAssemblyProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelAssemblyProperties_impl_proxy_s.h%"]()"
		end

	ccom_create_ieiffel_assembly_properties_impl_proxy_from_pointer (a_pointer: POINTER): POINTER is
			-- Create from pointer
		external
			"C++ [new ecom_EiffelComCompiler::IEiffelAssemblyProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelAssemblyProperties_impl_proxy_s.h%"](IUnknown *)"
		end

	ccom_item (cpp_obj: POINTER): POINTER is
			-- Item
		external
			"C++ [ecom_EiffelComCompiler::IEiffelAssemblyProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelAssemblyProperties_impl_proxy_s.h%"]():EIF_POINTER"
		end

	ccom_last_error_code (cpp_obj: POINTER): INTEGER is
			-- Last error code
		external
			"C++ [ecom_EiffelComCompiler::IEiffelAssemblyProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelAssemblyProperties_impl_proxy_s.h%"]():EIF_INTEGER"
		end

	ccom_last_error_description (cpp_obj: POINTER): STRING is
			-- Last error description
		external
			"C++ [ecom_EiffelComCompiler::IEiffelAssemblyProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelAssemblyProperties_impl_proxy_s.h%"]():EIF_REFERENCE"
		end

	ccom_last_error_help_file (cpp_obj: POINTER): STRING is
			-- Last error help file
		external
			"C++ [ecom_EiffelComCompiler::IEiffelAssemblyProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelAssemblyProperties_impl_proxy_s.h%"]():EIF_REFERENCE"
		end

	ccom_last_source_of_exception (cpp_obj: POINTER): STRING is
			-- Last source of exception
		external
			"C++ [ecom_EiffelComCompiler::IEiffelAssemblyProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelAssemblyProperties_impl_proxy_s.h%"]():EIF_REFERENCE"
		end

end -- IEIFFEL_ASSEMBLY_PROPERTIES_IMPL_PROXY

