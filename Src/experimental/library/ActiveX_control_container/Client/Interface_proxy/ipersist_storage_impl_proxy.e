note
	description: "Implemented `IPersistStorage' Interface."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	generator: "Automatically generated by the EiffelCOM Wizard."

class
	IPERSIST_STORAGE_IMPL_PROXY

inherit
	IPERSIST_STORAGE_INTERFACE

	ECOM_QUERIABLE

create
	make_from_other,
	make_from_pointer

feature {NONE}  -- Initialization

	make_from_pointer (cpp_obj: POINTER)
			-- Make from pointer
		do
			initializer := ccom_create_ipersist_storage_impl_proxy_from_pointer(cpp_obj)
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

	init_new (pstg: ECOM_STORAGE)
			-- No description available.
			-- `pstg' [in].  
		local
			pstg_item: POINTER
			a_stub: ECOM_STUB
		do
			if pstg /= Void then
				if (pstg.item = default_pointer) then
					a_stub ?= pstg
					if a_stub /= Void then
						a_stub.create_item
					end
				end
				pstg_item := pstg.item
			end
			ccom_init_new (initializer, pstg_item)
		end

	load (pstg: ECOM_STORAGE)
			-- No description available.
			-- `pstg' [in].  
		local
			pstg_item: POINTER
			a_stub: ECOM_STUB
		do
			if pstg /= Void then
				if (pstg.item = default_pointer) then
					a_stub ?= pstg
					if a_stub /= Void then
						a_stub.create_item
					end
				end
				pstg_item := pstg.item
			end
			ccom_load (initializer, pstg_item)
		end

	save (p_stg_save: ECOM_STORAGE; f_same_as_load: INTEGER)
			-- No description available.
			-- `p_stg_save' [in].  
			-- `f_same_as_load' [in].  
		local
			p_stg_save_item: POINTER
			a_stub: ECOM_STUB
		do
			if p_stg_save /= Void then
				if (p_stg_save.item = default_pointer) then
					a_stub ?= p_stg_save
					if a_stub /= Void then
						a_stub.create_item
					end
				end
				p_stg_save_item := p_stg_save.item
			end
			ccom_save (initializer, p_stg_save_item, f_same_as_load)
		end

	save_completed (p_stg_new: ECOM_STORAGE)
			-- No description available.
			-- `p_stg_new' [in].  
		local
			p_stg_new_item: POINTER
			a_stub: ECOM_STUB
		do
			if p_stg_new /= Void then
				if (p_stg_new.item = default_pointer) then
					a_stub ?= p_stg_new
					if a_stub /= Void then
						a_stub.create_item
					end
				end
				p_stg_new_item := p_stg_new.item
			end
			ccom_save_completed (initializer, p_stg_new_item)
		end

	hands_off_storage
			-- No description available.
		do
			ccom_hands_off_storage (initializer)
		end

feature {NONE}  -- Implementation

	delete_wrapper
			-- Delete wrapper
		do
			ccom_delete_ipersist_storage_impl_proxy(initializer)
		end

feature {NONE}  -- Externals

	ccom_get_class_id (cpp_obj: POINTER; p_class_id: POINTER)
			-- No description available.
		external
			"C++ [ecom_control_library::IPersistStorage_impl_proxy %"ecom_control_library_IPersistStorage_impl_proxy_s.h%"](GUID *)"
		end

	ccom_is_dirty (cpp_obj: POINTER)
			-- No description available.
		external
			"C++ [ecom_control_library::IPersistStorage_impl_proxy %"ecom_control_library_IPersistStorage_impl_proxy_s.h%"]()"
		end

	ccom_init_new (cpp_obj: POINTER; pstg: POINTER)
			-- No description available.
		external
			"C++ [ecom_control_library::IPersistStorage_impl_proxy %"ecom_control_library_IPersistStorage_impl_proxy_s.h%"](IStorage *)"
		end

	ccom_load (cpp_obj: POINTER; pstg: POINTER)
			-- No description available.
		external
			"C++ [ecom_control_library::IPersistStorage_impl_proxy %"ecom_control_library_IPersistStorage_impl_proxy_s.h%"](IStorage *)"
		end

	ccom_save (cpp_obj: POINTER; p_stg_save: POINTER; f_same_as_load: INTEGER)
			-- No description available.
		external
			"C++ [ecom_control_library::IPersistStorage_impl_proxy %"ecom_control_library_IPersistStorage_impl_proxy_s.h%"](IStorage *,EIF_INTEGER)"
		end

	ccom_save_completed (cpp_obj: POINTER; p_stg_new: POINTER)
			-- No description available.
		external
			"C++ [ecom_control_library::IPersistStorage_impl_proxy %"ecom_control_library_IPersistStorage_impl_proxy_s.h%"](IStorage *)"
		end

	ccom_hands_off_storage (cpp_obj: POINTER)
			-- No description available.
		external
			"C++ [ecom_control_library::IPersistStorage_impl_proxy %"ecom_control_library_IPersistStorage_impl_proxy_s.h%"]()"
		end

	ccom_delete_ipersist_storage_impl_proxy (a_pointer: POINTER)
			-- Release resource
		external
			"C++ [delete ecom_control_library::IPersistStorage_impl_proxy %"ecom_control_library_IPersistStorage_impl_proxy_s.h%"]()"
		end

	ccom_create_ipersist_storage_impl_proxy_from_pointer (a_pointer: POINTER): POINTER
			-- Create from pointer
		external
			"C++ [new ecom_control_library::IPersistStorage_impl_proxy %"ecom_control_library_IPersistStorage_impl_proxy_s.h%"](IUnknown *)"
		end

	ccom_item (cpp_obj: POINTER): POINTER
			-- Item
		external
			"C++ [ecom_control_library::IPersistStorage_impl_proxy %"ecom_control_library_IPersistStorage_impl_proxy_s.h%"]():EIF_POINTER"
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




end -- IPERSIST_STORAGE_IMPL_PROXY

