indexing
	description: "AST representation of binary `^' operation."
	date: "$Date$"
	revision: "$Revision $"

class
	BIN_POWER_AS

inherit
	ARITHMETIC_AS
		redefine
			balanced
		end

feature -- Properties

	infix_function_name: STRING is "_infix_power"
			-- Internal name of the infixed feature associated to the
			-- binary expression

	balanced: BOOLEAN is False
			-- Is the operation balanced ?

end -- class BIN_POWER_AS
