class TEST
create
	make
feature
	
	make is
		do
			if "$DATA" = "$DATA" then
			end
			print ({REAL_32}.nan = {REAL_32}.nan)
			print ("%N")
			print ({REAL_64}.nan = {REAL_64}.nan)
			print ("%N")
			print ({REAL_32}.nan /= {REAL_32}.nan)
			print ("%N")
			print ({REAL_64}.nan /= {REAL_64}.nan)
			print ("%N")

			print ({REAL_32}.nan ~ {REAL_32}.nan)
			print ("%N")
			print ({REAL_64}.nan ~ {REAL_64}.nan)
			print ("%N")
			print ({REAL_32}.nan /~ {REAL_32}.nan)
			print ("%N")
			print ({REAL_64}.nan /~ {REAL_64}.nan)
			print ("%N")
		end

end
