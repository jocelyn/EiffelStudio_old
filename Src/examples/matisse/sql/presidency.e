
indexing
	description: "Generated by MATISSE ODL tool (release 4.0.0 of mt_odl)";
	date: "$Date$"

class 
	PRESIDENCY

inherit

-- BEGIN generation of inheritance by mt_odl
-- DO NOT MODIFY UNTIL THE 'END of mt_odl generation' MARK BELOW
	MT_STORABLE
-- END of mt_odl generation of inheritance


		redefine out 
		end
		
create
	make
	
feature
	make(presidency_number, start_year, end_year: INTEGER; president: PERSON) is
		do
			number := presidency_number
			starting_year := start_year
			ending_year := end_year
			is_served_by := president
		end

-- BEGIN generation of accessors by mt_odl
-- DO NOT MODIFY UNTIL THE 'END of mt_odl generation' MARK BELOW
-- generated with release 4.0.0 of mt_odl (c) from ADB MATISSE
-- Date: Fri Oct 23 17:10:47 1998

feature {NONE}

	number: INTEGER
	starting_year: INTEGER
	ending_year: INTEGER
	is_served_by: PERSON

feature -- Access

	get_number: INTEGER is
		do
			if is_obsolete or else number = Integer_default_value then
				number := mt_get_integer_by_position(field_position_of_number)
			end
			Result := number
		end

	get_starting_year: INTEGER is
		do
			if is_obsolete or else starting_year = Integer_default_value then
				starting_year := mt_get_integer_by_position(field_position_of_starting_year)
			end
			Result := starting_year
		end

	get_ending_year: INTEGER is
		do
			if is_obsolete or else ending_year = Integer_default_value then
				ending_year := mt_get_integer_by_position(field_position_of_ending_year)
			end
			Result := ending_year
		end

	get_is_served_by: PERSON is
		do
			if is_obsolete or else is_served_by = Void then
				is_served_by ?= mt_get_successor_by_position(field_position_of_is_served_by)
			end
			Result := is_served_by
		end


feature -- Modification

	set_number(new_number: INTEGER) is
		do
			number := new_number
			mt_set_integer(field_position_of_number)
		end

	set_starting_year(new_starting_year: INTEGER) is
		do
			starting_year := new_starting_year
			mt_set_integer(field_position_of_starting_year)
		end

	set_ending_year(new_ending_year: INTEGER) is
		do
			ending_year := new_ending_year
			mt_set_integer(field_position_of_ending_year)
		end

	set_is_served_by(new_is_served_by: PERSON) is
		do
			check_persistence(new_is_served_by)
			is_served_by := new_is_served_by
			mt_set_successor(field_position_of_is_served_by)
		end


feature {NONE} -- Implementation

	field_position_of_number: INTEGER is
		once
			Result := field_position_of("number")
		end

	field_position_of_starting_year: INTEGER is
		once
			Result := field_position_of("starting_year")
		end

	field_position_of_ending_year: INTEGER is
		once
			Result := field_position_of("ending_year")
		end

	field_position_of_is_served_by: INTEGER is
		once
			Result := field_position_of("is_served_by")
		end


-- END of mt_odl generation of accessors

--
-- You may add your own code here...
--

feature

	out: STRING is
		do
			Result := get_number.out
			Result.append(": ")
			Result.append(get_starting_year.out)
			Result.append("-")
			Result.append(get_ending_year.out)
			Result.append(" ")
			Result.append(get_is_served_by.get_first_name)
			Result.append(" ")
			if get_is_served_by.get_middle_initial /= 'U' then
				Result.append_character(is_served_by.get_middle_initial)
				Result.append(". ")
			end
			Result.append(get_is_served_by.get_last_name)
		end
		
end -- class PRESIDENCY

