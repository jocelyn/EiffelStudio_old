indexing
	description: "Eiffel language compiler library. Help file: "
	Note: "Automatically generated by the EiffelCOM Wizard."

class
	CEIFFEL_PROJECT_PROXY

inherit
	IEIFFEL_PROJECT_INTERFACE

	ECOM_QUERIABLE

creation
	make,
	make_from_other,
	make_from_pointer

feature {NONE}  -- Initialization

	make is
			-- Creation
		do
			initializer := ccom_create_ceiffel_project_coclass
			item := ccom_item (initializer)
		end

	make_from_pointer (cpp_obj: POINTER) is
			-- Make from pointer
		do
			initializer := ccom_create_ceiffel_project_coclass_from_pointer(cpp_obj)
			item := ccom_item (initializer)
		end

feature -- Access

	project_file_name: STRING is
			-- Full path to .epr file.
		do
			Result := ccom_project_file_name (initializer)
		end

	ace_file_name: STRING is
			-- Full path to Ace file.
		do
			Result := ccom_ace_file_name (initializer)
		end

	project_directory: STRING is
			-- Project directory.
		do
			Result := ccom_project_directory (initializer)
		end

	valid_project: BOOLEAN is
			-- Is project valid?
		do
			Result := ccom_valid_project (initializer)
		end

	last_exception: IEIFFEL_EXCEPTION_INTERFACE is
			-- Last exception raised
		do
			Result := ccom_last_exception (initializer)
		end

	compiler: IEIFFEL_COMPILER_INTERFACE is
			-- Compiler.
		do
			Result := ccom_compiler (initializer)
		end

	is_compiled: BOOLEAN is
			-- Has system been compiled?
		do
			Result := ccom_is_compiled (initializer)
		end

	project_has_updated: BOOLEAN is
			-- Has the project updated since last compilation?
		do
			Result := ccom_project_has_updated (initializer)
		end

	system_browser: IEIFFEL_SYSTEM_BROWSER_INTERFACE is
			-- System Browser.
		do
			Result := ccom_system_browser (initializer)
		end

	project_properties: IEIFFEL_PROJECT_PROPERTIES_INTERFACE is
			-- Project Properties.
		do
			Result := ccom_project_properties (initializer)
		end

	completion_information: IEIFFEL_COMPLETION_INFO_INTERFACE is
			-- Completion information
		do
			Result := ccom_completion_information (initializer)
		end

	html_doc_generator: IEIFFEL_HTMLDOC_GENERATOR_INTERFACE is
			-- Help documentation generator
		do
			Result := ccom_html_doc_generator (initializer)
		end

feature -- Basic Operations

	retrieve_eiffel_project (a_project_file_name: STRING) is
			-- Retrieve Eiffel Project
			-- `a_project_file_name' [in].  
		do
			ccom_retrieve_eiffel_project (initializer, a_project_file_name)
		end

	create_eiffel_project (a_ace_file_name: STRING; a_project_directory_path: STRING) is
			-- Create new Eiffel project.
			-- `a_ace_file_name' [in].  
			-- `a_project_directory_path' [in].  
		do
			ccom_create_eiffel_project (initializer, a_ace_file_name, a_project_directory_path)
		end

feature {NONE}  -- Implementation

	delete_wrapper is
			-- Delete wrapper
		do
			ccom_delete_ceiffel_project_coclass(initializer)
		end

feature {NONE}  -- Externals

	ccom_retrieve_eiffel_project (cpp_obj: POINTER; a_project_file_name: STRING) is
			-- Retrieve Eiffel Project
		external
			"C++ [ecom_eiffel_compiler::CEiffelProject %"ecom_eiffel_compiler_CEiffelProject.h%"](EIF_OBJECT)"
		end

	ccom_create_eiffel_project (cpp_obj: POINTER; a_ace_file_name: STRING; a_project_directory_path: STRING) is
			-- Create new Eiffel project.
		external
			"C++ [ecom_eiffel_compiler::CEiffelProject %"ecom_eiffel_compiler_CEiffelProject.h%"](EIF_OBJECT,EIF_OBJECT)"
		end

	ccom_project_file_name (cpp_obj: POINTER): STRING is
			-- Full path to .epr file.
		external
			"C++ [ecom_eiffel_compiler::CEiffelProject %"ecom_eiffel_compiler_CEiffelProject.h%"](): EIF_REFERENCE"
		end

	ccom_ace_file_name (cpp_obj: POINTER): STRING is
			-- Full path to Ace file.
		external
			"C++ [ecom_eiffel_compiler::CEiffelProject %"ecom_eiffel_compiler_CEiffelProject.h%"](): EIF_REFERENCE"
		end

	ccom_project_directory (cpp_obj: POINTER): STRING is
			-- Project directory.
		external
			"C++ [ecom_eiffel_compiler::CEiffelProject %"ecom_eiffel_compiler_CEiffelProject.h%"](): EIF_REFERENCE"
		end

	ccom_valid_project (cpp_obj: POINTER): BOOLEAN is
			-- Is project valid?
		external
			"C++ [ecom_eiffel_compiler::CEiffelProject %"ecom_eiffel_compiler_CEiffelProject.h%"](): EIF_BOOLEAN"
		end

	ccom_last_exception (cpp_obj: POINTER): IEIFFEL_EXCEPTION_INTERFACE is
			-- Last exception raised
		external
			"C++ [ecom_eiffel_compiler::CEiffelProject %"ecom_eiffel_compiler_CEiffelProject.h%"](): EIF_REFERENCE"
		end

	ccom_compiler (cpp_obj: POINTER): IEIFFEL_COMPILER_INTERFACE is
			-- Compiler.
		external
			"C++ [ecom_eiffel_compiler::CEiffelProject %"ecom_eiffel_compiler_CEiffelProject.h%"](): EIF_REFERENCE"
		end

	ccom_is_compiled (cpp_obj: POINTER): BOOLEAN is
			-- Has system been compiled?
		external
			"C++ [ecom_eiffel_compiler::CEiffelProject %"ecom_eiffel_compiler_CEiffelProject.h%"](): EIF_BOOLEAN"
		end

	ccom_project_has_updated (cpp_obj: POINTER): BOOLEAN is
			-- Has the project updated since last compilation?
		external
			"C++ [ecom_eiffel_compiler::CEiffelProject %"ecom_eiffel_compiler_CEiffelProject.h%"](): EIF_BOOLEAN"
		end

	ccom_system_browser (cpp_obj: POINTER): IEIFFEL_SYSTEM_BROWSER_INTERFACE is
			-- System Browser.
		external
			"C++ [ecom_eiffel_compiler::CEiffelProject %"ecom_eiffel_compiler_CEiffelProject.h%"](): EIF_REFERENCE"
		end

	ccom_project_properties (cpp_obj: POINTER): IEIFFEL_PROJECT_PROPERTIES_INTERFACE is
			-- Project Properties.
		external
			"C++ [ecom_eiffel_compiler::CEiffelProject %"ecom_eiffel_compiler_CEiffelProject.h%"](): EIF_REFERENCE"
		end

	ccom_completion_information (cpp_obj: POINTER): IEIFFEL_COMPLETION_INFO_INTERFACE is
			-- Completion information
		external
			"C++ [ecom_eiffel_compiler::CEiffelProject %"ecom_eiffel_compiler_CEiffelProject.h%"](): EIF_REFERENCE"
		end

	ccom_html_doc_generator (cpp_obj: POINTER): IEIFFEL_HTMLDOC_GENERATOR_INTERFACE is
			-- Help documentation generator
		external
			"C++ [ecom_eiffel_compiler::CEiffelProject %"ecom_eiffel_compiler_CEiffelProject.h%"](): EIF_REFERENCE"
		end

	ccom_create_ceiffel_project_coclass: POINTER is
			-- Creation
		external
			"C++ [new ecom_eiffel_compiler::CEiffelProject %"ecom_eiffel_compiler_CEiffelProject.h%"]()"
		end

	ccom_delete_ceiffel_project_coclass (a_pointer: POINTER) is
			-- Release resource
		external
			"C++ [delete ecom_eiffel_compiler::CEiffelProject %"ecom_eiffel_compiler_CEiffelProject.h%"]()"
		end

	ccom_create_ceiffel_project_coclass_from_pointer (a_pointer: POINTER): POINTER is
			-- Create from pointer
		external
			"C++ [new ecom_eiffel_compiler::CEiffelProject %"ecom_eiffel_compiler_CEiffelProject.h%"](IUnknown *)"
		end

	ccom_item (cpp_obj: POINTER): POINTER is
			-- Item
		external
			"C++ [ecom_eiffel_compiler::CEiffelProject %"ecom_eiffel_compiler_CEiffelProject.h%"]():EIF_POINTER"
		end

end -- CEIFFEL_PROJECT_PROXY

