indexing
	description:
		"Evaluator to check if stack is empty"

	status:	"See note at end of class"
	date: "$Date$"
	revision: "$Revision$"

class EMPTY_STACK_EVALUATOR inherit

	EVALUATOR
		rename
			is_true as empty
		redefine
			test_step
		end

feature -- Status report

	empty: BOOLEAN is
			-- Is stack empty?
		do
			Result := test_step.stack.empty
		end

feature {NONE} -- Implementation

	test_step: POP_STEP
			-- Callback to test step

end -- class EMPTY_STACK_EVALUATOR

--|----------------------------------------------------------------
--| EiffelTest: Reusable components for developing unit tests.
--| Copyright (C) 2000 Interactive Software Engineering Inc.
--| All rights reserved. Duplication and distribution prohibited.
--| May be used only with ISE Eiffel, under terms of user license. 
--| Contact ISE for any other use.
--|
--| Interactive Software Engineering Inc.
--| ISE Building, 2nd floor
--| 270 Storke Road, Goleta, CA 93117 USA
--| Telephone 805-685-1006, Fax 805-685-6869
--| Electronic mail <info@eiffel.com>
--| Customer support e-mail <support@eiffel.com>
--| For latest info see award-winning pages: http://www.eiffel.com
--|----------------------------------------------------------------
