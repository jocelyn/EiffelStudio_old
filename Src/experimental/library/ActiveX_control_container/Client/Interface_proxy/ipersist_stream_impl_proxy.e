note
	description: "Implemented `IPersistStream' Interface."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	generator: "Automatically generated by the EiffelCOM Wizard."

class
	IPERSIST_STREAM_IMPL_PROXY

inherit
	IPERSIST_STREAM_INTERFACE

	ECOM_QUERIABLE

create
	make_from_other,
	make_from_pointer

feature {NONE}  -- Initialization

	make_from_pointer (cpp_obj: POINTER)
			-- Make from pointer
		do
			initializer := ccom_create_ipersist_stream_impl_proxy_from_pointer(cpp_obj)
			item := ccom_item (initializer)
		end

feature -- Basic Operations

	get_class_id (p_class_id: ECOM_GUID)
			-- No description available.
			-- `p_class_id' [out].  
		do
			ccom_get_class_id (initializer, p_class_id.item)
		end

	is_dirty
			-- No description available.
		do
			ccom_is_dirty (initializer)
		end

	load (pstm: ECOM_STREAM)
			-- No description available.
			-- `pstm' [in].  
		local
			pstm_item: POINTER
			a_stub: ECOM_STUB
		do
			if pstm /= Void then
				if (pstm.item = default_pointer) then
					a_stub ?= pstm
					if a_stub /= Void then
						a_stub.create_item
					end
				end
				pstm_item := pstm.item
			end
			ccom_load (initializer, pstm_item)
		end

	save (pstm: ECOM_STREAM; f_clear_dirty: INTEGER)
			-- No description available.
			-- `pstm' [in].  
			-- `f_clear_dirty' [in].  
		local
			pstm_item: POINTER
			a_stub: ECOM_STUB
		do
			if pstm /= Void then
				if (pstm.item = default_pointer) then
					a_stub ?= pstm
					if a_stub /= Void then
						a_stub.create_item
					end
				end
				pstm_item := pstm.item
			end
			ccom_save (initializer, pstm_item, f_clear_dirty)
		end

	get_size_max (pcb_size: ECOM_ULARGE_INTEGER)
			-- No description available.
			-- `pcb_size' [out].  
		do
			ccom_get_size_max (initializer, pcb_size.item)
		end

feature {NONE}  -- Implementation

	delete_wrapper
			-- Delete wrapper
		do
			ccom_delete_ipersist_stream_impl_proxy(initializer)
		end

feature {NONE}  -- Externals

	ccom_get_class_id (cpp_obj: POINTER; p_class_id: POINTER)
			-- No description available.
		external
			"C++ [ecom_control_library::IPersistStream_impl_proxy %"ecom_control_library_IPersistStream_impl_proxy_s.h%"](GUID *)"
		end

	ccom_is_dirty (cpp_obj: POINTER)
			-- No description available.
		external
			"C++ [ecom_control_library::IPersistStream_impl_proxy %"ecom_control_library_IPersistStream_impl_proxy_s.h%"]()"
		end

	ccom_load (cpp_obj: POINTER; pstm: POINTER)
			-- No description available.
		external
			"C++ [ecom_control_library::IPersistStream_impl_proxy %"ecom_control_library_IPersistStream_impl_proxy_s.h%"](IStream *)"
		end

	ccom_save (cpp_obj: POINTER; pstm: POINTER; f_clear_dirty: INTEGER)
			-- No description available.
		external
			"C++ [ecom_control_library::IPersistStream_impl_proxy %"ecom_control_library_IPersistStream_impl_proxy_s.h%"](IStream *,EIF_INTEGER)"
		end

	ccom_get_size_max (cpp_obj: POINTER; pcb_size: POINTER)
			-- No description available.
		external
			"C++ [ecom_control_library::IPersistStream_impl_proxy %"ecom_control_library_IPersistStream_impl_proxy_s.h%"](ULARGE_INTEGER *)"
		end

	ccom_delete_ipersist_stream_impl_proxy (a_pointer: POINTER)
			-- Release resource
		external
			"C++ [delete ecom_control_library::IPersistStream_impl_proxy %"ecom_control_library_IPersistStream_impl_proxy_s.h%"]()"
		end

	ccom_create_ipersist_stream_impl_proxy_from_pointer (a_pointer: POINTER): POINTER
			-- Create from pointer
		external
			"C++ [new ecom_control_library::IPersistStream_impl_proxy %"ecom_control_library_IPersistStream_impl_proxy_s.h%"](IUnknown *)"
		end

	ccom_item (cpp_obj: POINTER): POINTER
			-- Item
		external
			"C++ [ecom_control_library::IPersistStream_impl_proxy %"ecom_control_library_IPersistStream_impl_proxy_s.h%"]():EIF_POINTER"
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




end -- IPERSIST_STREAM_IMPL_PROXY

