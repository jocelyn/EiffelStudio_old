indexing
	description: "Implemented `IEiffelSystemAssemblies' Interface."
	Note: "Automatically generated by the EiffelCOM Wizard."

class
	IEIFFEL_SYSTEM_ASSEMBLIES_IMPL_STUB

inherit
	IEIFFEL_SYSTEM_ASSEMBLIES_INTERFACE

	ECOM_STUB

feature -- Access

	assemblies: IENUM_ASSEMBLY_INTERFACE is
			-- Returns all of the assemblies in an enumerator
		do
			-- Put Implementation here.
		end

feature -- Basic Operations

	store is
			-- Save changes.
		do
			-- Put Implementation here.
		end

	add_assembly (assembly_prefix: STRING; cluster_name: STRING; a_name: STRING; a_version: STRING; a_culture: STRING; a_publickey: STRING) is
			-- Add a signed assembly to the project.
			-- `assembly_prefix' [in].  
			-- `cluster_name' [in].  
			-- `a_name' [in].  
			-- `a_version' [in].  
			-- `a_culture' [in].  
			-- `a_publickey' [in].  
		do
			-- Put Implementation here.
		end

	remove_assembly (assembly_identifier: STRING) is
			-- Remove an assembly from the project.
			-- `assembly_identifier' [in].  
		do
			-- Put Implementation here.
		end

	assembly_properties (cluster_name: STRING): IEIFFEL_ASSEMBLY_PROPERTIES_INTERFACE is
			-- Assembly properties.
			-- `cluster_name' [in].  
		do
			-- Put Implementation here.
		end

	is_valid_cluster_name (cluster_name: STRING): BOOLEAN is
			-- Checks to see if a assembly cluster name is valid
			-- `cluster_name' [in].  
		do
			-- Put Implementation here.
		end

	contains_assembly (cluster_name: STRING): BOOLEAN is
			-- Checks to see if a assembly cluster name has already been added to the project
			-- `cluster_name' [in].  
		do
			-- Put Implementation here.
		end

	contains_gac_assembly (a_name: STRING; a_version: STRING; a_culture: STRING; a_publickey: STRING): BOOLEAN is
			-- Checks to see if a signed assembly has already been added to the project
			-- `a_name' [in].  
			-- `a_version' [in].  
			-- `a_culture' [in].  
			-- `a_publickey' [in].  
		do
			-- Put Implementation here.
		end

	contains_local_assembly (a_path: STRING): BOOLEAN is
			-- Checks to see if a unsigned assembly has already been added to the project
			-- `a_path' [in].  
		do
			-- Put Implementation here.
		end

	cluster_name_from_gac_assembly (a_name: STRING; a_version: STRING; a_culture: STRING; a_publickey: STRING): STRING is
			-- Retrieves the cluster name for a signed assembly in the project
			-- `a_name' [in].  
			-- `a_version' [in].  
			-- `a_culture' [in].  
			-- `a_publickey' [in].  
		do
			-- Put Implementation here.
		end

	cluster_name_from_local_assembly (a_path: STRING): STRING is
			-- Retrieves the cluster name for a unsigned assembly in the project
			-- `a_path' [in].  
		do
			-- Put Implementation here.
		end

	is_valid_prefix (assembly_prefix: STRING): BOOLEAN is
			-- Is 'prefix' a valid assembly prefix
			-- `assembly_prefix' [in].  
		do
			-- Put Implementation here.
		end

	is_prefix_allocated (assembly_prefix: STRING): BOOLEAN is
			-- Has the 'prefix' already been allocated to another assembly
			-- `assembly_prefix' [in].  
		do
			-- Put Implementation here.
		end

	create_item is
			-- Initialize `item'
		do
			item := ccom_create_item (Current)
		end

feature {NONE}  -- Externals

	ccom_create_item (eif_object: IEIFFEL_SYSTEM_ASSEMBLIES_IMPL_STUB): POINTER is
			-- Initialize `item'
		external
			"C++ [new ecom_eiffel_compiler::IEiffelSystemAssemblies_impl_stub %"ecom_eiffel_compiler_IEiffelSystemAssemblies_impl_stub_s.h%"](EIF_OBJECT)"
		end

end -- IEIFFEL_SYSTEM_ASSEMBLIES_IMPL_STUB

