note
	description	: "[
						cURL simple example Eiffel version. 
						For original C version, please see:
						http://curl.haxx.se/lxr/source/docs/examples/simple.c
						
						This demo will get html source from http://www.google.com, then print the html codes to command line.
						This is the simplest way to download a URL source.
					]"
	status: "See notice at end of class."
	legal: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION

create
	make

feature -- Initialization

	make
			-- Run application.
		local
			l_result: INTEGER
		do
			io.put_string ("Eiffel cURL simple example.")
			io.put_new_line

			if curl_easy.is_dynamic_library_exists then
				curl_handle := curl_easy.init

					-- First we specify which URL we would like to download.
				curl_easy.setopt_string (curl_handle, {CURL_OPT_CONSTANTS}.curlopt_url, "www.google.com")

					-- After `perform' has been called, the remote HTML source is printed in the console.
				l_result := curl_easy.perform (curl_handle)

					-- Always cleanup
				curl_easy.cleanup (curl_handle)
			else
				io.error.put_string ("cURL library not found!")
				io.error.put_new_line
			end
		end

feature {NONE} -- Implementation

	curl_easy: CURL_EASY_EXTERNALS
			-- cURL easy externals
		once
			create Result
		end

	curl_handle: POINTER;
			-- cURL handle

note
	copyright: "Copyright (c) 1984-2006, Eiffel Software and others"
	license:   "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			356 Storke Road, Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"

end -- class APPLICATION
