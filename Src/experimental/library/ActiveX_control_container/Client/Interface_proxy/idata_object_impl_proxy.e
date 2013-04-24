note
	description: "Implemented `IDataObject' Interface."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	generator: "Automatically generated by the EiffelCOM Wizard."

class
	IDATA_OBJECT_IMPL_PROXY

inherit
	IDATA_OBJECT_INTERFACE

	ECOM_QUERIABLE

create
	make_from_other,
	make_from_pointer

feature {NONE}  -- Initialization

	make_from_pointer (cpp_obj: POINTER)
			-- Make from pointer
		do
			initializer := ccom_create_idata_object_impl_proxy_from_pointer(cpp_obj)
			item := ccom_item (initializer)
		end

feature -- Basic Operations

	get_data (pformatetc_in: TAG_FORMATETC_RECORD; p_medium: STGMEDIUM_RECORD)
			-- No description available.
			-- `pformatetc_in' [in].  
			-- `p_medium' [out].  
		do
			ccom_get_data (initializer, pformatetc_in.item, p_medium.item)
		end

	get_data_here (p_formatetc: TAG_FORMATETC_RECORD; p_medium: STGMEDIUM_RECORD)
			-- No description available.
			-- `p_formatetc' [in].  
			-- `p_medium' [in, out].  
		do
			ccom_get_data_here (initializer, p_formatetc.item, p_medium.item)
		end

	query_get_data (p_formatetc: TAG_FORMATETC_RECORD)
			-- No description available.
			-- `p_formatetc' [in].  
		do
			ccom_query_get_data (initializer, p_formatetc.item)
		end

	get_canonical_format_etc (pformatect_in: TAG_FORMATETC_RECORD; pformatetc_out: TAG_FORMATETC_RECORD)
			-- No description available.
			-- `pformatect_in' [in].  
			-- `pformatetc_out' [out].  
		do
			ccom_get_canonical_format_etc (initializer, pformatect_in.item, pformatetc_out.item)
		end

	set_data (p_formatetc: TAG_FORMATETC_RECORD; pmedium: STGMEDIUM_RECORD; f_release: INTEGER)
			-- No description available.
			-- `p_formatetc' [in].  
			-- `pmedium' [in].  
			-- `f_release' [in].  
		do
			ccom_set_data (initializer, p_formatetc.item, pmedium.item, f_release)
		end

	enum_format_etc (dw_direction: INTEGER; ppenum_format_etc: CELL [IENUM_FORMATETC_INTERFACE])
			-- No description available.
			-- `dw_direction' [in].  
			-- `ppenum_format_etc' [out].  
		do
			ccom_enum_format_etc (initializer, dw_direction, ppenum_format_etc)
		end

	dadvise (p_formatetc: TAG_FORMATETC_RECORD; advf: INTEGER; p_adv_sink: IADVISE_SINK_INTERFACE; pdw_connection: INTEGER_REF)
			-- No description available.
			-- `p_formatetc' [in].  
			-- `advf' [in].  
			-- `p_adv_sink' [in].  
			-- `pdw_connection' [out].  
		local
			p_adv_sink_item: POINTER
			a_stub: ECOM_STUB
		do
			if p_adv_sink /= Void then
				if (p_adv_sink.item = default_pointer) then
					a_stub ?= p_adv_sink
					if a_stub /= Void then
						a_stub.create_item
					end
				end
				p_adv_sink_item := p_adv_sink.item
			end
			ccom_dadvise (initializer, p_formatetc.item, advf, p_adv_sink_item, pdw_connection)
		end

	dunadvise (dw_connection: INTEGER)
			-- No description available.
			-- `dw_connection' [in].  
		do
			ccom_dunadvise (initializer, dw_connection)
		end

	enum_dadvise (ppenum_advise: CELL [IENUM_STATDATA_INTERFACE])
			-- No description available.
			-- `ppenum_advise' [out].  
		do
			ccom_enum_dadvise (initializer, ppenum_advise)
		end

feature {NONE}  -- Implementation

	delete_wrapper
			-- Delete wrapper
		do
			ccom_delete_idata_object_impl_proxy(initializer)
		end

feature {NONE}  -- Externals

	ccom_get_data (cpp_obj: POINTER; pformatetc_in: POINTER; p_medium: POINTER)
			-- No description available.
		external
			"C++ [ecom_control_library::IDataObject_impl_proxy %"ecom_control_library_IDataObject_impl_proxy_s.h%"](ecom_control_library::tagFORMATETC *,STGMEDIUM *)"
		end

	ccom_get_data_here (cpp_obj: POINTER; p_formatetc: POINTER; p_medium: POINTER)
			-- No description available.
		external
			"C++ [ecom_control_library::IDataObject_impl_proxy %"ecom_control_library_IDataObject_impl_proxy_s.h%"](ecom_control_library::tagFORMATETC *,STGMEDIUM *)"
		end

	ccom_query_get_data (cpp_obj: POINTER; p_formatetc: POINTER)
			-- No description available.
		external
			"C++ [ecom_control_library::IDataObject_impl_proxy %"ecom_control_library_IDataObject_impl_proxy_s.h%"](ecom_control_library::tagFORMATETC *)"
		end

	ccom_get_canonical_format_etc (cpp_obj: POINTER; pformatect_in: POINTER; pformatetc_out: POINTER)
			-- No description available.
		external
			"C++ [ecom_control_library::IDataObject_impl_proxy %"ecom_control_library_IDataObject_impl_proxy_s.h%"](ecom_control_library::tagFORMATETC *,ecom_control_library::tagFORMATETC *)"
		end

	ccom_set_data (cpp_obj: POINTER; p_formatetc: POINTER; pmedium: POINTER; f_release: INTEGER)
			-- No description available.
		external
			"C++ [ecom_control_library::IDataObject_impl_proxy %"ecom_control_library_IDataObject_impl_proxy_s.h%"](ecom_control_library::tagFORMATETC *,STGMEDIUM *,EIF_INTEGER)"
		end

	ccom_enum_format_etc (cpp_obj: POINTER; dw_direction: INTEGER; ppenum_format_etc: CELL [IENUM_FORMATETC_INTERFACE])
			-- No description available.
		external
			"C++ [ecom_control_library::IDataObject_impl_proxy %"ecom_control_library_IDataObject_impl_proxy_s.h%"](EIF_INTEGER,EIF_OBJECT)"
		end

	ccom_dadvise (cpp_obj: POINTER; p_formatetc: POINTER; advf: INTEGER; p_adv_sink: POINTER; pdw_connection: INTEGER_REF)
			-- No description available.
		external
			"C++ [ecom_control_library::IDataObject_impl_proxy %"ecom_control_library_IDataObject_impl_proxy_s.h%"](ecom_control_library::tagFORMATETC *,EIF_INTEGER,::IAdviseSink *,EIF_OBJECT)"
		end

	ccom_dunadvise (cpp_obj: POINTER; dw_connection: INTEGER)
			-- No description available.
		external
			"C++ [ecom_control_library::IDataObject_impl_proxy %"ecom_control_library_IDataObject_impl_proxy_s.h%"](EIF_INTEGER)"
		end

	ccom_enum_dadvise (cpp_obj: POINTER; ppenum_advise: CELL [IENUM_STATDATA_INTERFACE])
			-- No description available.
		external
			"C++ [ecom_control_library::IDataObject_impl_proxy %"ecom_control_library_IDataObject_impl_proxy_s.h%"](EIF_OBJECT)"
		end

	ccom_delete_idata_object_impl_proxy (a_pointer: POINTER)
			-- Release resource
		external
			"C++ [delete ecom_control_library::IDataObject_impl_proxy %"ecom_control_library_IDataObject_impl_proxy_s.h%"]()"
		end

	ccom_create_idata_object_impl_proxy_from_pointer (a_pointer: POINTER): POINTER
			-- Create from pointer
		external
			"C++ [new ecom_control_library::IDataObject_impl_proxy %"ecom_control_library_IDataObject_impl_proxy_s.h%"](IUnknown *)"
		end

	ccom_item (cpp_obj: POINTER): POINTER
			-- Item
		external
			"C++ [ecom_control_library::IDataObject_impl_proxy %"ecom_control_library_IDataObject_impl_proxy_s.h%"]():EIF_POINTER"
		end

note
	copyright:	"Copyright (c) 1984-2006, Eiffel Software and others"
	license:	"Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			 Eiffel Software
			 356 Storke Road, Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"




end -- IDATA_OBJECT_IMPL_PROXY

