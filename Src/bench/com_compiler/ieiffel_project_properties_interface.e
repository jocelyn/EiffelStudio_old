indexing
	description: "Eiffel Project Properties.  Help file: "
	Note: "Automatically generated by the EiffelCOM Wizard."

deferred class
	IEIFFEL_PROJECT_PROPERTIES_INTERFACE

inherit
	ECOM_INTERFACE

feature -- Status Report

	system_name_user_precondition: BOOLEAN is
			-- User-defined preconditions for `system_name'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	set_system_name_user_precondition (return_value: STRING): BOOLEAN is
			-- User-defined preconditions for `set_system_name'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	root_class_name_user_precondition: BOOLEAN is
			-- User-defined preconditions for `root_class_name'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	set_root_class_name_user_precondition (return_value: STRING): BOOLEAN is
			-- User-defined preconditions for `set_root_class_name'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	creation_routine_user_precondition: BOOLEAN is
			-- User-defined preconditions for `creation_routine'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	set_creation_routine_user_precondition (return_value: STRING): BOOLEAN is
			-- User-defined preconditions for `set_creation_routine'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	compilation_type_user_precondition: BOOLEAN is
			-- User-defined preconditions for `compilation_type'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	set_compilation_type_user_precondition (return_value: INTEGER): BOOLEAN is
			-- User-defined preconditions for `set_compilation_type'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	console_application_user_precondition: BOOLEAN is
			-- User-defined preconditions for `console_application'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	set_console_application_user_precondition (return_value: BOOLEAN): BOOLEAN is
			-- User-defined preconditions for `set_console_application'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	evaluate_require_user_precondition: BOOLEAN is
			-- User-defined preconditions for `evaluate_require'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	set_evaluate_require_user_precondition (return_value: BOOLEAN): BOOLEAN is
			-- User-defined preconditions for `set_evaluate_require'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	evaluate_ensure_user_precondition: BOOLEAN is
			-- User-defined preconditions for `evaluate_ensure'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	set_evaluate_ensure_user_precondition (return_value: BOOLEAN): BOOLEAN is
			-- User-defined preconditions for `set_evaluate_ensure'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	evaluate_check_user_precondition: BOOLEAN is
			-- User-defined preconditions for `evaluate_check'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	set_evaluate_check_user_precondition (return_value: BOOLEAN): BOOLEAN is
			-- User-defined preconditions for `set_evaluate_check'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	evaluate_loop_user_precondition: BOOLEAN is
			-- User-defined preconditions for `evaluate_loop'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	set_evaluate_loop_user_precondition (return_value: BOOLEAN): BOOLEAN is
			-- User-defined preconditions for `set_evaluate_loop'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	evaluate_invariant_user_precondition: BOOLEAN is
			-- User-defined preconditions for `evaluate_invariant'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	set_evaluate_invariant_user_precondition (return_value: BOOLEAN): BOOLEAN is
			-- User-defined preconditions for `set_evaluate_invariant'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	debug_info_user_precondition: BOOLEAN is
			-- User-defined preconditions for `debug_info'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	set_debug_info_user_precondition (return_value: BOOLEAN): BOOLEAN is
			-- User-defined preconditions for `set_debug_info'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	clusters_user_precondition: BOOLEAN is
			-- User-defined preconditions for `clusters'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	externals_user_precondition: BOOLEAN is
			-- User-defined preconditions for `externals'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	default_namespace_user_precondition: BOOLEAN is
			-- User-defined preconditions for `default_namespace'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	set_default_namespace_user_precondition (return_value: STRING): BOOLEAN is
			-- User-defined preconditions for `set_default_namespace'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	assemblies_user_precondition: BOOLEAN is
			-- User-defined preconditions for `assemblies'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	precompiled_user_precondition: BOOLEAN is
			-- User-defined preconditions for `precompiled'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	set_precompiled_user_precondition (return_value: STRING): BOOLEAN is
			-- User-defined preconditions for `set_precompiled'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	title_user_precondition: BOOLEAN is
			-- User-defined preconditions for `title'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	set_title_user_precondition (return_value: STRING): BOOLEAN is
			-- User-defined preconditions for `set_title'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	description_user_precondition: BOOLEAN is
			-- User-defined preconditions for `description'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	set_description_user_precondition (return_value: STRING): BOOLEAN is
			-- User-defined preconditions for `set_description'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	company_user_precondition: BOOLEAN is
			-- User-defined preconditions for `company'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	set_company_user_precondition (return_value: STRING): BOOLEAN is
			-- User-defined preconditions for `set_company'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	product_user_precondition: BOOLEAN is
			-- User-defined preconditions for `product'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	set_product_user_precondition (return_value: STRING): BOOLEAN is
			-- User-defined preconditions for `set_product'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	version_user_precondition: BOOLEAN is
			-- User-defined preconditions for `version'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	set_version_user_precondition (return_value: STRING): BOOLEAN is
			-- User-defined preconditions for `set_version'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	trademark_user_precondition: BOOLEAN is
			-- User-defined preconditions for `trademark'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	set_trademark_user_precondition (return_value: STRING): BOOLEAN is
			-- User-defined preconditions for `set_trademark'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	copyright_user_precondition: BOOLEAN is
			-- User-defined preconditions for `copyright'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	set_copyright_user_precondition (return_value: STRING): BOOLEAN is
			-- User-defined preconditions for `set_copyright'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	key_file_name_user_precondition: BOOLEAN is
			-- User-defined preconditions for `key_file_name'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	set_key_file_name_user_precondition (return_value: STRING): BOOLEAN is
			-- User-defined preconditions for `set_key_file_name'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	culture_user_precondition: BOOLEAN is
			-- User-defined preconditions for `culture'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	set_culture_user_precondition (return_value: STRING): BOOLEAN is
			-- User-defined preconditions for `set_culture'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	apply_user_precondition: BOOLEAN is
			-- User-defined preconditions for `apply'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

feature -- Basic Operations

	system_name: STRING is
			-- System name.
		require
			system_name_user_precondition: system_name_user_precondition
		deferred

		end

	set_system_name (return_value: STRING) is
			-- System name.
			-- `return_value' [in].  
		require
			set_system_name_user_precondition: set_system_name_user_precondition (return_value)
		deferred

		end

	root_class_name: STRING is
			-- Root class name.
		require
			root_class_name_user_precondition: root_class_name_user_precondition
		deferred

		end

	set_root_class_name (return_value: STRING) is
			-- Root class name.
			-- `return_value' [in].  
		require
			set_root_class_name_user_precondition: set_root_class_name_user_precondition (return_value)
		deferred

		end

	creation_routine: STRING is
			-- Creation routine name.
		require
			creation_routine_user_precondition: creation_routine_user_precondition
		deferred

		end

	set_creation_routine (return_value: STRING) is
			-- Creation routine name.
			-- `return_value' [in].  
		require
			set_creation_routine_user_precondition: set_creation_routine_user_precondition (return_value)
		deferred

		end

	compilation_type: INTEGER is
			-- Compilation type.
			-- See ECOM_X__EIF_COMPILATION_TYPES_ENUM for possible `Result' values.
		require
			compilation_type_user_precondition: compilation_type_user_precondition
		deferred

		end

	set_compilation_type (return_value: INTEGER) is
			-- Compilation type.
			-- `return_value' [in]. See ECOM_X__EIF_COMPILATION_TYPES_ENUM for possible `return_value' values. 
		require
			set_compilation_type_user_precondition: set_compilation_type_user_precondition (return_value)
		deferred

		end

	console_application: BOOLEAN is
			-- Is console application?
		require
			console_application_user_precondition: console_application_user_precondition
		deferred

		end

	set_console_application (return_value: BOOLEAN) is
			-- Is console application?
			-- `return_value' [in].  
		require
			set_console_application_user_precondition: set_console_application_user_precondition (return_value)
		deferred

		end

	evaluate_require: BOOLEAN is
			-- Should preconditions be evaluated?
		require
			evaluate_require_user_precondition: evaluate_require_user_precondition
		deferred

		end

	set_evaluate_require (return_value: BOOLEAN) is
			-- Should preconditions be evaluated?
			-- `return_value' [in].  
		require
			set_evaluate_require_user_precondition: set_evaluate_require_user_precondition (return_value)
		deferred

		end

	evaluate_ensure: BOOLEAN is
			-- Should postconditions be evaluated?
		require
			evaluate_ensure_user_precondition: evaluate_ensure_user_precondition
		deferred

		end

	set_evaluate_ensure (return_value: BOOLEAN) is
			-- Should postconditions be evaluated?
			-- `return_value' [in].  
		require
			set_evaluate_ensure_user_precondition: set_evaluate_ensure_user_precondition (return_value)
		deferred

		end

	evaluate_check: BOOLEAN is
			-- Should check assertions be evaluated?
		require
			evaluate_check_user_precondition: evaluate_check_user_precondition
		deferred

		end

	set_evaluate_check (return_value: BOOLEAN) is
			-- Should check assertions be evaluated?
			-- `return_value' [in].  
		require
			set_evaluate_check_user_precondition: set_evaluate_check_user_precondition (return_value)
		deferred

		end

	evaluate_loop: BOOLEAN is
			-- Should loop assertions be evaluated?
		require
			evaluate_loop_user_precondition: evaluate_loop_user_precondition
		deferred

		end

	set_evaluate_loop (return_value: BOOLEAN) is
			-- Should loop assertions be evaluated?
			-- `return_value' [in].  
		require
			set_evaluate_loop_user_precondition: set_evaluate_loop_user_precondition (return_value)
		deferred

		end

	evaluate_invariant: BOOLEAN is
			-- Should class invariants be evaluated?
		require
			evaluate_invariant_user_precondition: evaluate_invariant_user_precondition
		deferred

		end

	set_evaluate_invariant (return_value: BOOLEAN) is
			-- Should class invariants be evaluated?
			-- `return_value' [in].  
		require
			set_evaluate_invariant_user_precondition: set_evaluate_invariant_user_precondition (return_value)
		deferred

		end

	debug_info: BOOLEAN is
			-- Generate debug info?
		require
			debug_info_user_precondition: debug_info_user_precondition
		deferred

		end

	set_debug_info (return_value: BOOLEAN) is
			-- Generate debug info?
			-- `return_value' [in].  
		require
			set_debug_info_user_precondition: set_debug_info_user_precondition (return_value)
		deferred

		end

	clusters: IEIFFEL_SYSTEM_CLUSTERS_INTERFACE is
			-- Project Clusters.
		require
			clusters_user_precondition: clusters_user_precondition
		deferred

		end

	externals: IEIFFEL_SYSTEM_EXTERNALS_INTERFACE is
			-- Externals.
		require
			externals_user_precondition: externals_user_precondition
		deferred

		end

	default_namespace: STRING is
			-- Default namespace.
		require
			default_namespace_user_precondition: default_namespace_user_precondition
		deferred

		end

	set_default_namespace (return_value: STRING) is
			-- Default namespace.
			-- `return_value' [in].  
		require
			set_default_namespace_user_precondition: set_default_namespace_user_precondition (return_value)
		deferred

		end

	assemblies: IEIFFEL_SYSTEM_ASSEMBLIES_INTERFACE is
			-- Assemblies.
		require
			assemblies_user_precondition: assemblies_user_precondition
		deferred

		end

	precompiled: STRING is
			-- Precompiled file.
		require
			precompiled_user_precondition: precompiled_user_precondition
		deferred

		end

	set_precompiled (return_value: STRING) is
			-- Precompiled file.
			-- `return_value' [in].  
		require
			set_precompiled_user_precondition: set_precompiled_user_precondition (return_value)
		deferred

		end

	title: STRING is
			-- Project title.
		require
			title_user_precondition: title_user_precondition
		deferred

		end

	set_title (return_value: STRING) is
			-- Project title.
			-- `return_value' [in].  
		require
			set_title_user_precondition: set_title_user_precondition (return_value)
		deferred

		end

	description: STRING is
			-- Project description.
		require
			description_user_precondition: description_user_precondition
		deferred

		end

	set_description (return_value: STRING) is
			-- Project description.
			-- `return_value' [in].  
		require
			set_description_user_precondition: set_description_user_precondition (return_value)
		deferred

		end

	company: STRING is
			-- Project company.
		require
			company_user_precondition: company_user_precondition
		deferred

		end

	set_company (return_value: STRING) is
			-- Project company.
			-- `return_value' [in].  
		require
			set_company_user_precondition: set_company_user_precondition (return_value)
		deferred

		end

	product: STRING is
			-- Product.
		require
			product_user_precondition: product_user_precondition
		deferred

		end

	set_product (return_value: STRING) is
			-- Product.
			-- `return_value' [in].  
		require
			set_product_user_precondition: set_product_user_precondition (return_value)
		deferred

		end

	version: STRING is
			-- Project version.
		require
			version_user_precondition: version_user_precondition
		deferred

		end

	set_version (return_value: STRING) is
			-- Project version.
			-- `return_value' [in].  
		require
			set_version_user_precondition: set_version_user_precondition (return_value)
		deferred

		end

	trademark: STRING is
			-- Project trademark.
		require
			trademark_user_precondition: trademark_user_precondition
		deferred

		end

	set_trademark (return_value: STRING) is
			-- Project trademark.
			-- `return_value' [in].  
		require
			set_trademark_user_precondition: set_trademark_user_precondition (return_value)
		deferred

		end

	copyright: STRING is
			-- Project copyright.
		require
			copyright_user_precondition: copyright_user_precondition
		deferred

		end

	set_copyright (return_value: STRING) is
			-- Project copyright.
			-- `return_value' [in].  
		require
			set_copyright_user_precondition: set_copyright_user_precondition (return_value)
		deferred

		end

	key_file_name: STRING is
			-- Asembly signing key file name.
		require
			key_file_name_user_precondition: key_file_name_user_precondition
		deferred

		end

	set_key_file_name (return_value: STRING) is
			-- Asembly signing key file name.
			-- `return_value' [in].  
		require
			set_key_file_name_user_precondition: set_key_file_name_user_precondition (return_value)
		deferred

		end

	culture: STRING is
			-- Asembly culture.
		require
			culture_user_precondition: culture_user_precondition
		deferred

		end

	set_culture (return_value: STRING) is
			-- Asembly culture.
			-- `return_value' [in].  
		require
			set_culture_user_precondition: set_culture_user_precondition (return_value)
		deferred

		end

	apply is
			-- Apply changes
		require
			apply_user_precondition: apply_user_precondition
		deferred

		end

end -- IEIFFEL_PROJECT_PROPERTIES_INTERFACE

