indexing
	description: "COM PARAMDESCEX structure"
	status: "See notice at end of class"
	date: "$Date$"
	revision: "$Revision$"

class
	ECOM_PARAM_DESCEX

inherit
	ECOM_STRUCTURE

creation
	make, make_from_pointer

feature {NONE} -- Initialization

	make_from_pointer (a_pointer: POINTER) is
			-- Make from pointer.
		do
			make_by_pointer (a_pointer)
		end

feature -- Access

	default_value: ECOM_VARIANT is
			-- VARIANT structure with default value 
			-- of parameter, described by PARAMDESC
		do
			!! Result.make_from_pointer (ccom_paramdescex_variant (item))
		end

	bytes: INTEGER is
			-- Bytes
		do
			Result := ccom_paramdescex_bytes (item)
		end

feature -- Measurement

	structure_size: INTEGER is
			-- Size of PARAMDESCEX structure
		do
			Result := c_size_of_param_descex
		end

feature {NONE} -- Externals

	c_size_of_param_descex: INTEGER is
		external 
			"C [macro %"E_paramdescex.h%"]"
		alias
			"sizeof(PARAMDESCEX)"
		end

	ccom_paramdescex_variant (a_ptr: POINTER): POINTER is
		external
			"C [macro %"E_paramdescex.h%"]"
		end

	ccom_paramdescex_bytes (a_ptr: POINTER): INTEGER is
		external
			"C [macro %"E_paramdescex.h%"]"
		end

end -- class ECOM_PARAM_DESCEX

--+----------------------------------------------------------------
--| EiffelCOM Wizard
--| Copyright (C) 1999-2005 Eiffel Software. All rights reserved.
--| Eiffel Software Confidential
--| Duplication and distribution prohibited.
--|
--| Eiffel Software
--| 356 Storke Road, Goleta, CA 93117 USA
--| http://www.eiffel.com
--+----------------------------------------------------------------

