
--| Copyright (c) 1993-2006 University of Southern California and contributors.
--| All rights reserved.
--| Your use of this work is governed under the terms of the GNU General
--| Public License version 2.

deferred class TEST2
inherit
	TEST3
		undefine
			f
		redefine
			make
		end
		
feature
	make is
		do
		end

end
