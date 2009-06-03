-- This file has been generated by EWG. Do not edit. Changes will be lost!

class CONTROL_USER_PANE_TRACKING_PROC_PTR_DISPATCHER

inherit

	ANY

	EWG_CARBON_CALLBACK_C_GLUE_CODE_FUNCTIONS_EXTERNAL
		export {NONE} all end

create

	make

feature {NONE}

	make (a_callback: CONTROL_USER_PANE_TRACKING_PROC_PTR_CALLBACK) is
		require
			a_callback_not_void: a_callback /= Void
		do
			callback := a_callback
			set_control_user_pane_tracking_proc_ptr_entry_external (Current, $on_callback)
		end

feature {ANY}

	callback: CONTROL_USER_PANE_TRACKING_PROC_PTR_CALLBACK

	c_dispatcher: POINTER is
		do
			Result := get_control_user_pane_tracking_proc_ptr_stub_external
		end

feature {NONE} -- Implementation

	frozen on_callback (a_control: POINTER; a_startpt: POINTER; a_actionproc: POINTER): INTEGER is 
		do
			Result := callback.on_callback (a_control, a_startpt, a_actionproc) 
		end

invariant

	 callback_not_void: callback /= Void

end
