indexing
	description: "Implemented `IFolderBrowser' Interface."
	Note: "Automatically generated by the EiffelCOM Wizard."

class
	IFOLDER_BROWSER_IMPL_STUB

inherit
	IFOLDER_BROWSER_INTERFACE

	ECOM_STUB

feature -- Basic Operations

	folder_name (result1: CELL [STRING]) is
			-- Folder chosen by the user.
			-- `result1' [out].  
		do
			-- Put Implementation here.
		end

	create_item is
			-- Initialize `item'
		do
			item := ccom_create_item (Current)
		end

feature {NONE}  -- Externals

	ccom_create_item (eif_object: IFOLDER_BROWSER_IMPL_STUB): POINTER is
			-- Initialize `item'
		external
			"C++ [new ecom_FolderBrowser::IFolderBrowser_impl_stub %"ecom_FolderBrowser_IFolderBrowser_impl_stub_s.h%"](EIF_OBJECT)"
		end

end -- IFOLDER_BROWSER_IMPL_STUB

