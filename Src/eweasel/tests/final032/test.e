
--| Copyright (c) 1993-2006 University of Southern California and contributors.
--| All rights reserved.
--| Your use of this work is governed under the terms of the GNU General
--| Public License version 2.

class TEST
create
	make
	
feature

	make is
		do
			print (({STRING}).generating_type); io.new_line
		end

end
