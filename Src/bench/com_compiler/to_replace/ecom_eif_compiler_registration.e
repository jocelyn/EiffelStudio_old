indexing
	description: "Objects of this class set the registry keys necessary for COM to access the component%
				   %and activate a new instance of the component whenever COM asks for if.%
				   %User may inherit from this class and redifine `main_window'."
	Note: "Automatically generated by the EiffelCOM Wizard."

class
	ECOM_EIF_COMPILER_REGISTRATION

inherit
	ARGUMENTS

	WEL_APPLICATION
		rename
			make as wel_make
		redefine
			default_show_command
		end

	WEL_SW_CONSTANTS
		export
			{NONE} all;
		end

creation
	make

feature {NONE}  -- Initialization

	make is
			-- Initialize server.
		local
			local_string: STRING
		do
			default_show_cmd := Sw_shownormal
			if argument_count > 0 then
				local_string :=argument (1)
				local_string.to_lower
			end
			if local_string /= Void and (local_string.is_equal ("-regserver") or local_string.is_equal ("/regserver")) then
				register_server
			elseif local_string /= Void and (local_string.is_equal ("-unregserver") or local_string.is_equal ("/unregserver")) then
				unregister_server
			else
				if local_string /= Void and (local_string.is_equal ("-embedding") or local_string.is_equal ("/embedding")) then
					default_show_cmd := Sw_hide
				end
				initialize_com
				wel_make
				cleanup_com
			end
		end

feature -- Access

	main_window: WEL_FRAME_WINDOW is
			-- Server main window
		once
			create Result.make_top ("Eif_compiler")
		end

	default_show_command: INTEGER is
			-- Default command used to show `main_window'.
		once
			Result := default_show_cmd
		end

feature {NONE}  -- Implementation

	Gacutil: STRING is "gacutil.exe"
			-- Gacutil utility
	
	Gacutil_arguments: STRING is " -silent -nologo -if "
			-- Gacutil arguments
			
	Regasm: STRING is "RegAsm.exe"
			-- Regasm utility
	
	Regasm_arguments: STRING is " -silent -nologo "
			-- Regasm arguments
	
	Eif_generator: STRING is "EiffelCompiler.dll"
			-- Eiffel managed IL generator
	
	Ise_runtime: STRING is "ise_runtime.dll"
			-- ISE managed runtime dll

	Sdk_directory_key: STRING is "SDKPath"
			-- SDK Path registry key name

	default_show_cmd: INTEGER
			-- Default command used to show `main_window'.

	initialize_com is
			-- Initialize COM 
		do
			ccom_initialize_com
		end

	cleanup_com is
			-- Clean up COM 
		do
			ccom_cleanup_com
		end

	register_server is
			-- Register Server
		local
			sdk_directory, gacutil_command, regasm_command, a_string: STRING
		do
			sdk_directory := (create {EXECUTION_ENVIRONMENT}).get (Sdk_directory_key)
			gacutil_command := sdk_directory + "\Bin\" + Gacutil
			regasm_command := c_net_directory + Regasm
			if (create {RAW_FILE}.make (gacutil_command)).exists then
				a_string := "%"" + gacutil_command + "%"" + Gacutil_arguments + Ise_runtime;
				(create {EXECUTION_ENVIRONMENT}).system (a_string)
				a_string := "%"" + gacutil_command + "%"" + Gacutil_arguments + Eif_generator;
				(create {EXECUTION_ENVIRONMENT}).system (a_string)
			end
			if (create {RAW_FILE}.make (regasm_command)).exists then
				a_string := "%"" + regasm_command + "%"" + Regasm_arguments + Eif_generator;
				(create {EXECUTION_ENVIRONMENT}).system (a_string)
			end
			ccom_register_server
		end

	unregister_server is
			-- Unregister Server
		do
			ccom_unregister_server
		end

feature {NONE}  -- Externals

	ccom_initialize_com is
			-- Initialize COM.
		external
			"C++[macro %"server_registration.h%"]"
		end

	ccom_cleanup_com is
			-- Clean up COM.
		external
			"C++[macro %"server_registration.h%"]"
		end

	ccom_register_server is
			-- Register server.
		external
			"C++[macro %"server_registration.h%"]"
		end

	ccom_unregister_server is
			-- Unregister server.
		external
			"C++[macro %"server_registration.h%"]"
		end

	c_net_directory: STRING is
			-- Path to .NET directory.
		external
			"C[macro %"c_net_directory.h%"](): EIF_REFERENCE"
		alias
			"c_net_directory()"
		end

end -- ECOM_EIF_COMPILER_REGISTRATION

