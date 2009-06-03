note
	description: "Wrapper for NSEvent"
	author: "Daniel Furrer"
	date: "$Date$"
	revision: "$Revision$"

class
	NS_EVENT_API

feature -- Getting General Event Information


	frozen location_in_window (a_event: POINTER; res: POINTER)
		external
			"C inline use <Cocoa/Cocoa.h>"
		alias
			"NSPoint point = [(NSEvent*)$a_event locationInWindow]; memcpy($res, &point, sizeof(NSPoint));"
		end

	frozen type (a_event: POINTER): INTEGER
		external
			"C inline use <Cocoa/Cocoa.h>"
		alias
			"return [(NSEvent*)$a_event type];"
		end

end
