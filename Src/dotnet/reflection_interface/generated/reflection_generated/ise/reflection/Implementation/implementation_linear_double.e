indexing
	Generator: "Eiffel Emitter 3.1rc1"
	external_name: "Implementation.LINEAR_DOUBLE"

deferred external class
	IMPLEMENTATION_LINEAR_DOUBLE

inherit
	CONTAINER_DOUBLE
	LINEAR_DOUBLE
	SYSTEM_OBJECT
		redefine
			finalize,
			get_hash_code,
			equals,
			to_string
		end
	TRAVERSABLE_DOUBLE

feature -- Access

	frozen ec_illegal_36_ec_illegal_36_object_comparison: BOOLEAN is
		external
			"IL field signature :System.Boolean use Implementation.LINEAR_DOUBLE"
		alias
			"$$object_comparison"
		end

feature -- Basic Operations

	get_hash_code: INTEGER is
		external
			"IL signature (): System.Int32 use Implementation.LINEAR_DOUBLE"
		alias
			"GetHashCode"
		end

	deep_clone (other: ANY): ANY is
		external
			"IL signature (ANY): ANY use Implementation.LINEAR_DOUBLE"
		alias
			"deep_clone"
		end

	search (v: DOUBLE) is
		external
			"IL signature (System.Double): System.Void use Implementation.LINEAR_DOUBLE"
		alias
			"search"
		end

	a_set_object_comparison (object_comparison2: BOOLEAN) is
		external
			"IL signature (System.Boolean): System.Void use Implementation.LINEAR_DOUBLE"
		alias
			"_set_object_comparison"
		end

	frozen ec_illegal_36_ec_illegal_36_do_if (current_: LINEAR_DOUBLE; action: PROCEDURE_ANY_ANY; test: FUNCTION_ANY_ANY_BOOLEAN) is
		external
			"IL static signature (LINEAR_DOUBLE, PROCEDURE_ANY_ANY, FUNCTION_ANY_ANY_BOOLEAN): System.Void use Implementation.LINEAR_DOUBLE"
		alias
			"$$do_if"
		end

	compare_references is
		external
			"IL signature (): System.Void use Implementation.LINEAR_DOUBLE"
		alias
			"compare_references"
		end

	tagged_out: STRING is
		external
			"IL signature (): STRING use Implementation.LINEAR_DOUBLE"
		alias
			"tagged_out"
		end

	has (v: DOUBLE): BOOLEAN is
		external
			"IL signature (System.Double): System.Boolean use Implementation.LINEAR_DOUBLE"
		alias
			"has"
		end

	internal_clone: ANY is
		external
			"IL signature (): ANY use Implementation.LINEAR_DOUBLE"
		alias
			"internal_clone"
		end

	operating_environment: OPERATING_ENVIRONMENT is
		external
			"IL signature (): OPERATING_ENVIRONMENT use Implementation.LINEAR_DOUBLE"
		alias
			"operating_environment"
		end

	standard_is_equal (other: ANY): BOOLEAN is
		external
			"IL signature (ANY): System.Boolean use Implementation.LINEAR_DOUBLE"
		alias
			"standard_is_equal"
		end

	is_equal_ (other: ANY): BOOLEAN is
		external
			"IL signature (ANY): System.Boolean use Implementation.LINEAR_DOUBLE"
		alias
			"is_equal"
		end

	standard_equal (some: ANY; other: ANY): BOOLEAN is
		external
			"IL signature (ANY, ANY): System.Boolean use Implementation.LINEAR_DOUBLE"
		alias
			"standard_equal"
		end

	same_type (other: ANY): BOOLEAN is
		external
			"IL signature (ANY): System.Boolean use Implementation.LINEAR_DOUBLE"
		alias
			"same_type"
		end

	empty: BOOLEAN is
		external
			"IL signature (): System.Boolean use Implementation.LINEAR_DOUBLE"
		alias
			"empty"
		end

	generator: STRING is
		external
			"IL signature (): STRING use Implementation.LINEAR_DOUBLE"
		alias
			"generator"
		end

	changeable_comparison_criterion: BOOLEAN is
		external
			"IL signature (): System.Boolean use Implementation.LINEAR_DOUBLE"
		alias
			"changeable_comparison_criterion"
		end

	internal_copy (o: ANY) is
		external
			"IL signature (ANY): System.Void use Implementation.LINEAR_DOUBLE"
		alias
			"internal_copy"
		end

	compare_objects is
		external
			"IL signature (): System.Void use Implementation.LINEAR_DOUBLE"
		alias
			"compare_objects"
		end

	there_exists (test: FUNCTION_ANY_ANY_BOOLEAN): BOOLEAN is
		external
			"IL signature (FUNCTION_ANY_ANY_BOOLEAN): System.Boolean use Implementation.LINEAR_DOUBLE"
		alias
			"there_exists"
		end

	standard_clone (other: ANY): ANY is
		external
			"IL signature (ANY): ANY use Implementation.LINEAR_DOUBLE"
		alias
			"standard_clone"
		end

	do_if (action: PROCEDURE_ANY_ANY; test: FUNCTION_ANY_ANY_BOOLEAN) is
		external
			"IL signature (PROCEDURE_ANY_ANY, FUNCTION_ANY_ANY_BOOLEAN): System.Void use Implementation.LINEAR_DOUBLE"
		alias
			"do_if"
		end

	equal_ (some: ANY; other: ANY): BOOLEAN is
		external
			"IL signature (ANY, ANY): System.Boolean use Implementation.LINEAR_DOUBLE"
		alias
			"equal"
		end

	frozen ec_illegal_36_ec_illegal_36_off (current_: LINEAR_DOUBLE): BOOLEAN is
		external
			"IL static signature (LINEAR_DOUBLE): System.Boolean use Implementation.LINEAR_DOUBLE"
		alias
			"$$off"
		end

	frozen ec_illegal_36_ec_illegal_36_do_all (current_: LINEAR_DOUBLE; action: PROCEDURE_ANY_ANY) is
		external
			"IL static signature (LINEAR_DOUBLE, PROCEDURE_ANY_ANY): System.Void use Implementation.LINEAR_DOUBLE"
		alias
			"$$do_all"
		end

	frozen a____class_name: SYSTEM_STRING is
		external
			"IL signature (): System.String use Implementation.LINEAR_DOUBLE"
		alias
			"____class_name"
		end

	do_nothing is
		external
			"IL signature (): System.Void use Implementation.LINEAR_DOUBLE"
		alias
			"do_nothing"
		end

	out_: STRING is
		external
			"IL signature (): STRING use Implementation.LINEAR_DOUBLE"
		alias
			"out"
		end

	default_rescue is
		external
			"IL signature (): System.Void use Implementation.LINEAR_DOUBLE"
		alias
			"default_rescue"
		end

	off: BOOLEAN is
		external
			"IL signature (): System.Boolean use Implementation.LINEAR_DOUBLE"
		alias
			"off"
		end

	default_pointer: POINTER is
		external
			"IL signature (): System.IntPtr use Implementation.LINEAR_DOUBLE"
		alias
			"default_pointer"
		end

	standard_copy (other: ANY) is
		external
			"IL signature (ANY): System.Void use Implementation.LINEAR_DOUBLE"
		alias
			"standard_copy"
		end

	to_string: SYSTEM_STRING is
		external
			"IL signature (): System.String use Implementation.LINEAR_DOUBLE"
		alias
			"ToString"
		end

	default_: ANY is
		external
			"IL signature (): ANY use Implementation.LINEAR_DOUBLE"
		alias
			"default"
		end

	deep_equal (some: ANY; other: ANY): BOOLEAN is
		external
			"IL signature (ANY, ANY): System.Boolean use Implementation.LINEAR_DOUBLE"
		alias
			"deep_equal"
		end

	frozen ec_illegal_36_ec_illegal_36_linear_representation (current_: LINEAR_DOUBLE): LINEAR_DOUBLE is
		external
			"IL static signature (LINEAR_DOUBLE): LINEAR_DOUBLE use Implementation.LINEAR_DOUBLE"
		alias
			"$$linear_representation"
		end

	equals (obj: SYSTEM_OBJECT): BOOLEAN is
		external
			"IL signature (System.Object): System.Boolean use Implementation.LINEAR_DOUBLE"
		alias
			"Equals"
		end

	frozen ec_illegal_36_ec_illegal_36_for_all (current_: LINEAR_DOUBLE; test: FUNCTION_ANY_ANY_BOOLEAN): BOOLEAN is
		external
			"IL static signature (LINEAR_DOUBLE, FUNCTION_ANY_ANY_BOOLEAN): System.Boolean use Implementation.LINEAR_DOUBLE"
		alias
			"$$for_all"
		end

	frozen ec_illegal_36_ec_illegal_36_index_of (current_: LINEAR_DOUBLE; v: DOUBLE; i: INTEGER): INTEGER is
		external
			"IL static signature (LINEAR_DOUBLE, System.Double, System.Int32): System.Int32 use Implementation.LINEAR_DOUBLE"
		alias
			"$$index_of"
		end

	frozen ec_illegal_36_ec_illegal_36_occurrences (current_: LINEAR_DOUBLE; v: DOUBLE): INTEGER is
		external
			"IL static signature (LINEAR_DOUBLE, System.Double): System.Int32 use Implementation.LINEAR_DOUBLE"
		alias
			"$$occurrences"
		end

	frozen ec_illegal_36_ec_illegal_36_there_exists (current_: LINEAR_DOUBLE; test: FUNCTION_ANY_ANY_BOOLEAN): BOOLEAN is
		external
			"IL static signature (LINEAR_DOUBLE, FUNCTION_ANY_ANY_BOOLEAN): System.Boolean use Implementation.LINEAR_DOUBLE"
		alias
			"$$there_exists"
		end

	do_all (action: PROCEDURE_ANY_ANY) is
		external
			"IL signature (PROCEDURE_ANY_ANY): System.Void use Implementation.LINEAR_DOUBLE"
		alias
			"do_all"
		end

	frozen ec_illegal_36_ec_illegal_36_exhausted (current_: LINEAR_DOUBLE): BOOLEAN is
		external
			"IL static signature (LINEAR_DOUBLE): System.Boolean use Implementation.LINEAR_DOUBLE"
		alias
			"$$exhausted"
		end

	generating_type: STRING is
		external
			"IL signature (): STRING use Implementation.LINEAR_DOUBLE"
		alias
			"generating_type"
		end

	linear_representation: LINEAR_DOUBLE is
		external
			"IL signature (): LINEAR_DOUBLE use Implementation.LINEAR_DOUBLE"
		alias
			"linear_representation"
		end

	object_comparison: BOOLEAN is
		external
			"IL signature (): System.Boolean use Implementation.LINEAR_DOUBLE"
		alias
			"object_comparison"
		end

	for_all (test: FUNCTION_ANY_ANY_BOOLEAN): BOOLEAN is
		external
			"IL signature (FUNCTION_ANY_ANY_BOOLEAN): System.Boolean use Implementation.LINEAR_DOUBLE"
		alias
			"for_all"
		end

	default_create_ is
		external
			"IL signature (): System.Void use Implementation.LINEAR_DOUBLE"
		alias
			"default_create"
		end

	io: STD_FILES is
		external
			"IL signature (): STD_FILES use Implementation.LINEAR_DOUBLE"
		alias
			"io"
		end

	clone_ (other: ANY): ANY is
		external
			"IL signature (ANY): ANY use Implementation.LINEAR_DOUBLE"
		alias
			"clone"
		end

	index_of (v: DOUBLE; i: INTEGER): INTEGER is
		external
			"IL signature (System.Double, System.Int32): System.Int32 use Implementation.LINEAR_DOUBLE"
		alias
			"index_of"
		end

	deep_copy (other: ANY) is
		external
			"IL signature (ANY): System.Void use Implementation.LINEAR_DOUBLE"
		alias
			"deep_copy"
		end

	copy_ (other: ANY) is
		external
			"IL signature (ANY): System.Void use Implementation.LINEAR_DOUBLE"
		alias
			"copy"
		end

	conforms_to (other: ANY): BOOLEAN is
		external
			"IL signature (ANY): System.Boolean use Implementation.LINEAR_DOUBLE"
		alias
			"conforms_to"
		end

	occurrences (v: DOUBLE): INTEGER is
		external
			"IL signature (System.Double): System.Int32 use Implementation.LINEAR_DOUBLE"
		alias
			"occurrences"
		end

	frozen ec_illegal_36_ec_illegal_36_search (current_: LINEAR_DOUBLE; v: DOUBLE) is
		external
			"IL static signature (LINEAR_DOUBLE, System.Double): System.Void use Implementation.LINEAR_DOUBLE"
		alias
			"$$search"
		end

	frozen ec_illegal_36_ec_illegal_36_has (current_: LINEAR_DOUBLE; v: DOUBLE): BOOLEAN is
		external
			"IL static signature (LINEAR_DOUBLE, System.Double): System.Boolean use Implementation.LINEAR_DOUBLE"
		alias
			"$$has"
		end

	print (some: ANY) is
		external
			"IL signature (ANY): System.Void use Implementation.LINEAR_DOUBLE"
		alias
			"print"
		end

	exhausted: BOOLEAN is
		external
			"IL signature (): System.Boolean use Implementation.LINEAR_DOUBLE"
		alias
			"exhausted"
		end

feature {NONE} -- Implementation

	finalize is
		external
			"IL signature (): System.Void use Implementation.LINEAR_DOUBLE"
		alias
			"Finalize"
		end

end -- class IMPLEMENTATION_LINEAR_DOUBLE
