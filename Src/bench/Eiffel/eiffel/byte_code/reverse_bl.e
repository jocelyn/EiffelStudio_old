-- Enlarged byte code for reverse assignment

class REVERSE_BL 

inherit

	ASSIGN_BL
		rename
			target_propagated as register_propagated
		redefine
			analyze, generate_regular_assignment,
			generate_last_assignment, source_print_register
		end;
	
feature 

	analyze is
			-- Analyze reverse assignment
		local
			source_type: TYPE_I;
			target_type: TYPE_I;
			gen_type   : GEN_TYPE_I
		do
				-- Mark Result used only if not the last instruction (in which
				-- case we'll generate a direct return, hence Result won't be
				-- needed).
			if target.is_result then
				context.mark_result_used;
			end;
				-- The target is always expanded in-line for de-referencing.
				-- Ensure propagation in any generation mode (the propagation
				-- of No_register in workbench mode is prevented to force
				-- expression splitting).
			target.set_register (No_register);
			target.analyze;
			if target.is_predefined then
				register := target;
			else
				get_register;
			end;
			context.init_propagation;
			source_type := context.real_type (source.type);
			target_type := context.real_type (target.type);
				-- We won't attempt a propagation of the target if the
				-- target is a reference and the source is a basic type
				-- or an expanded. Note that the target cannot be an expanded
				-- nor a basic type so the only other possibility is NONE.
			if not target_type.is_none and
				(source_type.is_basic or source_type.is_expanded)
			then
				source.propagate (No_register);
				register_for_metamorphosis := true;
			else
				source.propagate (register);
				register_propagated := context.propagated;
			end;
			gen_type ?= target_type;

				-- Current needed in the access if target is not predefined
				-- or if target is generic.

			if (not target.is_predefined and target.c_type.is_pointer)
						or else (gen_type /= Void) then
				context.mark_current_used;
			end;
			source.analyze;
			source.free_register;
			if register.is_temporary and not register_propagated then
				register.free_register;
			end;
			simple_op_assignment := No_simple_op;
		end;

	source_print_register is
			-- Print register holding the source
		do
			if not (register_propagated and source.is_simple_expr)
				and register_for_metamorphosis
			then
				print_register;
			else
				source.print_register;
			end;
		end;
	
	generate_last_assignment (how: INTEGER) is
			-- Generate last assignment in Result
		do
			generate_regular_assignment (how);
		end;

	generate_regular_assignment (how: INTEGER) is
			-- Generate assignment
		local
			cl_type_i: CL_TYPE_I;
			gen_type : GEN_TYPE_I
			f: INDENT_FILE
		do
			f := generated_file
			generate_line_info;
				-- First pre-compute the source and put it in the register
				-- so that we can use it inside macro (where the argument is
				-- evaluated more than once).
			source.generate;
			generate_special (how);

			cl_type_i ?= real_type (target.type);   -- Cannot fail
			gen_type  ?= cl_type_i;

			if gen_type /= Void then
				-- We need a new C block with new locals.
				generate_block_open;
				generate_gen_type_conversion (gen_type);
			end;

				-- If register was propagated, then the assignment was already
				-- generated by the `generate' call unless the source is not
				-- a simple expression.
			if not (register_propagated and source.is_simple_expr)
				and not register_for_metamorphosis
			then
				print_register;
				f.putstring (" = ");
				source.print_register;
				f.putchar (';');
				f.new_line;
			end;
				-- If last is in result, generate a return instruction.
			if last_in_result then
				context.byte_code.finish_compound;
				if last_instruction then
					f.new_line;
				end;
				f.putstring ("return ");
			else
					-- Perform aging tests when necessary
				if how /= None_assignment and not target.is_predefined then
				   source_print_register;
					f.putstring (" = RTRM(");
					source_print_register;
					f.putstring (gc_comma);
					context.Current_register.print_register_by_name;
					f.putchar (')');
					f.putchar (';');
					f.new_line;
				end;
				target.print_register;
				f.putstring (" = ");
			end;
			if how /= None_assignment then
				f.putstring ("RTRV(");
-- FIXME!!!! use something similar to CREATE_INFO in CREATION_BL
					-- It so happens that reverse assignments are only allowed
					-- on reference types.

				if gen_type = Void then
					if context.final_mode then
						f.putint (cl_type_i.type_id - 1);
					else
						f.putstring ("RTUD(");
						cl_type_i.associated_class_type.id.generated_id (f)
						f.putchar (')');
					end;
				else
					f.putstring ("typres");
				end;

				f.putstring (gc_comma);
				source_print_register;
				f.putchar (')');
			else
				f.putstring ("(char *) 0");
			end;
			f.putchar (';');
			f.new_line;

			if gen_type /= Void then
				-- We need to close the C block.
				generate_block_close;
			end;
		end;

end
