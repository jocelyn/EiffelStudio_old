indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION_STATUS_DOTNET

inherit
	APPLICATION_STATUS
		redefine
			display_status,
			current_stack_element,
			where
		end
		
	EIFNET_DEBUGGER_INFO_ACCESSOR

create {APPLICATION_STATUS_EXPORTER}

	do_nothing
	
feature {APPLICATION_STATUS_EXPORTER} -- Initialization

	set_top_level is -- (n: STRING; obj: STRING; ot, dt, offs, reas: INTEGER) is
			-- Set the various attributes identifying current 
			-- position in source code.
		local
--			stack_num: INTEGER
--			cont_request: EWB_REQUEST
--			l_cse: CALL_STACK_ELEMENT_DOTNET

			l_curr_mod_name: STRING
			l_curr_class_tok, l_curr_feature_tok: INTEGER
			l_curr_il_offset: INTEGER
			l_dyn_class_type: CLASS_TYPE
			l_feature_i: FEATURE_I
			
			l_eiffel_break_index: INTEGER
			l_current_stack_info: EIFNET_DEBUGGER_STACK_INFO
		do
--			Eifnet_debugger_info.reset_current_callstack
			Eifnet_debugger_info.init_current_callstack

			l_current_stack_info := Eifnet_debugger_info.current_stack_info
			
			l_curr_mod_name := l_current_stack_info.current_module_name
			l_curr_class_tok := l_current_stack_info.current_class_token
			l_curr_feature_tok := l_current_stack_info.current_feature_token
			l_dyn_class_type := Il_debug_info_recorder.class_type_for_module_class_token (l_curr_mod_name, l_curr_class_tok)
			l_feature_i := Il_debug_info_recorder.feature_i_by_module_class_token (l_curr_mod_name, l_curr_class_tok, l_curr_feature_tok)	

			if l_feature_i = Void then
				if l_curr_feature_tok = Il_debug_info_recorder.entry_point_token then
					l_feature_i := Il_debug_info_recorder.entry_point_feature_i
				end
			end

			object_address := l_current_stack_info.current_stack_address					

			if l_dyn_class_type /= Void then
				dynamic_class := l_dyn_class_type.associated_class				
			end
			
			if l_feature_i /= Void then
				e_feature := l_feature_i.e_feature
				body_index := e_feature.body_index
				origin_class := l_feature_i.written_class

				l_curr_il_offset := l_current_stack_info.current_il_offset			
				break_index := Il_debug_info_recorder.feature_eiffel_breakable_line_for_il_offset (l_feature_i, l_curr_il_offset)
			end
			
----			if where = Void then
--				create_where_with (1)			
----			end
--			l_cse := current_stack_element_dotnet
--			
--			object_address := l_cse.object_address
----			reason := reas
--
--				-- Compute class type.
--			dynamic_class := l_cse.dynamic_class
--
--				-- Compute origin class type
--			origin_class := l_cse.origin_class
--			
--				-- Compute feature (E_FEATURE)
--				--|Note: the applicaiton sends us the original name.
--			e_feature := l_cse.routine
--			body_index := e_feature.body_index
--
--				-- Compute break position.
--			break_index := l_cse.break_index
--	
--				-- create the call stack
----			create where.dummy_make
--
----			stack_num := Application.current_execution_stack_number
----			if stack_num > where.count then
----				stack_num := where.count
----			end
----			Application.set_current_execution_stack(stack_num)
--

		ensure
			valid_break_index: break_index > 0
			valid_efeature: e_feature /= Void
		end
	
feature -- Values

	is_evaluating: BOOLEAN
			-- Is the debugged application evaluating expression ?	

feature -- settings

	set_is_evaluating (b: BOOLEAN) is
			-- set is_evaluating to `b'
		do
			is_evaluating := b
		end
		
feature -- Output
	
	display_status (st: STRUCTURED_TEXT) is
			-- 
		do
			check
				il_generation: Eiffel_system.System.il_generation
			end

			if not is_stopped then
				st.add_string ("System is running")
				st.add_new_line
			end
--			st.add_string ("Last debug callback ["+Eifnet_debugger_info.last_managed_callback.out+"] = " + Eifnet_debugger_info.last_managed_callback_name)
			st.add_new_line
		end

feature -- Class stack creation

	create_where_with (a_stack_max_depth: INTEGER) is
		do
			create where.make (a_stack_max_depth)
		end

feature -- Values

	where: EIFFEL_CALL_STACK_DOTNET
			-- Eiffel call stack

	current_stack_element: CALL_STACK_ELEMENT is
			-- Current call stack element being displayed
		do
			Result := where.i_th (Application.current_execution_stack_number)
		end

	current_stack_element_dotnet: CALL_STACK_ELEMENT_DOTNET is
			-- Current call stack element being displayed
		do
			Result ?= where.i_th (Application.current_execution_stack_number)
		end
		
feature -- Reason for stopping

	set_reason (val: like reason) is
			-- 
		do
			reason := val
		ensure
			valid_reason
		end
		
	set_reason_as_break is
		do
			set_reason (feature {IPC_SHARED}.Pg_break)
		end

	set_reason_as_interrupt is
		do
			set_reason (feature {IPC_SHARED}.Pg_interrupt)
		end		
		
	set_reason_as_raise is
		do
			set_reason (feature {IPC_SHARED}.Pg_raise)
		end		

	set_reason_as_viol is
		do
			set_reason (feature {IPC_SHARED}.Pg_viol)
		end		
		
	set_reason_as_new_breakpoint is
		do
			set_reason (feature {IPC_SHARED}.Pg_new_breakpoint)
		end	
		
	set_reason_as_step is
		do
			set_reason (feature {IPC_SHARED}.Pg_step)
		end		

end -- class APPLICATION_STATUS_DOTNET
