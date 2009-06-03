-- This file has been generated by EWG. Do not edit. Changes will be lost!

class EV_QEL_STRUCT

inherit

	EWG_STRUCT

	EV_QEL_STRUCT_EXTERNAL
		export
			{NONE} all
		end

create

	make_new_unshared,
	make_new_shared,
	make_unshared,
	make_shared

feature {ANY} -- Access

	sizeof: INTEGER is
		do
			Result := sizeof_external
		end

feature {ANY} -- Member Access

	qlink_struct: QELEM_STRUCT is
			-- Access member `qLink'
		require
			exists: exists
		do
			create Result.make_shared (get_qlink_external (item))
		ensure
			result_not_void: Result /= Void
			result_has_correct_item: Result.item = qlink
		end

	set_qlink_struct (a_value: QELEM_STRUCT) is
			-- Set member `qLink'
		require
			a_value_not_void: a_value /= Void
			exists: exists
		do
			set_qlink_external (item, a_value.item)
		ensure
			a_value_set: a_value.item = qlink
		end

	qlink: POINTER is
			-- Access member `qLink'
		require
			exists: exists
		do
			Result := get_qlink_external (item)
		ensure
			result_correct: Result = get_qlink_external (item)
		end

	set_qlink (a_value: POINTER) is
			-- Set member `qLink'
		require
			exists: exists
		do
			set_qlink_external (item, a_value)
		ensure
			a_value_set: a_value = qlink
		end

	qtype: INTEGER is
			-- Access member `qType'
		require
			exists: exists
		do
			Result := get_qtype_external (item)
		ensure
			result_correct: Result = get_qtype_external (item)
		end

	set_qtype (a_value: INTEGER) is
			-- Set member `qType'
		require
			exists: exists
		do
			set_qtype_external (item, a_value)
		ensure
			a_value_set: a_value = qtype
		end

	evtqwhat: INTEGER is
			-- Access member `evtQWhat'
		require
			exists: exists
		do
			Result := get_evtqwhat_external (item)
		ensure
			result_correct: Result = get_evtqwhat_external (item)
		end

	set_evtqwhat (a_value: INTEGER) is
			-- Set member `evtQWhat'
		require
			exists: exists
		do
			set_evtqwhat_external (item, a_value)
		ensure
			a_value_set: a_value = evtqwhat
		end

	evtqmessage: INTEGER is
			-- Access member `evtQMessage'
		require
			exists: exists
		do
			Result := get_evtqmessage_external (item)
		ensure
			result_correct: Result = get_evtqmessage_external (item)
		end

	set_evtqmessage (a_value: INTEGER) is
			-- Set member `evtQMessage'
		require
			exists: exists
		do
			set_evtqmessage_external (item, a_value)
		ensure
			a_value_set: a_value = evtqmessage
		end

	evtqwhen: INTEGER is
			-- Access member `evtQWhen'
		require
			exists: exists
		do
			Result := get_evtqwhen_external (item)
		ensure
			result_correct: Result = get_evtqwhen_external (item)
		end

	set_evtqwhen (a_value: INTEGER) is
			-- Set member `evtQWhen'
		require
			exists: exists
		do
			set_evtqwhen_external (item, a_value)
		ensure
			a_value_set: a_value = evtqwhen
		end

	evtqwhere: POINTER is
			-- Access member `evtQWhere'
		require
			exists: exists
		do
			Result := get_evtqwhere_external (item)
		ensure
			result_correct: Result = get_evtqwhere_external (item)
		end

	set_evtqwhere (a_value: POINTER) is
			-- Set member `evtQWhere'
		require
			exists: exists
		do
			set_evtqwhere_external (item, a_value)
		end

	evtqmodifiers: INTEGER is
			-- Access member `evtQModifiers'
		require
			exists: exists
		do
			Result := get_evtqmodifiers_external (item)
		ensure
			result_correct: Result = get_evtqmodifiers_external (item)
		end

	set_evtqmodifiers (a_value: INTEGER) is
			-- Set member `evtQModifiers'
		require
			exists: exists
		do
			set_evtqmodifiers_external (item, a_value)
		ensure
			a_value_set: a_value = evtqmodifiers
		end

end
