indexing
	description: "Objects that ..."
	date: "$Date$"
	revision: "$Revision$"

class
	WIZARD_IDL_GENERATOR

inherit
	WIZARD_ERRORS
		export
			{NONE} all
		end

	WIZARD_SHARED_DATA
		export
			{NONE} all
		end

feature -- Access

	destination_folder: STRING

feature -- Basic operations

	generate is
			-- Generate IDL file
		local
			l_dir: DIRECTORY
			l_cmd: STRING
			l_data: EI_CLASS_DATA_INPUT
			l_idl_file, l_file: PLAIN_TEXT_FILE
			l_midl_lib: EI_MIDL_LIBRARY
			l_midl_coclass_creator: EI_MIDL_COCLASS_CREATOR
			l_process_launcher: WEL_PROCESS_LAUNCHER
		do
			message_output.add_message ("Generating IDL from Eiffel class " + environment.eiffel_class_name)
			destination_folder := environment.destination_folder.twin
			destination_folder.append ("idl")
			create l_dir.make (destination_folder)
			if not l_dir.exists then
				l_dir.create_dir
			end
			create l_cmd.make (100)
			l_cmd.append ("ec -flatshort -filter com ")
			l_cmd.append (environment.eiffel_class_name)
			l_cmd.append (" -project ")
			l_cmd.append (environment.eiffel_project_name)
			create l_file.make (Output_file_name)
			if l_file.exists then
				l_file.delete
			end
			create l_process_launcher
			l_process_launcher.run_hidden
			l_process_launcher.launch (l_cmd, destination_folder, agent write_to_output_file)

			if not environment.abort then
				create l_data.make
				l_data.input_from_file (Output_file_name)
				if l_data.class_not_found then
					environment.set_abort (Class_not_in_project)
				else
					if not environment.abort then						
						create l_midl_lib.make (environment.eiffel_class_name)
						create l_midl_coclass_creator.make
						l_midl_coclass_creator.create_from_eiffel_class (l_data.eiffel_class)
						l_midl_lib.set_coclass (l_midl_coclass_creator.midl_coclass)
	
						create l_idl_file.make_open_write (environment.idl_file_name)
						l_idl_file.put_string (l_midl_lib.code)
						l_idl_file.flush
						l_idl_file.close
					end
				end
			end
		end

feature {NONE} -- Basic operations

	write_to_output_file (a_output: STRING) is
			-- Write output to `Output_file_name'.
		local
			l_output_file: PLAIN_TEXT_FILE
			l_retried: BOOLEAN
		do
			if not l_retried then
				create l_output_file.make_open_append (Output_file_name)
				l_output_file.put_string (a_output)
				l_output_file.close
			end
		rescue
			environment.set_abort (File_write_error)
			environment.set_error_data ((create {EXECUTION_ENVIRONMENT}).current_working_directory + "\" + Output_file_name)
			l_retried := True
		end

	Output_file_name: STRING is
			-- Intermediate file for IDL generator.
		once
			Result := environment.destination_folder.twin
			Result.append ("idl\e2idl.output")
		end

end -- class WIZARD_IDL_GENERATOR
