indexing
	description: "Implemented `IEiffelProjectProperties' Interface."
	Note: "Automatically generated by the EiffelCOM Wizard."

class
	IEIFFEL_PROJECT_PROPERTIES_IMPL_PROXY

inherit
	IEIFFEL_PROJECT_PROPERTIES_INTERFACE

	ECOM_QUERIABLE

creation
	make_from_other,
	make_from_pointer

feature {NONE}  -- Initialization

	make_from_pointer (cpp_obj: POINTER) is
			-- Make from pointer
		do
			initializer := ccom_create_ieiffel_project_properties_impl_proxy_from_pointer(cpp_obj)
			item := ccom_item (initializer)
		end

feature -- Access

	system_name: STRING is
			-- System name.
		do
			Result := ccom_system_name (initializer)
		end

	root_class_name: STRING is
			-- Root class name.
		do
			Result := ccom_root_class_name (initializer)
		end

	creation_routine: STRING is
			-- Creation routine name.
		do
			Result := ccom_creation_routine (initializer)
		end

	namespace_generation: INTEGER is
			-- Namespace generation for cluster
			-- See ECOM_EIF_CLUSTER_NAMESPACE_GENERATION_ENUM for possible `Result' values.
		do
			Result := ccom_namespace_generation (initializer)
		end

	default_namespace: STRING is
			-- Default namespace.
		do
			Result := ccom_default_namespace (initializer)
		end

	project_type: INTEGER is
			-- Project type
			-- See ECOM_EIF_PROJECT_TYPES_ENUM for possible `Result' values.
		do
			Result := ccom_project_type (initializer)
		end

	target_clr_version: STRING is
			-- Version of CLR compiler should target
		do
			Result := ccom_target_clr_version (initializer)
		end

	dot_net_naming_convention: BOOLEAN is
			-- .NET Naming convention
		do
			Result := ccom_dot_net_naming_convention (initializer)
		end

	generate_debug_info: BOOLEAN is
			-- Generate debug info?
		do
			Result := ccom_generate_debug_info (initializer)
		end

	precompiled_library: STRING is
			-- Precompiled file.
		do
			Result := ccom_precompiled_library (initializer)
		end

	assertions: INTEGER is
			-- Project assertions
		do
			Result := ccom_assertions (initializer)
		end

	clusters: IEIFFEL_SYSTEM_CLUSTERS_INTERFACE is
			-- Project Clusters.
		do
			Result := ccom_clusters (initializer)
		end

	externals: IEIFFEL_SYSTEM_EXTERNALS_INTERFACE is
			-- Externals.
		do
			Result := ccom_externals (initializer)
		end

	assemblies: IEIFFEL_SYSTEM_ASSEMBLIES_INTERFACE is
			-- Assemblies.
		do
			Result := ccom_assemblies (initializer)
		end

	title: STRING is
			-- Project title.
		do
			Result := ccom_title (initializer)
		end

	description: STRING is
			-- Project description.
		do
			Result := ccom_description (initializer)
		end

	company: STRING is
			-- Project company.
		do
			Result := ccom_company (initializer)
		end

	product: STRING is
			-- Product.
		do
			Result := ccom_product (initializer)
		end

	version: STRING is
			-- Project version.
		do
			Result := ccom_version (initializer)
		end

	trademark: STRING is
			-- Project trademark.
		do
			Result := ccom_trademark (initializer)
		end

	copyright: STRING is
			-- Project copyright.
		do
			Result := ccom_copyright (initializer)
		end

	culture: STRING is
			-- Asembly culture.
		do
			Result := ccom_culture (initializer)
		end

	key_file_name: STRING is
			-- Asembly signing key file name.
		do
			Result := ccom_key_file_name (initializer)
		end

	working_directory: STRING is
			-- Project working directory
		do
			Result := ccom_working_directory (initializer)
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

	set_system_name (pbstr_name: STRING) is
			-- System name.
			-- `pbstr_name' [in].  
		do
			ccom_set_system_name (initializer, pbstr_name)
		end

	set_root_class_name (pbstr_class_name: STRING) is
			-- Root class name.
			-- `pbstr_class_name' [in].  
		do
			ccom_set_root_class_name (initializer, pbstr_class_name)
		end

	set_creation_routine (pbstr_routine_name: STRING) is
			-- Creation routine name.
			-- `pbstr_routine_name' [in].  
		do
			ccom_set_creation_routine (initializer, pbstr_routine_name)
		end

	set_namespace_generation (penum_cluster_namespace_generation: INTEGER) is
			-- Namespace generation for cluster
			-- `penum_cluster_namespace_generation' [in]. See ECOM_EIF_CLUSTER_NAMESPACE_GENERATION_ENUM for possible `penum_cluster_namespace_generation' values. 
		do
			ccom_set_namespace_generation (initializer, penum_cluster_namespace_generation)
		end

	set_default_namespace (pbstr_namespace: STRING) is
			-- Default namespace.
			-- `pbstr_namespace' [in].  
		do
			ccom_set_default_namespace (initializer, pbstr_namespace)
		end

	set_project_type (penum_project_type: INTEGER) is
			-- Project type
			-- `penum_project_type' [in]. See ECOM_EIF_PROJECT_TYPES_ENUM for possible `penum_project_type' values. 
		do
			ccom_set_project_type (initializer, penum_project_type)
		end

	set_target_clr_version (pbstr_version: STRING) is
			-- Version of CLR compiler should target
			-- `pbstr_version' [in].  
		do
			ccom_set_target_clr_version (initializer, pbstr_version)
		end

	set_dot_net_naming_convention (pvb_naming_convention: BOOLEAN) is
			-- .NET Naming convention
			-- `pvb_naming_convention' [in].  
		do
			ccom_set_dot_net_naming_convention (initializer, pvb_naming_convention)
		end

	set_generate_debug_info (pvb_generate: BOOLEAN) is
			-- Generate debug info?
			-- `pvb_generate' [in].  
		do
			ccom_set_generate_debug_info (initializer, pvb_generate)
		end

	set_precompiled_library (pbstr_path: STRING) is
			-- Precompiled file.
			-- `pbstr_path' [in].  
		do
			ccom_set_precompiled_library (initializer, pbstr_path)
		end

	set_assertions (pul_assertions: INTEGER) is
			-- Project assertions
			-- `pul_assertions' [in].  
		do
			ccom_set_assertions (initializer, pul_assertions)
		end

	set_title (pbstr_title: STRING) is
			-- Project title.
			-- `pbstr_title' [in].  
		do
			ccom_set_title (initializer, pbstr_title)
		end

	set_description (pbstr_description: STRING) is
			-- Project description.
			-- `pbstr_description' [in].  
		do
			ccom_set_description (initializer, pbstr_description)
		end

	set_company (pbstr_company: STRING) is
			-- Project company.
			-- `pbstr_company' [in].  
		do
			ccom_set_company (initializer, pbstr_company)
		end

	set_product (ppbstr_product: STRING) is
			-- Product.
			-- `ppbstr_product' [in].  
		do
			ccom_set_product (initializer, ppbstr_product)
		end

	set_version (pbstr_version: STRING) is
			-- Project version.
			-- `pbstr_version' [in].  
		do
			ccom_set_version (initializer, pbstr_version)
		end

	set_trademark (pbstr_trademark: STRING) is
			-- Project trademark.
			-- `pbstr_trademark' [in].  
		do
			ccom_set_trademark (initializer, pbstr_trademark)
		end

	set_copyright (pbstr_copyright: STRING) is
			-- Project copyright.
			-- `pbstr_copyright' [in].  
		do
			ccom_set_copyright (initializer, pbstr_copyright)
		end

	set_culture (pbstr_cultre: STRING) is
			-- Asembly culture.
			-- `pbstr_cultre' [in].  
		do
			ccom_set_culture (initializer, pbstr_cultre)
		end

	set_key_file_name (pbstr_file_name: STRING) is
			-- Asembly signing key file name.
			-- `pbstr_file_name' [in].  
		do
			ccom_set_key_file_name (initializer, pbstr_file_name)
		end

	set_working_directory (pbstr_working_directory: STRING) is
			-- Project working directory
			-- `pbstr_working_directory' [in].  
		do
			ccom_set_working_directory (initializer, pbstr_working_directory)
		end

	apply is
			-- Apply changes
		do
			ccom_apply (initializer)
		end

feature {NONE}  -- Implementation

	delete_wrapper is
			-- Delete wrapper
		do
			ccom_delete_ieiffel_project_properties_impl_proxy(initializer)
		end

feature {NONE}  -- Externals

	ccom_system_name (cpp_obj: POINTER): STRING is
			-- System name.
		external
			"C++ [ecom_EiffelComCompiler::IEiffelProjectProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelProjectProperties_impl_proxy_s.h%"](): EIF_REFERENCE"
		end

	ccom_set_system_name (cpp_obj: POINTER; pbstr_name: STRING) is
			-- System name.
		external
			"C++ [ecom_EiffelComCompiler::IEiffelProjectProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelProjectProperties_impl_proxy_s.h%"](EIF_OBJECT)"
		end

	ccom_root_class_name (cpp_obj: POINTER): STRING is
			-- Root class name.
		external
			"C++ [ecom_EiffelComCompiler::IEiffelProjectProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelProjectProperties_impl_proxy_s.h%"](): EIF_REFERENCE"
		end

	ccom_set_root_class_name (cpp_obj: POINTER; pbstr_class_name: STRING) is
			-- Root class name.
		external
			"C++ [ecom_EiffelComCompiler::IEiffelProjectProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelProjectProperties_impl_proxy_s.h%"](EIF_OBJECT)"
		end

	ccom_creation_routine (cpp_obj: POINTER): STRING is
			-- Creation routine name.
		external
			"C++ [ecom_EiffelComCompiler::IEiffelProjectProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelProjectProperties_impl_proxy_s.h%"](): EIF_REFERENCE"
		end

	ccom_set_creation_routine (cpp_obj: POINTER; pbstr_routine_name: STRING) is
			-- Creation routine name.
		external
			"C++ [ecom_EiffelComCompiler::IEiffelProjectProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelProjectProperties_impl_proxy_s.h%"](EIF_OBJECT)"
		end

	ccom_namespace_generation (cpp_obj: POINTER): INTEGER is
			-- Namespace generation for cluster
		external
			"C++ [ecom_EiffelComCompiler::IEiffelProjectProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelProjectProperties_impl_proxy_s.h%"](): EIF_INTEGER"
		end

	ccom_set_namespace_generation (cpp_obj: POINTER; penum_cluster_namespace_generation: INTEGER) is
			-- Namespace generation for cluster
		external
			"C++ [ecom_EiffelComCompiler::IEiffelProjectProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelProjectProperties_impl_proxy_s.h%"](EIF_INTEGER)"
		end

	ccom_default_namespace (cpp_obj: POINTER): STRING is
			-- Default namespace.
		external
			"C++ [ecom_EiffelComCompiler::IEiffelProjectProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelProjectProperties_impl_proxy_s.h%"](): EIF_REFERENCE"
		end

	ccom_set_default_namespace (cpp_obj: POINTER; pbstr_namespace: STRING) is
			-- Default namespace.
		external
			"C++ [ecom_EiffelComCompiler::IEiffelProjectProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelProjectProperties_impl_proxy_s.h%"](EIF_OBJECT)"
		end

	ccom_project_type (cpp_obj: POINTER): INTEGER is
			-- Project type
		external
			"C++ [ecom_EiffelComCompiler::IEiffelProjectProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelProjectProperties_impl_proxy_s.h%"](): EIF_INTEGER"
		end

	ccom_set_project_type (cpp_obj: POINTER; penum_project_type: INTEGER) is
			-- Project type
		external
			"C++ [ecom_EiffelComCompiler::IEiffelProjectProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelProjectProperties_impl_proxy_s.h%"](EIF_INTEGER)"
		end

	ccom_target_clr_version (cpp_obj: POINTER): STRING is
			-- Version of CLR compiler should target
		external
			"C++ [ecom_EiffelComCompiler::IEiffelProjectProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelProjectProperties_impl_proxy_s.h%"](): EIF_REFERENCE"
		end

	ccom_set_target_clr_version (cpp_obj: POINTER; pbstr_version: STRING) is
			-- Version of CLR compiler should target
		external
			"C++ [ecom_EiffelComCompiler::IEiffelProjectProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelProjectProperties_impl_proxy_s.h%"](EIF_OBJECT)"
		end

	ccom_dot_net_naming_convention (cpp_obj: POINTER): BOOLEAN is
			-- .NET Naming convention
		external
			"C++ [ecom_EiffelComCompiler::IEiffelProjectProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelProjectProperties_impl_proxy_s.h%"](): EIF_BOOLEAN"
		end

	ccom_set_dot_net_naming_convention (cpp_obj: POINTER; pvb_naming_convention: BOOLEAN) is
			-- .NET Naming convention
		external
			"C++ [ecom_EiffelComCompiler::IEiffelProjectProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelProjectProperties_impl_proxy_s.h%"](EIF_BOOLEAN)"
		end

	ccom_generate_debug_info (cpp_obj: POINTER): BOOLEAN is
			-- Generate debug info?
		external
			"C++ [ecom_EiffelComCompiler::IEiffelProjectProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelProjectProperties_impl_proxy_s.h%"](): EIF_BOOLEAN"
		end

	ccom_set_generate_debug_info (cpp_obj: POINTER; pvb_generate: BOOLEAN) is
			-- Generate debug info?
		external
			"C++ [ecom_EiffelComCompiler::IEiffelProjectProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelProjectProperties_impl_proxy_s.h%"](EIF_BOOLEAN)"
		end

	ccom_precompiled_library (cpp_obj: POINTER): STRING is
			-- Precompiled file.
		external
			"C++ [ecom_EiffelComCompiler::IEiffelProjectProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelProjectProperties_impl_proxy_s.h%"](): EIF_REFERENCE"
		end

	ccom_set_precompiled_library (cpp_obj: POINTER; pbstr_path: STRING) is
			-- Precompiled file.
		external
			"C++ [ecom_EiffelComCompiler::IEiffelProjectProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelProjectProperties_impl_proxy_s.h%"](EIF_OBJECT)"
		end

	ccom_assertions (cpp_obj: POINTER): INTEGER is
			-- Project assertions
		external
			"C++ [ecom_EiffelComCompiler::IEiffelProjectProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelProjectProperties_impl_proxy_s.h%"](): EIF_INTEGER"
		end

	ccom_set_assertions (cpp_obj: POINTER; pul_assertions: INTEGER) is
			-- Project assertions
		external
			"C++ [ecom_EiffelComCompiler::IEiffelProjectProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelProjectProperties_impl_proxy_s.h%"](EIF_INTEGER)"
		end

	ccom_clusters (cpp_obj: POINTER): IEIFFEL_SYSTEM_CLUSTERS_INTERFACE is
			-- Project Clusters.
		external
			"C++ [ecom_EiffelComCompiler::IEiffelProjectProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelProjectProperties_impl_proxy_s.h%"](): EIF_REFERENCE"
		end

	ccom_externals (cpp_obj: POINTER): IEIFFEL_SYSTEM_EXTERNALS_INTERFACE is
			-- Externals.
		external
			"C++ [ecom_EiffelComCompiler::IEiffelProjectProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelProjectProperties_impl_proxy_s.h%"](): EIF_REFERENCE"
		end

	ccom_assemblies (cpp_obj: POINTER): IEIFFEL_SYSTEM_ASSEMBLIES_INTERFACE is
			-- Assemblies.
		external
			"C++ [ecom_EiffelComCompiler::IEiffelProjectProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelProjectProperties_impl_proxy_s.h%"](): EIF_REFERENCE"
		end

	ccom_title (cpp_obj: POINTER): STRING is
			-- Project title.
		external
			"C++ [ecom_EiffelComCompiler::IEiffelProjectProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelProjectProperties_impl_proxy_s.h%"](): EIF_REFERENCE"
		end

	ccom_set_title (cpp_obj: POINTER; pbstr_title: STRING) is
			-- Project title.
		external
			"C++ [ecom_EiffelComCompiler::IEiffelProjectProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelProjectProperties_impl_proxy_s.h%"](EIF_OBJECT)"
		end

	ccom_description (cpp_obj: POINTER): STRING is
			-- Project description.
		external
			"C++ [ecom_EiffelComCompiler::IEiffelProjectProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelProjectProperties_impl_proxy_s.h%"](): EIF_REFERENCE"
		end

	ccom_set_description (cpp_obj: POINTER; pbstr_description: STRING) is
			-- Project description.
		external
			"C++ [ecom_EiffelComCompiler::IEiffelProjectProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelProjectProperties_impl_proxy_s.h%"](EIF_OBJECT)"
		end

	ccom_company (cpp_obj: POINTER): STRING is
			-- Project company.
		external
			"C++ [ecom_EiffelComCompiler::IEiffelProjectProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelProjectProperties_impl_proxy_s.h%"](): EIF_REFERENCE"
		end

	ccom_set_company (cpp_obj: POINTER; pbstr_company: STRING) is
			-- Project company.
		external
			"C++ [ecom_EiffelComCompiler::IEiffelProjectProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelProjectProperties_impl_proxy_s.h%"](EIF_OBJECT)"
		end

	ccom_product (cpp_obj: POINTER): STRING is
			-- Product.
		external
			"C++ [ecom_EiffelComCompiler::IEiffelProjectProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelProjectProperties_impl_proxy_s.h%"](): EIF_REFERENCE"
		end

	ccom_set_product (cpp_obj: POINTER; ppbstr_product: STRING) is
			-- Product.
		external
			"C++ [ecom_EiffelComCompiler::IEiffelProjectProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelProjectProperties_impl_proxy_s.h%"](EIF_OBJECT)"
		end

	ccom_version (cpp_obj: POINTER): STRING is
			-- Project version.
		external
			"C++ [ecom_EiffelComCompiler::IEiffelProjectProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelProjectProperties_impl_proxy_s.h%"](): EIF_REFERENCE"
		end

	ccom_set_version (cpp_obj: POINTER; pbstr_version: STRING) is
			-- Project version.
		external
			"C++ [ecom_EiffelComCompiler::IEiffelProjectProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelProjectProperties_impl_proxy_s.h%"](EIF_OBJECT)"
		end

	ccom_trademark (cpp_obj: POINTER): STRING is
			-- Project trademark.
		external
			"C++ [ecom_EiffelComCompiler::IEiffelProjectProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelProjectProperties_impl_proxy_s.h%"](): EIF_REFERENCE"
		end

	ccom_set_trademark (cpp_obj: POINTER; pbstr_trademark: STRING) is
			-- Project trademark.
		external
			"C++ [ecom_EiffelComCompiler::IEiffelProjectProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelProjectProperties_impl_proxy_s.h%"](EIF_OBJECT)"
		end

	ccom_copyright (cpp_obj: POINTER): STRING is
			-- Project copyright.
		external
			"C++ [ecom_EiffelComCompiler::IEiffelProjectProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelProjectProperties_impl_proxy_s.h%"](): EIF_REFERENCE"
		end

	ccom_set_copyright (cpp_obj: POINTER; pbstr_copyright: STRING) is
			-- Project copyright.
		external
			"C++ [ecom_EiffelComCompiler::IEiffelProjectProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelProjectProperties_impl_proxy_s.h%"](EIF_OBJECT)"
		end

	ccom_culture (cpp_obj: POINTER): STRING is
			-- Asembly culture.
		external
			"C++ [ecom_EiffelComCompiler::IEiffelProjectProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelProjectProperties_impl_proxy_s.h%"](): EIF_REFERENCE"
		end

	ccom_set_culture (cpp_obj: POINTER; pbstr_cultre: STRING) is
			-- Asembly culture.
		external
			"C++ [ecom_EiffelComCompiler::IEiffelProjectProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelProjectProperties_impl_proxy_s.h%"](EIF_OBJECT)"
		end

	ccom_key_file_name (cpp_obj: POINTER): STRING is
			-- Asembly signing key file name.
		external
			"C++ [ecom_EiffelComCompiler::IEiffelProjectProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelProjectProperties_impl_proxy_s.h%"](): EIF_REFERENCE"
		end

	ccom_set_key_file_name (cpp_obj: POINTER; pbstr_file_name: STRING) is
			-- Asembly signing key file name.
		external
			"C++ [ecom_EiffelComCompiler::IEiffelProjectProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelProjectProperties_impl_proxy_s.h%"](EIF_OBJECT)"
		end

	ccom_working_directory (cpp_obj: POINTER): STRING is
			-- Project working directory
		external
			"C++ [ecom_EiffelComCompiler::IEiffelProjectProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelProjectProperties_impl_proxy_s.h%"](): EIF_REFERENCE"
		end

	ccom_set_working_directory (cpp_obj: POINTER; pbstr_working_directory: STRING) is
			-- Project working directory
		external
			"C++ [ecom_EiffelComCompiler::IEiffelProjectProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelProjectProperties_impl_proxy_s.h%"](EIF_OBJECT)"
		end

	ccom_apply (cpp_obj: POINTER) is
			-- Apply changes
		external
			"C++ [ecom_EiffelComCompiler::IEiffelProjectProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelProjectProperties_impl_proxy_s.h%"]()"
		end

	ccom_delete_ieiffel_project_properties_impl_proxy (a_pointer: POINTER) is
			-- Release resource
		external
			"C++ [delete ecom_EiffelComCompiler::IEiffelProjectProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelProjectProperties_impl_proxy_s.h%"]()"
		end

	ccom_create_ieiffel_project_properties_impl_proxy_from_pointer (a_pointer: POINTER): POINTER is
			-- Create from pointer
		external
			"C++ [new ecom_EiffelComCompiler::IEiffelProjectProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelProjectProperties_impl_proxy_s.h%"](IUnknown *)"
		end

	ccom_item (cpp_obj: POINTER): POINTER is
			-- Item
		external
			"C++ [ecom_EiffelComCompiler::IEiffelProjectProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelProjectProperties_impl_proxy_s.h%"]():EIF_POINTER"
		end

	ccom_last_error_code (cpp_obj: POINTER): INTEGER is
			-- Last error code
		external
			"C++ [ecom_EiffelComCompiler::IEiffelProjectProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelProjectProperties_impl_proxy_s.h%"]():EIF_INTEGER"
		end

	ccom_last_error_description (cpp_obj: POINTER): STRING is
			-- Last error description
		external
			"C++ [ecom_EiffelComCompiler::IEiffelProjectProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelProjectProperties_impl_proxy_s.h%"]():EIF_REFERENCE"
		end

	ccom_last_error_help_file (cpp_obj: POINTER): STRING is
			-- Last error help file
		external
			"C++ [ecom_EiffelComCompiler::IEiffelProjectProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelProjectProperties_impl_proxy_s.h%"]():EIF_REFERENCE"
		end

	ccom_last_source_of_exception (cpp_obj: POINTER): STRING is
			-- Last source of exception
		external
			"C++ [ecom_EiffelComCompiler::IEiffelProjectProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelProjectProperties_impl_proxy_s.h%"]():EIF_REFERENCE"
		end

end -- IEIFFEL_PROJECT_PROPERTIES_IMPL_PROXY

