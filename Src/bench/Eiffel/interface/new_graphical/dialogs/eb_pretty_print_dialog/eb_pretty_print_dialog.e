indexing
	description: "Objects that represent an EV_DIALOG.%
		%The original version of this class was generated by EiffelBuild."
	date: "$Date$"
	revision: "$Revision$"

class
	EB_PRETTY_PRINT_DIALOG

inherit
	EB_PRETTY_PRINT_DIALOG_IMP
		redefine
			default_create
		end

	EB_CONSTANTS
		undefine
			default_create
		end

	SHARED_APPLICATION_EXECUTION
		undefine
			default_create
		end

	EB_SHARED_PIXMAPS
		undefine
			default_create
		end
		
	EB_SHARED_WINDOW_MANAGER
		undefine
			default_create
		end

create
	default_create,
	make_with_window,
	make

feature {NONE} -- Initialization

	make (cmd: EB_PRETTY_PRINT_CMD) is
			-- Initialize `Current'.
		require
			cmd_not_void: cmd /= Void
		do
			parent := cmd

				--| FIXME JFIAT: remove link to EB_SET_SLICE_SIZE_CMD
				--| the slice limits should be specific to Pretty display settings
				--| not linked to other dialog
				--| we need to decide on this

				-- Create `slice_cmd'.				
--			create slice_cmd.make_for_pretty_print (Current)
			slice_min_ref := 0 									-- slice_cmd.slice_min
			slice_max_ref := application.displayed_string_size 	-- slice_cmd.slice_max
			default_create
		end

	make_with_window (a_window: EV_DIALOG) is
			-- Create `Current' in `a_window'.
		require
			window_not_void: a_window /= Void
			window_empty: a_window.is_empty
			no_menu_bar: a_window.menu_bar = Void
		do
			window := a_window
			initialize
		ensure
			window_set: window = a_window
			window_not_void: window /= Void
		end

	default_create is
			 -- Create `Current'.
		do
			create window
			initialize
		ensure then
			window_not_void: window /= Void
		end

feature {NONE} -- Initialization

	user_initialization is
			-- called by `initialize'.
			-- Any custom user initialization that
			-- could not be performed in `initialize',
			-- (due to regeneration of implementation class)
			-- can be added here.
		do
			set_slice_button.set_pixmap (icon_green_tick)
			auto_set_slice_button.set_pixmap (icon_auto_slice_limits_color @ 1)
			word_wrap_button.set_pixmap (icon_word_wrap_color @ 1)
			editor.set_background_color (create {EV_COLOR}.make_with_8_bit_rgb (255, 255, 255))
			editor.disable_word_wrapping
			
			editor.drop_actions.extend (agent on_stone_dropped)
			editor.drop_actions.set_veto_pebble_function (agent is_stone_valid)			
			
			lower_slice_field.set_text (slice_min.out)
			upper_slice_field.set_text (slice_max.out)			
		end

feature -- Slice limits

	set_limits (lower, upper: INTEGER) is
			-- Change limits to `lower, upper' values.
		local
			nmin, nmax: INTEGER
		do
			nmin := lower
			nmax := upper

			nmin := nmin.max (0)
			nmax := nmax.max (nmin)

			slice_min_ref.set_item (nmin)
			slice_max_ref.set_item (nmax)
		end

	slice_min: INTEGER is
		do
			Result := slice_min_ref.item
		end
		
	slice_max: INTEGER is
		do
			Result := slice_max_ref.item
		end		

	slice_min_ref: INTEGER_REF
	slice_max_ref: INTEGER_REF
	
feature -- Status Setting

	is_stone_valid (st: OBJECT_STONE): BOOLEAN is
			-- Is `st' valid stone for Current?
		do
			Result := st /= Void and then parent.accepts_stone (st)
		end
		
	current_object: OBJECT_STONE
			-- Object `Current' is displaying.
			
	is_destroyed: BOOLEAN is
			-- Is `dialog' destroyed?
		do
			Result := window = Void
		end

	has_object: BOOLEAN is
			-- Has an object been assigned to current?
		do
			Result := current_object /= Void
		end
		
	current_dump_value: DUMP_VALUE
			-- DUMP_VALUE `Current' is displaying.		
		
feature -- Status setting

	raise is
			-- Display `dialog' and put it in front.
		do
			window.show_relative_to_window (parent.associated_window)
		end

	set_stone (st: OBJECT_STONE) is
			-- Give a new object to `Current' and refresh the display.
		require
			stone_valid: is_stone_valid (st)
		local
			l_tree_item: EV_TREE_ITEM
			l_dv: ABSTRACT_DEBUG_VALUE
		do
			current_dump_value := Void
			current_object := st
			
			l_tree_item := st.tree_item
			if l_tree_item /= Void then
				l_dv ?= l_tree_item.data
				if l_dv /= Void then
					if Application.is_dotnet then
							--| FIXME: JFIAT : find a nicer way to manage kept objects						
						Application.imp_dotnet.keep_object (l_dv)
					end
					current_dump_value := l_dv.dump_value
				end
			end
			
			parent.tool.debugger_manager.kept_objects.extend (st.object_address)
			retrieve_dump_value
			
--			slice_cmd.enable_sensitive
--			auto_set_slice_button.disable_sensitive
--			slice_button.enable_sensitive
			refresh
		end
		
	retrieve_dump_value is
			-- Retrieve `current_dump_value' from `current_object'.
		require
			has_current_object: has_object
		local
			l_dv: ABSTRACT_DEBUG_VALUE			
		do
			if current_dump_value = Void then
				if application.is_dotnet then
					l_dv := Application.imp_dotnet.kept_object_item (current_object.object_address)
					if l_dv /= Void then
						current_dump_value := l_dv.dump_value
					end					
				else
					create current_dump_value.make_object (current_object.object_address, current_object.dynamic_class)				
				end
			end
		end

	refresh is
			-- Recompute the displayed text.
		local
			l_dlg: EV_WARNING_DIALOG
			l_str_length: STRING
		do
			if Application.status.is_stopped then
				if has_object then
					retrieve_dump_value
					if current_dump_value /= Void then
						editor.set_text (current_dump_value.string_representation (slice_min, slice_max))
						l_str_length := "Complete length = " + current_dump_value.last_string_representation_length.out
						window.set_title ("Expanded display : " + l_str_length)
						upper_slice_field.set_tooltip (l_str_length)						
					else
						editor.remove_text
						create l_dlg.make_with_text ("Sorry a problem occured, %Nwe are not able to show you the value ...%N")
						l_dlg.show_modal_to_window (window)
					end
				else
					editor.remove_text
				end
			else
				editor.remove_text
			end
		end

	destroy is
			-- Destroy the actual dialog and forget about `Current'.
		require
			not is_destroyed
		do
			window.destroy
			window := Void
			parent.remove_dialog (Current)
		ensure
			destroyed: is_destroyed
		end

	--| FIXME XR: Maybe we should add advanced positioning methods (set_position, set_size,...).
	--| FIXME XR: Anyway they wouldn't be used at the moment.

feature {NONE} -- Implementation

	text: STRUCTURED_TEXT
			-- Text that is displayed in the editor.

--	slice_cmd: EB_SET_SLICE_SIZE_CMD
--			-- Command that is supposed to resize special objects.

	parent: EB_PRETTY_PRINT_CMD
			-- Command that created `Current' and knows about it.

feature {NONE} -- Event handling

	return_pressed_in_lower_slice_field is
			-- Called by `return_actions' of `lower_slice_field'.
		do
			upper_slice_field.set_focus
		end
		
	return_pressed_in_upper_slice_field is
			-- Called by `return_actions' of `lower_slice_field'.
		do
			set_slice_selected
		end
	
	set_slice_selected is
			-- Called by `select_actions' of `set_slice_button'.
		local
			lower, upper: INTEGER
			valid: BOOLEAN
			error_dialog: EV_WARNING_DIALOG
		do
			valid := True
			if lower_slice_field.text.is_integer then
				lower := lower_slice_field.text.to_integer
			else				
				create error_dialog.make_with_text (warning_messages.w_not_an_integer)
				error_dialog.show_modal_to_window (window_manager.last_focused_development_window.window)
				valid := False			
				if lower_slice_field.text_length /= 0 then
					lower_slice_field.select_all
				end
				lower_slice_field.set_focus
			end
			if upper_slice_field.text.is_integer then
				upper := upper_slice_field.text.to_integer
			elseif valid then
				create error_dialog.make_with_text (warning_messages.w_not_an_integer)
				error_dialog.show_modal_to_window (window_manager.last_focused_development_window.window)
				valid := False
				if upper_slice_field.text_length /= 0 then
					upper_slice_field.select_all	
				end
				upper_slice_field.set_focus
			end
			if valid then
				set_limits (lower, upper)
--				if upper > 0 then
--					application.set_displayed_string_size (upper)
--						--| FIXME JFIAT: 2004-01-30 : do we really want this to be fix ?
--						--| a prob is the size for the pretty print dialog and
--						--| the size of the displayed string in object browser are linked ...			
--				end
				refresh
			end
		end
	
	auto_slice_selected is
			-- Called by `select_actions' of `auto_set_slice_button'.
		do
			lower_slice_field.set_text ("0")
			upper_slice_field.set_text ((-1).out) --(current_dump_value.last_string_representation_length - 1).out)
			slice_min_ref.set_item (0)
			slice_max_ref.set_item (-1)
			refresh
			
			set_limits (0, current_dump_value.last_string_representation_length - 1)			
			upper_slice_field.set_text (slice_max.out)
		end
	
	word_wrap_toggled is
			-- Called by `select_actions' of `word_wrap_button'.
		do
			window.lock_update
			if word_wrap_button.is_selected then
				editor.enable_word_wrapping
			else
				editor.disable_word_wrapping
			end
			window.unlock_update
		end

	on_stone_dropped (st: OBJECT_STONE) is
			-- A stone was dropped in the editor. Handle it.
		do
			set_stone (st)
		end
		
	close_action is
			-- Close dialog
		do
			window.destroy
			window := Void
			parent.remove_dialog (Current)
		ensure then
			destroyed: is_destroyed
		end

invariant
	has_parent_command: parent /= Void
	valid_stone: has_object implies is_stone_valid (current_object)

end -- class EB_PRETTY_PRINT_DIALOG

