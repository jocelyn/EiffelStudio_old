indexing
	description: "Implemented `IEiffelSystemBrowser' Interface."
	Note: "Automatically generated by the EiffelCOM Wizard."

class
	IEIFFEL_SYSTEM_BROWSER_IMPL_PROXY

inherit
	IEIFFEL_SYSTEM_BROWSER_INTERFACE

	ECOM_QUERIABLE

creation
	make_from_other,
	make_from_pointer

feature {NONE}  -- Initialization

	make_from_pointer (cpp_obj: POINTER) is
			-- Make from pointer
		do
			initializer := ccom_create_ieiffel_system_browser_impl_proxy_from_pointer(cpp_obj)
			item := ccom_item (initializer)
		end

feature -- Access

	system_classes: IENUM_EIFFEL_CLASS_INTERFACE is
			-- List of classes in system.
		do
			Result := ccom_system_classes (initializer)
		end

	class_count: INTEGER is
			-- Number of classes in system.
		do
			Result := ccom_class_count (initializer)
		end

	system_clusters: IENUM_CLUSTER_INTERFACE is
			-- List of system's clusters.
		do
			Result := ccom_system_clusters (initializer)
		end

	external_clusters: IENUM_CLUSTER_INTERFACE is
			-- List of system's external clusters.
		do
			Result := ccom_external_clusters (initializer)
		end

	assemblies: IENUM_ASSEMBLY_INTERFACE is
			-- Returns all of the assemblies in an enumerator
		do
			Result := ccom_assemblies (initializer)
		end

	cluster_count: INTEGER is
			-- Number of top-level clusters in system.
		do
			Result := ccom_cluster_count (initializer)
		end

	root_cluster: IEIFFEL_CLUSTER_DESCRIPTOR_INTERFACE is
			-- Number of top-level clusters in system.
		do
			Result := ccom_root_cluster (initializer)
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

	cluster_descriptor (bstr_class_name: STRING): IEIFFEL_CLUSTER_DESCRIPTOR_INTERFACE is
			-- Cluster descriptor.
			-- `bstr_class_name' [in].  
		do
			Result := ccom_cluster_descriptor (initializer, bstr_class_name)
		end

	class_descriptor (bstr_cluster_name: STRING): IEIFFEL_CLASS_DESCRIPTOR_INTERFACE is
			-- Class descriptor.
			-- `bstr_cluster_name' [in].  
		do
			Result := ccom_class_descriptor (initializer, bstr_cluster_name)
		end

	feature_descriptor (bstr_class_name: STRING; bstr_feature_name: STRING): IEIFFEL_FEATURE_DESCRIPTOR_INTERFACE is
			-- Feature descriptor.
			-- `bstr_class_name' [in].  
			-- `bstr_feature_name' [in].  
		do
			Result := ccom_feature_descriptor (initializer, bstr_class_name, bstr_feature_name)
		end

	search_classes (bstr_search_str: STRING; vb_is_substring: BOOLEAN): IENUM_EIFFEL_CLASS_INTERFACE is
			-- Search classes with names matching `a_string'.
			-- `bstr_search_str' [in].  
			-- `vb_is_substring' [in].  
		do
			Result := ccom_search_classes (initializer, bstr_search_str, vb_is_substring)
		end

	search_features (bstr_search_str: STRING; vb_is_substring: BOOLEAN): IENUM_FEATURE_INTERFACE is
			-- Search feature with names matching `a_string'.
			-- `bstr_search_str' [in].  
			-- `vb_is_substring' [in].  
		do
			Result := ccom_search_features (initializer, bstr_search_str, vb_is_substring)
		end

	description_from_dotnet_type (bstr_assembly_name: STRING; bstr_full_dotnet_name: STRING): STRING is
			-- Retrieve description from dotnet type
			-- `bstr_assembly_name' [in].  
			-- `bstr_full_dotnet_name' [in].  
		do
			Result := ccom_description_from_dotnet_type (initializer, bstr_assembly_name, bstr_full_dotnet_name)
		end

	description_from_dotnet_feature (bstr_assembly_name: STRING; bstr_full_dotnet_name: STRING; bstr_feature_signature: STRING): STRING is
			-- Retrieve description from dotnet feature
			-- `bstr_assembly_name' [in].  
			-- `bstr_full_dotnet_name' [in].  
			-- `bstr_feature_signature' [in].  
		do
			Result := ccom_description_from_dotnet_feature (initializer, bstr_assembly_name, bstr_full_dotnet_name, bstr_feature_signature)
		end

feature {NONE}  -- Implementation

	delete_wrapper is
			-- Delete wrapper
		do
			ccom_delete_ieiffel_system_browser_impl_proxy(initializer)
		end

feature {NONE}  -- Externals

	ccom_system_classes (cpp_obj: POINTER): IENUM_EIFFEL_CLASS_INTERFACE is
			-- List of classes in system.
		external
			"C++ [ecom_EiffelComCompiler::IEiffelSystemBrowser_impl_proxy %"ecom_EiffelComCompiler_IEiffelSystemBrowser_impl_proxy_s.h%"](): EIF_REFERENCE"
		end

	ccom_class_count (cpp_obj: POINTER): INTEGER is
			-- Number of classes in system.
		external
			"C++ [ecom_EiffelComCompiler::IEiffelSystemBrowser_impl_proxy %"ecom_EiffelComCompiler_IEiffelSystemBrowser_impl_proxy_s.h%"](): EIF_INTEGER"
		end

	ccom_system_clusters (cpp_obj: POINTER): IENUM_CLUSTER_INTERFACE is
			-- List of system's clusters.
		external
			"C++ [ecom_EiffelComCompiler::IEiffelSystemBrowser_impl_proxy %"ecom_EiffelComCompiler_IEiffelSystemBrowser_impl_proxy_s.h%"](): EIF_REFERENCE"
		end

	ccom_external_clusters (cpp_obj: POINTER): IENUM_CLUSTER_INTERFACE is
			-- List of system's external clusters.
		external
			"C++ [ecom_EiffelComCompiler::IEiffelSystemBrowser_impl_proxy %"ecom_EiffelComCompiler_IEiffelSystemBrowser_impl_proxy_s.h%"](): EIF_REFERENCE"
		end

	ccom_assemblies (cpp_obj: POINTER): IENUM_ASSEMBLY_INTERFACE is
			-- Returns all of the assemblies in an enumerator
		external
			"C++ [ecom_EiffelComCompiler::IEiffelSystemBrowser_impl_proxy %"ecom_EiffelComCompiler_IEiffelSystemBrowser_impl_proxy_s.h%"](): EIF_REFERENCE"
		end

	ccom_cluster_count (cpp_obj: POINTER): INTEGER is
			-- Number of top-level clusters in system.
		external
			"C++ [ecom_EiffelComCompiler::IEiffelSystemBrowser_impl_proxy %"ecom_EiffelComCompiler_IEiffelSystemBrowser_impl_proxy_s.h%"](): EIF_INTEGER"
		end

	ccom_root_cluster (cpp_obj: POINTER): IEIFFEL_CLUSTER_DESCRIPTOR_INTERFACE is
			-- Number of top-level clusters in system.
		external
			"C++ [ecom_EiffelComCompiler::IEiffelSystemBrowser_impl_proxy %"ecom_EiffelComCompiler_IEiffelSystemBrowser_impl_proxy_s.h%"](): EIF_REFERENCE"
		end

	ccom_cluster_descriptor (cpp_obj: POINTER; bstr_class_name: STRING): IEIFFEL_CLUSTER_DESCRIPTOR_INTERFACE is
			-- Cluster descriptor.
		external
			"C++ [ecom_EiffelComCompiler::IEiffelSystemBrowser_impl_proxy %"ecom_EiffelComCompiler_IEiffelSystemBrowser_impl_proxy_s.h%"](EIF_OBJECT): EIF_REFERENCE"
		end

	ccom_class_descriptor (cpp_obj: POINTER; bstr_cluster_name: STRING): IEIFFEL_CLASS_DESCRIPTOR_INTERFACE is
			-- Class descriptor.
		external
			"C++ [ecom_EiffelComCompiler::IEiffelSystemBrowser_impl_proxy %"ecom_EiffelComCompiler_IEiffelSystemBrowser_impl_proxy_s.h%"](EIF_OBJECT): EIF_REFERENCE"
		end

	ccom_feature_descriptor (cpp_obj: POINTER; bstr_class_name: STRING; bstr_feature_name: STRING): IEIFFEL_FEATURE_DESCRIPTOR_INTERFACE is
			-- Feature descriptor.
		external
			"C++ [ecom_EiffelComCompiler::IEiffelSystemBrowser_impl_proxy %"ecom_EiffelComCompiler_IEiffelSystemBrowser_impl_proxy_s.h%"](EIF_OBJECT,EIF_OBJECT): EIF_REFERENCE"
		end

	ccom_search_classes (cpp_obj: POINTER; bstr_search_str: STRING; vb_is_substring: BOOLEAN): IENUM_EIFFEL_CLASS_INTERFACE is
			-- Search classes with names matching `a_string'.
		external
			"C++ [ecom_EiffelComCompiler::IEiffelSystemBrowser_impl_proxy %"ecom_EiffelComCompiler_IEiffelSystemBrowser_impl_proxy_s.h%"](EIF_OBJECT,EIF_BOOLEAN): EIF_REFERENCE"
		end

	ccom_search_features (cpp_obj: POINTER; bstr_search_str: STRING; vb_is_substring: BOOLEAN): IENUM_FEATURE_INTERFACE is
			-- Search feature with names matching `a_string'.
		external
			"C++ [ecom_EiffelComCompiler::IEiffelSystemBrowser_impl_proxy %"ecom_EiffelComCompiler_IEiffelSystemBrowser_impl_proxy_s.h%"](EIF_OBJECT,EIF_BOOLEAN): EIF_REFERENCE"
		end

	ccom_description_from_dotnet_type (cpp_obj: POINTER; bstr_assembly_name: STRING; bstr_full_dotnet_name: STRING): STRING is
			-- Retrieve description from dotnet type
		external
			"C++ [ecom_EiffelComCompiler::IEiffelSystemBrowser_impl_proxy %"ecom_EiffelComCompiler_IEiffelSystemBrowser_impl_proxy_s.h%"](EIF_OBJECT,EIF_OBJECT): EIF_REFERENCE"
		end

	ccom_description_from_dotnet_feature (cpp_obj: POINTER; bstr_assembly_name: STRING; bstr_full_dotnet_name: STRING; bstr_feature_signature: STRING): STRING is
			-- Retrieve description from dotnet feature
		external
			"C++ [ecom_EiffelComCompiler::IEiffelSystemBrowser_impl_proxy %"ecom_EiffelComCompiler_IEiffelSystemBrowser_impl_proxy_s.h%"](EIF_OBJECT,EIF_OBJECT,EIF_OBJECT): EIF_REFERENCE"
		end

	ccom_delete_ieiffel_system_browser_impl_proxy (a_pointer: POINTER) is
			-- Release resource
		external
			"C++ [delete ecom_EiffelComCompiler::IEiffelSystemBrowser_impl_proxy %"ecom_EiffelComCompiler_IEiffelSystemBrowser_impl_proxy_s.h%"]()"
		end

	ccom_create_ieiffel_system_browser_impl_proxy_from_pointer (a_pointer: POINTER): POINTER is
			-- Create from pointer
		external
			"C++ [new ecom_EiffelComCompiler::IEiffelSystemBrowser_impl_proxy %"ecom_EiffelComCompiler_IEiffelSystemBrowser_impl_proxy_s.h%"](IUnknown *)"
		end

	ccom_item (cpp_obj: POINTER): POINTER is
			-- Item
		external
			"C++ [ecom_EiffelComCompiler::IEiffelSystemBrowser_impl_proxy %"ecom_EiffelComCompiler_IEiffelSystemBrowser_impl_proxy_s.h%"]():EIF_POINTER"
		end

	ccom_last_error_code (cpp_obj: POINTER): INTEGER is
			-- Last error code
		external
			"C++ [ecom_EiffelComCompiler::IEiffelSystemBrowser_impl_proxy %"ecom_EiffelComCompiler_IEiffelSystemBrowser_impl_proxy_s.h%"]():EIF_INTEGER"
		end

	ccom_last_error_description (cpp_obj: POINTER): STRING is
			-- Last error description
		external
			"C++ [ecom_EiffelComCompiler::IEiffelSystemBrowser_impl_proxy %"ecom_EiffelComCompiler_IEiffelSystemBrowser_impl_proxy_s.h%"]():EIF_REFERENCE"
		end

	ccom_last_error_help_file (cpp_obj: POINTER): STRING is
			-- Last error help file
		external
			"C++ [ecom_EiffelComCompiler::IEiffelSystemBrowser_impl_proxy %"ecom_EiffelComCompiler_IEiffelSystemBrowser_impl_proxy_s.h%"]():EIF_REFERENCE"
		end

	ccom_last_source_of_exception (cpp_obj: POINTER): STRING is
			-- Last source of exception
		external
			"C++ [ecom_EiffelComCompiler::IEiffelSystemBrowser_impl_proxy %"ecom_EiffelComCompiler_IEiffelSystemBrowser_impl_proxy_s.h%"]():EIF_REFERENCE"
		end

end -- IEIFFEL_SYSTEM_BROWSER_IMPL_PROXY

