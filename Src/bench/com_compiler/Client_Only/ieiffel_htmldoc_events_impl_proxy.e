indexing
	description: "Implemented `IEiffelHTMLDocEvents' Interface."
	Note: "Automatically generated by the EiffelCOM Wizard."

class
	IEIFFEL_HTMLDOC_EVENTS_IMPL_PROXY

inherit
	IEIFFEL_HTMLDOC_EVENTS_INTERFACE

	ECOM_QUERIABLE

creation
	make_from_other,
	make_from_pointer

feature {NONE}  -- Initialization

	make_from_pointer (cpp_obj: POINTER) is
			-- Make from pointer
		do
			initializer := ccom_create_ieiffel_htmldoc_events_impl_proxy_from_pointer(cpp_obj)
			item := ccom_item (initializer)
		end

feature -- Basic Operations

	put_header (new_value: STRING) is
			-- Put a header message to the output
			-- `new_value' [in].  
		do
			ccom_put_header (initializer, new_value)
		end

	put_string (new_value: STRING) is
			-- Put a string to the output
			-- `new_value' [in].  
		do
			ccom_put_string (initializer, new_value)
		end

	put_class_document_message (new_value: STRING) is
			-- Put a class name to the output
			-- `new_value' [in].  
		do
			ccom_put_class_document_message (initializer, new_value)
		end

	put_initializing_documentation is
			-- Notify that documentation generating is initializing
		do
			ccom_put_initializing_documentation (initializer)
		end

	put_percentage_completed (new_value: INTEGER) is
			-- Notify that the percentage completed has changed
			-- `new_value' [in].  
		do
			ccom_put_percentage_completed (initializer, new_value)
		end

feature {NONE}  -- Implementation

	delete_wrapper is
			-- Delete wrapper
		do
			ccom_delete_ieiffel_htmldoc_events_impl_proxy(initializer)
		end

feature {NONE}  -- Externals

	ccom_put_header (cpp_obj: POINTER; new_value: STRING) is
			-- Put a header message to the output
		external
			"C++ [ecom_eiffel_compiler::IEiffelHTMLDocEvents_impl_proxy %"ecom_eiffel_compiler_IEiffelHTMLDocEvents_impl_proxy.h%"](EIF_OBJECT)"
		end

	ccom_put_string (cpp_obj: POINTER; new_value: STRING) is
			-- Put a string to the output
		external
			"C++ [ecom_eiffel_compiler::IEiffelHTMLDocEvents_impl_proxy %"ecom_eiffel_compiler_IEiffelHTMLDocEvents_impl_proxy.h%"](EIF_OBJECT)"
		end

	ccom_put_class_document_message (cpp_obj: POINTER; new_value: STRING) is
			-- Put a class name to the output
		external
			"C++ [ecom_eiffel_compiler::IEiffelHTMLDocEvents_impl_proxy %"ecom_eiffel_compiler_IEiffelHTMLDocEvents_impl_proxy.h%"](EIF_OBJECT)"
		end

	ccom_put_initializing_documentation (cpp_obj: POINTER) is
			-- Notify that documentation generating is initializing
		external
			"C++ [ecom_eiffel_compiler::IEiffelHTMLDocEvents_impl_proxy %"ecom_eiffel_compiler_IEiffelHTMLDocEvents_impl_proxy.h%"]()"
		end

	ccom_put_percentage_completed (cpp_obj: POINTER; new_value: INTEGER) is
			-- Notify that the percentage completed has changed
		external
			"C++ [ecom_eiffel_compiler::IEiffelHTMLDocEvents_impl_proxy %"ecom_eiffel_compiler_IEiffelHTMLDocEvents_impl_proxy.h%"](EIF_INTEGER)"
		end

	ccom_delete_ieiffel_htmldoc_events_impl_proxy (a_pointer: POINTER) is
			-- Release resource
		external
			"C++ [delete ecom_eiffel_compiler::IEiffelHTMLDocEvents_impl_proxy %"ecom_eiffel_compiler_IEiffelHTMLDocEvents_impl_proxy.h%"]()"
		end

	ccom_create_ieiffel_htmldoc_events_impl_proxy_from_pointer (a_pointer: POINTER): POINTER is
			-- Create from pointer
		external
			"C++ [new ecom_eiffel_compiler::IEiffelHTMLDocEvents_impl_proxy %"ecom_eiffel_compiler_IEiffelHTMLDocEvents_impl_proxy.h%"](IUnknown *)"
		end

	ccom_item (cpp_obj: POINTER): POINTER is
			-- Item
		external
			"C++ [ecom_eiffel_compiler::IEiffelHTMLDocEvents_impl_proxy %"ecom_eiffel_compiler_IEiffelHTMLDocEvents_impl_proxy.h%"]():EIF_POINTER"
		end

end -- IEIFFEL_HTMLDOC_EVENTS_IMPL_PROXY

