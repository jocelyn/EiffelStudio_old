
--| Copyright (c) 1993-2006 University of Southern California and contributors.
--| All rights reserved.
--| Your use of this work is governed under the terms of the GNU General
--| Public License version 2.


class TEST
$INHERITANCE
creation
	make
feature

	make is
		do
			print (strip (try));
		end;
	
	f is do end;
	
	$TEST_ATTRIBUTE
	
end

