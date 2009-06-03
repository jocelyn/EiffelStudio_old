-- This file has been generated by EWG. Do not edit. Changes will be lost!

class POINT_STRUCT

inherit

	EWG_STRUCT

	POINT_STRUCT_EXTERNAL
		export
			{NONE} all
		end

create

	make_new_unshared,
	make_new_shared,
	make_unshared,
	make_shared

feature {ANY} -- Access

	sizeof: INTEGER is
		do
			Result := sizeof_external
		end

feature {ANY} -- Member Access

	v: INTEGER is
			-- Access member `v'
		require
			exists: exists
		do
			Result := get_v_external (item)
		ensure
			result_correct: Result = get_v_external (item)
		end

	set_v (a_value: INTEGER) is
			-- Set member `v'
		require
			exists: exists
		do
			set_v_external (item, a_value)
		ensure
			a_value_set: a_value = v
		end

	h: INTEGER is
			-- Access member `h'
		require
			exists: exists
		do
			Result := get_h_external (item)
		ensure
			result_correct: Result = get_h_external (item)
		end

	set_h (a_value: INTEGER) is
			-- Set member `h'
		require
			exists: exists
		do
			set_h_external (item, a_value)
		ensure
			a_value_set: a_value = h
		end

end
