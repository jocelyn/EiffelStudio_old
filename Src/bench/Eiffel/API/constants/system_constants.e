class SYSTEM_CONSTANTS

feature {NONE}

	Casegen: STRING is "CASEGEN";

	Case_storage: STRING is "Storage";

	Class_suffix: STRING is "C";

	Continuation: CHARACTER is '\'

	Comp: STRING is "COMP"

	Copy_cmd: STRING is
		once
			Result := Platform_constants.Copy_cmd
		end;

	Default_Ace_file: STRING is
		local
			c: CHARACTER
		once
			c := Directory_separator;
			!!Result.make (0);
			Result.extend (c);
			Result.append ("bench");
			Result.extend (c);
			Result.append ("help");
			Result.extend (c);
			Result.append ("defaults");
			Result.extend (c);
			Result.append ("default.ace");
		end;

	Default_precompiled_location: STRING is
		local
			c: CHARACTER
		once
			c := Directory_separator;
			!!Result.make (0);
			Result.append ("$EIFFEL3");
			Result.extend (c);
			Result.append ("precomp");
			Result.extend (c);
			Result.append ("spec");
			Result.extend (c);
			Result.append ("$PLATFORM");
			Result.extend (c);
			Result.append ("base");
		end;

	Descriptor_file_suffix: CHARACTER is 'd'

	Descriptor_suffix: STRING is "D"

	Directory_separator: CHARACTER is
		once
			Result := Operating_environment.Directory_separator
		end

	Dot: CHARACTER is '.'

	Dot_c: STRING is ".c"

	Dot_e: STRING is
		once
			Result := Platform_constants.Dot_e
		end;

	Dot_h: STRING is ".h"

	Dot_o: STRING is
		once
			Result := Platform_constants.Dot_o
		end;

	Dot_workbench: STRING is "project.eif"

	Dot_x: STRING is ".x"

	Driver: STRING is
		once
			Result := Platform_constants.Driver
		end;

	Eattr: STRING is "eattr"

	Ecall: STRING is "ecall"

	Econform: STRING is "econform"

	Edispatch: STRING is "edisptch"

	Efrozen: STRING is "efrozen"

	Ehisto: STRING is "ehisto"

	Eiffelgen: STRING is "EIFGEN"

	Eiffel_suffix: CHARACTER is
		once
			Result := Platform_constants.Eiffel_suffix
		end;

	Einit: STRING is "einit"

	Emain: STRING is "emain"

	Eoption: STRING is "eoption"

	Epattern: STRING is "epattern"

	Eplug: STRING is "eplug"

	Eref: STRING is "eref"

	Erout: STRING is "erout"

	Esize: STRING is "esize"

	Eskelet: STRING is "eskelet"

	Evisib: STRING is "evisib"

	Executable_suffix: STRING is
		once
			Result := Platform_constants.Executable_suffix
		end;

	F_code: STRING is "F_code"

	Finish_freezing_script: STRING is "finish_freezing"

	Feature_table_file_suffix: CHARACTER is 'f'

	Feature_table_suffix: STRING is "F"

	Makefile_SH: STRING is "Makefile.SH"

	Prelink_script: STRING is "prelink"

	Preobj: STRING is
		once
			Result := Platform_constants.Preobj
		end;

	Removed_log_file_name: STRING is "REMOVED";

	System_object_prefix: STRING is "E";

	Translation_log_file_name: STRING is "TRANSLAT";

	Updt: STRING is "melted.eif"

	Version_number: STRING is "3.2.7"

	W_code: STRING is "W_code"

feature {NONE}

	Max_non_encrypted: INTEGER is 3
		-- Maximum number of non encrypted characters during
		-- code generation
		--| The class FEATURE_I will be generated in the file 'feature<n>.c'

feature {NONE}

	Platform_constants: PLATFORM_CONSTANTS is
		once
			!!Result
		end;

end

