indexing
	description: "MDI child window to insert into a MDI client window."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	WEL_MDI_CHILD_WINDOW

inherit
	WEL_FRAME_WINDOW
		rename
			make_child as make
		redefine
			class_name,
			class_background,
			internal_window_make,
			call_default_window_procedure,
			destroy,
			parent,
			move_and_resize,
			move,
			move_absolute,
			make,
			set_parent
		end

create
	make

feature {NONE} -- Initialization

	make (a_parent: WEL_MDI_FRAME_WINDOW; a_name: STRING) is
			-- Make window as child of `a_parent' and `a_name' as title.
		do
			register_class
			internal_window_make (a_parent, a_name,
				default_style,
				default_x, default_y,
				default_width, default_height,
				default_id, default_pointer)
		end

feature -- Access

	parent: WEL_MDI_FRAME_WINDOW
			-- Parent window

feature -- Basic operations

	move_and_resize (a_x, a_y, a_width, a_height: INTEGER;
			repaint: BOOLEAN) is
			-- Move the window to `a_x', `a_y' position and
			-- resize it with `a_width', `a_height'.
		do
			cwin_move_window (item, a_x, a_y,
				a_width, a_height, repaint)
		end

	move (a_x, a_y: INTEGER) is
			-- Move the window to `a_x', `a_y' position.
		do
			cwin_set_window_pos (item, default_pointer,
				a_x, a_y, 0, 0,
				Swp_nosize + Swp_nozorder + Swp_noactivate)
		end

	move_absolute (a_x, a_y: INTEGER) is
			-- Move the window to `a_x', `a_y' absolute position.
		local
			point: WEL_POINT
		do
			create point.make (a_x, a_y)
			point.screen_to_client (parent)
			move (point.x, point.y)
		end

	destroy is
			-- Destroy the window.
		do
			parent.client_window.destroy_window (Current)
		end

feature -- Element change

	set_parent (a_parent: WEL_WINDOW) is
			-- Change parent of current window if possible.
		local
			l_parent: like parent
		do
			l_parent ?= a_parent
			if l_parent /= Void then
				parent := l_parent
				cwin_set_parent (item, l_parent.item)
			else
				parent := Void
				cwin_set_parent (item, default_pointer)
			end
		end
		
feature {NONE} -- Implementation

	internal_window_make (a_parent: WEL_MDI_FRAME_WINDOW; a_name: STRING;
			a_style, a_x, a_y, a_w, a_h, an_id: INTEGER;
			data: POINTER) is
			-- Create the window
		local
			mdi_cs: WEL_MDI_CREATE_STRUCT
		do
			parent := a_parent
			create mdi_cs.make (class_name, a_name)
			mdi_cs.set_style (default_style)
			item := cwel_integer_to_pointer (
				cwin_send_message_result (a_parent.client_window.item,
				Wm_mdicreate, 0, cwel_pointer_to_integer (mdi_cs.item)))
			if item /= default_pointer then
				register_current_window
				set_default_window_procedure
			end
		end

	call_default_window_procedure (hwnd: POINTER; msg, wparam, lparam: INTEGER): INTEGER is
		do
			Result := cwin_def_mdi_child_proc (hwnd, msg,
				 wparam, lparam)
		end

	class_background: WEL_BRUSH is
			-- Standard window background color
		once
			create Result.make_by_sys_color (Color_window + 1)
		end

	class_name: STRING is
			-- Window class name to create
		once
			Result := "WELMDIChildWindowClass"
		end

feature {NONE} -- Externals

	cwin_def_mdi_child_proc (hwnd: POINTER; msg, wparam,
		lparam: INTEGER): INTEGER is
			-- SDK DefMDIChildProc
		external
			"C [macro <wel.h>] (HWND, UINT, WPARAM, %
				%LPARAM): EIF_INTEGER"
		alias
			"DefMDIChildProc"
		end

end -- class WEL_MDI_CHILD_WINDOW

--|----------------------------------------------------------------
--| Windows Eiffel Library: library of reusable components for ISE Eiffel.
--| Copyright (C) 1985-2004 Eiffel Software. All rights reserved.
--| Duplication and distribution prohibited.  May be used only with
--| ISE Eiffel, under terms of user license.
--| Contact Eiffel Software for any other use.
--|
--| Interactive Software Engineering Inc.
--| dba Eiffel Software
--| 356 Storke Road, Goleta, CA 93117 USA
--| Telephone 805-685-1006, Fax 805-685-6869
--| Contact us at: http://www.eiffel.com/general/email.html
--| Customer support: http://support.eiffel.com
--| For latest info on our award winning products, visit:
--|	http://www.eiffel.com
--|----------------------------------------------------------------

