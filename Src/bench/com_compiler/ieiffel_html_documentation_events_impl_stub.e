indexing
	description: "Implemented `IEiffelHtmlDocumentationEvents' Interface."
	Note: "Automatically generated by the EiffelCOM Wizard."

class
	IEIFFEL_HTML_DOCUMENTATION_EVENTS_IMPL_STUB

inherit
	IEIFFEL_HTML_DOCUMENTATION_EVENTS_INTERFACE

	ECOM_STUB

feature -- Basic Operations

	notify_initalizing_documentation is
			-- Notify that documentation generating is initializing
		do
			-- Put Implementation here.
		end

	notify_percentage_complete (ul_percent: INTEGER) is
			-- Notify that the percentage completed has changed
			-- `ul_percent' [in].  
		do
			-- Put Implementation here.
		end

	output_header (bstr_msg: STRING) is
			-- Put a header message to the output
			-- `bstr_msg' [in].  
		do
			-- Put Implementation here.
		end

	output_string (bstr_msg: STRING) is
			-- Put a string to the output
			-- `bstr_msg' [in].  
		do
			-- Put Implementation here.
		end

	output_class_document_message (bstr_msg: STRING) is
			-- Put a class name to the output
			-- `bstr_msg' [in].  
		do
			-- Put Implementation here.
		end

	should_continue (pvb_continue: BOOLEAN_REF) is
			-- Should compilation continue.
			-- `pvb_continue' [in, out].  
		do
			-- Put Implementation here.
		end

	create_item is
			-- Initialize `item'
		do
			item := ccom_create_item (Current)
		end

feature {NONE}  -- Externals

	ccom_create_item (eif_object: IEIFFEL_HTML_DOCUMENTATION_EVENTS_IMPL_STUB): POINTER is
			-- Initialize `item'
		external
			"C++ [new ecom_EiffelComCompiler::IEiffelHtmlDocumentationEvents_impl_stub %"ecom_EiffelComCompiler_IEiffelHtmlDocumentationEvents_impl_stub_s.h%"](EIF_OBJECT)"
		end

end -- IEIFFEL_HTML_DOCUMENTATION_EVENTS_IMPL_STUB

