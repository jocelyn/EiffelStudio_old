indexing
	description: "Objects that represent an EV_DIALOG.%
		%The original version of this class was generated by EiffelBuild."
	date: "$Date$"
	revision: "$Revision$"

class
	SHORTCUTS_DIALOG

inherit
	SHORTCUTS_DIALOG_IMP


feature {NONE} -- Initialization

	user_initialization is
			-- called by `initialize'.
			-- Any custom user initialization that
			-- could not be performed in `initialize',
			-- (due to regeneration of implementation class)
			-- can be added here.
		do
			keys_combo.disable_edit
			set_default_cancel_button (dummy_cancel_button)
			close_request_actions.extend (agent hide)
			add_button.select_actions.extend (agent add_accelerator)
			populate_widgets 
		end

feature {NONE} -- Implementation

	populate_widgets is
			-- Build widgets with data
		do
			populate_accelerator_list
			populate_keys_combo			
		end	

	populate_accelerator_list is
			-- Populate accelerator list
		local
			l_keys: HASH_TABLE [STRING, INTEGER]
			l_ev_key_constants: EV_KEY_CONSTANTS
			l_key,
			l_tag: STRING			
			l_list_row: EV_MULTI_COLUMN_LIST_ROW
		do
			accelerator_list.select_actions.force_extend (agent accelerator_list_item_selected)
			accelerator_list.set_column_titles (<<"Ctrl +", "XML text">>)
			accelerator_list.set_column_widths (<<50, 250>>)
			create l_ev_key_constants
			l_keys := accelerator_target.tag_accelerators
			from
				l_keys.start
			until
				l_keys.after
			loop
				l_tag := l_keys.item_for_iteration
				if l_tag /= Void and not l_tag.is_empty then					
					l_key := l_ev_key_constants.key_strings.item (l_keys.key_for_iteration)
					create l_list_row
					l_list_row.extend (l_key)
					l_list_row.extend (l_tag)					
					accelerator_list.extend (l_list_row)
				end
				l_keys.forth
			end
		end
		
	populate_keys_combo is
			-- Populate keys combo
		local
			l_keys: HASH_TABLE [STRING, INTEGER]
			l_ev_key_constants: EV_KEY_CONSTANTS
			l_key: STRING
			l_combo_item: EV_LIST_ITEM
		do
			create l_ev_key_constants
			l_keys := accelerator_target.tag_accelerators
			from
				l_keys.start
			until
				l_keys.after
			loop
				l_key := l_ev_key_constants.key_strings.item (l_keys.key_for_iteration)
				create l_combo_item.make_with_text (l_key)
				l_combo_item.set_data (l_keys.key_for_iteration)
				keys_combo.extend (l_combo_item)
				l_keys.forth
			end
		end		

	add_accelerator is
			-- Add accelerator to list
		local
			l_found: BOOLEAN
			l_row: EV_MULTI_COLUMN_LIST_ROW
			l_key: EV_KEY
			l_accelerator: EV_ACCELERATOR
			l_code: reference INTEGER
		do
			l_code ?= keys_combo.selected_item.data
			create l_key.make_with_code (l_code)
			from
				accelerator_list.start
			until
				accelerator_list.after
			loop
				if accelerator_list.item.first.is_equal (keys_combo.selected_item.text) then					
					accelerator_list.item.go_i_th (2)
					accelerator_list.item.replace (tag_text_field.text)
					create l_accelerator.make_with_key_combination (l_key, True, False, False)
					accelerator_target.add_tag_accelerator (l_accelerator, tag_text_field.text)
					l_found := True
				end
				accelerator_list.forth
			end
			
			if not l_found then
				create l_row
				l_row.extend (keys_combo.selected_item.text)
				l_row.extend (tag_text_field.text)
				accelerator_list.extend (l_row)
				create l_accelerator.make_with_key_combination (l_key, True, False, False)
				accelerator_target.add_tag_accelerator (l_accelerator, tag_text_field.text)
			end
		end		

	accelerator_target: DOCUMENT_EDITOR is
			-- Target for accelerators
		once
			Result := (create {SHARED_OBJECTS}).shared_document_editor
		end

feature {NONE} -- Events

	accelerator_list_item_selected is
			-- An item was selected in the accelerator list
		local
			l_list_row: EV_MULTI_COLUMN_LIST_ROW
			item_found: BOOLEAN
		do
			l_list_row := accelerator_list.selected_item	
			tag_text_field.set_text (l_list_row.i_th (2))
			if l_list_row /= Void then
				from
					keys_combo.start
				until
					keys_combo.after or item_found
				loop
					item_found := keys_combo.item.text.is_equal (l_list_row.first)
					if item_found then
						keys_combo.item.enable_select
					end
					keys_combo.forth
				end
			end
		end		

end -- class SHORTCUTS_DIALOG

