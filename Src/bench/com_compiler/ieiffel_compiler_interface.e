indexing
	description: "Eiffel Compiler. Eiffel language compiler library. Help file: "
	Note: "Automatically generated by the EiffelCOM Wizard."

deferred class
	IEIFFEL_COMPILER_INTERFACE

inherit
	ECOM_INTERFACE

feature -- Status Report

	compiler_version_user_precondition: BOOLEAN is
			-- User-defined preconditions for `compiler_version'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	has_signable_generation_user_precondition: BOOLEAN is
			-- User-defined preconditions for `has_signable_generation'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	can_run_user_precondition: BOOLEAN is
			-- User-defined preconditions for `can_run'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	compile_user_precondition (mode: INTEGER): BOOLEAN is
			-- User-defined preconditions for `compile'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	compile_to_pipe_user_precondition (mode: INTEGER; bstr_pipe_name: STRING): BOOLEAN is
			-- User-defined preconditions for `compile_to_pipe'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	was_compilation_successful_user_precondition: BOOLEAN is
			-- User-defined preconditions for `was_compilation_successful'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	freezing_occurred_user_precondition: BOOLEAN is
			-- User-defined preconditions for `freezing_occurred'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	freeze_command_name_user_precondition: BOOLEAN is
			-- User-defined preconditions for `freeze_command_name'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	freeze_command_arguments_user_precondition: BOOLEAN is
			-- User-defined preconditions for `freeze_command_arguments'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	remove_file_locks_user_precondition: BOOLEAN is
			-- User-defined preconditions for `remove_file_locks'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	set_display_warnings_user_precondition (arg_1: BOOLEAN): BOOLEAN is
			-- User-defined preconditions for `set_display_warnings'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	expand_path_user_precondition (bstr_path: STRING): BOOLEAN is
			-- User-defined preconditions for `expand_path'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	generate_msil_key_file_name_user_precondition (bstr_file_name: STRING): BOOLEAN is
			-- User-defined preconditions for `generate_msil_key_file_name'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

feature -- Basic Operations

	compiler_version: STRING is
			-- Compiler version.
		require
			compiler_version_user_precondition: compiler_version_user_precondition
		deferred

		end

	has_signable_generation: BOOLEAN is
			-- Is the compiler a trial version.
		require
			has_signable_generation_user_precondition: has_signable_generation_user_precondition
		deferred

		end

	can_run: BOOLEAN is
			-- Can product be run? (i.e. is it activated or was run less than 10 times)
		require
			can_run_user_precondition: can_run_user_precondition
		deferred

		end

	compile (mode: INTEGER) is
			-- Compile.
			-- `mode' [in]. See ECOM_EIF_COMPILATION_MODE_ENUM for possible `mode' values. 
		require
			compile_user_precondition: compile_user_precondition (mode)
		deferred

		end

	compile_to_pipe (mode: INTEGER; bstr_pipe_name: STRING) is
			-- Compile to an already established named pipe.
			-- `mode' [in]. See ECOM_EIF_COMPILATION_MODE_ENUM for possible `mode' values. 
			-- `bstr_pipe_name' [in].  
		require
			compile_to_pipe_user_precondition: compile_to_pipe_user_precondition (mode, bstr_pipe_name)
		deferred

		end

	was_compilation_successful: BOOLEAN is
			-- Was last compilation successful?
		require
			was_compilation_successful_user_precondition: was_compilation_successful_user_precondition
		deferred

		end

	freezing_occurred: BOOLEAN is
			-- Did last compile warrant a call to finish_freezing?
		require
			freezing_occurred_user_precondition: freezing_occurred_user_precondition
		deferred

		end

	freeze_command_name: STRING is
			-- Eiffel Freeze command name
		require
			freeze_command_name_user_precondition: freeze_command_name_user_precondition
		deferred

		end

	freeze_command_arguments: STRING is
			-- Eiffel Freeze command arguments
		require
			freeze_command_arguments_user_precondition: freeze_command_arguments_user_precondition
		deferred

		end

	remove_file_locks is
			-- Remove file locks
		require
			remove_file_locks_user_precondition: remove_file_locks_user_precondition
		deferred

		end

	set_display_warnings (arg_1: BOOLEAN) is
			-- Should warning events be raised when compilation raises a warning?
			-- `arg_1' [in].  
		require
			set_display_warnings_user_precondition: set_display_warnings_user_precondition (arg_1)
		deferred

		end

	expand_path (bstr_path: STRING): STRING is
			-- Takes a path and expands it using the env vars.
			-- `bstr_path' [in].  
		require
			expand_path_user_precondition: expand_path_user_precondition (bstr_path)
		deferred

		end

	generate_msil_key_file_name (bstr_file_name: STRING) is
			-- Generate a cyrptographic key filename.
			-- `bstr_file_name' [in].  
		require
			generate_msil_key_file_name_user_precondition: generate_msil_key_file_name_user_precondition (bstr_file_name)
		deferred

		end

end -- IEIFFEL_COMPILER_INTERFACE

