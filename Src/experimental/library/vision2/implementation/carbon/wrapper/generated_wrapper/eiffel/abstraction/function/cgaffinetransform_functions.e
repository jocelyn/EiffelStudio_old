-- This file has been generated by EWG. Do not edit. Changes will be lost!
-- functions wrapper
class CGAFFINETRANSFORM_FUNCTIONS

obsolete
	"Use class CGAFFINETRANSFORM_FUNCTIONS_EXTERNAL instead."

inherit

	CGAFFINETRANSFORM_FUNCTIONS_EXTERNAL

feature
-- Ignoring cgaffine_transform_make since its return type is a composite type

-- Ignoring cgaffine_transform_make_translation since its return type is a composite type

-- Ignoring cgaffine_transform_make_scale since its return type is a composite type

-- Ignoring cgaffine_transform_make_rotation since its return type is a composite type

	cgaffine_transform_is_identity (t: POINTER): INTEGER is
		local
		do
			Result := cgaffine_transform_is_identity_external (t)
		end

-- Ignoring cgaffine_transform_translate since its return type is a composite type

-- Ignoring cgaffine_transform_scale since its return type is a composite type

-- Ignoring cgaffine_transform_rotate since its return type is a composite type

-- Ignoring cgaffine_transform_invert since its return type is a composite type

-- Ignoring cgaffine_transform_concat since its return type is a composite type

	cgaffine_transform_equal_to_transform (t1: POINTER; t2: POINTER): INTEGER is
		local
		do
			Result := cgaffine_transform_equal_to_transform_external (t1, t2)
		end

-- Ignoring cgpoint_apply_affine_transform since its return type is a composite type

-- Ignoring cgsize_apply_affine_transform since its return type is a composite type

-- Ignoring cgrect_apply_affine_transform since its return type is a composite type

end
