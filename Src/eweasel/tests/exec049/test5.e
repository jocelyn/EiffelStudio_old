
--| Copyright (c) 1993-2006 University of Southern California and contributors.
--| All rights reserved.
--| Your use of this work is governed under the terms of the GNU General
--| Public License version 2.

class TEST5
inherit
	SHOW
feature
	try is
		require
			assert: show ("Precondition of try in TEST5");
		do
		ensure
			assert: show ("Postcondition of try in TEST5");
		end
end
