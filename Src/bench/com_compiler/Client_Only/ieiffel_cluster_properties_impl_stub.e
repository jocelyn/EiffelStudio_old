indexing
	description: "Implemented `IEiffelClusterProperties' Interface."
	Note: "Automatically generated by the EiffelCOM Wizard."

class
	IEIFFEL_CLUSTER_PROPERTIES_IMPL_STUB

inherit
	IEIFFEL_CLUSTER_PROPERTIES_INTERFACE

	ECOM_STUB

feature -- Access

	name: STRING is
			-- Cluster name.
		do
			-- Put Implementation here.
		end

	cluster_path: STRING is
			-- Full path to cluster.
		do
			-- Put Implementation here.
		end

	override: BOOLEAN is
			-- Should this cluster classes take priority over other classes with same name?
		do
			-- Put Implementation here.
		end

	is_library: BOOLEAN is
			-- Should this cluster be treated as library?
		do
			-- Put Implementation here.
		end

	all1: BOOLEAN is
			-- Should all subclusters be included?
		do
			-- Put Implementation here.
		end

	use_system_default: BOOLEAN is
			-- Should use system default?
		do
			-- Put Implementation here.
		end

	evaluate_require_by_default: BOOLEAN is
			-- Should preconditions be evaluated by default?
		do
			-- Put Implementation here.
		end

	evaluate_ensure_by_default: BOOLEAN is
			-- Should postconditions be evaluated by default?
		do
			-- Put Implementation here.
		end

	evaluate_check_by_default: BOOLEAN is
			-- Should check assertions be evaluated by default?
		do
			-- Put Implementation here.
		end

	evaluate_loop_by_default: BOOLEAN is
			-- Should loop assertions be evaluated by default?
		do
			-- Put Implementation here.
		end

	evaluate_invariant_by_default: BOOLEAN is
			-- Should class invariants be evaluated by default?
		do
			-- Put Implementation here.
		end

	excluded: IENUM_CLUSTER_EXCLUDES_INTERFACE is
			-- List of excluded directories.
		do
			-- Put Implementation here.
		end

	parent_name: STRING is
			-- Name of the parent cluster.
		do
			-- Put Implementation here.
		end

	has_parent: BOOLEAN is
			-- Does the current cluster have a parent cluster?
		do
			-- Put Implementation here.
		end

	subclusters: IENUM_CLUSTER_PROP_INTERFACE is
			-- List subclusters (list of IEiffelClusterProperties*).
		do
			-- Put Implementation here.
		end

	has_children: BOOLEAN is
			-- Does the current cluster have children?
		do
			-- Put Implementation here.
		end

	cluster_id: INTEGER is
			-- Cluster identifier.
		do
			-- Put Implementation here.
		end

	is_eiffel_library: BOOLEAN is
			-- Is the cluster in the Eiffel library
		do
			-- Put Implementation here.
		end

	expanded_cluster_path: STRING is
			-- Full path to cluster with ISE_EIFFEL env var expanded.
		do
			-- Put Implementation here.
		end

	cluster_namespace: STRING is
			-- Cluster namespace.
		do
			-- Put Implementation here.
		end

feature -- Basic Operations

	set_cluster_path (path: STRING) is
			-- Full path to cluster.
			-- `path' [in].  
		do
			-- Put Implementation here.
		end

	set_override (return_value: BOOLEAN) is
			-- Should this cluster classes take priority over other classes with same name?
			-- `return_value' [in].  
		do
			-- Put Implementation here.
		end

	set_is_library (return_value: BOOLEAN) is
			-- Should this cluster be treated as library?
			-- `return_value' [in].  
		do
			-- Put Implementation here.
		end

	set_all (return_value: BOOLEAN) is
			-- Should all subclusters be included?
			-- `return_value' [in].  
		do
			-- Put Implementation here.
		end

	set_use_system_default (return_value: BOOLEAN) is
			-- Should use system default?
			-- `return_value' [in].  
		do
			-- Put Implementation here.
		end

	set_assertions (evaluate_check: BOOLEAN; evaluate_require: BOOLEAN; evaluate_ensure: BOOLEAN; evaluate_loop: BOOLEAN; evaluate_invariant: BOOLEAN) is
			-- Set assertions for cluster.
			-- `evaluate_check' [in].  
			-- `evaluate_require' [in].  
			-- `evaluate_ensure' [in].  
			-- `evaluate_loop' [in].  
			-- `evaluate_invariant' [in].  
		do
			-- Put Implementation here.
		end

	add_exclude (dir_name: STRING) is
			-- Add a directory to exclude.
			-- `dir_name' [in].  
		do
			-- Put Implementation here.
		end

	remove_exclude (dir_name: STRING) is
			-- Remove a directory to exclude.
			-- `dir_name' [in].  
		do
			-- Put Implementation here.
		end

	set_cluster_namespace (a_namespace: STRING) is
			-- Cluster namespace.
			-- `a_namespace' [in].  
		do
			-- Put Implementation here.
		end

	create_item is
			-- Initialize `item'
		do
			item := ccom_create_item (Current)
		end

feature {NONE}  -- Externals

	ccom_create_item (eif_object: IEIFFEL_CLUSTER_PROPERTIES_IMPL_STUB): POINTER is
			-- Initialize `item'
		external
			"C++ [new ecom_eiffel_compiler::IEiffelClusterProperties_impl_stub %"ecom_eiffel_compiler_IEiffelClusterProperties_impl_stub.h%"](EIF_OBJECT)"
		end

end -- IEIFFEL_CLUSTER_PROPERTIES_IMPL_STUB

