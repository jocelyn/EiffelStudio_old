indexing
	description: "EiffelVision EV_ARGUMENT2. To be used when passing two arguments to a command.";
	status: "See notice at end of class";
	id: "$Id$";
	date: "$Date$";
	revision: "$Revision$"

class 
	EV_ARGUMENT2 [G, H]
	
inherit
	EV_ARGUMENT1

creation 
	make
	
feature -- Initialization
	
	make (first_argument: G; second_argument: H) is
		do
			Precursor (first)
			second := second_argument
		end
	
feature -- Access
	
	second: H
	
	
end -- class EV_ARGUMENTS
