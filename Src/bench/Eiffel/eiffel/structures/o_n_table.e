-- Old/New table

class O_N_TABLE [G -> COMPILER_ID]

inherit

	EXTEND_TABLE [G, G]
		rename
			put as tbl_put,
			item as tbl_item
		export
			{NONE} all
		end

creation

	make

feature

	put (new_value, old_value: G) is
		local
			latest_old: G
		do
debug
	io.error.putstring ("OLD/NEW TABLE put ");
end;
			if not has (new_value) then
debug
	io.error.putstring ("insert new value%N");
end;
				latest_old := item (old_value);
				force (new_value, latest_old);
				from
					start
				until
					after
				loop
					if equal (item_for_iteration, latest_old) then
						content.put (new_value, pos_for_iter);
						control := Changed_constant;
					end;
					forth
				end;
			end;
debug
	trace;
end;
		end;

	undo_put (old_value, new_value: G) is
			-- Undo the changes
			--| We cannot use `put' again because of the
			--| protection `has'
		require
			item (old_value) = new_value
		local
			latest_new: G
		do
			latest_new := item (new_value);
debug
	io.error.putstring ("Calling undo_put old: ");
	old_value.trace;
	io.error.putstring (" new: ");
	new_value.trace;
	io.error.new_line;
end;
			force (latest_new, old_value);
			from
				start
			until
				after
			loop
				if equal (item_for_iteration, latest_new) then
debug
	io.error.putstring ("FOUND ");
	io.error.putint (pos_for_iter);
	io.error.new_line;
end;
					content.put (old_value, pos_for_iter);
					control := Changed_constant;
				end;
				forth
			end;
debug
	trace;
end;
		end;


	item (i: G): G is
		do
			if has (i) then
				Result := tbl_item (i)
			else
				Result := i
			end;
		end;

feature -- Trace

	trace is
			-- For debug purposes
		do
			from
				start;
				io.error.putstring ("==== Old/New table ====%N");
			until
				after
			loop
				io.error.putstring ("Old: ");
				key_for_iteration.trace;
				io.error.putstring (" , New: ");
				item_for_iteration.trace;
				io.error.new_line;
				forth
			end
		end;

end
