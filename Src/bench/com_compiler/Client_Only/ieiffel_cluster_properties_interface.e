indexing
	description: "Eiffel Cluster Properties (for Ace file). Eiffel language compiler library. Help file: "
	Note: "Automatically generated by the EiffelCOM Wizard."

deferred class
	IEIFFEL_CLUSTER_PROPERTIES_INTERFACE

inherit
	ECOM_INTERFACE

feature -- Status Report

	name_user_precondition: BOOLEAN is
			-- User-defined preconditions for `name'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	cluster_path_user_precondition: BOOLEAN is
			-- User-defined preconditions for `cluster_path'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	set_cluster_path_user_precondition (path: STRING): BOOLEAN is
			-- User-defined preconditions for `set_cluster_path'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	override_user_precondition: BOOLEAN is
			-- User-defined preconditions for `override'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	set_override_user_precondition (return_value: BOOLEAN): BOOLEAN is
			-- User-defined preconditions for `set_override'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	is_library_user_precondition: BOOLEAN is
			-- User-defined preconditions for `is_library'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	set_is_library_user_precondition (return_value: BOOLEAN): BOOLEAN is
			-- User-defined preconditions for `set_is_library'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	all1_user_precondition: BOOLEAN is
			-- User-defined preconditions for `all1'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	set_all_user_precondition (return_value: BOOLEAN): BOOLEAN is
			-- User-defined preconditions for `set_all'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	use_system_default_user_precondition: BOOLEAN is
			-- User-defined preconditions for `use_system_default'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	set_use_system_default_user_precondition (return_value: BOOLEAN): BOOLEAN is
			-- User-defined preconditions for `set_use_system_default'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	evaluate_require_by_default_user_precondition: BOOLEAN is
			-- User-defined preconditions for `evaluate_require_by_default'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	evaluate_ensure_by_default_user_precondition: BOOLEAN is
			-- User-defined preconditions for `evaluate_ensure_by_default'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	evaluate_check_by_default_user_precondition: BOOLEAN is
			-- User-defined preconditions for `evaluate_check_by_default'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	evaluate_loop_by_default_user_precondition: BOOLEAN is
			-- User-defined preconditions for `evaluate_loop_by_default'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	evaluate_invariant_by_default_user_precondition: BOOLEAN is
			-- User-defined preconditions for `evaluate_invariant_by_default'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	set_assertions_user_precondition (evaluate_check: BOOLEAN; evaluate_require: BOOLEAN; evaluate_ensure: BOOLEAN; evaluate_loop: BOOLEAN; evaluate_invariant: BOOLEAN): BOOLEAN is
			-- User-defined preconditions for `set_assertions'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	excluded_user_precondition: BOOLEAN is
			-- User-defined preconditions for `excluded'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	add_exclude_user_precondition (dir_name: STRING): BOOLEAN is
			-- User-defined preconditions for `add_exclude'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	remove_exclude_user_precondition (dir_name: STRING): BOOLEAN is
			-- User-defined preconditions for `remove_exclude'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	parent_name_user_precondition: BOOLEAN is
			-- User-defined preconditions for `parent_name'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	has_parent_user_precondition: BOOLEAN is
			-- User-defined preconditions for `has_parent'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	subclusters_user_precondition: BOOLEAN is
			-- User-defined preconditions for `subclusters'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	has_children_user_precondition: BOOLEAN is
			-- User-defined preconditions for `has_children'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	cluster_id_user_precondition: BOOLEAN is
			-- User-defined preconditions for `cluster_id'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	is_eiffel_library_user_precondition: BOOLEAN is
			-- User-defined preconditions for `is_eiffel_library'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	expanded_cluster_path_user_precondition: BOOLEAN is
			-- User-defined preconditions for `expanded_cluster_path'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	cluster_namespace_user_precondition: BOOLEAN is
			-- User-defined preconditions for `cluster_namespace'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	set_cluster_namespace_user_precondition (a_namespace: STRING): BOOLEAN is
			-- User-defined preconditions for `set_cluster_namespace'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

feature -- Basic Operations

	name: STRING is
			-- Cluster name.
		require
			name_user_precondition: name_user_precondition
		deferred

		end

	cluster_path: STRING is
			-- Full path to cluster.
		require
			cluster_path_user_precondition: cluster_path_user_precondition
		deferred

		end

	set_cluster_path (path: STRING) is
			-- Full path to cluster.
			-- `path' [in].  
		require
			set_cluster_path_user_precondition: set_cluster_path_user_precondition (path)
		deferred

		end

	override: BOOLEAN is
			-- Should this cluster classes take priority over other classes with same name?
		require
			override_user_precondition: override_user_precondition
		deferred

		end

	set_override (return_value: BOOLEAN) is
			-- Should this cluster classes take priority over other classes with same name?
			-- `return_value' [in].  
		require
			set_override_user_precondition: set_override_user_precondition (return_value)
		deferred

		end

	is_library: BOOLEAN is
			-- Should this cluster be treated as library?
		require
			is_library_user_precondition: is_library_user_precondition
		deferred

		end

	set_is_library (return_value: BOOLEAN) is
			-- Should this cluster be treated as library?
			-- `return_value' [in].  
		require
			set_is_library_user_precondition: set_is_library_user_precondition (return_value)
		deferred

		end

	all1: BOOLEAN is
			-- Should all subclusters be included?
		require
			all1_user_precondition: all1_user_precondition
		deferred

		end

	set_all (return_value: BOOLEAN) is
			-- Should all subclusters be included?
			-- `return_value' [in].  
		require
			set_all_user_precondition: set_all_user_precondition (return_value)
		deferred

		end

	use_system_default: BOOLEAN is
			-- Should use system default?
		require
			use_system_default_user_precondition: use_system_default_user_precondition
		deferred

		end

	set_use_system_default (return_value: BOOLEAN) is
			-- Should use system default?
			-- `return_value' [in].  
		require
			set_use_system_default_user_precondition: set_use_system_default_user_precondition (return_value)
		deferred

		end

	evaluate_require_by_default: BOOLEAN is
			-- Should preconditions be evaluated by default?
		require
			evaluate_require_by_default_user_precondition: evaluate_require_by_default_user_precondition
		deferred

		end

	evaluate_ensure_by_default: BOOLEAN is
			-- Should postconditions be evaluated by default?
		require
			evaluate_ensure_by_default_user_precondition: evaluate_ensure_by_default_user_precondition
		deferred

		end

	evaluate_check_by_default: BOOLEAN is
			-- Should check assertions be evaluated by default?
		require
			evaluate_check_by_default_user_precondition: evaluate_check_by_default_user_precondition
		deferred

		end

	evaluate_loop_by_default: BOOLEAN is
			-- Should loop assertions be evaluated by default?
		require
			evaluate_loop_by_default_user_precondition: evaluate_loop_by_default_user_precondition
		deferred

		end

	evaluate_invariant_by_default: BOOLEAN is
			-- Should class invariants be evaluated by default?
		require
			evaluate_invariant_by_default_user_precondition: evaluate_invariant_by_default_user_precondition
		deferred

		end

	set_assertions (evaluate_check: BOOLEAN; evaluate_require: BOOLEAN; evaluate_ensure: BOOLEAN; evaluate_loop: BOOLEAN; evaluate_invariant: BOOLEAN) is
			-- Set assertions for cluster.
			-- `evaluate_check' [in].  
			-- `evaluate_require' [in].  
			-- `evaluate_ensure' [in].  
			-- `evaluate_loop' [in].  
			-- `evaluate_invariant' [in].  
		require
			set_assertions_user_precondition: set_assertions_user_precondition (evaluate_check, evaluate_require, evaluate_ensure, evaluate_loop, evaluate_invariant)
		deferred

		end

	excluded: IENUM_CLUSTER_EXCLUDES_INTERFACE is
			-- List of excluded directories.
		require
			excluded_user_precondition: excluded_user_precondition
		deferred

		end

	add_exclude (dir_name: STRING) is
			-- Add a directory to exclude.
			-- `dir_name' [in].  
		require
			add_exclude_user_precondition: add_exclude_user_precondition (dir_name)
		deferred

		end

	remove_exclude (dir_name: STRING) is
			-- Remove a directory to exclude.
			-- `dir_name' [in].  
		require
			remove_exclude_user_precondition: remove_exclude_user_precondition (dir_name)
		deferred

		end

	parent_name: STRING is
			-- Name of the parent cluster.
		require
			parent_name_user_precondition: parent_name_user_precondition
		deferred

		end

	has_parent: BOOLEAN is
			-- Does the current cluster have a parent cluster?
		require
			has_parent_user_precondition: has_parent_user_precondition
		deferred

		end

	subclusters: IENUM_CLUSTER_PROP_INTERFACE is
			-- List subclusters (list of IEiffelClusterProperties*).
		require
			subclusters_user_precondition: subclusters_user_precondition
		deferred

		end

	has_children: BOOLEAN is
			-- Does the current cluster have children?
		require
			has_children_user_precondition: has_children_user_precondition
		deferred

		end

	cluster_id: INTEGER is
			-- Cluster identifier.
		require
			cluster_id_user_precondition: cluster_id_user_precondition
		deferred

		end

	is_eiffel_library: BOOLEAN is
			-- Is the cluster in the Eiffel library
		require
			is_eiffel_library_user_precondition: is_eiffel_library_user_precondition
		deferred

		end

	expanded_cluster_path: STRING is
			-- Full path to cluster with ISE_EIFFEL env var expanded.
		require
			expanded_cluster_path_user_precondition: expanded_cluster_path_user_precondition
		deferred

		end

	cluster_namespace: STRING is
			-- Cluster namespace.
		require
			cluster_namespace_user_precondition: cluster_namespace_user_precondition
		deferred

		end

	set_cluster_namespace (a_namespace: STRING) is
			-- Cluster namespace.
			-- `a_namespace' [in].  
		require
			set_cluster_namespace_user_precondition: set_cluster_namespace_user_precondition (a_namespace)
		deferred

		end

end -- IEIFFEL_CLUSTER_PROPERTIES_INTERFACE

