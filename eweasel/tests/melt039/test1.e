
--| Copyright (c) 1993-2010 University of Southern California and contributors.
--| All rights reserved.
--| Your use of this work is governed under the terms of the GNU General
--| Public License version 2.

class TEST1 [G -> ANY]
feature
	weasel is
		local
			b: G;
		do
			print (b.generator); io.new_line;
		end
	
end
