indexing
	description: "Eiffel Cluster Properties Enumeration. Eiffel language compiler library. Help file: "
	Note: "Automatically generated by the EiffelCOM Wizard."

deferred class
	IENUM_CLUSTER_PROP_INTERFACE

inherit
	ECOM_INTERFACE

feature -- Status Report

	next_user_precondition (rgelt: CELL [IEIFFEL_CLUSTER_PROPERTIES_INTERFACE]; pcelt_fetched: INTEGER_REF): BOOLEAN is
			-- User-defined preconditions for `next'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	skip_user_precondition (celt: INTEGER): BOOLEAN is
			-- User-defined preconditions for `skip'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	reset_user_precondition: BOOLEAN is
			-- User-defined preconditions for `reset'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	clone1_user_precondition (ppenum: CELL [IENUM_CLUSTER_PROP_INTERFACE]): BOOLEAN is
			-- User-defined preconditions for `clone1'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	ith_item_user_precondition (an_index: INTEGER; rgelt: CELL [IEIFFEL_CLUSTER_PROPERTIES_INTERFACE]): BOOLEAN is
			-- User-defined preconditions for `ith_item'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	count_user_precondition: BOOLEAN is
			-- User-defined preconditions for `count'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

feature -- Basic Operations

	next (rgelt: CELL [IEIFFEL_CLUSTER_PROPERTIES_INTERFACE]; pcelt_fetched: INTEGER_REF) is
			-- No description available.
			-- `rgelt' [out].  
			-- `pcelt_fetched' [out].  
		require
			non_void_rgelt: rgelt /= Void
			non_void_pcelt_fetched: pcelt_fetched /= Void
			next_user_precondition: next_user_precondition (rgelt, pcelt_fetched)
		deferred

		ensure
			valid_rgelt: rgelt.item /= Void
		end

	skip (celt: INTEGER) is
			-- No description available.
			-- `celt' [in].  
		require
			skip_user_precondition: skip_user_precondition (celt)
		deferred

		end

	reset is
			-- No description available.
		require
			reset_user_precondition: reset_user_precondition
		deferred

		end

	clone1 (ppenum: CELL [IENUM_CLUSTER_PROP_INTERFACE]) is
			-- No description available.
			-- `ppenum' [out].  
		require
			non_void_ppenum: ppenum /= Void
			clone1_user_precondition: clone1_user_precondition (ppenum)
		deferred

		ensure
			valid_ppenum: ppenum.item /= Void
		end

	ith_item (an_index: INTEGER; rgelt: CELL [IEIFFEL_CLUSTER_PROPERTIES_INTERFACE]) is
			-- No description available.
			-- `an_index' [in].  
			-- `rgelt' [out].  
		require
			non_void_rgelt: rgelt /= Void
			ith_item_user_precondition: ith_item_user_precondition (an_index, rgelt)
		deferred

		ensure
			valid_rgelt: rgelt.item /= Void
		end

	count: INTEGER is
			-- No description available.
		require
			count_user_precondition: count_user_precondition
		deferred

		end

end -- IENUM_CLUSTER_PROP_INTERFACE

