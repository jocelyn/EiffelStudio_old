class A

inherit
	I
	E
		redefine
			get_hash_code
		end
	D

feature

	get_hash_code: INTEGER is
		do
			Result := 5
		end

end