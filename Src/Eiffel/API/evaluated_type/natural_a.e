indexing
	description: "Actual type for natural type."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	NATURAL_A

inherit
	BASIC_A
		rename
			make as cl_make
		redefine
			is_natural, associated_class,
			same_as, is_numeric, process,
			minimum_interval_value,
			maximum_interval_value,
			heaviest
		end

create
	make

feature {NONE} -- Initialization

	make (n: INTEGER) is
			-- Create instance of NATURAL_A represented by `n' bits.
		require
			valid_n: n = 8 or n = 16 or n = 32 or n = 64
		do
			size := n.to_integer_8
			cl_make (associated_class.class_id)
		ensure
			size_set: size = n
		end

feature -- Visitor

	process (v: TYPE_A_VISITOR) is
			-- Process current element.
		do
			v.process_natural_a (Current)
		end

feature -- Property

	is_natural: BOOLEAN is True
			-- Is the current type an natural type ?

	size: INTEGER_8
			-- Current is stored on `size' bits.

feature -- Access

	same_as (other: TYPE_A): BOOLEAN is
			-- Is the current type the same as `other' ?
		do
			Result := {n: NATURAL_A} other and then size = n.size
		end

	associated_class: CLASS_C is
			-- Class NATURAL
		do
			inspect size
			when 8 then Result := System.natural_8_class.compiled_class
			when 16 then Result := System.natural_16_class.compiled_class
			when 32 then Result := System.natural_32_class.compiled_class
			when 64 then Result := System.natural_64_class.compiled_class
			end
		end

feature -- IL code generation

	minimum_interval_value: INTERVAL_VAL_B is
			-- Minimum value in inspect interval for current type
		do
			if size = 64 then
				create {NAT64_VAL_B} Result.make (0)
			else
				check
					valid_size: size = 8 or size = 16 or size = 32
				end
				create {NAT_VAL_B} Result.make (0)
			end
		end

	maximum_interval_value: INTERVAL_VAL_B is
			-- Maximum value in inspect interval for current type
		do
			inspect size
			when 8 then
				create {NAT_VAL_B} Result.make ({NATURAL_8}.max_value)
			when 16 then
				create {NAT_VAL_B} Result.make ({NATURAL_16}.max_value)
			when 32 then
				create {NAT_VAL_B} Result.make ({NATURAL_32}.max_value)
			when 64 then
				create {NAT64_VAL_B} Result.make ({NATURAL_64}.max_value)
			end
		end

	heaviest (other: TYPE_A): TYPE_A is
		local
			l_long: like Current
		do
			if other.is_real_64 or other.is_real_32 then
				Result := other
			else
				if other.is_natural then
					l_long ?= other
					if size >= l_long.size then
						Result := Current
					else
						Result := other
					end
				else
					Result := Current
				end
			end
		end

feature {COMPILER_EXPORTER}

	is_numeric: BOOLEAN is True
			-- Is the current type a numeric type ?

	c_type: NATURAL_I is
			-- C type
		do
			inspect size
			when 8 then Result := uint8_c_type
			when 16 then Result := uint16_c_type
			when 32 then Result := uint32_c_type
			when 64 then Result := uint64_c_type
			end
		end

invariant
	correct_size: size = 8 or size = 16 or size = 32 or size = 64

indexing
	copyright:	"Copyright (c) 1984-2007, Eiffel Software"
	license:	"GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options:	"http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful,	but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the	GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301  USA
		]"
	source: "[
			 Eiffel Software
			 356 Storke Road, Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"

end
