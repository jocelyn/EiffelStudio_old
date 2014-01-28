/*
	description: "[
			Declaration of variables generated by compiler, later assigned to variables from `eif_project.h'.
  			Not used by run-time.
			]"
	date:		"$Date$"
	revision:	"$Revision$"
	copyright:	"Copyright (c) 1985-2006, Eiffel Software."
	license:	"GPL version 2 see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options:	"Commercial license is available at http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Runtime.
			
			Eiffel Software's Runtime is free software; you can
			redistribute it and/or modify it under the terms of the
			GNU General Public License as published by the Free
			Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Runtime is distributed in the hope
			that it will be useful,	but WITHOUT ANY WARRANTY;
			without even the implied warranty of MERCHANTABILITY
			or FITNESS FOR A PARTICULAR PURPOSE.
			See the	GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Runtime; if not,
			write to the Free Software Foundation, Inc.,
			51 Franklin St, Fifth Floor, Boston, MA 02110-1301  USA
		]"
	source: "[
			 Eiffel Software
			 356 Storke Road, Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"
*/

#ifndef _egc_include_h_
#define _egc_include_h_
#if defined(_MSC_VER) && (_MSC_VER >= 1020)
#pragma once
#endif

#include "eif_struct.h"

#ifdef __cplusplus
extern "C" {
#endif

extern struct ctable egc_ce_type_init;
extern struct ctable egc_ce_exp_type_init;
extern struct cnode egc_fsystem_init [];
extern struct conform *egc_fco_table_init [];
extern void egc_system_mod_init_init (void);
extern struct eif_par_types *egc_partab_init [];
extern int egc_partab_size_init;
extern struct eif_opt egc_foption_init [];

#ifdef WORKBENCH

extern fnptr egc_frozen_init [];
extern int egc_fpatidtab_init [];
extern fnptr *egc_address_table_init;
extern struct p_interface egc_fpattern_init [];

extern void egc_einit_init (void);
extern void egc_tabinit_init (void);

extern struct rout_info egc_forg_table_init [];

#else

extern struct ctable egc_ce_rname_init[];
extern long egc_fnbref_init[];
extern long egc_fsize_init[]; 

#endif

#ifdef __cplusplus
}
#endif

#endif
