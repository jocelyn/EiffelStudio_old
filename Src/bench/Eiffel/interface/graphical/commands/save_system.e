
class SAVE_SYSTEM

inherit
	
	SHARED_WORKBENCH;	
	PROJECT_CONTEXT;
	SAVE_FILE
		redefine
			work
		end;

creation

	make
	
feature {NONE}

	work (argument: ANY) is
			-- Save a file with the chosen name.
		local   
			new_file: PLAIN_TEXT_FILE;
			to_write: STRING;
			file_name: STRING;
			aok: BOOLEAN;
			temp: STRING;
			show_text: SHOW_TEXT
		do
			if text_window.file_name /= Void then
				file_name := text_window.file_name;
			else
				!!file_name.make (50);
				file_name.append (Project_directory.name);
				if file_name.item (file_name.count) /= Directory_separator then
					file_name.extend (Directory_separator);
				end;
				file_name.append ("Ace");
			end;
			!!new_file.make (file_name);

			aok := True;
			if
				(new_file.exists) and then (not new_file.is_plain)
			then
				aok := False;
				!! temp.make (0);
				temp.append (new_file.name);
				temp.append ("%Nis not a plain file");
				warner.set_window (text_window);
				warner.gotcha_call (temp);
			elseif
				new_file.exists and then (not new_file.is_writable)
			then
				aok := False;
				!! temp.make (0);
				temp.append ("File: ");
				temp.append (new_file.name);
				temp.append (" is not writable.%NPlease check permissions");
				warner.set_window (text_window);
				warner.gotcha_call (temp);
			elseif
				(not new_file.exists) and then (not new_file.is_creatable)
			then
				aok := False;
				!! temp.make (0);
				temp.append ("File: ");
				temp.append (new_file.name);
				temp.append (" cannot be created.%NPlease check permissions");
				warner.set_window (text_window);
				warner.gotcha_call (temp);
			end;

			if aok then
				new_file.open_write;
				to_write := text_window.text; 
				new_file.putstring (to_write);
				if to_write.item (to_write.count) /= '%N' then 
					-- Add a carriage return like vi if there's none at the end 
					new_file.putchar ('%N')
				end; 
				new_file.close;
				show_text ?= text_window.last_format;
				if show_text /= Void then
					--| Only set the file name if it is an Ace file
					--| (and not the show_clusters file name).
					Lace.set_file_name (file_name);
				end;
				text_window.set_changed (false)
			end
		end;

	
end
