/*

 #    #    ##    #       #        ####    ####            ####
 ##  ##   #  #   #       #       #    #  #    #          #    #
 # ## #  #    #  #       #       #    #  #               #
 #    #  ######  #       #       #    #  #        ###    #
 #    #  #    #  #       #       #    #  #    #   ###    #    #
 #    #  #    #  ######  ######   ####    ####    ###     ####

	Fast memory allocation management routines.

	If this file is compiled with -DTEST, it will produce a standalone
	executable.
*/

/*
doc:<file name="malloc.c" header="eif_malloc.h" version="$Id$" summary="Memory allocation management routines">
*/

/*#define MEMCHK */
/*#define MEM_STAT */

#include "eif_portable.h"
#include "eif_project.h"
#include "rt_lmalloc.h"	/* for eif_calloc, eif_malloc, eif_free */
#include <errno.h>			/* For system calls error report */
#include <sys/types.h>		/* For caddr_t */
#include "rt_assert.h"

#ifdef HAS_SMART_MMAP
#include <sys/mman.h>
#endif

#include <stdio.h>			/* For eif_trace_types() */
#include <signal.h>

#include "eif_eiffel.h"			/* For bcopy/memcpy */
#include "rt_timer.h"			/* For getcputime */
#include "rt_malloc.h"
#include "rt_macros.h"
#include "rt_garcol.h"			/* For Eiffel flags and function declarations */
#include "rt_threads.h"
#include "rt_gen_types.h"
#include "rt_gen_conf.h"
#include "eif_except.h"			/* For exception raising */
#include "x2c.h"			/* For macro LNGPAD */
#include "eif_local.h"			/* For epop() */
#include "rt_sig.h"
#include "rt_err_msg.h"
#include "rt_bits.h"
#include "rt_globals.h"
#include "rt_struct.h"
#ifdef ISE_GC
#endif
#ifdef VXWORKS
#include <string.h>
#endif
#include "rt_main.h"

#ifdef BOEHM_GC
#include "rt_boehm.h"
#ifdef WORKBENCH
#include "rt_interp.h"	/* For definition of `call_disp' */
#endif
#endif

/* For debugging */
#define dprintf(n)		if (DEBUG & (n)) printf
#define flush			fflush(stdout)

/*#define MEMCHK */		/* Define for memory checker */
/*#define EMCHK */		/* Define for calls to memck */
/*#define MEMPANIC */		/* Panic if memck reports a trouble */
/*#define DEBUG 63 */		/* Activate debugging code */

#ifdef MEMPANIC
#define mempanic	eif_panic("memory inconsistency")
#else
#define mempanic	fflush(stdout);
#endif

#ifdef ISE_GC
/* Give the type of an hlist, by doing pointer comparaison (classic).
 * Also give the address of the hlist of a given type and the address of
 * the buffer related to a free list.
 */
#define CHUNK_TYPE(c)		(((c) == c_hlist)? C_T : EIFFEL_T)
#define FREE_LIST(t)		((t)? c_hlist : e_hlist)
#define BUFFER(c)			(((c) == c_hlist)? c_buffer : e_buffer)

/* Fast access to `hlist'. All sizes between `0' and HLIST_SIZE_LIMIT
 * with their own padding which is a multiple of ALIGNMAX
 * have their own entry in the `hlist'.
 *  E.g.: 0, 8, 16, ...., 512 in case where ALIGNMAX = 8
 * Above `HLIST_SIZE_LIMIT', the corresponding entry `i' has
 * the sizes between 2^i and (2^(i+1) - 1).
 *
 * In `compute_hlist_index' we decided to shift by default by 8 since the minimum
 * of ALIGNMAX is 4 which gives us 19 more possibilities in addition to the 64
 * of HLIST_INDEX_LIMIT. Resulting in a value of 83 for NBLOCKS defined in
 * `include/rt_malloc.h'
 */
#define HLIST_INDEX_LIMIT	64
#define HLIST_DEFAULT_SHIFT 8
#define HLIST_SIZE_LIMIT	HLIST_INDEX_LIMIT * ALIGNMAX
#define HLIST_INDEX(size)	(((size) < HLIST_SIZE_LIMIT)? \
							 	(size / ALIGNMAX) : compute_hlist_index (size))

/* For eif_trace_types() */

#define CHUNK_T     0           /* Scanning a chunk */
#define ZONE_T      1           /* Scanning a generation scavenging zone */

/* The main data-structures for eif_malloc are filled-in statically at
 * compiled time, so that no special initialization routine is
 * necessary. (Except in MT mode --ZS)
 */

/*
doc:	<attribute name="m_data" return_type="struct emallinfo" export="shared">
doc:		<summary>This structure records some general information about the memory, the number of chunck, etc... These informations are available via the meminfo() routine. Only used by current and garcol.c</summary>
doc:		<access>Read/Write</access>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>Through `eif_free_list_mutex' or GC synchronization.</synchronization>
doc:		<eiffel_classes>MEM_INFO</eiffel_classes>
doc:	</attribute>
*/
rt_shared struct emallinfo m_data = {
	0,		/* ml_chunk */
	0,		/* ml_total */
	0,		/* ml_used */
	0,		/* ml_over */
};	

/*
doc:	<attribute name="c_data" return_type="struct emallinfo" export="shared">
doc:		<summary>For C memory, we keep track of general informations too. This enables us to pilot the garbage collector correctly or to call coalescing over the memory only if it is has a chance to succeed. Only used by current and garcol.c</summary>
doc:		<access>Read/Write</access>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>Through `eif_free_list_mutex' or GC synchronization.</synchronization>
doc:		<eiffel_classes>MEM_INFO</eiffel_classes>
doc:	</attribute>
*/
rt_shared struct emallinfo c_data = { /* Informations on C memory */
	0,		/* ml_chunk */
	0,		/* ml_total */
	0,		/* ml_used */
	0,		/* ml_over */
};

/*
doc:	<attribute name="e_data" return_type="struct emallinfo" export="shared">
doc:		<summary>For Eiffel memory, we keep track of general informations too. This enables us to pilot the garbage collector correctly or to call coalescing over the memory only if it is has a chance to succeed. Only used by current and garcol.c</summary>
doc:		<access>Read/Write</access>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>Through `eif_free_list_mutex' or GC synchronization.</synchronization>
doc:		<eiffel_classes>MEM_INFO</eiffel_classes>
doc:		<fixme>Unsafe access to `e_data' from `acollect' when compiled with `-DEIF_CONDITIONAL_COLLECT' option.</fixme>
doc:	</attribute>
*/
rt_shared struct emallinfo e_data = { /* Informations on Eiffel memory */
	0,		/* ml_chunk */
	0,		/* ml_total */
	0,		/* ml_used */
	0,		/* ml_over */
};	

/*  */
/*
doc:	<attribute name="cklst" return_type="struct ck_list" export="shared">
doc:		<summary>Record head and tail of the chunk list. Only used by current and garcol.c</summary>
doc:		<access>Read/Write</access>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>Through `eif_free_list_mutex' or GC synchronization.</synchronization>
doc:	</attribute>
*/
rt_shared struct ck_list cklst = {
	(struct chunk *) 0,			/* ck_head */
	(struct chunk *) 0,			/* ck_tail */
	(struct chunk *) 0,			/* cck_head */
	(struct chunk *) 0,			/* cck_tail */
	(struct chunk *) 0,			/* eck_head */
	(struct chunk *) 0,			/* eck_tail */
};

/*
doc:	<attribute name="c_hlist" return_type="union overhead * [NBLOCKS]" export="private">
doc:		<summary>Records all C blocks with roughly the same size. The entry at index 'i' is a block whose size is at least 2^i. All the blocks with same size are chained, and the head of each list is kept in the array. As an exception, index 0 holds block with a size of zero, and as there cannot be blocks of size 1 (OVERHEAD > 1 anyway), it's ok--RAM.</summary>
doc:		<access>Read/Write</access>
doc:		<indexing>i for access to block of size 2^i</indexing>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>Through `eif_free_list_mutex'.</synchronization>
doc:	</attribute>
*/

rt_private union overhead *c_hlist[NBLOCKS];

/*
doc:	<attribute name="e_hlist" return_type="union overhead * [NBLOCKS]" export="private">
doc:		<summary>Records all Eiffel blocks with roughly the same size. The entry at index 'i' is a block whose size is at least 2^i. All the blocks with same size are chained, and the head of each list is kept in the array.  As an exception, index 0 holds block with a size of zero, and as there cannot be blocks of size 1 (OVERHEAD > 1 anyway), it's ok--RAM.</summary>
doc:		<access>Read/Write</access>
doc:		<indexing>i for access to block of size 2^i</indexing>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>Through `eif_free_list_mutex'.</synchronization>
doc:	</attribute>
*/
rt_private union overhead *e_hlist[NBLOCKS];

/*
doc:	<attribute name="c_buffer" return_type="union overhead * [NBLOCKS]" export="private">
doc:		<summary>The following arrays act as a buffer cache for every operation in the C free list. They simply record the address of the last access. Whenever we wish to insert/find an element in the list, we first look at the buffer cache value to see if we can start the traversing from that point.</summary>
doc:		<access>Read/Write</access>
doc:		<indexing>i for access to block of size 2^i</indexing>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>Through `eif_free_list_mutex'.</synchronization>
doc:	</attribute>
*/
rt_private union overhead *c_buffer[NBLOCKS];

/*
doc:	<attribute name="e_buffer" return_type="union overhead * [NBLOCKS]" export="private">
doc:		<summary>The following arrays act as a buffer cache for every operation in the Eiffel free list. They simply record the address of the last access. Whenever we wish to insert/find an element in the list, we first look at the buffer cache value to see if we can start the traversing from that point.</summary>
doc:		<access>Read/Write</access>
doc:		<indexing>i for access to block of size 2^i</indexing>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>Through `eif_free_list_mutex'.</synchronization>
doc:	</attribute>
*/
rt_private union overhead *e_buffer[NBLOCKS];

/*
doc:	<attribute name="sc_from" return_type="struct sc_zone" export="shared">
doc:		<summary>The sc_from zone is the `from' zone used by the generation scavenging garbage collector. They are shared with the garbage collector. This zone may be put back into the free list in case we are low in RAM.</summary>
doc:		<access>Read/Write</access>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>Through `eif_gc_gsz_mutex'.</synchronization>
doc:	</attribute>
*/
rt_shared struct sc_zone sc_from;

/*
doc:	<attribute name="sc_to" return_type="struct sc_zone" export="shared">
doc:		<summary>The sc_to zone is the `to' zone used by the generation scavenging garbage collector. They are shared with the garbage collector. This zone may be put back into the free list in case we are low in RAM.</summary>
doc:		<access>Read/Write</access>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>Through `eif_gc_gsz_mutex'.</synchronization>
doc:	</attribute>
*/
rt_shared struct sc_zone sc_to;

/*
doc:	<attribute name="gen_scavenge" return_type="uint32" export="shared">
doc:		<summary>Generation scavenging status which can be either GS_OFF (disabled) or GS_ON (enabled). When it is GC_ON, it can be temporarly disabled in which case it holds the GS_STOP flag. By default it is GS_OFF, and it will be enabled by `create_scavenge_zones' if `cc_for_speed' is enabled and enough memory is available to allocate the zones.</summary>
doc:		<access>Read/Write</access>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>Through GC synchronization.</synchronization>
doc:		<fixme>Is the visibility of the change is not guaranteed among all threads.</fixme>
doc:	</attribute>
*/
rt_shared uint32 gen_scavenge = GS_OFF;

/*
doc:	<attribute name="eiffel_usage" return_type="long" export="shared">
doc:		<summary>Monitor Eiffel memory usage. Each time an Eiffel object is created outside the scavenge zone (via emalloc or tenuring), we record its size in eiffel_usage variable. Then, once the amount of allocated data goes beyond th_alloc, a cycle of acollect() is run.</summary>
doc:		<access>Read/Write</access>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>Through `eiffel_usage_mutex' or GC synchronization.</synchronization>
doc:	</attribute>
*/
rt_shared long eiffel_usage = 0;

/*
doc:	<attribute name="eif_max_mem" return_type="int" export="shared">
doc:		<summary>This variable is the maximum amount of memory the run-time can allocate. If it is null or negative, there is no limit.</summary>
doc:		<access>Read/Write</access>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>Use `eif_memory_mutex' when updating its value in `memory.c'.</synchronization>
doc:	</attribute>
*/
rt_shared int eif_max_mem = 0;

/*
doc:	<attribute name="eif_tenure_max" return_type="int" export="shared">
doc:		<summary>Maximum age of tenuring.</summary>
doc:		<access>Read/Write once</access>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>None since initialized in `eif_alloc_init' (main.c)</synchronization>
doc:	</attribute>
*/
rt_shared int eif_tenure_max;

/*
doc:	<attribute name="eif_gs_limit" return_type="int" export="shared">
doc:		<summary>Maximum size of object in GSZ.</summary>
doc:		<access>Read/Write once</access>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>None since initialized in `eif_alloc_init' (main.c)</synchronization>
doc:	</attribute>
*/
rt_shared int eif_gs_limit;

/*
doc:	<attribute name="eif_scavenge_size" return_type="int" export="shared">
doc:		<summary>Size of scavenge zones. Should be a multiple of ALIGNMAX.</summary>
doc:		<access>Read/Write once</access>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>None since initialized in `eif_alloc_init' (main.c)</synchronization>
doc:	</attribute>
*/
rt_shared int eif_scavenge_size;
#endif

/*
doc:	<attribute name="eif_stack_chunk" return_type="int" export="shared">
doc:		<summary>Size of local stack chunk. Should be a multiple of ALIGNMAX.</summary>
doc:		<access>Read/Write once</access>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>None since initialized in `eif_alloc_init' (main.c)</synchronization>
doc:	</attribute>
*/
rt_shared int eif_stack_chunk;

/*
doc:	<attribute name="eif_chunk_size" return_type="int" export="shared">
doc:		<summary>Size of memory chunks. Should be a multiple of ALIGNMAX.</summary>
doc:		<access>Read/Write once</access>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>None since initialized in `eif_alloc_init' (main.c)</synchronization>
doc:	</attribute>
*/
rt_shared int eif_chunk_size;

#ifdef ISE_GC
/* Functions handling free list */
rt_private int32 compute_hlist_index (int32 size);
rt_shared EIF_REFERENCE eif_rt_xmalloc(unsigned int nbytes, int type, int gc_flag);		/* General free-list allocation */
rt_shared void rel_core(void);					/* Release core to kernel */
rt_private union overhead *add_core(register unsigned int nbytes, int type);		/* Get more core from kernel */
rt_private void connect_free_list(register union overhead *zone, register uint32 i);		/* Insert a block in free list */
rt_private void disconnect_free_list(register union overhead *next, register uint32 i);	/* Remove a block from free list */
rt_private int coalesc(register union overhead *zone);					/* Coalescing (return # of bytes) */
rt_private EIF_REFERENCE malloc_free_list(unsigned int nbytes, union overhead **hlist, int type, int gc_flag);		/* Allocate block in one of the lists */
rt_private EIF_REFERENCE allocate_free_list(register unsigned int nbytes, register union overhead **hlist);		/* Allocate block from free list */
rt_private union overhead * allocate_free_list_helper (uint32 i, register unsigned int nbytes, register union overhead **hlist);
rt_private EIF_REFERENCE allocate_from_core(unsigned int nbytes, union overhead **hlist);		/* Allocate block asking for core */
rt_private EIF_REFERENCE set_up(register union overhead *selected, unsigned int nbytes);					/* Set up block before public usage */
rt_shared int chunk_coalesc(struct chunk *c);				/* Coalescing on a chunk */
rt_private void xfreeblock(union overhead *zone, uint32 r);				/* Release block to the free list */
rt_shared int full_coalesc(int chunk_type);				/* Coalescing over specified chunks */
rt_private int full_coalesc_unsafe(int chunk_type);				/* Coalescing over specified chunks */
rt_private int free_last_chunk(void);			/* Detach last chunk from core */

/* Functions handling scavenging zone */
rt_private EIF_REFERENCE malloc_from_eiffel_list (unsigned int nbytes);
rt_private EIF_REFERENCE malloc_from_zone(unsigned int nbytes);		/* Allocate block in scavenging zone */
rt_shared void create_scavenge_zones(void);	/* Attempt creating the two zones */
rt_private void explode_scavenge_zone(struct sc_zone *sc);	/* Release objects to free-list */
rt_public void sc_stop(void);					/* Stop the scavenging process */
#endif

/* Eiffel object setting */
rt_private EIF_REFERENCE eif_set(EIF_REFERENCE object, uint32 dftype, uint32 dtype);					/* Set Eiffel object prior use */
rt_private EIF_REFERENCE eif_spset(EIF_REFERENCE object, EIF_BOOLEAN in_scavenge);				/* Set special Eiffel object */

#ifdef ISE_GC
rt_private int trigger_gc_cycle (void);
rt_private int trigger_smart_gc_cycle (void);
rt_private EIF_REFERENCE add_to_stack (EIF_REFERENCE, struct stack *);

/* Also used by the garbage collector */
rt_shared int eif_rt_split_block(register union overhead *selected, register uint32 nbytes);				/* Split a block (return length) */
rt_shared void lxtract(union overhead *next);					/* Extract a block from free list */
rt_shared EIF_REFERENCE malloc_from_eiffel_list_no_gc (unsigned int nbytes);			/* Wrapper to eif_rt_xmalloc */
rt_shared EIF_REFERENCE get_to_from_core(unsigned int nbytes);		/* Get a free eiffel chunk from kernel */
#endif

#ifdef ISE_GC
#ifdef HAS_SMART_MMAP
rt_private void free_unused(void);
#else
#ifdef HAS_SBRK
#include <unistd.h>						/* Set break (system call) */
#endif
#endif
#endif

/* Compiled with -DTEST, we turn on DEBUG if not already done */
#ifdef TEST

/* This is to make tests */
#undef References
#undef Size
#undef Disp_rout
#undef XCreate
#define References(type)	2		/* Number of references in object */
#define EIF_Size(type)			40		/* Size of the object */
#define Disp_rout(type)		0		/* No dispose procedure */
#define XCreate(type)		0		/* No creation procedure */
/* char *(**ecreate)(); FIXME: SEE EIF_PROJECT.C */

#ifndef DEBUG
#define DEBUG	 127		/* Highest debug level */
#endif
#endif

#ifndef lint
rt_private char *rcsid =
	"$Id$";
#endif

#ifdef BOEHM_GC
/*
doc:	<routine name="boehm_dispose" export="private">
doc:		<summary>Record `dispose' routine for Boehm GC</summary>
doc:		<param name="header" type="union overhead *">Zone allocated by Boehm GC which needs to be recorded so that `dispose' is called by Boehm GC when collectin `header'.</param>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>None required</synchronization>
doc:	</routine>
*/

rt_private void boehm_dispose (union overhead *header)
	/* Record `dispose' routine fro Boehm GC. */
{
	uint32 dtype;
	dtype = Deif_bid(header->ov_flags);
	DISP(dtype, (EIF_REFERENCE) (header + 1));
}
#endif

#if defined(BOEHM_GC) || defined(NO_GC)
/*
doc:	<routine name="external_allocation" return_type="EIF_REFERENCE" export="private">
doc:		<summary>Allocate new object using an external allocator such as `Boehm GC' or `standard malloc'.</summary>
doc:		<param name="atomic" type="int">Is object to be allocated empty of references to other objects?</param>
doc:		<param name="has_dispose" type="int">Has object to be allocated a `dispose' routine to be called when object will be collected?</param>
doc:		<param name="nbytes" type="uint32">Size in bytes of object to be allocated.</param>
doc:		<return>A newly allocated object of size `nbytes'.</return>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>Performed by external allocator</synchronization>
doc:	</routine>
*/

rt_private EIF_REFERENCE external_allocation (int atomic, int has_dispose, uint32 nbytes)
{
	unsigned int real_nbytes;	/* Real object size */
	int mod;					/* Remainder for padding */
	union overhead *header;

		/* We need to allocate room for the header and
		 * make sure that we won't alignment problems. We
		 * really use at least ALIGNMAX, so even if `nbytes'
		 * is 0, some memory will be used (the header).
		 */
	real_nbytes = nbytes;
	mod = real_nbytes % ALIGNMAX;
	if (mod != 0)
		real_nbytes += ALIGNMAX - mod;
	if (real_nbytes & ~B_SIZE) {
			/* Object too big */
		return NULL;
	} else {
		DISCARD_BREAKPOINTS
#ifdef BOEHM_GC
		if (real_nbytes == 0) {
			real_nbytes++;
		}
		if (atomic) {
			header = (union overhead *) GC_malloc_atomic (real_nbytes + OVERHEAD);
		} else {
			header = (union overhead *) GC_malloc (real_nbytes + OVERHEAD);
		}
#endif
#ifdef NO_GC
		header = (union overhead *) malloc(real_nbytes + OVERHEAD);
#endif
		if (header != NULL) {
			header->ov_size = real_nbytes;
				/* Point to the first data byte, just after the header. */
#ifdef BOEHM_GC
#ifdef EIF_ASSERTIONS
			GC_is_valid_displacement(header);
			GC_is_valid_displacement((EIF_REFERENCE)(header + 1));
#endif
			if (has_dispose) {
				GC_register_finalizer(header, &boehm_dispose, 0, 0, 0);
			}
#endif
			UNDISCARD_BREAKPOINTS
			return (EIF_REFERENCE)(header + 1);
		} else {
			UNDISCARD_BREAKPOINTS
			return NULL;
		}
	}
}

/*
doc:	<routine name="external_reallocation" return_type="EIF_REFERENCE" export="private">
doc:		<summary>Reallocate a given object with a  bigger size using external allocator.</summary>
doc:		<param name="obj" type="EIF_REFERENCE">Object to be reallocated</param>
doc:		<param name="nbytes" type="uint32">New size in bytes of `obj'.</param>
doc:		<return>A reallocated object of size `nbytes'.</return>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>Performed by external allocator</synchronization>
doc:	</routine>
*/

rt_private EIF_REFERENCE external_reallocation (EIF_REFERENCE obj, uint32 nbytes) {
	unsigned int real_nbytes;	/* Real object size */
	int mod;					/* Remainder for padding */
	union overhead *header;

		/* We need to allocate room for the header and
		 * make sure that we won't alignment problems. We
		 * really use at least ALIGNMAX, so even if `nbytes'
		 * is 0, some memory will be used (the header).
		 */
	real_nbytes = nbytes;
	mod = real_nbytes % ALIGNMAX;
	if (mod != 0)
		real_nbytes += ALIGNMAX - mod;
	if (real_nbytes & ~B_SIZE) {
			/* Object too big */
		return NULL;
	} else {
		DISCARD_BREAKPOINTS
#ifdef BOEHM_GC
		header = (union overhead *) GC_realloc((union overhead *) obj - 1, real_nbytes + OVERHEAD);
#endif
#ifdef NO_GC
		header = (union overhead *) realloc((union overhead *) obj - 1, real_nbytes + OVERHEAD);
#endif
		UNDISCARD_BREAKPOINTS

		if (header != NULL) {
			header->ov_size = real_nbytes;
				/* Point to the first data byte, just after the header. */
			return (EIF_REFERENCE)(header + 1);
		} else {
			return NULL;
		}
	}
}

#endif

#if defined(ISE_GC) && defined(EIF_THREADS)
/*
doc:	<attribute name="eif_gc_gsz_mutex" return_type="EIF_LW_MUTEX_TYPE *" export="shared">
doc:		<summary>Mutex used to protect GC allocation in scavenge zone.</summary>
doc:		<thread_safety>Safe</thread_safety>
doc:	</attribute>
*/
rt_shared EIF_LW_MUTEX_TYPE *eif_gc_gsz_mutex = NULL;
#define EIF_GC_GSZ_LOCK EIF_LW_MUTEX_LOCK(eif_gc_gsz_mutex, "Could not lock GSZ mutex");
#define EIF_GC_GSZ_UNLOCK EIF_LW_MUTEX_UNLOCK(eif_gc_gsz_mutex, "Could not unlock GSZ mutex")

/*
doc:	<attribute name="eif_free_list_mutex" return_type="EIF_LW_MUTEX_TYPE *" export="shared">
doc:		<summary>Mutex used to protect access and update to private/shared member of this module.</summary>
doc:		<thread_safety>Safe</thread_safety>
doc:	</attribute>
*/

rt_shared EIF_LW_MUTEX_TYPE *eif_free_list_mutex = NULL;
#define EIF_FREE_LIST_MUTEX_LOCK	EIF_LW_MUTEX_LOCK(eif_free_list_mutex, "Could not lock free list mutex");
#define EIF_FREE_LIST_MUTEX_UNLOCK	EIF_LW_MUTEX_UNLOCK(eif_free_list_mutex, "Could not unlock free list mutex");

/*
doc:	<attribute name="eiffel_usage_mutex" return_type="EIF_LW_MUTEX_TYPE *" export="shared">
doc:		<summary>Mutex used to protect access and update `eiffel_usage'.</summary>
doc:		<thread_safety>Safe</thread_safety>
doc:	</attribute>
*/

rt_shared EIF_LW_MUTEX_TYPE *eiffel_usage_mutex = NULL;
#define EIFFEL_USAGE_MUTEX_LOCK		EIF_LW_MUTEX_LOCK(eiffel_usage_mutex, "Could not lock eiffel_usage mutex");
#define EIFFEL_USAGE_MUTEX_UNLOCK	EIF_LW_MUTEX_UNLOCK(eiffel_usage_mutex, "Could not unlock eiffel_usage mutex");

/*
doc:	<attribute name="trigger_gc_mutex" return_type="EIF_LW_MUTEX_TYPE *" export="shared">
doc:		<summary>Mutex used to protect execution of `trigger_gc' routines. So that even if more than one threads enter this routine because there is a need to launch a GC cycle, hopefully one will run it, and not all of them.</summary>
doc:		<thread_safety>Safe</thread_safety>
doc:	</attribute>
*/

rt_shared EIF_LW_MUTEX_TYPE *trigger_gc_mutex = NULL;
#define TRIGGER_GC_LOCK		EIF_LW_MUTEX_LOCK(trigger_gc_mutex, "Could not lock trigger gc mutex");
#define TRIGGER_GC_UNLOCK	EIF_LW_MUTEX_UNLOCK(trigger_gc_mutex, "Could not unlock trigger gc mutex");
#endif



/*
doc:	<routine name="smart_emalloc" return_type="EIF_REFERENCE" export="public">
doc:		<summary>Perform smart allocation of either a TUPLE object or a normal object. It does not take into account SPECIAL or BIT creation as a size is required for those. See `emalloc' comments for me details.</summary>
doc:		<param name="ftype" type="uint32">Full dynamic type used to determine if we are creating a TUPLE or a normal object.</param>
doc:		<return>A newly allocated object if successful, otherwise throw an exception</return>
doc:		<exception>"No more memory" when it fails</exception>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>Done by different allocators to whom we request memory</synchronization>
doc:	</routine>
*/

rt_public EIF_REFERENCE smart_emalloc (uint32 ftype)
{
	int32 type = (int32) Deif_bid(ftype);
	if (type == egc_tup_dtype) {
		return tuple_malloc (ftype);
	} else {
		return emalloc_size (ftype, type, EIF_Size(type));
	}
}

/*
doc:	<routine name="emalloc" return_type="EIF_REFERENCE" export="public">
doc:		<summary>Perform allocation of normal object (i.e. not a BIT, SPECIAL or TUPLE object) based on `ftype' full dynamic type which is used to find out object's size in bytes. Note that the size of all the Eiffel objects is correctly padded, but do not take into account the header's size.</summary>
doc:		<param name="ftype" type="uint32">Full dynamic type used to determine if we are creating a TUPLE or a normal object.</param>
doc:		<return>A newly allocated object if successful, otherwise throw an exception.</return>
doc:		<exception>"No more memory" when it fails</exception>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>Done by different allocators to whom we request memory</synchronization>
doc:	</routine>
*/

rt_public EIF_REFERENCE emalloc (uint32 ftype)
{
	uint32 type = (uint32) Deif_bid(ftype);
	return emalloc_size (ftype, type, EIF_Size(type));
}

/*
doc:	<routine name="emalloc_size" return_type="EIF_REFERENCE" export="public">
doc:		<summary>Memory allocation for a normal Eiffel object (i.e. not BIT, SPECIAL or TUPLE).</summary>
doc:		<param name="ftype" type="uint32">Full dynamic type used to initialize full dynamic type overhead part of Eiffel object.</param>
doc:		<param name="type" type="uint32">Dynamic type used to initialize flags overhead part of Eiffel object, mostly used if type is a deferred one, or if it is an expanded one, or if it has a dispose routine.</param>
doc:		<param name="nbytes" type="uint32">Number of bytes to allocate for this type.</param>
doc:		<return>A newly allocated object holding at least `nbytes' if successful, otherwise throw an exception.</return>
doc:		<exception>"No more memory" when it fails</exception>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>Done by different allocators to whom we request memory</synchronization>
doc:	</routine>
*/

rt_public EIF_REFERENCE emalloc_size(uint32 ftype, uint32 type, uint32 nbytes)
{
	EIF_REFERENCE object;				/* Pointer to the freshly created object */
#ifdef ISE_GC
	uint32 mod;							/* Remainder for padding */
#endif
	
#ifdef WORKBENCH
	if (EIF_IS_DEFERRED_TYPE(System(type))) {	/* Cannot create deferred */
		eraise(System(type).cn_generator, EN_CDEF);
		return (EIF_REFERENCE) 0;			/* In case they chose to ignore EN_CDEF */
	}
#endif

#if defined(BOEHM_GC) || defined(NO_GC)
	object = external_allocation (References(type) == 0, (int) Disp_rout(type), nbytes);
	if (object != NULL) {
		return eif_set(object, ftype | EO_NEW, type);
	} else {
		eraise("object allocation", EN_MEM);	/* Signals no more memory */
		return NULL;
	}
#endif

#ifdef ISE_GC
		/* We really use at least ALIGNMAX, to avoid alignement problems.
		 * So even if nbytes is 0, some memory will be used (the header), he he !!
		 */
	mod = nbytes % ALIGNMAX;
	if (mod != 0)
		nbytes += ALIGNMAX - mod;

	/* Depending on the optimization chosen, we allocate the object in
	 * the Generational Scavenge Zone (GSZ) or in the free-list.
	 * All the objects smaller than `eif_gs_limit' are allocated 
	 * in the the GSZ, otherwise they are allocated in the free-list.
	 * We put the memory objects in the GSZ (i.e those, which inherits from class
	 * MEMORY, otherwise they are allocated in the free-list.
	 * All the non-special objects smaller than `eif_gs_limit' are allocated 
	 * in the the GSZ, otherwise they are allocated in the free-list.
	 */

	if ((gen_scavenge == GS_ON) && (nbytes <= (unsigned int) eif_gs_limit)) {
		object = malloc_from_zone(nbytes);
		if (object) {
			return eif_set(object, ftype, type);	/* Set for Eiffel use */
		} else if (trigger_smart_gc_cycle()) {
				/* First allocation in scavenge zone failed. If `trigger_smart_gc_cycle' was
				 * successful, let's try again as this is a more efficient way to allocate
				 * in the scavenge zone. */
			object = malloc_from_zone (nbytes);
			if (object) {
				return eif_set(object, ftype, type);	/* Set for Eiffel use */
			}
		}
	}

	/* Try an allocation in the free list, with garbage collection turned on. */
	CHECK("Not too big", !(nbytes & ~B_SIZE));
	object = malloc_from_eiffel_list (nbytes);
	if (object) {
		return eif_set(object, ftype | EO_NEW, type);		/* Set for Eiffel use */
	} else {
			/*
			 * Allocation failed even if GC was requested. We can only make some space
			 * by turning off generation scavenging and getting the two scavenge zones
			 * back for next allocation. A last attempt is then made before raising
			 * an exception if it also failed.
			 */
		if (gen_scavenge & GS_ON)		/* If generation scaveging was on */
			sc_stop();					/* Free 'to' and explode 'from' space */

		object = malloc_from_eiffel_list_no_gc (nbytes);		/* Retry with GC off this time */

		if (object) {
			return eif_set(object, ftype | EO_NEW, type);		/* Set for Eiffel use */
		}
	}

#endif /* ISE_GC */

	eraise("object allocation", EN_MEM);	/* Signals no more memory */

	/* NOTREACHED, to avoid C compilation warning. */
	return NULL;
}

/*
doc:	<routine name="sp_init" return_type="EIF_REFERENCE" export="public">
doc:		<summary>Initialize special object of expanded `obj' from `lower' position to `upper' position. I.e. creating new instances of expanded objects and assigning them from `obj [lower]' to `obj [upper]'.</summary>
doc:		<param name="obj" type="EIF_REFERENCE">Special object of expanded which will be initialized.</param>
doc:		<param name="dftype" type="uint32">Dynamic type of expanded object to create for each entry of special object `obj'.</param>
doc:		<param name="lower" type="EIF_INTEGER">Lower bound of `obj'.</param>
doc:		<param name="upper" type="EIF_INTEGER">Upper bound of `obj'.</param>
doc:		<return>New address of `obj' in case a GC collection was performed.</return>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>None required</synchronization>
doc:	</routine>
*/

rt_public EIF_REFERENCE sp_init (EIF_REFERENCE obj, uint32 dftype, EIF_INTEGER lower, EIF_INTEGER upper)
{
	EIF_GET_CONTEXT

	EIF_INTEGER elem_size, i;
	EIF_REFERENCE exp;
	union overhead *zone;

	REQUIRE ("obj not null", obj != (EIF_REFERENCE) 0);
	REQUIRE ("Not forwarded", !(HEADER (obj)->ov_size & B_FWD));
	REQUIRE ("Special object", HEADER (obj)->ov_flags & EO_SPEC);
	REQUIRE ("Special object of expanded", HEADER (obj)->ov_flags & EO_COMP);
	REQUIRE ("Valid lower", ((lower >= 0) && (lower <= RT_SPECIAL_COUNT(obj))));
	REQUIRE ("Valid upper", ((upper >= lower - 1) && (upper <= RT_SPECIAL_COUNT(obj))));

	RT_GC_PROTECT(obj);
	elem_size = RT_SPECIAL_ELEM_SIZE(obj);
	for (i = lower; i <= upper; i++) {
		EIF_INTEGER offset = elem_size * i;
		zone = (union overhead *) (obj + offset);
		zone->ov_size = OVERHEAD + offset;	/* For GC */
		zone->ov_flags = dftype | EO_EXP;	/* Expanded type */
		exp = RTLX(dftype);					/* Create new expanded */
		ecopy(exp, obj + OVERHEAD + offset);
	}
	RT_GC_WEAN(obj);

	return obj;
}

/*
doc:	<routine name="special_malloc" return_type="EIF_REFERENCE" export="public">
doc:		<summary>Allocated new SPECIAL object with flags `flags' (flags includes the full dynamic type). Elements are zeroed, It initializes elements of a special of expanded.</summary>
doc:		<param name="flags" type="uint32">Dynamic type of TUPLE object to create along with flags.</param>
doc:		<param name="nb" type="EIF_INTEGER">Number of element in special.</param>
doc:		<param name="element_size" type="uint32">Size of element in special.</param>
doc:		<param name="atomic" type="EIF_BOOLEAN">Is this a special of basic types?</param>
doc:		<return>A newly allocated SPECIAL object if successful, otherwise throw an exception.</return>
doc:		<exception>"No more memory" when it fails</exception>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>Done by different allocators to whom we request memory</synchronization>
doc:	</routine>
*/

rt_public EIF_REFERENCE special_malloc (uint32 flags, EIF_INTEGER nb, uint32 element_size, EIF_BOOLEAN atomic)
{
	EIF_REFERENCE result = NULL;
	EIF_REFERENCE offset;
	union overhead *zone;

	result = spmalloc (CHRPAD(nb * element_size) + LNGPAD(2), atomic);

		/* At this stage we are garanteed to have an initialized object, otherwise an
		 * exception would have been thrown by the call to `spmalloc'. */
	CHECK("result not null", result);

	zone = HEADER(result);
	zone->ov_flags |= flags;

	offset = result + (zone->ov_size & B_SIZE) - LNGPAD(2);

	RT_SPECIAL_COUNT_WITH_INFO(offset) = nb;
	RT_SPECIAL_ELEM_SIZE_WITH_INFO(offset) = element_size;

	if (flags & EO_COMP) {
			/* It is a composite object, that is to say a special of expanded,
			 * we need to initialize every entry properly. */
		uint32 exp_dtype = eif_gen_param_id (-1, (int16) (flags & EO_TYPE), 1);
		result = sp_init (result, exp_dtype, 0, nb - 1);
	}
	return result;
}

/*
doc:	<routine name="tuple_malloc" return_type="EIF_REFERENCE" export="public">
doc:		<summary>Allocated new TUPLE object of type `ftype'. It internally calls `tuple_malloc_specific' therefore it computes `count' of TUPLE to create as wekl as determines if TUPLE is atomic or not.</summary>
doc:		<param name="ftype" type="uint32">Dynamic type of TUPLE object to create.</param>
doc:		<return>A newly allocated TUPLE object of type `ftype' if successful, otherwise throw an exception.</return>
doc:		<exception>"No more memory" when it fails</exception>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>Done by different allocators to whom we request memory</synchronization>
doc:	</routine>
*/

rt_public EIF_REFERENCE tuple_malloc (uint32 ftype)
{
	unsigned int i, count;
	EIF_BOOLEAN is_atomic = EIF_TRUE;
	int16 dftype = (int16) ftype;

	REQUIRE("Is a tuple type", Deif_bid(ftype) == egc_tup_dtype);

		/* We add + 1 since TUPLE objects have `count + 1' element
		 * to avoid doing -1 each time we try to access an item at position `pos'.
		 */
	count = eif_gen_count_with_dftype (dftype) + 1;

		/* Let's find out if this is a tuple which contains some reference
		 * when there is no reference then `is_atomic' is True which enables
		 * us to do some optimization at the level of the GC */
	for (i = 1; (i < count) && (is_atomic); i++) {
		if (eif_gen_typecode_with_dftype(dftype, i) == EIF_REFERENCE_CODE) {
			is_atomic = EIF_FALSE;
		}
	}

	return tuple_malloc_specific(ftype, count, is_atomic);
}

/*
doc:	<routine name="tuple_malloc_specific" return_type="EIF_REFERENCE" export="public">
doc:		<summary>Allocated new TUPLE object of type `ftype', of count `count' and `atomic'. TUPLE is alloated through `spmalloc', but the element size is the one of TUPLE element, i.e. sizeof (EIF_TYPED_ELEMENT).</summary>
doc:		<param name="ftype" type="uint32">Dynamic type of TUPLE object to create.</param>
doc:		<param name="count" type="uint32">Number of elements in TUPLE object to create.</param>
doc:		<param name="atomic" type="EIF_BOOLEAN">Does current TUPLE object to create has reference or not? True means no.</param>
doc:		<return>A newly allocated TUPLE object if successful, otherwise throw an exception.</return>
doc:		<exception>"No more memory" when it fails</exception>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>Done by different allocators to whom we request memory</synchronization>
doc:	</routine>
*/

rt_public EIF_REFERENCE tuple_malloc_specific (uint32 ftype, uint32 count, EIF_BOOLEAN atomic)
{
	EIF_REFERENCE object;
	REQUIRE("Is a tuple type", Deif_bid(ftype) == egc_tup_dtype);

	object = spmalloc (count * sizeof(EIF_TYPED_ELEMENT) + LNGPAD_2, atomic);

	if (object == NULL) {
		eraise ("Tuple allocation", EN_MEM);	/* signals no more memory */
	} else {
			/* Initialize TUPLE headers and end of special object */
		union overhead * zone = HEADER(object);
		unsigned int i;
		EIF_TYPED_ELEMENT *l_item = (EIF_TYPED_ELEMENT *) object;
		EIF_REFERENCE ref = RT_SPECIAL_INFO_WITH_ZONE(object, zone);
		RT_SPECIAL_COUNT_WITH_INFO(ref) = count;
		RT_SPECIAL_ELEM_SIZE_WITH_INFO(ref) = sizeof(EIF_TYPED_ELEMENT);
			/* Mark it is a tuple object */
		zone->ov_flags |= EO_TUPLE;
		zone->ov_flags |= ftype;
		if (!atomic) {
			zone->ov_flags |= EO_REF;
		}
			/* Initialize type information held in TUPLE instance*/
			/* Don't forget that first element of TUPLE is just a placeholder
			 * to avoid offset computation from Eiffel code */
		l_item++;
		for (i = 1; i < count; i++,l_item++) {
			l_item->type = eif_gen_typecode_with_dftype((int16)ftype, i);
		}
	}
	return object;
}

/*
doc:	<routine name="spmalloc" return_type="EIF_REFERENCE" export="public">
doc:		<summary>Memory allocation for an Eiffel special object. It either succeeds or raises the "No more memory" exception. The routine returns the pointer on a new special object holding at least 'nbytes'. `atomic' means that it is a special object without references.</summary>
doc:		<param name="nbytes" type="unsigned int">Number of bytes to allocate.</param>
doc:		<param name="atomic" type="EIF_BOOLEAN">Does current special object to create has reference or not? True means no.</param>
doc:		<return>A newly allocated TUPLE object if successful, otherwise throw an exception.</return>
doc:		<exception>"No more memory" when it fails</exception>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>Done by different allocators to whom we request memory</synchronization>
doc:	</routine>
*/

rt_public EIF_REFERENCE spmalloc(unsigned int nbytes, EIF_BOOLEAN atomic)
{
	EIF_REFERENCE object;		/* Pointer to the freshly created special object */
#ifdef ISE_GC
	uint32 mod;
#endif
	
#if defined(BOEHM_GC) || defined(NO_GC)
		/* No dispose routine associated, therefore `0' for second argument */
	object = external_allocation (atomic, 0, nbytes);
	if (object != NULL) {
		return eif_spset(object, EIF_FALSE);
	} else {
		eraise("Special allocation", EN_MEM);	/* Signals no more memory */
		return NULL;
	}
#endif

#ifdef ISE_GC
		/* We really use at least ALIGNMAX, to avoid alignement problems.
		 * So even if nbytes is 0, some memory will be used (the header), he he !!
		 */
	mod = nbytes % ALIGNMAX;
	if (mod != 0)
		nbytes += ALIGNMAX - mod;

	if ((gen_scavenge == GS_ON) && (nbytes <= (unsigned int) eif_gs_limit)) {
		object = malloc_from_zone (nbytes);	/* allocate it in scavenge zone. */
		if (object) {
			return  eif_spset(object, EIF_TRUE);
		} else if (trigger_smart_gc_cycle()) {
			object = malloc_from_zone (nbytes);
			if (object) {
				return eif_spset(object, EIF_TRUE);
			}
		}
	}

		/* New special object is too big to be created in generational scavenge zone or there is
		 * more space in scavenge zone. So we allocate it in free list only if it is less
		 * than the authorized size `2^27'. */
	if (!(nbytes & ~B_SIZE)) {
		object = malloc_from_eiffel_list (nbytes);
		if (object) {
			return eif_spset(object, EIF_FALSE);
		} else {
				/*
				 * Allocation failed even if GC was requested. We can only make some space
				 * by turning off generation scavenging and getting the two scavenge zones
				 * back for next allocation. A last attempt is then made before raising
				 * an exception if it also failed.
				 */
			if (gen_scavenge & GS_ON)		/* If generation scaveging was on */
				sc_stop();					/* Free 'to' and explode 'from' space */

			object = malloc_from_eiffel_list_no_gc (nbytes);		/* Retry with GC off this time */

			if (object) {
				return eif_spset(object, EIF_FALSE);		/* Set for Eiffel use */
			}
		}
	}

	eraise("Special allocation", EN_MEM);	/* No more memory */

	/* Not reached - to avoid C compilation warning */
	return NULL;
#endif
}

/*
doc:	<routine name="sprealloc" return_type="EIF_REFERENCE" export="public">
doc:		<summary>Reallocate a special object `ptr' so that it can hold at least `nbitems'.</summary>
doc:		<param name="ptr" type="EIF_REFERENCE">Special object which will be reallocated.</param>
doc:		<param name="nbitems" type="unsigned int">New number of items wanted.</param>
doc:		<return>A newly allocated special object if successful, otherwise throw an exception.</return>
doc:		<exception>"No more memory" when it fails</exception>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>None required, it is done by the features we are calling.</synchronization>
doc:	</routine>
*/

rt_public EIF_REFERENCE sprealloc(EIF_REFERENCE ptr, unsigned int nbitems)
{
	EIF_GET_CONTEXT
	union overhead *zone;		/* Malloc information zone */
	EIF_REFERENCE ref, object;
	unsigned int count, elem_size;
	unsigned int old_size, new_size;					/* New and old size of special object. */
	unsigned int old_real_size, new_real_size;		/* Size occupied by items of special */
#ifdef ISE_GC
	EIF_BOOLEAN need_update = EIF_FALSE;	/* Do we need to remember content of special? */
#endif
	EIF_BOOLEAN need_expanded_initialization = EIF_FALSE;	/* Do we need to initialize new entries? */

	REQUIRE ("ptr not null", ptr != (EIF_REFERENCE) 0);
	REQUIRE ("Not forwarded", !(HEADER (ptr)->ov_size & B_FWD));
	REQUIRE ("Special object:", HEADER (ptr)->ov_flags & EO_SPEC);

	/* At the end of the special object arena, there are two long values which
	 * are kept up-to-date: the actual number of items held and the size in
	 * byte of each item (the same for all items).
	 */
	zone = HEADER(ptr);
	old_size = zone->ov_size & B_SIZE;	/* Old size of array */
	ref = RT_SPECIAL_INFO_WITH_ZONE(ptr, zone);
	count = RT_SPECIAL_COUNT_WITH_INFO(ref);		/* Current number of elements */
	elem_size = RT_SPECIAL_ELEM_SIZE_WITH_INFO(ref);
	old_real_size = count * elem_size;	/* Size occupied by items in old special */
	new_real_size = nbitems * elem_size;	/* Size occupied by items in new special */
	new_size = new_real_size + LNGPAD_2;		/* New required size */

	if (nbitems == count) {		/* OPTIMIZATION: Does resized object have same size? */
		return ptr;				/* If so, we return unchanged `ptr'. */
	}

	RT_GC_PROTECT(ptr);	/* Object may move if GC called */

	CHECK ("Stil not forwarded", !(HEADER(ptr)->ov_size & B_FWD));

#ifdef ISE_GC
#ifdef EIF_GSZ_ALLOC_OPTIMIZATION
	if (zone->ov_flags & (EO_NEW | EO_OLD)) {	/* Is it out of GSZ? */
#endif
			/* It is very important to give the GC_FREE flag to xrealloc, as if the
			 * special object happens to move during the reallocing operation, its
			 * old "location" must not be freed in case it is in the moved_set or
			 * whatever GC stack. This old copy will be normally reclaimed by the
			 * GC. Also, this prevents a nasty bug when Eiffel objects share the area.
			 * When one of this area is resized and moved, the other object still
			 * references somthing valid (although the area is no longer shared)--RAM.
			 */	

		object = xrealloc (ptr, new_size, GC_ON | GC_FREE);
#endif

#if defined(BOEHM_GC) || defined(NO_GC)
		object = external_reallocation (ptr, new_size);
#endif

		if ((EIF_REFERENCE) 0 == object) {
			eraise("special reallocation", EN_MEM);
			return (EIF_REFERENCE) 0;
		}

		zone = HEADER (object);
		new_size = zone->ov_size & B_SIZE;	/* `xrealloc' can change the `new_size' value for padding */

		CHECK ("Not forwarded", !(HEADER(ptr)->ov_size & B_FWD));

			/* Reset extra-items with zeros or default expanded value if any */
		if (new_real_size > old_real_size) {
			CHECK ("New size bigger than old one", new_size >= old_size);
			memset (object + old_real_size, 0, new_size - old_real_size);
			if (zone->ov_flags & EO_COMP)
				need_expanded_initialization = EIF_TRUE;
		} else { 	/* Smaller object requested. */
			CHECK ("New size smaller than old one", new_size <= old_size);
				/* We need to remove existing elements between `new_real_size'
				 * and `new_size'. Above `new_size' it has been taken care
				 * by `xrealloc' when moving the memory area above `new_size'
				 * in the free list.
				 */
			memset (object + new_real_size, 0, new_size - new_real_size);
		}

#ifdef ISE_GC
		if (ptr != object) {		/* Has ptr moved in the reallocation? */
				/* If the reallocation had to allocate a new object, then we have to do
				 * some further settings: if the original object was marked EO_NEW, we
				 * must push the new object into the moved set. Also we must reset the B_C
				 * flags set by malloc (which makes it impossible to freeze a special
				 * object, but it cannot be achieved anyway since a reallocation may
				 * have to move it).
				 */

			zone->ov_size &= ~B_C;		/* Cannot freeze a special object */
			need_update = EIF_TRUE;
		}
#ifdef EIF_GSZ_ALLOC_OPTIMIZATION
	} else {	/* Was allocated in the GSZ. */
		CHECK ("In scavenge zone", !(HEADER (ptr)->ov_size & B_BUSY));

			/* We do not need to reallocate an array if the existing one has enough
			 * space to accomadate the resizing */
		if (new_size > old_size) {
				/* Reserve `new_size' bytes in GSZ if possible. */
			object = spmalloc (new_size, EIF_TEST(!(zone->ov_flags & EO_REF)));
		} else
			object = ptr;

		if (object == (EIF_REFERENCE) 0) {
			eraise("Special reallocation", EN_MEM);
			return (EIF_REFERENCE) 0;
		}

			/* Set flags of newly created object */
		zone = HEADER (object);
		new_size = zone->ov_size & B_SIZE;	/* `spmalloc' can change the `new_size' value for padding */

				/* Copy only dynamic type and object nature and age from old object
				 * We cannot copy HEADER(ptr)->ov_flags because `ptr' might have
				 * moved outside the GSZ during reallocation of `object'. */
		zone->ov_flags |= HEADER(ptr)->ov_flags & (EO_TYPE | EO_REF | EO_COMP);

			/* Update flags of new object */
		if ((zone->ov_flags & EO_NEW) && (zone->ov_flags & (EO_REF | EO_COMP))) 
				/* New object has been created outside the
				 * scavenge zone, we need to remember it
				 * if it contains references to other objects. */
			erembq (object);	/* Usual remembrance process. */

		CHECK ("Not forwarded", !(HEADER (ptr)->ov_size & B_FWD));

			/* Copy `ptr' in `object'.	*/
		if (new_real_size > old_real_size) {
			CHECK ("New size bigger than old one", new_size >= old_size);
				/* If object has been resized we do not need to clean the new
				 * allocated memory because `spmalloc' does it for us. */
			if (object != ptr)
			  		/* Object has been resized to grow, we need to copy old items. */
				memcpy (object, ptr, old_real_size);
			else {
				CHECK ("New size same as old one", new_size == old_size);
			  		/* We need to clean area between `old_real_size' and
					 * `new_real_size'.
					 */
				memset (object + old_real_size, 0, new_size - old_real_size);
			}
			
			if (zone->ov_flags & EO_COMP)
					/* Object has been resized and contains expanded objects.
					 * We need to initialize the newly allocated area. */
				need_expanded_initialization = EIF_TRUE;
		} else {				/* Smaller object requested. */
			CHECK ("New size smaller than old one", new_size <= old_size);
				/* We need to remove existing elements between `new_real_size'
				 * and `new_size'. Above `new_size' we do not care since it
				 * is in the scavenge zone and no one is going to access it
				 */
			memset (object + new_real_size, 0, new_size - new_real_size);
		}
	}
#endif
#endif

	RT_GC_WEAN(ptr);	/* Unprotect `ptr'. No more collection is expected. */

		/* Update special attributes count and element size at the end */
	ref = RT_SPECIAL_INFO(object);
	RT_SPECIAL_COUNT_WITH_INFO(ref) = nbitems;						/* New count */
	RT_SPECIAL_ELEM_SIZE_WITH_INFO(ref) = elem_size; 	/* New item size */

	if (need_expanded_initialization) {
	   		/* Case of a special object of expanded structures. */
			/* Initialize remaining items. */
		object = sp_init(object, HEADER(object + OVERHEAD)->ov_flags & EO_TYPE, count, nbitems - 1);
	}

#ifdef ISE_GC
	if (need_update) {
			/* If the object has moved in the reallocation process and was in the
			 * remembered set, we must re-issue a memorization call otherwise all the
			 * old contents of the area could be freed. Note that the test below is
			 * NOT perfect, since the area could have been moved by the GC and still
			 * have not been moved around wrt the GC stacks. But it doen't hurt--RAM.
			 */

		if (HEADER (ptr)->ov_flags & EO_REM) {
			erembq (object);	/* Usual remembrance process. */
					/* A simple remembering for other special objects. */
		}

		if (HEADER(ptr)->ov_flags & EO_NEW) {	/* Original was new, ie not allocated in GSZ. */
			object = add_to_stack (object, &moved_set);
		}
	}
#endif

	ENSURE ("Special object", HEADER (object)->ov_flags & EO_SPEC);
	ENSURE ("Eiffel object", !(HEADER (object)->ov_flags & EO_C));
	ENSURE ("Valid new size", (int)(HEADER (object)->ov_size & B_SIZE) >= new_size);

		/* The accounting of memory used by Eiffel is not accurate here, but it is
		 * not easy to know at this level whether the block was merely extended or
		 * whether we had to allocate a new block. However, if the reallocation
		 * shrinks the object, we know xrealloc will not move the block but shrink
		 * it in place, so there is no need to update the usage.
		 */

#ifdef ISE_GC
	if (new_size > old_size) {				/* Then update memory usage. */
		GC_THREAD_PROTECT(EIFFEL_USAGE_MUTEX_LOCK);
		eiffel_usage += (new_size - old_size);
		GC_THREAD_PROTECT(EIFFEL_USAGE_MUTEX_UNLOCK);
	}
#endif

	return object;
}

/*
doc:	<routine name="bmalloc" return_type="EIF_REFERENCE" export="public">
doc:		<summary>Allocate a new object of type BIT `size'.</summary>
doc:		<param name="size" type="long int">Required size of bit type to allocated.</param>
doc:		<return>A newly allocated BIT object if successful, otherwise throw an exception.</return>
doc:		<exception>"No more memory" when it fails</exception>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>None required</synchronization>
doc:	</routine>
*/

rt_public EIF_REFERENCE bmalloc(long int size)
{
	EIF_REFERENCE object;			/* Pointer to the freshly created bit object */
	unsigned int nbytes;			/* Object's size */
#ifdef ISE_GC
	uint32 mod;
#endif

	(void) eif_register_bit_type (size);
#ifdef DEBUG
	dprintf(1) ("bmalloc: %d bits requested.\n", size);
#endif

	/* A BIT object has a length field (the number of bits in the object), and
	 * an arena where the bits are stored, from left to right, as an array of
	 * booleans (i.e. the first bit is the rightmost one, as opposed to the
	 * usual conventions).
	 */
	nbytes = BIT_NBPACK(size) * BIT_PACKSIZE + sizeof(uint32);
#ifdef ISE_GC
	mod = nbytes % ALIGNMAX;
	if (mod != 0)
		nbytes += ALIGNMAX - mod;

	object = malloc_from_eiffel_list (nbytes);		/* Allocate Eiffel object */
#endif
#if defined(BOEHM_GC) || defined(NO_GC)
	object = external_allocation (1, 0, nbytes);
#endif

		/* As in the memory allocation routines located in eif_malloc.c, a new
		 * BIT object has to be marked after being allocated in the eif_free
		 * list. Otherwise the GC will be lost. 
		 * Fixes negate-big-bit-local.
		 * -- Fabrice
		 */
	if (object) {
		CHECK ("Allocated size big enough", nbytes <= (HEADER(object)->ov_size & B_SIZE));
		object = eif_set(object, egc_bit_dtype | EO_NEW, egc_bit_dtype);
		LENGTH(object) = (uint32) size;				/* Record size */
		return object;
	}
  
	eraise(MTC "object allocation", EN_MEM);	/* Signals no more memory */
	return (0); /* NOTREACHED */
}

/*
doc:	<routine name="cmalloc" return_type="EIF_REFERENCE" export="public">
doc:		<summary>Memory allocation for a C object. This is the same as the traditional malloc routine, excepted that the memory management is done by the Eiffel run time, so Eiffel keeps a kind of control over this memory. Memory is `zeroed'.</summary>
doc:		<param name="nbytes" type="unsigned int">Number of bytes to allocated.</param>
doc:		<return>Upon success, it returns a pointer on a new free zone holding at least 'nbytes' free. Otherwise, a null pointer is returned.</return>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>None required</synchronization>
doc:	</routine>
*/

rt_public EIF_REFERENCE cmalloc(unsigned int nbytes)
{
#ifdef ISE_GC
	EIF_REFERENCE arena;		/* C arena allocated */

	arena = eif_rt_xmalloc(nbytes, C_T, GC_OFF);

		/* The C object does not use its Eiffel flags field in the header. However,
		 * we set the EO_C bit. This will help the GC because it won't need
		 * extra-tests to skip the C arenas referenced by Eiffel objects.
		 */
	if (arena)
		HEADER(arena)->ov_flags = EO_C;		/* Clear all flags but EO_C */

	return arena;
#else
	return (EIF_REFERENCE) malloc (nbytes);
#endif
}

#ifdef ISE_GC
/*
doc:	<routine name="malloc_from_eiffel_list_no_gc" return_type="EIF_REFERENCE" export="shared">
doc:		<summary>Requests 'nbytes' from the free-list (Eiffel if possible), garbage collection turned off. This entry point is used by some garbage collector routines, so it is really important to turn the GC off. This routine being called from within the garbage collector, there is no need to make it a critical section with SIGBLOCK / SIGRESUME.</summary>
doc:		<param name="nbytes" type="unsigned int">Number of bytes to allocated, should be properly aligned an no greater than the maximum size we can allocate (i.e. 2^27 currently).</param>
doc:		<return>Upon success, it returns a pointer on a new free zone holding at least 'nbytes' free. Otherwise, a null pointer is returned.</return>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>None required</synchronization>
doc:	</routine>
*/

rt_shared EIF_REFERENCE malloc_from_eiffel_list_no_gc (unsigned int nbytes)
{
	EIF_REFERENCE result;	

	REQUIRE("nbytes properly padded", (nbytes % ALIGNMAX) == 0);
	REQUIRE("nbytes not too big (less than 2^27)", !(nbytes & ~B_SIZE)); 

		/* We try to find an empty spot in the free list. If not found, we
		 * will try `malloc_free_list' which will either allocate more
		 * memory or coalesc some zone of the free list to create a bigger
		 * one that will be able to accommodate `nbytes'.
		 */
	result = allocate_free_list (nbytes, e_hlist);
	if (!result) {
		result = malloc_free_list (nbytes, e_hlist, EIFFEL_T, GC_OFF);

		GC_THREAD_PROTECT(EIFFEL_USAGE_MUTEX_LOCK);
			/* Increment allocated bytes outside scavenge zone. */
		eiffel_usage += nbytes;
			/* No more space found in free memory, we force a full collection next time
			 * we do a collect. */
		force_plsc++;
		GC_THREAD_PROTECT(EIFFEL_USAGE_MUTEX_UNLOCK);
	}

	ENSURE ("Allocated size big enough", !result || (nbytes <= (HEADER(result)->ov_size & B_SIZE)));
	return result;
}

/*
doc:	<routine name="malloc_from_eiffel_list" return_type="EIF_REFERENCE" export="shared">
doc:		<summary>Requests 'nbytes' from the free-list (Eiffel if possible), garbage collection turned on. If no more space is found in the free list, we will launch a GC cycle to make some room and then try again, if it fails we try one more time with garbage collection turned off.</summary>
doc:		<param name="nbytes" type="unsigned int">Number of bytes to allocated, should be properly aligned an no greater than the maximum size we can allocate (i.e. 2^27 currently).</param>
doc:		<return>Upon success, it returns a pointer on a new free zone holding at least 'nbytes' free. Otherwise, a null pointer is returned.</return>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>Use `eiffel_usage_mutex' to perform safe update to `eiffel_usage', otherwise rest is naturally thread safe.</synchronization>
doc:	</routine>
*/

rt_private EIF_REFERENCE malloc_from_eiffel_list (unsigned int nbytes)
{
	EIF_REFERENCE result;

	REQUIRE("nbytes properly padded", (nbytes % ALIGNMAX) == 0);
	REQUIRE("nbytes not too big (less than 2^27)", !(nbytes & ~B_SIZE)); 

		/* Perform allocation in free list. If not successful, we try again
		 * by trying a GC cycle. */
	result = allocate_free_list(nbytes, e_hlist);

	if (!result) {
		if (trigger_gc_cycle()) {
			result = allocate_free_list(nbytes, e_hlist);
		}
		if (!result) {
				/* We try to put Eiffel blocks in Eiffel chunks
				 * If the free list cannot hold the block, switch to the C chunks list.
				 */
			result = malloc_free_list(nbytes, e_hlist, EIFFEL_T, GC_ON);
			if (!result) {
				result = allocate_free_list (nbytes, c_hlist);
				if (!result) {
					result = malloc_free_list(nbytes, c_hlist, C_T, GC_OFF);
				}
			}
		}
	}

	if (result) {
		GC_THREAD_PROTECT(EIFFEL_USAGE_MUTEX_LOCK);
		eiffel_usage += nbytes + OVERHEAD;	/* Memory used by Eiffel */
		GC_THREAD_PROTECT(EIFFEL_USAGE_MUTEX_UNLOCK);
	}

	ENSURE ("Allocated size big enough", !result || (nbytes <= (HEADER(result)->ov_size & B_SIZE)));
	return result;
}
#endif

/*
doc:	<routine name="eif_rt_xmalloc" return_type="EIF_REFERENCE" export="shared">
doc:		<summary>This routine is the main entry point for free-list driven memory allocation. It allocates 'nbytes' of type 'type' (Eiffel or C) and will call the garbage collector if necessary, unless it is turned off. The function returns a pointer to the free location found, or a null pointer if there is no memory available.</summary>
doc:		<param name="nbytes" type="unsigned int">Number of bytes requested.</param>
doc:		<param name="type" type="int">Type of block (C_T or EIFFEL_T).</param>
doc:		<param name="gc_flag" type="int">Is GC on or off?</param>
doc:		<return>New block of memory if successful, otherwise a null pointer.</return>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>None required</synchronization>
doc:	</routine>
*/

rt_shared EIF_REFERENCE eif_rt_xmalloc(unsigned int nbytes, int type, int gc_flag)
{
#ifdef ISE_GC
	int mod;			/* Remainder for padding */
	EIF_REFERENCE result;		/* Pointer to the free memory location we found */
	union overhead **first_hlist, **second_hlist;
	int second_type;
#ifdef EIF_ASSERTIONS
	unsigned int old_nbytes = nbytes;
#endif

	/* We really use at least ALIGNMAX, to avoid alignement problems.
	 * So even if nbytes is 0, some memory will be used (the header), he he !!
	 * The maximum size for nbytes is 2^27, because the upper 5 bits ot the
	 * size field are used to mark the blocks.
	 */
	mod = nbytes % ALIGNMAX;
	if (mod != 0)
		nbytes += ALIGNMAX - mod;

	if (nbytes & ~B_SIZE)
		return (EIF_REFERENCE) 0;		/* I guess we can't malloc more than 2^27 */

#ifdef DEBUG
	dprintf(1)("eif_rt_xmalloc: requesting %d bytes from %s list (GC %s)\n", nbytes,
		type == C_T ? "C" : "Eiffel", gc_flag == GC_ON ? "on" : "off");
	flush;
#endif

	/* We try to put Eiffel blocks in Eiffel chunks and C blocks in C chunks.
	 * That way, we do not spoil the Eiffel chunks for scavenging (C blocks
	 * cannot be moved). The Eiffel objects that are referenced from C must
	 * be moved to C chunks and become C blocks (so that the GC skips them).
	 * If the free list cannot hold the block, switch to the other list. Note
	 * that the GC flag makes sense only when allocating from a free list for
	 * the first time (it does make sense for the C list in case we had to
	 * allocate Eiffel blocks in the C list due to a "low on memory" condition).
	 */

	if (type == EIFFEL_T) {
		first_hlist = e_hlist;
		second_hlist = c_hlist;
		second_type = C_T;
	} else {
		first_hlist = c_hlist;
		second_hlist = e_hlist;
		second_type = EIFFEL_T;
	}

	result = allocate_free_list (nbytes, first_hlist);
	if (!result) {
		if (gc_flag && (type == EIFFEL_T)) {
			if (trigger_gc_cycle()) {
				result = allocate_free_list(nbytes, e_hlist);
			}
		}
		if (!result) {
			result = malloc_free_list (nbytes, first_hlist, type, gc_flag);
			if (result == (EIF_REFERENCE) 0 && gc_flag != GC_OFF) {
				result = allocate_free_list (nbytes, second_hlist);
				if (!result) {
					result = malloc_free_list(nbytes, second_hlist, second_type, GC_OFF);
				}
			}
		}
	}

	ENSURE ("Allocated size big enough", !result || (old_nbytes <= (HEADER(result)->ov_size & B_SIZE)));
	return result;	/* Pointer to free data space or null if out of memory */
#else
	return (EIF_REFERENCE) malloc (nbytes);
#endif
}

#ifdef ISE_GC
/*
doc:	<routine name="malloc_free_list" return_type="EIF_REFERENCE" export="private">
doc:		<summary>We tried to find a free block in `hlist' before calling this routine but could not find any. Therefore here we will try to launch a GC cycle if permitted, or we will try to coalesc the memory so that bigger blocks of memory can be found in the free list.</summary>
doc:		<param name="nbytes" type="unsigned int">Number of bytes to allocated, should be properly aligned.</param>
doc:		<param name="hlist" type="union overhead **">List from which we try to find a free block or allocated a new block.</param>
doc:		<param name="type" type="int">Type of list (EIFFEL_T or C_T).</param>
doc:		<param name="gc_flag" type="int">Is GC on or off?</param>
doc:		<return>An aligned block of 'nbytes' bytes or null if no more memory is available.</return>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>Through `eif_free_list_mutex'.</synchronization>
doc:	</routine>
*/

rt_private EIF_REFERENCE malloc_free_list (unsigned int nbytes, union overhead **hlist, int type, int gc_flag)
{
	EIF_REFERENCE result;					/* Location of the malloc'ed block */
	unsigned int estimated_free_space;

	REQUIRE("Valid list", CHUNK_TYPE(hlist) == type);

	if (cc_for_speed) {
			/* They asked for speed (over memory, of course), so we first try
			 * to allocate by requesting some core from the kernel. If this fails,
			 * we try to do block coalescing before attempting a new allocation
			 * from the free list if the coalescing brought a big enough bloc.
			 */
		result = allocate_from_core (nbytes, hlist);	/* Ask for more core */
		if (result) {
			return result;				/* We got it */
		}
	}
	
		/* Call garbage collector if it is not turned off and restart our
		 * attempt from the beginning. We always call the partial scavenging
		 * collector to benefit from the memory compaction, if possible.
		 */
	if (gc_flag == GC_ON) {
#ifdef EIF_THREADS
		RT_GET_CONTEXT
		if ((gc_thread_status == EIF_THREAD_GC_RUNNING) || thread_can_launch_gc) {
			plsc();						/* Call garbage collector */
			return malloc_free_list (nbytes, hlist, type, GC_OFF);
		}
#else
		plsc();						/* Call garbage collector */
		return malloc_free_list (nbytes, hlist, type, GC_OFF);
#endif
	}

	/* Optimize: do not try to run a full coalescing if there is not
	 * enough free memory anyway. To give an estimation of the amount of
	 * free memory, we substract the amount used from the total allocated:
	 * in a perfect world, the amount of overhead would be zero... Anyway,
	 * the coalescing operation will reduce the overhead, so we must not
	 * deal with it or we may wrongly reject some situtations--RAM.
	 */

	GC_THREAD_PROTECT(EIF_FREE_LIST_MUTEX_LOCK);
	if (type == C_T) {
		estimated_free_space = (unsigned int) (c_data.ml_total - c_data.ml_used);
	} else {
		estimated_free_space = (unsigned int) (e_data.ml_total - e_data.ml_used);
	}

	if ((nbytes <= estimated_free_space) && (nbytes < (unsigned int) full_coalesc_unsafe (type))) {
#ifdef EIF_ASSERTIONS
		EIF_REFERENCE result;
		GC_THREAD_PROTECT(EIF_FREE_LIST_MUTEX_UNLOCK);
		result = allocate_free_list (nbytes, hlist);
		CHECK ("result not null", result);
		return result;
#else
		GC_THREAD_PROTECT(EIF_FREE_LIST_MUTEX_UNLOCK);
		return allocate_free_list (nbytes, hlist);
#endif
	} else {
		GC_THREAD_PROTECT(EIF_FREE_LIST_MUTEX_UNLOCK);
#ifdef HAS_SMART_MMAP
		free_unused ();
#endif
			/* No other choice but to request for more core */
		return allocate_from_core (nbytes, hlist);
	}
}

#ifdef HAS_SMART_MMAP
/*
doc:	<routine name="free_unused" export="private">
doc:		<summary>???</summary>
doc:		<thread_safety>Not safe</thread_safety>
doc:		<synchronization>Safe if caller holds `eif_free_list_mutex' or is under GC synchronization.</synchronization>
doc:	</routine>
*/

rt_private void free_unused (void)
{
	struct chunk *local_chunk;

	if (cklst.ck_head == (struct chunk *) 0)
		return;
	for (local_chunk = cklst.ck_head; local_chunk != (struct chunk *) 0; 
			local_chunk = local_chunk->ck_next) {
		if (!chunk_free(local_chunk))
			continue;
		SIGBLOCK;
		
		SIGRESUME;
	}
}

/*
doc:	<routine name="chunk_free" return_type="int" export="private">
doc:		<summary>???</summary>
doc:		<param name="ck" type="struct chunk *">??</param>
doc:		<thread_safety>Safe</thread_safety>
doc:	</routine>
*/

rt_private int chunk_free (struct chunk *ck)
{
	return 0;
}

#endif

/*
doc:	<routine name="allocate_free_list" return_type="EIF_REFERENCE" export="private">
doc:		<summary>Given a correctly padded size 'nbytes', we try to find a free block from the free list described in 'hlist'.</summary>
doc:		<param name="nbytes" type="unsigned int">Number of bytes requested.</param>
doc:		<param name="hlist" type="union overhead **">List from which we try to find a free block.</param>
doc:		<return>Return the address of the (splited) block if found, a null pointer otherwise.</return>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>Through `eif_free_list_mutex'</synchronization>
doc:	</routine>
*/

rt_private EIF_REFERENCE allocate_free_list(register unsigned int nbytes, register union overhead **hlist)
{
	RT_GET_CONTEXT
	register2 uint32 i;					/* Index in hlist */
	register3 union overhead *selected;
	EIF_REFERENCE result;

#ifdef DEBUG
	dprintf(4)("allocate_free_list: requesting %d bytes from %s list\n",
		nbytes, (CHUNK_TYPE(hlist) == C_T) ? "C" : "Eiffel");
	flush;
#endif

		/* Quickly compute the index in the hlist array where we have a
		 * chance to find the right block. */
	i = HLIST_INDEX(nbytes);

		/* Look in free list to find a suitable block. */

	GC_THREAD_PROTECT(EIF_FREE_LIST_MUTEX_LOCK);
	SIGBLOCK;				/* Critical section */

	if (i >= HLIST_INDEX_LIMIT) {
		selected = allocate_free_list_helper (i, nbytes, hlist);
	} else {
			/* We are below the limit `HLIST_INDEX_LIMIT', therefore if the entry of
			 * `hlist' at index `i' is not NULL, then it means that we have `nbytes'
			 * available. No need to check the size here. If block is null, then we
			 * go through all other blocks to find the first one available. */
		selected = hlist[i];
	  	if (selected) {
			hlist[i] = selected->ov_next;		/* remove block from list */
			if (BUFFER(hlist)[i] == selected)	/* Selected was cached */
			  	BUFFER(hlist)[i] = hlist[i];	/* update cache */
		} else {
			i++;
			selected = allocate_free_list_helper (i, nbytes, hlist);
		}
	}
		
	SIGRESUME;				/* End of critical section */

	/* Now, either 'i' is NBLOCKS and 'selected' still holds a null
	 * pointer or 'selected' holds the wanted address and 'i' is the
	 * index in the hlist array.
	 */
	
	if (!selected) {		/* We did not find it */
		GC_THREAD_PROTECT(EIF_FREE_LIST_MUTEX_UNLOCK);
		return NULL;	/* Failed */
	}

#ifdef DEBUG
	dprintf(8)("allocate_free_list: got block from list #%d\n", i);
	flush;
#endif

	/* Block is ready to be set up for use of 'nbytes' (eventually after
	 * having been split). Memory accounting is done in set_up().
	 */
	result = set_up(selected, nbytes);
	GC_THREAD_PROTECT(EIF_FREE_LIST_MUTEX_UNLOCK);
	return result;
}

/*
doc:	<routine name="allocate_free_list_helper" return_type="union overhead *" export="private">
doc:		<summary>This is the heart of malloc: Look in the hlist array to see if there is already a block available. If so, we take the first one and we eventually split the block. If no block is available, we look for some bigger one. If none is found, then we fail.</summary>
doc:		<param name="i" type="uint32">Index from where we start looking for a block of `nbytes' in `hlist'.</param>
doc:		<param name="nbytes" type="unsigned int">Number of bytes requested to be found.</param>
doc:		<param name="hlist" type="union overhead **">Free list where search will take place.</param>
doc:		<return>Location of a zone that can hold `nbytes', null otherwise.</return>
doc:		<thread_safety>Not safe</thread_safety>
doc:		<synchronization>Safe if caller holds `eif_free_list_mutex' or is under GC synchronization.</synchronization>
doc:	</routine>
*/

rt_private union overhead * allocate_free_list_helper(uint32 i, register unsigned int nbytes, register union overhead **hlist)
{
	register3 union overhead *selected;	/* The selected block */
	register4 union overhead *p;		/* To walk through free-list */


	for (; i < NBLOCKS; i++) {
		if ((selected = hlist[i]) == NULL)
			continue;
		else if ((selected->ov_size & B_SIZE) >= nbytes) {
			hlist[i] = selected->ov_next;		/* Remove block from list */
			if (BUFFER(hlist)[i] == selected)	/* Selected was cached */
				BUFFER(hlist)[i] = hlist[i];	/* Update cache */
			return selected;				/* Found it, selected points to it */
		} else {
			/* Walk through list, until we find a good block. This
			 * is only done for the first 'i'. Afterwards, either the
			 * first item will fit, or we'll have to report failure.
			 */
			for (
				p = selected, selected = p->ov_next;
				selected != NULL;
				p = selected, selected = p->ov_next
			) {
				if ((selected->ov_size & B_SIZE) >= nbytes) {
					p->ov_next = selected->ov_next;	/* Remove from list */
					if (BUFFER(hlist)[i] == selected)	/* Selected cached? */
						BUFFER(hlist)[i] = p->ov_next;	/* Update cache */
					return selected;		/* Found it, selected points to it */
				}
			}
			CHECK ("Not found", selected == NULL);
		}
	}

#if DEBUG
{
	uint32 bytes_available = 0;
	int found = 0;
	fprintf(stderr, "\nallocate_free_list_helper: Requested %d, but found nothing.\n", nbytes);
	for (i = 0; i < NBLOCKS; i++) {
		selected = hlist [i];
		if (selected) {
			uint32 count = 0;
			uint32 list_bytes = 0;
			for (
				p = selected;
				selected != NULL;
				p = selected, selected = p->ov_next
			) {
				if ((selected->ov_size & B_SIZE) >= nbytes) {
					found++;
				}
				list_bytes += selected->ov_size & B_SIZE;
				count++;
			}
			fprintf(stderr, "hlist [%d] has %d elements and %d free bytes.\n", i, count, list_bytes);
			bytes_available += list_bytes;
		} else {
//			fprintf(stderr, "hlist [%d] is empty.\n", i);
		}
	}
	if (found) {
		fprintf(stderr, "We found a possible %d block(s) of size greater than %d bytes.\n", found, nbytes);
	}
	fprintf(stderr, "Total available bytes is %d\n", bytes_available);
	if (CHUNK_TYPE(hlist) == EIFFEL_T) {
		fprintf(stderr, "Eiffel free list has %d bytes allocated, %d used and %d free.\n",
			e_data.ml_total, e_data.ml_used, e_data.ml_total - e_data.ml_used); 
	} else {
		fprintf(stderr, "C free list has %d bytes allocated, %d used and %d free.\n",
			c_data.ml_total, c_data.ml_used, c_data.ml_total - c_data.ml_used); 
	}
	flush;
}
#endif
	return NULL;
}


/*
doc:	<routine name="get_to_from_core" return_type="EIF_REFERENCE" export="shared">
doc:		<summary>For the partial scavenging algorithm, gets a new free chunk for the to_space.</summary>
doc:		<param name="nbytes" type="unsigned int">Number of bytes requested.</param>
doc:		<return>New block if successful, otherwise a null pointer.</return>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>Call to `allocate_from_core' is safe.</synchronization>
doc:	</routine>
*/

rt_shared EIF_REFERENCE get_to_from_core (unsigned int nbytes)
{
	return allocate_from_core (nbytes, e_hlist);
}

/*
doc:	<routine name="allocate_from_core" return_type="EIF_REFERENCE" export="private">
doc:		<summary>Given a correctly padded size 'nbytes', we ask for some core to be able to make a chunk capable of holding 'nbytes'. The chunk will be placed in the specified `hlist'.</summary>
doc:		<param name="nbytes" type="unsigned int">Number of bytes requested.</param>
doc:		<param name="hlist" type="union overhead **">List in which we try to allocated a free block.</param>
doc:		<return>Address of new block, or null if no more core is available.</return>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>Through `eif_free_list_mutex'.</synchronization>
doc:	</routine>
*/

rt_private EIF_REFERENCE allocate_from_core(unsigned int nbytes, union overhead **hlist)
{
	RT_GET_CONTEXT
	register2 union overhead *selected;		/* The selected block */
	register1 struct chunk *chkbase;		/* Base address of new chunk */
	EIF_REFERENCE result;
	int type = CHUNK_TYPE(hlist);
	
#ifdef DEBUG
	dprintf(4)("allocate_from_core: requesting %d bytes from %s list\n",
		nbytes, (type == C_T) ? "C" : "Eiffel");
	flush;
#endif

	GC_THREAD_PROTECT(EIF_FREE_LIST_MUTEX_LOCK);

	selected = add_core(nbytes, type);	/* Ask for more core */
	if (!selected) {
		GC_THREAD_PROTECT(EIF_FREE_LIST_MUTEX_UNLOCK);
		return (EIF_REFERENCE) 0;				/* Could not obtain enough memory */
	}
	
	/* Add_core() returns a pointer of the info zone of the sole block
	 * currently in the new born chunk. We have to set the "type" of the
	 * chunk correctly, along with the type of the block held in it (so that
	 * a free can put the block back into the right eif_free list. Note that an
	 * Eiffel object may well be in a C chunk.
	 */
	chkbase = ((struct chunk *) selected) - 1;	/* Chunk info zone */

	/* Hang on. The following should avoid some useless swapping when
	 * walking through a well defined type of chunk list--RAM.
	 * All the chunks are added to the list at the end of it, so the
	 * addresses are always increasing when walking through the list. This
	 * property is used by the garbage collector, for efficiency reasons
	 * that are too long to be explained here--RAM.
	 */

	SIGBLOCK;			/* Critical section */

	if (C_T == type) {
		/* C block chunck */
		if (cklst.cck_head == (struct chunk *) 0) {	/* No C chunk yet */
			cklst.cck_head = chkbase;				/* First C chunk */
			chkbase->ck_lprev = (struct chunk *) 0;	/* First item in list */
		} else {
			cklst.cck_tail->ck_lnext = chkbase;		/* Added at the tail */
			chkbase->ck_lprev = cklst.cck_tail;		/* Previous item */
		}
		cklst.cck_tail = chkbase;					/* New tail */
		chkbase->ck_lnext = (struct chunk *) 0;		/* Last block in list */
		chkbase->ck_type = C_T;						/* Dedicated to C */
		selected->ov_size |= B_CTYPE;				/* Belongs to C free list */
	} else {
		/* Eiffel block chunck */
		if (cklst.eck_head == (struct chunk *) 0) {	/* No Eiffel chunk yet */
			cklst.eck_head = chkbase;				/* First Eiffel chunk */
			chkbase->ck_lprev = (struct chunk *) 0;	/* First item in list */
		} else {
			cklst.eck_tail->ck_lnext = chkbase;		/* Added at the tail */
			chkbase->ck_lprev = cklst.eck_tail;		/* Previous item */
		}
		cklst.eck_tail = chkbase;					/* New tail */
		chkbase->ck_lnext = (struct chunk *) 0;		/* Last block in list */
		chkbase->ck_type = EIFFEL_T;				/* Dedicated to Eiffel */
	}

	SIGRESUME;			/* End of critical section */

#ifdef DEBUG
	dprintf(4)("allocate_from_core: %d user bytes chunk added to %s list\n",
		chkbase->ck_length, (type == C_T) ? "C" : "Eiffel");
	flush;
#endif

	/* Block is ready to be set up for use of 'nbytes' (eventually after
	 * having been split). Memory accounting is done in set_up().
	 */

	result = set_up(selected, nbytes);

	GC_THREAD_PROTECT(EIF_FREE_LIST_MUTEX_UNLOCK);
	return result;
}

/*
doc:	<routine name="add_core" return_type="union overhead *" export="private">
doc:		<summary>Get more core from kernel, increasing the data segment of the process by calling mmap() or sbrk() or. We try to request at least CHUNK bytes to allow for efficient scavenging. If more than that amount is requested, the value is padded to the nearest multiple of the system page size. If less than that amount are requested but the system call fails, successive attempts are made, decreasing each time by one system page size. A pointer to a new chunk suitable for at least 'nbytes' bytes is returned, or a null pointer if no more memory is available. The chunk is linked in the main list, but left out of any free list.</summary>
doc:		<param name="nbytes" type="unsigned int">Number of bytes requested.</param>
doc:		<param name="type" type="int">Type of block to allocated (EIFFEL_T or C_T).</param>
doc:		<return>Address of new block of `nbytes' bytes, or null if no more core is available.</return>
doc:		<thread_safety>Not safe</thread_safety>
doc:		<synchronization>Safe if caller holds `eif_free_list_mutex' or is under GC synchronization.</synchronization>
doc:	</routine>
*/

rt_private union overhead *add_core(register unsigned int nbytes, int type)
{
	RT_GET_CONTEXT	
#if defined HAS_SMART_MMAP || defined HAS_SBRK
	register1 union overhead *oldbrk = (union overhead *) -1;
						/* Initialized with `failed' value. */
#else
	register1 union overhead *oldbrk = (union overhead *) -1;
						/* Initialized with `failed' value. */
#endif
	register2 int32 asked = (int32) nbytes;	/* Bytes requested */

	/* We want at least 'nbytes' bytes for use, so we must add the overhead
	 * for each block and for each chunk. The memory made available to us
	 * will be formatted correctly. We must not forget the ending pointer
	 * (What we want is at least one usable block of 'nbytes').
	 */
	asked += sizeof(struct chunk) + OVERHEAD;

	/* Requesting less than CHUNK implies requesting CHUNK bytes, at least.
	 * Requesting more implies at least CHUNK plus the needed number of
	 * extra pages necessary (tiny fit).
	 */
	if (asked <= eif_chunk_size) {
		asked = eif_chunk_size;
	} else {
		asked = eif_chunk_size + (((asked - eif_chunk_size) / PAGESIZE_VALUE) + 1) * PAGESIZE_VALUE;
	}

	/* If we request for more than a CHUNK, we'll loop only once (for Eiffel,
	 * because of the tiny fit). Otherwise, we decrease the amount of requested
	 * bytes as long as there are enough for our current need.
	 */
	for (; asked >= (int32) nbytes; asked -= PAGESIZE_VALUE) {

#ifdef DEBUG
		dprintf(2)("add_core: requesting for %d bytes\n", asked);
		flush;
#endif

		/* We check that we are not asking for more than the limit
		 * the user has fixed:
		 *   - eif_max_mem (total allocated memory)
		 * If the value of eif_max_mem is 0, there is no limit.
		 */

		if (eif_max_mem > 0)
			if (m_data.ml_total + asked > eif_max_mem) {
				print_err_msg (stderr, "Cannot allocate memory: too much in comparison with maximum allowed!\n");
				return (union overhead *) 0;
			}
		/* Now request for some more core, checking the return value
		 * from mmap() if available or sbrk() if available or malloc()
		 * as the last option. Every failure is handled as a "no more memory"
		 * condition.
		 */

#ifdef HAS_SMART_MMAP

#if PTRSIZ > 4
		oldbrk = (union overhead *) mmap (root_obj, asked, PROT_READ | PROT_WRITE, MAP_ANONYMOUS | MAP_VARIABLE | MAP_PRIVATE, -1, 0);
#else
		oldbrk = (union overhead *) mmap (NULL, asked, PROT_READ | PROT_WRITE, MAP_ANONYMOUS | MAP_VARIABLE | MAP_PRIVATE, -1, 0);
#endif

		if ((union overhead *) -1 != oldbrk)
			break;							/* OK, we got it */

#else /* !HAS_SMART_MMAP */

#ifdef HAS_SBRK
		oldbrk = (union overhead *) sbrk(asked);

#ifdef DEBUG
		dprintf(2)("add_core: kernel responded: %s (oldbrk: 0x%lx)\n",
			((union overhead *) -1 == oldbrk) ? "no" : "ok", oldbrk);
		flush;
#endif
		if ((union overhead *) -1 != oldbrk)
			break;							/* OK, we got it */
#else /* !HAS_SBRK */

		oldbrk = (union overhead *) eif_malloc (asked); /* Use malloc () */ 

#ifdef DEBUG
		dprintf(2)("add_core: kernel responded: %s (oldbrk: 0x%lx)\n",
			((union overhead *) 0 == oldbrk) ? "no" : "ok", oldbrk);
		flush;
#endif
		if ((union overhead *) 0 != oldbrk)
			break;							/* OK, we got it */

#endif /* HAS_SBRK */
#endif /* HAS_SMART_MMAP */

	}

#if defined HAS_SMART_MMAP || defined HAS_SBRK

	if ((union overhead *) -1 == oldbrk)
		return (union overhead *) 0;		/* We never succeeded */
#else

	if ((union overhead *) 0 == oldbrk)
		return (union overhead *) 0;		/* We never succeeded */
#endif
	SIGBLOCK;			/* Critical section starts */

	/* Accounting informations */
	m_data.ml_chunk++;
	m_data.ml_total += asked;				/* Counts overhead */
	m_data.ml_over += sizeof(struct chunk) + OVERHEAD;

	/* Accounting is also done for each type of memory (C/Eiffel) */
	if (type == EIFFEL_T) {
		e_data.ml_chunk++;
		e_data.ml_total += asked;
#ifdef MEM_STAT
		printf ("Eiffel: %ld used, %ld total (+%ld) (add_core)\n",
			e_data.ml_used, e_data.ml_total, asked);
#endif
		e_data.ml_over += sizeof(struct chunk) + OVERHEAD;
	} else {
		c_data.ml_chunk++;
		c_data.ml_total += asked;
		c_data.ml_over += sizeof(struct chunk) + OVERHEAD;
#ifdef MEM_STAT
		printf ("C: %ld used, %ld total (+%ld) (add_core)\n",
			c_data.ml_used, c_data.ml_total, asked);
#endif
	}

	/* We got the memory we wanted. Make a chunk out of it, build one
	 * big block inside and return the pointer to that block. This is
	 * a somewhat costly operation, but it is note done very often.
	 */
	
	asked -= sizeof(struct chunk) + OVERHEAD;	/* Was previously increased */

	/* Update all the pointers for the double linked list. This
	 * is somewhat heavy code, hard to read because of all these
	 * casts, but believe me, it is simple--RAM.
	 */

#define chkstart	((struct chunk *) oldbrk)

	if (cklst.ck_head == (struct chunk *) 0) {	/* No chunk yet */
		cklst.ck_head = chkstart;				/* First chunk */
		chkstart->ck_prev = (struct chunk *) 0;	/* First item in list */
	} else {
		cklst.ck_tail->ck_next = chkstart;		/* Added at the tail */
		chkstart->ck_prev = cklst.ck_tail;		/* Previous item */
	}
		
	cklst.ck_tail = chkstart;					/* New tail */
	chkstart->ck_next = (struct chunk *) 0;		/* Last block in list */
	chkstart->ck_length = asked + OVERHEAD;		/* Size of chunk */
	
	/* Address of new block (skip chunck overhead) */
	oldbrk = (union overhead *) (chkstart + 1);

	/* Set the size of the new block. Note that this new block
	 * is the first and the last one in the chunk, so we set the
	 * B_LAST bit. All the other flags are set to false.
	 */

	oldbrk->ov_size = asked | B_LAST;

	SIGRESUME;				/* Critical section ends */

#ifdef DEBUG
	dprintf(1+4)(
		"add_core: kernel granted %d bytes (user mem from 0x%lx to 0x%lx)\n",
		asked + OVERHEAD + sizeof(struct chunk), oldbrk,
		(EIF_REFERENCE) oldbrk + asked + OVERHEAD - 1);
	flush;
#endif

	return oldbrk;			/* Pointer to new free zone */
}

/*
doc:	<routine name="rel_core" export="shared">
doc:		<summary>Release core if possible, giving pages back to the kernel. This will shrink the size of the process accordingly. To release memory, we need at least two free chunks at the end (i.e. near the break), and of course, a chunk not reserved for next partial scavenging as a 'to' zone.</summary>
doc:		<thread_safety>Not safe</thread_safety>
doc:		<synchronization>Safe under GC synchronization.</synchronization>
doc:	</routine>
*/

rt_shared void rel_core(void)
{

	while (free_last_chunk() == 0)		/* Free last chunk (all you can eat) */
		;
}

/*
doc:	<routine name="free_last_chunk" return_type="int" export="private">
doc:		<summary>The last chunk in memory is freed (i.e. given back to the kernel) and the break value is updated. The status from sbrk() is returned. Great care is taken to ensure that the last chunk does not contain anything referenced by the process (otherwise, you get a free ticket for a memory fault)--RAM. Only called by `rel_core'.</summary>
doc:		<return>An error condition of -2 means the last chunk is not near the break for whatever reason and hence cannot be wiped out from the process, sorry. A -3 means that there is no way the last chunk can be freed. -4 is returned when there are no more chunks to be freed</return>
doc:		<thread_safety>Not safe</thread_safety>
doc:		<synchronization>Safe under GC synchronization.</synchronization>
doc:	</routine>
*/

rt_private int free_last_chunk(void)
{
	RT_GET_CONTEXT
	int nbytes;				/* Number of bytes to be freed */
	union overhead *arena;	/* The address of the arena enclosed in chunk */
	struct chunk *last_chk;	/* Pointer to last chunk header */
	struct chunk last_desc;	/* A copy of the overhead part from last chunk */
	uint32 i;				/* Index in hash table where block is stored */
	uint32 r;				/* To compute hashing index for released block */

#if (!defined (HAS_SMART_MMAP)) && defined HAS_SBRK
	EIF_REFERENCE last_addr;		/* The first address beyond the last chunk */
#endif

#if (!defined (HAS_SMART_MMAP)) && defined (HAS_SBRK) && (!defined (HAS_SMART_SBRK))
	return -5;
#else
	last_chk = cklst.ck_tail;			/* Last chunk in memory */
	if (last_chk == (struct chunk *) 0)	/* No more chunk */
		return -4;						/* Make sure a failure is reported */
	nbytes = last_chk->ck_length +		/* Amount of bytes is chunk's length */
		sizeof(struct chunk);			/* plus the header overhead */
#if (!defined (HAS_SMART_MMAP)) && defined HAS_SBRK
	last_addr = (EIF_REFERENCE) last_chk + nbytes;
#endif

	/* Return immediately if the last chunk is used as a scavenging 'to' zone or
	 * contains a generation scavenging pool.
	 */
	if (
		to_chunk() > (EIF_REFERENCE) last_chk ||		/* Partial 'to' zone */
		sc_from.sc_arena > (EIF_REFERENCE) last_chk ||	/* Generation scavenging pool */
		sc_to.sc_arena > (EIF_REFERENCE) last_chk
	) {
#ifdef DEBUG
		dprintf(1)("free_last_chunk: 0x%lx not eligible for shrinking\n",
			last_chk);
		flush;
#endif
		return -3;						/* Not eligible for shrinking */
	}

	/* Ok, let's see if this chunk is free. If it holds a free last block,
	 * that's fine. Otherwise, we run a coalescing on the chunk and check again.
	 * If we do not succeed either, then abort the procedure.
	 */

	arena = (union overhead *) ((EIF_REFERENCE) last_chk + sizeof(struct chunk));

#ifdef DEBUG
	dprintf(1)("free_last_chunk: %s block 0x%lx, %d bytes, %s\n",
		arena->ov_size & B_LAST ? "last" : "normal",
		arena, arena->ov_size & B_SIZE,
		arena->ov_size & B_BUSY ?
		(arena->ov_size & B_C ? "busy C" : "busy Eiffel") : "free");
	flush;
#endif

	if (!(arena->ov_size & B_LAST) || (arena->ov_size & B_BUSY)) {
		if (0 == chunk_coalesc(last_chk))	/* No coalescing was done */
			return -3;						/* So this chunk is not eligible */
		if (!(arena->ov_size & B_LAST) || (arena->ov_size & B_BUSY))
			return -3;						/* Coalescing did not help */
	}

#ifdef DEBUG
#if (!defined HAS_SMART_MMAP) && defined HAS_SBRK
	dprintf(1)("free_last_chunk: %d bytes to be removed before 0x%lx\n",
		nbytes, sbrk(0));
	flush;

#endif
#endif

	SIGBLOCK;			/* Entering in critical section */

	/* Make sure there is *nothing* between the end of the last chunk and the
	 * break. There might be something on weird systems or if the pagesize value
	 * was not correctly determined by Configure--RAM.
	 */

#if (!defined HAS_SMART_MMAP) && defined HAS_SBRK
	/* Fetch current break value */
	if (((EIF_REFERENCE) sbrk(0)) != last_addr) { /* There *is* something */
		SIGRESUME;					/* End of critical section */
		return -2;					/* Sorry, cannot shrink data segment */
	}
#endif
	
	/* Save a copy of the informations held in the header of the last chunk:
	 * once the sbrk() system call is run, those data won't be able to be
	 * accessed any more.
	 */

	memcpy (&last_desc, last_chk, sizeof(struct chunk));

	/* The bloc we are about to remove from the process memory is to be removed
	 * from the free list (may manipulate some pointers in a zone where no
	 * further access will be allowed by the kernel if shrinking succeeds).
	 * In fact, we do not remove the block from the free list if it happens to
	 * be the current ps_from structure (which the GC has freed, in the sense
	 * that no alive object is stored in it, but has not put back to the free
	 * list). Same thing for the current ps_to strucuture.
	 */

	if (
		(EIF_REFERENCE) arena == ps_from.sc_arena ||
		(EIF_REFERENCE) arena == ps_to.sc_arena
	)
		i = (uint32) -1;
	else {
		r = (uint32) arena->ov_size & B_SIZE;
		i = HLIST_INDEX(r);
		disconnect_free_list(arena, i);		/* Remove arena from free list */
	}

	/* Now here we go. Attempt the shrinking process by calling munmap() or sbrk() with a
	 * negative value or free, bringing the memory used by the chunk back to the kernel.
	 */

#ifdef HAS_SMART_MMAP
	if (munmap (last_chk, nbytes) == -1) {
		if (i != -1)
			connect_free_list (arena, i);
		SIGRESUME;
		return -1;
	}
#else	/* HAS_SMART_SBRK */
#ifdef HAS_SBRK
	/* Shrink process's data segment */
	if (((int) sbrk(-nbytes)) == -1) {	/* System call failed */
		if (i != -1)					/* Was removed from free list */
			connect_free_list(arena, i);/* Put block back in free list */
		SIGRESUME;						/* End of critical section */
		return -1;						/* Propagate failure */
	}
#else	/* HAS_SBRK */
	eif_free (last_chk);
#endif	/* HAS_SBRK */
#endif /* HAS_SMART_SBRK */

#ifdef DEBUG
#if (!defined HAS_SMART_MMAP) && defined HAS_SBRK
	dprintf(1+2)("free_last_chunk: shrinking succeeded, new break at 0x%lx\n",
		sbrk(0));
	flush;
#endif	/* !HAS_SMART_MMAP && HAS_SBRK */
#endif	/* DEBUG */

	/* The break value was sucessfully lowered. It's now time to update the
	 * internal data structure which keep track of the memory status.
	 */

	m_data.ml_chunk--;
	m_data.ml_total -= nbytes;			/* Counts overhead */
	m_data.ml_over -= sizeof(struct chunk) + OVERHEAD;

	/* The garbage collectors counts the amount of allocated 'to' zones. A limit
	 * is fixed to avoid a nasty memory leak when all the zones used would be
	 * spoilt by frozen objects. However, each time we successfully decrease
	 * the process size by releasing some core, we may allow a new allocation.
	 */

	if (g_data.gc_to > 0)
		g_data.gc_to--;					/* Decrease number of allocated 'to' */

	if (last_chk == cklst.eck_tail) {	/* Chunk was an Eiffel one */
		e_data.ml_chunk--;
		e_data.ml_total -= nbytes;	
		e_data.ml_over -= sizeof(struct chunk) + OVERHEAD;
		cklst.eck_tail = last_desc.ck_lprev;
		if (last_desc.ck_lprev == (struct chunk *) 0)
			cklst.eck_head = (struct chunk *) 0;
	} else {							/* Chunk was a C one */
		c_data.ml_chunk--;
		c_data.ml_total -= nbytes;	
		c_data.ml_over -= sizeof(struct chunk) + OVERHEAD;
		cklst.cck_tail = last_desc.ck_lprev;
		if (last_desc.ck_lprev == (struct chunk *) 0)
			cklst.cck_head = (struct chunk *) 0;
	}

	if (last_desc.ck_lprev != (struct chunk *) 0) {
		if (last_desc.ck_lprev->ck_next == last_chk)
			last_desc.ck_lprev->ck_next = (struct chunk *) 0;
		last_desc.ck_lprev->ck_lnext = (struct chunk *) 0;
	}
	cklst.ck_tail = last_desc.ck_prev;
	if (last_desc.ck_prev == (struct chunk *) 0)
		cklst.ck_head = (struct chunk *) 0;

	/* Now the tail has been updated, update the new last block so that
	 * its ck_next does not point to the removed chunk anymore.
	 * Note that the previous chunk of same type has been updated, but
	 * not the previous chunk (which might not be of same type).
	 * The code is not optmized. I just try to fix a bug here.
	 * It fixes malloc-free-collect-coalesc.
	 * -- Fabrice
	 */

	if (last_desc.ck_prev != (struct chunk *) 0)
	{
		if (last_desc.ck_prev->ck_next == last_chk)
			last_desc.ck_prev->ck_next = (struct chunk *) 0;
	};

	/* The garbage collector keeps track of 'last_from', the latest chunk which
	 * has been scavenged in the partial scavenging collection cycle. If the
	 * chunk we removed was this one, reset the value to a null pointer.
	 */
	if (last_from > last_chk)			/* Last from was held in chunk */
		last_from = (struct chunk *) 0;	/* GC will start over from start */

	/* If the chunk freed was one of the scavenge zones, reset them to their
	 * initial state.
	 */
	if ((EIF_REFERENCE) arena == ps_from.sc_arena) {
		memset (&ps_from, 0, sizeof(struct sc_zone));
	} else if ((EIF_REFERENCE) arena == ps_to.sc_arena) {
		memset (&ps_to, 0, sizeof(struct sc_zone));
	}

	SIGRESUME;							/* Critical section ends */

	return 0;			/* Signals no error */
#endif	/* !HAS_SMART_MMAP && HAS_SBRK && !HAS_SMART_SBRK */
}

/*
doc:	<routine name="set_up" return_type="EIF_REFERENCE" export="private">
doc:		<summary>Given a 'selected' block which may be too big to hold 'nbytes', we set it up to, updating memory accounting infos and setting the correct flags in the malloc info zone (header). We then return the address the user will know (points to the first datum byte).</summary>
doc:		<param name="selected" type="union overhead *">Block of memory which is too big to hold `nbytes'.</param>
doc:		<param name="nbytes" type="unsigned int">Size in bytes of block we should return.</param>
doc:		<return>Address of location of object of size `nbytes' in `selected'.</return>
doc:		<thread_safety>Not safe</thread_safety>
doc:		<synchronization>Safe if caller is synchronized on `eif_free_list_mutex', or under GC synchronization.</synchronization>
doc:	</routine>
*/

rt_private EIF_REFERENCE set_up(register union overhead *selected, unsigned int nbytes)
{
	RT_GET_CONTEXT
	register2 uint32 r;		/* For temporary storage */
	register3 uint32 i;		/* To store true size */

#ifdef DEBUG
	dprintf(8)("set_up: selected is 0x%lx (%s, %d bytes)\n",
		selected, selected->ov_size & B_LAST ? "last" : "normal",
		selected->ov_size & B_SIZE);
	flush;
#endif

	SIGBLOCK;				/* Critical section, cannot be interrupted */

	(void) eif_rt_split_block(selected, nbytes);	/* Eventually split the area */

	/* The 'selected' block is now in use and the real size is in
	 * the ov_size area. To mark the block as used, we have to set
	 * two bits in the flags part (block is busy and it is a C block).
	 * Another part of the run-time will overwrite this if Eiffel is
	 * to ever use this object.
	 */
	
	r = selected->ov_size;
#ifdef EIF_TID 
#ifdef EIF_THREADS
    selected->ovs_tid = eif_thr_id; /* tid from eif_thr_context */
#else
    selected->ovs_tid = NULL; /* In non-MT-mode, it is NULL by convention */
#endif  /* EIF_THREADS */
#endif  /* EIF_TID */

	selected->ov_size = r | B_NEW;
	i = r & B_SIZE;						/* Keep only true size */
	m_data.ml_used += i;				/* Account for memory used */
	if (r & B_CTYPE)
		c_data.ml_used += i;
	else {
		e_data.ml_used += i;
#ifdef MEM_STAT
		printf ("Eiffel: %ld used (+%ld) %ld total (set_up)\n",
			e_data.ml_used, i, e_data.ml_total);
#endif
	}

	SIGRESUME;				/* Re-enable signal exceptions */

	/* Now it's done. We return the address of data space, that
	 * is to say (selected + 1) -- yes ! The area holds at least
	 * 'nbytes' (entrance value) of free space.
	 */

#ifdef DEBUG
	dprintf(8)("set_up: returning %s %s block starting at 0x%lx (%d bytes)\n",
		(selected->ov_size & B_CTYPE) ? "C" : "Eiffel",
		(selected->ov_size & B_LAST) ? "last" : "normal",
		(EIF_REFERENCE) (selected + 1), selected->ov_size & B_SIZE);
	flush;
#endif

	return (EIF_REFERENCE) (selected + 1);		/* Free data space */
}

#endif /* ISE_GC */

/*
doc:	<routine name="eif_rt_xfree" export="public">
doc:		<summary>Frees the memory block which starts at 'ptr'. This has to be a pointer returned by eif_rt_xmalloc, otherwise impredictable results will follow... The contents of the block are preserved, though one should not rely on this as it may change without notice.</summary>
doc:		<param name="ptr" type="EIF_REFERENCE">Address of memory to be freed.</param>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>Through `eif_free_list_mutex'.</synchronization>
doc:	</routine>
*/

rt_public void eif_rt_xfree(register EIF_REFERENCE ptr)
{
#ifdef ISE_GC
	uint32 r;					/* For shifting purposes */
	union overhead *zone;		/* The to-be-freed zone */
	uint32 i;					/* Index in hlist */

#ifdef LMALLOC_CHECK
	if (is_in_lm (ptr))
		fprintf (stderr, "Warning: try to eif_rt_xfree a malloc'ed ptr\n");
#endif	/* LMALLOC_CHECK */
	zone = ((union overhead *) ptr) - 1;	/* Walk backward to header */
	r = zone->ov_size;						/* Size of block */

	/* If the bloc is in the generation scavenge zone, nothing has to be done.
	 * This is easy to detect because objects in the scavenge zone have the
	 * B_BUSY bit reset. Testing for that bit will also enable the routine
	 * to return immediately if the address of a free block is given.
	 */
	if (!(r & B_BUSY))
		return;				/* Nothing to be done */

	GC_THREAD_PROTECT(EIF_FREE_LIST_MUTEX_LOCK);

	/* Memory accounting */
	i = r & B_SIZE;				/* Amount of memory released */
	m_data.ml_used -= i;		/* At least this is free */
	if (r & B_CTYPE)
		c_data.ml_used -= i;
	else {
		e_data.ml_used -= i;
#ifdef MEM_STAT
	printf ("Eiffel: %ld used (-%ld), %ld total (eif_rt_xfree)\n",
		e_data.ml_used, i, e_data.ml_total);
#endif
	}

#ifdef DEBUG
	dprintf(1)("eif_rt_xfree: on a %s %s block starting at 0x%lx (%d bytes)\n",
		(zone->ov_size & B_LAST) ? "last" : "normal",
		(zone->ov_size & B_CTYPE) ? "C" : "Eiffel",
		ptr, zone->ov_size & B_SIZE);
	flush;
	if (DEBUG & 128) {					/* Print type and class name */
		EIF_REFERENCE obj = (EIF_REFERENCE) (zone + 1);
		if (zone->ov_size & B_FWD)		/* Object was forwarded */
			obj = zone->ov_fwd;
		if (!(HEADER(obj)->ov_flags & EO_C))
			printf("eif_rt_xfree: %s object [%d]\n",
				System(Dtype(obj)).cn_generator, Dtype(obj));
	}
	flush;
#endif

	/* Now put back in the free list a memory block starting at `zone', of
	 * size 'r' bytes.
	 */
	xfreeblock(zone, r);

	GC_THREAD_PROTECT(EIF_FREE_LIST_MUTEX_UNLOCK);

#ifdef DEBUG
	dprintf(8)("eif_rt_xfree: %s %s block starting at 0x%lx holds %d bytes free\n",
		(zone->ov_size & B_LAST) ? "last" : "normal",
		(zone->ov_size & B_CTYPE) ? "C" : "Eiffel",
		ptr, zone->ov_size & B_SIZE);
#endif
#else
	free(ptr);
#endif
}

/*
doc:	<routine name="eif_rt_xcalloc" export="public">
doc:		<summary>Allocate space for 'nelem' elements of 'elsize' bytes and set the new space with zeros. This is NEVER used by the Eiffel run time but it is provided to keep the C interface with the standard malloc package.</summary>
doc:		<param name="nelem" type="unsigned int">Number of elements to allocate.</param>
doc:		<param name="elsize" type="unsigned int">Size of element.</param>
doc:		<return>New block of memory of size nelem * elsize if successful, otherwise null pointer.</return>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>Handled by `eif_rt_xmalloc'.</synchronization>
doc:	</routine>
*/

rt_public EIF_REFERENCE eif_rt_xcalloc(unsigned int nelem, unsigned int elsize)
{
#ifdef ISE_GC
	register1 unsigned int nbytes;	/* Number of bytes requested */
	register2 EIF_REFERENCE allocated;		/* Address of new arena */

	nbytes = nelem * elsize;
	allocated = eif_rt_xmalloc(nbytes, C_T, GC_ON);	/* Ask for C space */

	if (allocated != (EIF_REFERENCE) 0) {
		memset (allocated, 0, nbytes);		/* Fill arena with zeros */
	}

	return allocated;		/* Pointer to new zero-filled zone */
#else
	return (EIF_REFERENCE) calloc(nelem, elsize);
#endif
}

#ifdef ISE_GC
/*
doc:	<routine name="xfreeblock" export="private">
doc:		<summary>Put the memory block starting at 'zone' into the free_list. Note that zone points at the beginning of the memory block (beginning of the header) and not at an object data area.</summary>
doc:		<param name="zone" type="union overhead *">Zone to be freed.</param>
doc:		<param name="r" type="uint32">Size of block.</param>
doc:		<thread_safety>Not safe</thread_safety>
doc:		<synchronization>Safe if caller holds `eif_free_list_mutex' or is under GC synchronization.</synchronization>
doc:	</routine>
*/

rt_private void xfreeblock(union overhead *zone, uint32 r)
{
	RT_GET_CONTEXT
	register2 uint32 i;					/* Index in hlist */
#ifndef EIF_MALLOC_OPTIMIZATION
	register5 uint32 size;				/* Size of the coalesced block */
#endif

	SIGBLOCK;					/* Critical section starts */

	/* The block will be inserted in the sorted hashed free list.
	 * The current size is fetched from the header. If the block
	 * is not the last one in a chunk, we check the next one. If
	 * it happens to be free, then we do coalescing. And so on...
	 */
	
#ifndef EIF_MALLOC_OPTIMIZATION
	while ((size = coalesc(zone)))	/* Perform coalescing as long as possible */
		r += size;					/* And upadte size of block */
#endif	/* EIF_MALLOC_OPTIMIZATION */
		
	/* Now 'zone' points to the block to be freed, and 'r' is the
	 * size (eventually, this is a coalesced block). Reset all the
	 * flags but B_LAST and put the block in the free list again.
	 */

	i = zone->ov_size & ~B_SIZE;	/* Save flags */
	r &= B_SIZE;					/* Clear all flags */
	zone->ov_size = r | (i & (B_LAST | B_CTYPE));	/* Save size B_LAST & type */

	i = HLIST_INDEX(r);
	connect_free_list(zone, i);		/* Insert block in free list */

	SIGRESUME;					/* Critical section ends */
}
#endif

/*
doc:	<routine name="crealloc" return_type="EIF_REFERENCE" export="shared">
doc:		<summary>This is the C interface with xrealloc, which is fully compatible with the realloc() function in the standard C library (excepted that no storage compaction is done). The function simply calls xrealloc with garbage collection turned on.</summary>
doc:		<param name="ptr" type="EIF_REFERENCE">Address that will be reallocated.</param>
doc:		<param name="nbytes" type="unsigned int">New size in bytes of `ptr'.</param>
doc:		<return>New block of memory of size `nbytes', otherwise null pointer or throw an exception.</return>
doc:		<exception>"No more memory" exception</exception>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>None required</synchronization>
doc:	</routine>
*/

rt_shared EIF_REFERENCE crealloc(EIF_REFERENCE ptr, unsigned int nbytes)
{
	
#ifdef ISE_GC
	return xrealloc(ptr, nbytes, GC_ON);
#else
	return (EIF_REFERENCE) realloc(ptr, nbytes);
#endif
}

/*
doc:	<routine name="xrealloc" return_type="EIF_REFERENCE" export="shared">
doc:		<summary>Modify the size of the block pointed to by 'ptr' to 'nbytes'. The 'storage compaction' mechanism mentionned in the old malloc man page is not implemented (i.e the 'ptr' block has to be an allocated block, and not a freed block). If 'gc_flag' is GC_ON, then the GC is called when mallocing a new block. If GC_FREE is activated, then no free is performed: the GC will take care of the object (this is crucial when reallocing an object which is part of the moved set).</summary>
doc:		<param name="ptr" type="EIF_REFERENCE">Address that will be reallocated.</param>
doc:		<param name="nbytes" type="unsigned int">New size in bytes of `ptr'.</param>
doc:		<param name="gc_flag" type="nbytes">New size in bytes of `ptr'.</param>
doc:		<return>New block of memory of size `nbytes', otherwise null pointer or throw an exception.</return>
doc:		<exception>"No more memory" exception</exception>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>Through `eif_free_list_mutex'.</synchronization>
doc:	</routine>
*/

rt_shared EIF_REFERENCE xrealloc(register EIF_REFERENCE ptr, register unsigned int nbytes, int gc_flag)
{
	RT_GET_CONTEXT
	EIF_GET_CONTEXT
#ifdef ISE_GC
	register1 uint32 r;					/* For shifting purposes */
	register2 uint32 i;					/* Index in free list */
	register3 union overhead *zone;		/* The to-be-reallocated zone */
	EIF_REFERENCE safeptr = NULL;		/* GC-safe pointer */
	int size, size_gain;				/* Gain in size brought by coalesc */
	
#ifdef LMALLOC_CHECK
	if (is_in_lm (ptr))
		fprintf (stderr, "Warning: try to xrealloc a malloc'ed pointer\n");
#endif
	if (nbytes & ~B_SIZE)
		return (EIF_REFERENCE) 0;		/* I guess we can't malloc more than 2^27 */

	zone = HEADER(ptr);

#ifdef DEBUG
	dprintf(16)("realloc: reallocing block 0x%lx to be %d bytes\n",
		zone, nbytes);
	if (zone->ov_flags & EO_SPEC) {
		dprintf(16)("eif_realloc: special has count = %d, elemsize = %d\n",
			RT_SPECIAL_COUNT(ptr), RT_SPECIAL_ELEM_SIZE(ptr));
		if (zone->ov_flags & EO_REF)
			dprintf(16)("realloc: special has object references\n");
	}
	flush;
#endif

	/* First get the size of the block pointed to by 'ptr'. If, by
	 * chance the size is the same or less than the current size,
	 * we won't have to move the block. However, we may have to split
	 * the block...
	 */
	
	r = zone->ov_size & B_SIZE;			/* Size of block */
	i = nbytes % ALIGNMAX;
	if (i != 0)
		nbytes += ALIGNMAX - i;		/* Pad nbytes */

	if (r == nbytes) 			/* Same size, lucky us... */
		return ptr;				/* That's all I wrote */

	GC_THREAD_PROTECT(EIF_FREE_LIST_MUTEX_LOCK);
	SIGBLOCK;					/* Beginning of critical section */

	if (r > nbytes) {			/* New block is smaller */

#ifdef DEBUG
		dprintf(16)("realloc: new size is smaller (%d versus %d bytes)\n",
			nbytes, r);
		flush;
#endif

		r = (uint32) eif_rt_split_block(zone, nbytes);	/* Split block, r holds size */
		if (r == (uint32) -1) {			/* If we did not split it */
			SIGRESUME;					/* Exiting from critical section */
			GC_THREAD_PROTECT(EIF_FREE_LIST_MUTEX_UNLOCK);
			return ptr;					/* Leave block unchanged */
		}
		
		m_data.ml_used -= r + OVERHEAD;	/* Data we lose in realloc */
		if (zone->ov_size & B_CTYPE)
			c_data.ml_used -= r + OVERHEAD;
		else {
#ifdef MEM_STAT
		printf ("Eiffel: %ld used (-%ld), %ld total (xrealloc)\n",
			e_data.ml_used, r + OVERHEAD, e_data.ml_total);
#endif
			e_data.ml_used -= r + OVERHEAD;
		}

#ifdef DEBUG
		dprintf(16)("realloc: shrinked block is now %d bytes (lost %d bytes)\n",
			zone->ov_size & B_SIZE, r + OVERHEAD);
		flush;
#endif

		SIGRESUME;		/* Exiting from critical section */
		GC_THREAD_PROTECT(EIF_FREE_LIST_MUTEX_UNLOCK);
		return ptr;		/* Block address did not change */
	}
	
	/* As we would like to avoid moving the block unless it is
	 * absolutely necessary, we check to see if the block after
	 * us is not, by extraordinary, free.
	 */
	
#ifdef EIF_MALLOC_OPTIMIZATION
	size_gain = 0;
#else	/* EIF_MALLOC_OPTIMIZATION */
	size_gain = 0;
	while ((size = coalesc(zone))) {	/* Perform coalescing as long as possible */
		size_gain += size;
	}
#endif	/* EIF_MALLOC_OPTIMIZATION */

#ifdef DEBUG
	dprintf(16)("realloc: coalescing added %d bytes (block is now %d bytes)\n",
		size_gain, zone->ov_size & B_SIZE);
	flush;
#endif

	/* If the garbage collector is on and the object has some references, then
	 * adter attempting a coalescing we must update the count and copy the old
	 * elemsize, since they are fetched by the garbage collector by first going
	 * to the end of the object and then back by LNGPAD_2. Of course, this
	 * matters only if coalescing has been done, which is indicated by a
	 * non-zero return value from coalesc.
	 */
	
	if (size_gain != 0 && gc_flag & GC_ON && zone->ov_flags & EO_REF)
	{
		EIF_REFERENCE old;				/* Pointer to the old count/elemsize */
		EIF_REFERENCE o_ref;	/* POinter to new count/elemsize */

		o_ref = RT_SPECIAL_INFO_WITH_ZONE(ptr, zone);
		old = ((EIF_REFERENCE) o_ref - size_gain);
			/* Copy old count to new location */
		RT_SPECIAL_COUNT_WITH_INFO(o_ref) = RT_SPECIAL_COUNT_WITH_INFO(old);
			/* And also propagate element size */
		RT_SPECIAL_ELEM_SIZE_WITH_INFO(o_ref) = RT_SPECIAL_ELEM_SIZE_WITH_INFO (old);

#ifdef DEBUG
		dprintf(16)("realloc: progagated count = %d, elemsize = %d\n",
			RT_SPECIAL_COUNT(ptr), RT_SPECIAL_ELEM_SIZE(ptr));
		flush;
#endif
	}

	i = zone->ov_size & B_SIZE;			/* Coalesc modified data in zone */

	if (i >= nbytes) {					/* Total size is ok ? */

		r = i - r;						/* Amount of memory over-used */
		i = (uint32) eif_rt_split_block(zone, nbytes);	/* Split block, i holds size */
		if (i == (uint32) -1) {			/* If we did not split it */
			m_data.ml_used += r;		/* Update memory used */
			if (zone->ov_size & B_CTYPE)
				c_data.ml_used += r;
			else {
				e_data.ml_used += r;
#ifdef MEM_STAT
		printf ("Eiffel: %ld used (+%ld), %ld total (xrealloc)\n",
			e_data.ml_used, r, e_data.ml_total);
#endif
			}

			SIGRESUME;					/* Exiting from critical section */
			GC_THREAD_PROTECT(EIF_FREE_LIST_MUTEX_UNLOCK);
			return ptr;					/* Leave block unsplit */
		}
		
		r -= i + OVERHEAD;				/* Split occurred, overhead unused */
		m_data.ml_used += r;			/* Data we gained in realloc */
		if (zone->ov_size & B_CTYPE)
			c_data.ml_used += r;
		else {
			e_data.ml_used += r;
#ifdef MEM_STAT
		printf ("Eiffel: %ld used (+%ld), %ld total (xrealloc)\n",
			e_data.ml_used, r, e_data.ml_total);
#endif
		}

#ifdef DEBUG
		dprintf(16)("realloc: block is now %d bytes\n",
			zone->ov_size & B_SIZE);
		flush;
#endif

		SIGRESUME;		/* Exiting from critical section */
		GC_THREAD_PROTECT(EIF_FREE_LIST_MUTEX_UNLOCK);
		return ptr;		/* Block address did not change */
	}

	SIGRESUME;			/* End of critical section */
	GC_THREAD_PROTECT(EIF_FREE_LIST_MUTEX_UNLOCK);

	/* If we come here, we have to use malloc/free. I use 'zone' as
	 * a temporary variable, because in fact, pointers returned by
	 * malloc are (union overhead *) cast to (EIF_REFERENCE) and also
	 * because I do not want to declare another register variable.
	 *
	 * There is no need to update the m_data accounting variables,
	 * because malloc and free will do that for us. We allocate the
	 * block from the correct free list, if at all possible.
	 */

	i = (uint32) ((HEADER(ptr)->ov_size & B_C) ? C_T : EIFFEL_T);	/* Best type */

	if (gc_flag & GC_ON) {
		safeptr = ptr;
		if (-1 == RT_GC_PROTECT(safeptr)) {	/* Protect against moves */
			eraise("object reallocation", EN_MEM);	/* No more memory */
			return (EIF_REFERENCE) 0;						/* They ignored it */
		}
	}

	zone = (union overhead *) eif_rt_xmalloc(nbytes, (int) i, gc_flag);

	if (gc_flag & GC_ON) {
		ptr = safeptr;
		RT_GC_WEAN(safeptr);			/* Remove protection */
	}

	/* Keep Eiffel flags. If GC was on, it might have run its cycle during
	 * the reallocation process and the original object might have moved.
	 * In that case, we take the flags from the forwarded address and we
	 * do NOT free the object itself, but its forwarded copy!!
	 */

	if (zone != (union overhead *) 0) {
		memcpy (zone, ptr, r & B_SIZE);	/* Move to new location */
		HEADER(zone)->ov_flags = HEADER(ptr)->ov_flags;		/* Keep Eiffel flags */
		if (!(gc_flag & GC_FREE))		/* Will GC take care of free? */
			eif_rt_xfree(ptr);					/* Free old location */
	} else if (i == EIFFEL_T)			/* Could not reallocate object */
		eraise("object reallocation", EN_MEM);	/* No more memory */
		

#ifdef DEBUG
	if (zone != (union overhead *) 0)
		dprintf(16)("realloc: malloced a new arena at 0x%lx (%d bytes)\n",
			zone, (zone-1)->ov_size & B_SIZE);
	else
		dprintf(16)("realloc: failed for %d bytes, garbage collector %s\n",
			nbytes, gc_flag == GC_OFF ? "off" : "on");
	flush;
#endif

	return (EIF_REFERENCE) zone;		/* Pointer to new arena or 0 if failed */
#else
	return (EIF_REFERENCE) realloc(ptr, nbytes);
#endif
}

#ifdef ISE_GC
/*
doc:	<routine name="meminfo" return_type="struct emallinfo *" export="public">
doc:		<summary>Return the pointer to the static data held in m_data. The user must not corrupt these data. It will be harmless to malloc, however, but may fool the garbage collector. Type selects the kind of information wanted.</summary>
doc:		<param name="type" type="int">Type of memory (M_C or M_EIFFEL or M_ALL) to get info from.</param>
doc:		<return>Pointer to an internal structure used by `malloc.c'.</return>
doc:		<thread_safety>Not Safe</thread_safety>
doc:		<synchronization>Safe if caller holds `eif_free_list_mutex' or is under GC synchronization.</synchronization>
doc:	</routine>
*/

rt_public struct emallinfo *meminfo(int type)
{
	switch(type) {
	case M_C:
		return &c_data;		/* Pointer to static data */
	case M_EIFFEL:
		return &e_data;		/* Pointer to static data */
	}
	
	return &m_data;		/* Pointer to static data */
}

/*
doc:	<routine name="eif_rt_split_block" return_type="int" export="shared">
doc:		<summary>The block 'selected' may be too big to hold only 'nbytes', so it is split and the new block is put in the free list. At the end, 'selected' will hold only 'nbytes'. From the accounting point's of vue, only the overhead is incremented (the split block is assumed to be already free). The function returns -1 if no split occurred, or the length of the split block otherwise (which means it must fit in a signed int, argh!!--RAM). Caller is responsible for issuing a SIGBLOCK before any call to this critical routine.</summary>
doc:		<param name="selected" type="union overhead *">Selected block from which we try to extract a block of `nbytes' bytes.</param>
doc:		<param name="nbytes" type="uint32">Size of block we should retur</param>
doc:		<return>Address of location of object of size `nbytes' in `selected'.</return>
doc:		<thread_safety>Not safe</thread_safety>
doc:		<synchronization>Safe if caller holds `eif_free_list_mutex' or is under GC synchronization.</synchronization>
doc:	</routine>
*/

rt_shared int eif_rt_split_block(register union overhead *selected, register uint32 nbytes)
{
	register5 uint32 flags;				/* Flags of original block */
	register1 uint32 r;					/* For shifting purposes */
	register2 uint32 i;					/* Index in free list */

	/* Compute residual bytes. The flags bits should remain clear */
	i = selected->ov_size & B_SIZE;			/* Hope it will fit in an int */
	r = (uint32) (i - nbytes);				/* Actual usable bytes */

	/* Do the split only if possible */
	if (r < OVERHEAD)
		return -1;				/* Not enough space to split */

	/* Check wether the block we split was the last one in a
	 * chunk. If so, then the remaining will be the last, but
	 * the 'selected' block is no longer the last one anyway.
	 */
	flags = i = selected->ov_size;		/* Optimize for speed, phew !! */
	i &= ~B_SIZE & ~B_LAST;				/* Keep flags but clear B_LAST */
	selected->ov_size = i | nbytes;		/* Block has been split */

	/* Base address of new block (skip overhead and add nbytes) */
	selected = (union overhead *) (((EIF_REFERENCE) (selected+1)) + nbytes);

	r -= OVERHEAD;					/* This is the overhead for split block */
	selected->ov_size = r;			/* Set the size of new block */
	m_data.ml_over += OVERHEAD;		/* Added overhead */
	if (i & B_CTYPE)				/* Holds flags (without B_LAST) */
		c_data.ml_over += OVERHEAD;
	else
		e_data.ml_over += OVERHEAD;

	/* Compute hash index */
	i = HLIST_INDEX(r);

	/* If the block we split was the last one in the chunk, the new block is now
	 * the last one. There is no need to clear the B_BUSY flag, as normally the
	 * size fits in 27 bits, thus the upper 5 bits are clear--RAM.
	 */
	r = selected->ov_size;
	if (flags & B_LAST)
		r |= B_LAST;				/* Mark it last block */
	if (flags & B_CTYPE)
		r |= B_CTYPE;				/* Propagate the information */
	selected->ov_size = r;
	connect_free_list(selected, i);	/* Insert block in free list */

#ifdef DEBUG
	dprintf(32)("eif_rt_split_block: split %s %s block starts at 0x%lx (%d bytes)\n",
		(selected->ov_size & B_LAST) ? "last" : "normal",
		(selected->ov_size & B_CTYPE) ? "C" : "Eiffel",
		selected, selected->ov_size & B_SIZE);
	flush;
#endif

	return r & B_SIZE;			/* Length of split block */
}

/*
doc:	<routine name="coalesc" return_type="int" export="private">
doc:		<summary>Given a zone to be freed, test whether we can do some coalescing with the next block, if it happens to be free. Overhead accounting is updated. It is up to the caller to put the coalesced block back to the free list (in case this is called by a free operation). It is up to the caller to issue a SIGBLOCK prior any call to this critical routine.</summary>
doc:		<param name="zone" type="union overhead *">Starting block from which we are trying to coalesc next block to it, if next block is free.</param>
doc:		<return>Number of new free bytes available (i.e. the size of the coalesced block plus the overhead) or 0 if no coalescing occurred.</return>
doc:		<thread_safety>Not safe</thread_safety>
doc:		<synchronization>Safe if caller holds `eif_free_list_mutex' or is under GC synchronization.</synchronization>
doc:	</routine>
*/

rt_private int coalesc(register union overhead *zone)
{
	register1 uint32 r;					/* For shifting purposes */
	register2 uint32 i;					/* Index in hlist */
	register3 union overhead *next;		/* Pointer to next block */

	i = zone->ov_size;			/* Fetch size and flags */
	if (i & B_LAST)
		return 0;				/* Block is the last one in chunk */

	/* Compute address of next block */
	next = (union overhead *) (((EIF_REFERENCE) zone) + (i & B_SIZE) + OVERHEAD);

	if ((next->ov_size & B_BUSY))
		return 0;				/* Next block is not free */

	r = next->ov_size & B_SIZE;			/* Fetch its size */
	zone->ov_size = i + r + OVERHEAD;	/* Update size (no overflow possible) */
	m_data.ml_over -= OVERHEAD;			/* Overhead freed */
	if (i & B_CTYPE)
		c_data.ml_over -= OVERHEAD;
	else
		e_data.ml_over -= OVERHEAD;
			
#ifdef DEBUG
	dprintf(1)("coalesc: coalescing with a %d bytes %s %s block at 0x%lx\n",
		r, (next->ov_size & B_LAST) ? "last" : "normal",
		(next->ov_size & B_CTYPE) ? "C" : "Eiffel", next);
	flush;
#endif

	/* Now the longest part... We have to find the block we've just merged and
	 * remove it from the free list.
	 */

	/* First, compute the position in hash list */
	i = HLIST_INDEX(r);
	disconnect_free_list(next, i);		/* Remove block from free list */
	
	/* Finally, we set the new coalesced block correctly, checking for last
	 * position. The other flags were kept from the original block.
	 */

	if ((i = next->ov_size) & B_LAST)	/* Next block was the last one */
		zone->ov_size |= B_LAST;		/* So coalesced is now the last one */

#ifdef DEBUG
	dprintf(1)("coalesc: coalescing provided a %s %d bytes %s block at 0x%lx\n",
		zone->ov_size & B_LAST ? "last" : "normal",
		zone->ov_size & B_SIZE,
		zone->ov_size & B_CTYPE ? "C" : "Eiffel", zone);
	flush;
#endif

	return (i & B_SIZE) + OVERHEAD;		/* Number of coalesced free bytes */
}
		
/*
doc:	<routine name="connect_free_list" export="private">
doc:		<summary>The block 'zone' is inserted in the free list #i. This list is sorted by increasing addresses. Although this costs in case of insertions, it can drastically improve performances, because as the malloc routine uses a frist fit in the free list, the objects won't get sparsed in the whole memory. This should limit swapping overhead and enable the process to give memory back to the kernel. It is up to the caller to ensure signal exceptions are blocked when entering in this critical routine.</summary>
doc:		<param name="zone" type="union overhead *">Block to insert in free list #`i'.</param>
doc:		<param name="i" type="uint32">Free list index to insert `zone'.</param>
doc:		<thread_safety>Not safe</thread_safety>
doc:		<synchronization>Safe if caller holds `eif_free_list_mutex' or is under GC synchronization.</synchronization>
doc:	</routine>
*/

rt_private void connect_free_list(register union overhead *zone, register uint32 i)
{
	register1 union overhead *last;		/* Pointer to last block */
	register2 union overhead *p;		/* To walk along free list */
	register4 union overhead **hlist;	/* The free list */
	register5 union overhead **blist;	/* Buffer cache associated with list */

	/* As each block carries its type, we are able to determine which
	 * free list it belongs. This is completely hidden by the interface
	 * with the outside world, isn't that nice? :-)--RAM.
	 */
	hlist = FREE_LIST(zone->ov_size & B_CTYPE);		/* Get right list ptr */
	blist = BUFFER(hlist);							/* And the right cache */

#ifdef DEBUG
	dprintf(64)("connect_free_list: bloc 0x%lx, %d bytes in %s list #%d\n",
		zone, zone->ov_size & B_SIZE,
		zone->ov_size & B_CTYPE ? "C" : "Eiffel", i);
	flush;
#endif

	/* Special checks for the head of the list. I know that k&R forbid
	 * comparaisons between pointers that are not in the same array.
	 * This means a large memory model would have to be chosen on a small
	 * machine.
	 */

	p = hlist[i];		/* Head of list */

	if (!p) {
		zone->ov_next = NULL;	/* First element */
		hlist[i] = zone;
		blist[i] = zone;						/* Update buffer cache */
		return;
	}

	if (zone < p) {
		zone->ov_next = p;			/* Old head */
		hlist[i] = zone;			/* New head */
		blist[i] = zone;			/* Update buffer cache */
		return;
	}

	/* General case: we have to scan the list to find the right place for
	 * inserting our block. With the help of the buffer cache, we may not
	 * have to scan all the list, hopefully--RAM.
	 */

	if (zone > blist[i]) {			/* We can consider starting from here */
		p = blist[i];
		if (p == (union overhead *) 0)
			p = hlist[i];			/* But not if it is a null pointer */
	}

	for (last = p, p = p->ov_next; p; last = p, p = p->ov_next)
		if (zone < p) {
			zone->ov_next = p;				/* 'zone' is before 'p' */
			last->ov_next = zone;			/* and after 'last' */
			blist[i] = zone;				/* Record insertion point */
			return;
		}

	/* If we come here, then we reached the end of the list without
	 * being able to insert the element. Thus, insertion takes place
	 * at the tail. */
	
	last->ov_next = zone;
	zone->ov_next = (union overhead *) 0;	/* Last element in list */

	blist[i] = zone;						/* Record last insertion point */
}

/*
doc:	<routine name="disconnect_free_list" export="private">
doc:		<summary>Removes block pointed to by 'next' from free list #i. Note that we do not take advantage of the sorting of the free list, because the block has to be found. If it is not, then the free list has been corrupted. It is up to the caller to ensure signal exceptions are blocked when entering in this critical routine.</summary>
doc:		<param name="next" type="union overhead *">Block to remove from free list #`i'.</param>
doc:		<param name="i" type="uint32">Free list index to remove `next'.</param>
doc:		<thread_safety>Not safe</thread_safety>
doc:		<synchronization>Safe if caller holds `eif_free_list_mutex' or is under GC synchronization.</synchronization>
doc:	</routine>
*/

rt_private void disconnect_free_list(register union overhead *next, register uint32 i)
{
	register3 union overhead *p;		/* To walk along free list */
	register4 union overhead **hlist;	/* The free list */
	register5 union overhead **blist;	/* Associated buffer cache */

	/* As each block carries its type, we are able to determine which free
	 * list it belongs. This is completely hidden by the interface with
	 * the outside world, and, as mentionned before, I love it :-)--RAM.
	 */
	hlist = FREE_LIST(next->ov_size & B_CTYPE);		/* Get right list ptr */
	blist = BUFFER(hlist);							/* And associated cache */

#ifdef DEBUG
	dprintf(64)("disconnect_free_list: bloc 0x%lx, %d bytes in %s list #%d\n",
		next, next->ov_size & B_SIZE,
		next->ov_size & B_CTYPE ? "C" : "Eiffel", i);
	flush;
#endif

	/* To avoid the cost of an extra variable, look whether it is in hlist[i]
	 * first. That way, we will be able to test only for the next field in the
	 * loop and still have a pointer on current, so that we can update the list.
	 */
	if (next != hlist[i]) {
		p = blist[i];				/* Cached value = location of last op */
		if ((!p) || (next <=p))		/* Is it ok ? */
			p = hlist[i];			/* No, it is before the cached location */
		for (; p; p = p->ov_next) {
			if (p->ov_next == next) {			/* Next block is ok */
				p->ov_next = next->ov_next;		/* Remove from free list */
				blist[i] = p;					/* Last operation */
				break;							/* Exit from loop */
			}
		}

			/* Consistency check: we MUST have found the block.
			 * Otherwise, it is a fatal error. */
		CHECK ("p not null", p != NULL);
#ifdef DEBUG
		printf("Uh-Oh... Item 0x%lx not found in %s list #%d\n",
			next, next->ov_size & B_CTYPE ? "C" : "Eiffel", i);
		printf("Dumping of list:\n");
		for (p = hlist[i]; p; p = p->ov_next)
			printf("\t0x%lx\n", p);
#endif

	} else {
		hlist[i] = hlist[i]->ov_next;
		blist[i] = hlist[i];		/* Record last operation on free list */
	}
}

/*
doc:	<routine name="lxtract" export="shared">
doc:		<summary>Remove 'next' from the free list. This routine is used by the garbage collector, and thus it is visible from the outside world, hence the cryptic name for portability--RAM. Note that the garbage collector performs with signal exceptions blocked.</summary>
doc:		<param name="next" type="union overhead *">Block to remove from free list.</param>
doc:		<thread_safety>Not safe</thread_safety>
doc:		<synchronization>Safe under GC synchronization.</synchronization>
doc:	</routine>
*/

rt_shared void lxtract(union overhead *next)
{
	register1 uint32 r;				/* For shifting purposes */
	register2 uint32 i;				/* Index in H-list (free list) */

	r = next->ov_size & B_SIZE;		/* Pure size of block */
	i = HLIST_INDEX(r);				/* Compute hash index */
	disconnect_free_list(next, i);	/* Remove from free list */
}

/*
doc:	<routine name="chunk_coalesc" return_type="int" export="shared">
doc:		<summary>Do block coalescing inside the chunk wherever possible.</summary>
doc:		<param name="c" type="struct chunk *">Block to remove from free list.</param>
doc:		<return>Size of the largest coalesced block or 0 if no coalescing occurred.</return>
doc:		<thread_safety>Not safe</thread_safety>
doc:		<synchronization>Safe under GC synchronization.</synchronization>
doc:	</routine>
*/

rt_shared int chunk_coalesc(struct chunk *c)
{
	RT_GET_CONTEXT
	register3 union overhead *zone;	/* Malloc info zone */
	register4 uint32 flags;			/* Malloc flags */
	register2 uint32 i;				/* Index in free list */
	register1 uint32 r;				/* For shifting purposes */
	register5 uint32 old_i;			/* To save old index in free list */
	register6 int max_size = 0;		/* Size of biggest coalesced block */

	SIGBLOCK;			/* Take no risks with signals */

	for (
		zone = (union overhead *) (c + 1);	/* First malloc block */
		/* empty */;
		zone = (union overhead *)
			(((EIF_REFERENCE) (zone + 1)) + (flags & B_SIZE))
	) {
		flags = zone->ov_size;		/* Size and flags */

#ifdef DEBUG
		dprintf(32)("chunk_coalesc: %s block 0x%lx, %d bytes, %s\n",
			flags & B_LAST ? "last" : "normal",
			zone, flags & B_SIZE,
			flags & B_BUSY ?
			(flags & B_C ? "busy C" : "busy Eiffel") : "free");
		flush;
#endif

		if (flags & B_LAST)
			break;					/* Last block reached */
		if (flags & B_BUSY)			/* Block is busy */
			continue;				/* Skip block */

		/* In case we are coalescsing a block, we have to store the
		 * free list to which it belongs, so that we can remove it
		 * if necessary (i.e. if its size changes).
		 */
		r = flags & B_SIZE;		/* Pure size */
		i = HLIST_INDEX(r);

		while (!(zone->ov_size & B_LAST)) {		/* Not last block */
			if (0 == coalesc(zone))
				break;					/* Could not merge block */
		}
		flags = zone->ov_size;			/* Possible coalesced block */

		/* Check whether coalescing occurred. If so, we have to remove
		 * 'zone' from list #i and then put it back to a possible
		 * different list. Also update the size of the biggest coalesced
		 * block. This value should help malloc in its decisions--RAM.
		 */
		if (r != (flags & B_SIZE)) {			/* Size changed */

			/* Compute new list number for coalesced block */
			old_i = i;					/* Save old index */
			r = flags & B_SIZE;			/* Size of coalesced block */
			if (max_size < (int) r)
				max_size = r;			/* Update maximum size yielded */
			i = HLIST_INDEX(r);

			/* Do the update only if necessary */
			if (old_i != i) {
				disconnect_free_list(zone, old_i);	/* Remove (old list) */
				connect_free_list(zone, i);			/* Add in new list */
			}
		}

		if (flags & B_LAST)				/* We reached last malloc block */
			break;						/* Finished for that block */
	}

	SIGRESUME;				/* Restore signal handling */

#ifdef DEBUG
	dprintf(32)("chunk_coalesc: %d bytes is the largest coalesced block\n",
		max_size);
	flush;
#endif

	return max_size;		/* Maximum size of coalesced block or 0 */
}

/*
doc:	<routine name="full_coalesc" return_type="int" export="shared">
doc:		<summary>Same as `full_coalesc_unsafe' except it is a safe thread version.</summary>
doc:		<param name="chunk_type" type="int">Type of chunk on which we perform coalescing (C_T, EIFFEL_T or ALL_T).</param>
doc:		<return>Size of the largest block made available by coalescing, or 0 if no coalescing ever occurred.</return>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>Through `eif_free_list_mutex'.</synchronization>
doc:	</routine>
*/

rt_shared int full_coalesc (int chunk_type)
{
	int result;
	GC_THREAD_PROTECT(EIF_FREE_LIST_MUTEX_LOCK);
	result = full_coalesc_unsafe (chunk_type);
	GC_THREAD_PROTECT(EIF_FREE_LIST_MUTEX_UNLOCK);
	return result;
}

/*
doc:	<routine name="full_coalesc_unsafe" return_type="int" export="shared">
doc:		<summary>Walks through the designated chunk list (type 'chunk_type') and do block coalescing wherever possible.</summary>
doc:		<param name="chunk_type" type="int">Type of chunk on which we perform coalescing (C_T, EIFFEL_T or ALL_T).</param>
doc:		<return>Size of the largest block made available by coalescing, or 0 if no coalescing ever occurred.</return>
doc:		<thread_safety>Not safe</thread_safety>
doc:		<synchronization>Safe if caller holds `eif_free_list_mutex' or is under GC synchronization.</synchronization>
doc:	</routine>
*/

rt_private int full_coalesc_unsafe(int chunk_type)
{
	register1 struct chunk *c;		/* To walk along chunk list */
	register2 int max_size = 0;		/* Size of biggest coalesced block */
	register3 int max_coalesced;	/* Size of coalesced block in a chunk */

	/* Choose the correct head for the list depending on the memory type.
	 * If ALL_T is used, then the whole memory is scanned and coalesced.
	 */

	switch (chunk_type) {
	case C_T:						/* Only walk through the C chunks */
		c = cklst.cck_head;
		break;
	case EIFFEL_T:					/* Only walk through the Eiffel chunks */
		c = cklst.eck_head;
		break;
	case ALL_T:						/* Walk through all the memory */
		c = cklst.ck_head;
		break;
	default:
		return -1;					/* Invalid request */
	}
 
	for (
		/* empty */;
		c != (struct chunk *) 0;
		c = chunk_type == ALL_T ? c->ck_next : c->ck_lnext
	) {
	
#ifdef DEBUG
		dprintf(1+32)("full_coalesc_unsafe: entering %s chunk 0x%lx (%d bytes)\n",
			c->ck_type == C_T ? "C" : "Eiffel", c, c->ck_length);
		flush;
#endif

		max_coalesced = chunk_coalesc(c);	/* Deal with the chunk */
		if (max_coalesced > max_size)		/* Keep track of largest block */
			max_size = max_coalesced;
	}

#ifdef DEBUG
	dprintf(1+8+32)("full_coalesc_unsafe: %d bytes is the largest coalesced block\n",
		max_size);
	flush;
#endif

	return max_size;		/* Maximum size of coalesced block or 0 */
}

/*
doc:	<routine name="trigger_smart_gc_cycle" return_type="int" export="private">
doc:		<summary>Launch a GC cycle. If we have allocated more than `th_alloc' then we perform an automatic collection, otherwise we try a simple generation scavenging. If we are under the control of a complete synchronization, we do not try to acquire mutex. This is useful for `retrieve' which blocks all threads but if one is blocked in here through a lock on `trigger_gc_mutex' then we end up with a dead lock, where actually we didn't need to hold the `trigger_gc_mutex'.</summary>
doc:		<return>1 if collection was successful, 0 otherwise.</return>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>Through `eiffel_usage_mutex' for getting value of `eiffel_usage'.</synchronization>
doc:	</routine>
*/

rt_private int trigger_smart_gc_cycle (void)
{
	RT_GET_CONTEXT
	int result = 0;

#ifdef EIF_THREADS
	if (gc_thread_status == EIF_THREAD_GC_RUNNING) {
#endif
		if (eiffel_usage > th_alloc) {
			if (0 == acollect()) {
				result = 1;
			}
		} else if (0 == collect()) {
			result = 1;
		}
		return result;
#ifdef EIF_THREADS
	} else if (thread_can_launch_gc) {
		long e_usage;
		EIF_ENTER_C;
		TRIGGER_GC_LOCK;
		EIFFEL_USAGE_MUTEX_LOCK;
		e_usage = eiffel_usage;
		EIFFEL_USAGE_MUTEX_UNLOCK;
		if (e_usage > th_alloc) {	/* Above threshold */
			if (0 == acollect()) {		/* Perform automatic collection */
				result = 1;
			}
		} else if (0 == collect()) {	/* Simple generation scavenging */
			result = 1;
		}
		TRIGGER_GC_UNLOCK;
		EIF_EXIT_C;
		return result;
	} else {
		return result;
	}
#endif
}

/*
doc:	<routine name="trigger_gc_cycle" return_type="int" export="private">
doc:		<summary>Launch a GC cycle. If we have allocated more than `th_alloc' then we perform an automatic collection. If we are under the control of a complete synchronization, we do not try to acquire mutex. This is useful for `retrieve' which blocks all threads but if one is blocked in here through a lock on `trigger_gc_mutex' then we end up with a dead lock, where actually we didn't need to hold the `trigger_gc_mutex'.</summary>
doc:		<return>1 if collection was successful, 0 otherwise</return>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>Through `eiffel_usage_mutex' for getting value of `eiffel_usage'.</synchronization>
doc:	</routine>
*/

rt_private int trigger_gc_cycle (void)
{
	RT_GET_CONTEXT
	int result = 0;
#ifdef EIF_THREADS
	if (gc_thread_status == EIF_THREAD_GC_RUNNING) {
#endif
		if (eiffel_usage > th_alloc) {
			if (0 == acollect()) {
				result = 1;
			}
		}
		return result;
#ifdef EIF_THREADS
	} else if (thread_can_launch_gc) {
		long e_usage;
		EIF_ENTER_C;
		TRIGGER_GC_LOCK;
		EIFFEL_USAGE_MUTEX_LOCK;
		e_usage = eiffel_usage;
		EIFFEL_USAGE_MUTEX_UNLOCK;
		if (e_usage > th_alloc) {	/* Above threshold */
			if (0 == acollect()) {		/* Perform automatic collection */
				result = 1;
			}
		}
		TRIGGER_GC_UNLOCK;
		EIF_EXIT_C;
		return result;
	} else {
		return 0;
	}
#endif
}

/*
doc:	<routine name="malloc_from_zone" return_type="EIF_REFERENCE" export="private">
doc:		<summary>Try to allocate 'nbytes' in the scavenge zone. Returns a pointer to the object's location or a null pointer if an error occurred.</summary>
doc:		<param name="nbytes" type="unsigned int">Size in bytes of zone to allocated.</param>
doc:		<return>Address of a block in scavenge zone if successful, null pointer otherwise.</return>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>Through `eif_gc_gsz_mutex'.</synchronization>
doc:	</routine>
*/

rt_private EIF_REFERENCE malloc_from_zone(unsigned int nbytes)
{
	RT_GET_CONTEXT
	EIF_REFERENCE object;	/* Address of the allocated object */

	REQUIRE("Scavenging enabled", gen_scavenge == GS_ON);
	REQUIRE("Has from zone", sc_from.sc_arena);
	REQUIRE("nbytes properly padded", (nbytes % ALIGNMAX) == 0);
	
	/* Allocating from a scavenging zone is easy and fast. It's basically a
	 * pointer update... However, if the level in the 'from' zone reaches
	 * the watermark GS_WATERMARK, we return NULL immediately, it is up to
	 * the caller to decide whether or not he will run the generation scavenging
	 * The tenuring threshold for the next scavenge is computed to make the level
	 * of occupation go below the watermark at the next collection so that
	 * the next call to `malloc_from_zone' is most likely to succeed.
	 * 
	 * Aslo, if there is not enough space in the scavenge zone, we need to return
	 * immediately.
	 */
	GC_THREAD_PROTECT(EIF_GC_GSZ_LOCK);

	object = sc_from.sc_top;				/* First eif_free location */

	if ((object >= sc_from.sc_mark) || ((ALIGNMAX + nbytes + object) > sc_from.sc_end)) {
		GC_THREAD_PROTECT(EIF_GC_GSZ_UNLOCK);
		return NULL;
	}

	SIGBLOCK;								/* Block signals */
	sc_from.sc_top += nbytes + ALIGNMAX;	/* Update free-location pointer */
	((union overhead *) object)->ov_size = nbytes;	/* All flags cleared */

	/* No account for memory used is to be done. The memory used by the two
	 * scavenge zones is already considered to be in full use.
	 */

#ifdef DEBUG
	dprintf(4)("malloc_from_zone: returning block starting at 0x%lx (%d bytes)\n",
		(EIF_REFERENCE) (((union overhead *) object ) + 1),
		((union overhead *) object)->ov_size);
	flush;
#endif

	SIGRESUME;								/* Restore signal handling */
	GC_THREAD_PROTECT(EIF_GC_GSZ_UNLOCK);

	ENSURE ("Allocated size big enough", nbytes <= (((union overhead *) object)->ov_size & B_SIZE));

	return (EIF_REFERENCE) (((union overhead *) object ) + 1);	/* Free data space */
}

/*
doc:	<routine name="create_scavenge_zones" export="shared">
doc:		<summary>Attempt creation of two scavenge zones: the 'from' zone and the 'to' zone. If it is successful, `gen_scavenge' is set to `GS_ON' otherwise the value remained unchanged and is `GS_OFF'. Upon success, the routine updates the structures accordingly.</summary>
doc:		<thread_safety>Not safe</thread_safety>
doc:		<synchronization>Safe when under GC synchronization or during run-time initialization.</synchronization>
doc:	</routine>
*/

rt_shared void create_scavenge_zones(void)
{
	REQUIRE("Not already allocated", (sc_from.sc_arena == NULL) && (sc_to.sc_arena == NULL));
	REQUIRE("Generation scavenging off", gen_scavenge == GS_OFF);

		/* Initialize `gen_scavenge' to GS_OFF in case it fails to allocate the scavenge zones. */
	if (cc_for_speed) {
		RT_GET_CONTEXT
		EIF_REFERENCE from;		/* From zone */
		EIF_REFERENCE to;		/* To zone */

		/* I think it's best to allocate the spaces in the C list. Firstly, this
		 * space must never be moved, secondly it should never be reclaimed,
		 * excepted when we are low on memory, but then it does not really matters.
		 * Lastly, the garbage collector will simply ignore the block, which is
		 * just fine--RAM.
		 */
		from = eif_rt_xmalloc(eif_scavenge_size, C_T, GC_OFF);
		if (from) {
			to = eif_rt_xmalloc(eif_scavenge_size, C_T, GC_OFF);
			if (!to) {
				eif_rt_xfree(from);
			} else {
					/* Now set up the zones */
				SIGBLOCK;								/* Critical section */
				sc_from.sc_size = sc_to.sc_size = eif_scavenge_size; /* GC statistics */
				sc_from.sc_arena = from;				/* Base address */
				sc_to.sc_arena = to;
				sc_from.sc_top = from;					/* First free address */
				sc_to.sc_top = to;
				sc_from.sc_mark = from + GS_WATERMARK;	/* Water mark (nearly full) */
				sc_to.sc_mark = to + GS_WATERMARK;
				sc_from.sc_end = from + eif_scavenge_size;	/* First free location beyond */
				sc_to.sc_end = to + eif_scavenge_size;
				SIGRESUME;								/* End of critical section */

				gen_scavenge = GS_ON;		/* Generation scavenging activated */
			}
		}
	}

	ENSURE("Correct_value", (gen_scavenge == GS_OFF) || (gen_scavenge == GS_ON));
	ENSURE("Created", !(gen_scavenge == GS_ON) || sc_from.sc_arena && sc_to.sc_arena);
	ENSURE("Not created", (gen_scavenge == GS_ON) || !sc_from.sc_arena && !sc_to.sc_arena);
}

/*
doc:	<routine name="explode_scavenge_zones" export="private">
doc:		<summary>Take a scavenge zone and destroy it letting all the objects held in it go back under the free-list management scheme. The memory accounting has to be done exactely: all the zone was handled as being in use for the statistics, but now we have to account for the overhead used by each stored object...</summary>
doc:		<param name="sc" type="struct sc_zone *">Zone to be freed. Usually the from zone of the 2 scavenge zones.</param>
doc:		<thread_safety>Not safe</thread_safety>
doc:		<synchronization>Safe when under GC synchronization.</synchronization>
doc:	</routine>
*/

rt_private void explode_scavenge_zone(struct sc_zone *sc)
{
	RT_GET_CONTEXT
	register1 uint32 flags;				/* Store some flags */
	register2 union overhead *zone;		/* Malloc info zone */
	register3 union overhead *next;		/* Next zone to be studied */
	register4 uint32 size = 0;			/* Flags to bo OR'ed on each object */
	register5 EIF_REFERENCE top = sc->sc_top;	/* Top in scavenge space */
	register6 int object = 0;			/* Count released objects */

	next = (union overhead *) sc->sc_arena;
	if (next == (union overhead *) 0)
			return;
	zone = next - 1;
	flags = zone->ov_size;

	if (flags & B_CTYPE)				/* This is the usual case */
		size |= B_CTYPE;				/* Scavenge zone is in a C chunk */

	size |= B_BUSY;						/* Every released object is busy */

	/* Loop over the zone and build for each object a header that would have
	 * been given to it if it had been malloc'ed in from the free-list.
	 */

	SIGBLOCK;				/* Beginning of critical section */

	for (zone = next; (EIF_REFERENCE) zone < top; zone = next) {

		/* Set the flags for the new block and compute the location of
		 * the next object in the space.
		 */
		flags = zone->ov_size;
		next = (union overhead *)
			(((EIF_REFERENCE) zone) + (flags & B_SIZE) + OVERHEAD);
		zone->ov_size = flags | size;

		/* The released object belongs to the new generation so add it
		 * to the moved_set. If it is not possible (stack full), abort. We
		 * do that because there should be room as the 'to' space should have
		 * been released before exploding the 'from' space, thus leaving
		 * room for stack growth.
		 */
		if (-1 == epush(&moved_set, (EIF_REFERENCE) (zone + 1)))
			enomem(MTC_NOARG);					/* Critical exception */
		zone->ov_flags |= EO_NEW;		/* Released object is young */
		object++;						/* One more released object */
	}

#ifdef MAY_PANIC
	/* Consitency check. We must have reached the top of the zone */
	if ((EIF_REFERENCE) zone != top)
		eif_panic("scavenge zone botched");
#endif

	/* If we did not reach the end of the scavenge zone, then there is at
	 * least some room for one header. We're going to fake a malloc block and
	 * call eif_rt_xfree() to release it.
	 */

	if ((EIF_REFERENCE) zone != sc->sc_end) {

		/* Everything from 'zone' to the end of the scavenge space is now free.
		 * Set up a normal busy block before calling eif_rt_xfree. If the scavenge zone
		 * was the last block in the chunk, then this remaining space is the
		 * last in the chunk too, so set the flags accordingly.
		 */
	
		zone->ov_size = size | (sc->sc_end - (EIF_REFERENCE) (zone + 1));
		next = HEADER(sc->sc_arena);
		if (next->ov_size & B_LAST)		/* Scavenge zone was a last block ? */
			zone->ov_size |= B_LAST;	/* So is it for the remainder */

#ifdef DEBUG
		dprintf(1)("explode_scavenge_zone: remainder is a %s%d bytes bloc\n",
			zone->ov_size & B_LAST ? "last " : "", zone->ov_size & B_SIZE);
		flush;
#endif

		eif_rt_xfree((EIF_REFERENCE) (zone + 1));			/* Put remainder back to free-list */
		object++;							/* One more released block */
	} else
		next = HEADER(sc->sc_arena);	/* Point to the header of the arena */

	/* Freeing the header of the arena (the scavenge zone) is easy. We fake a
	 * zero length block and call free on it. Note that this does not change
	 * statistics at all: this overhead was already accounted for and it remains
	 * an overhead.
	 */

	next->ov_size = size;				/* A zero length bloc */
	eif_rt_xfree((EIF_REFERENCE) (next + 1));			/* Free header of scavenge zone */

	/* Update the statistics: we released 'object' blocks, so we created that
	 * amount of overhead. Note that we do not have to change the amount of
	 * memory used.
	 */

	flags = object * OVERHEAD;			/* Amount of "added" overhead space */
	m_data.ml_over += flags;
	if (size & B_CTYPE)					/* Scavenge zone in a C chunk */
		c_data.ml_over += flags;
	else								/* Scavenge zone in an Eiffel chunk */
		e_data.ml_over += flags;

	SIGRESUME;							/* End of critical section */
}

/*
doc:	<routine name="sc_stop" export="shared">
doc:		<summary>Stop the scavenging process by freeing the zones. In MT mode, it forces a GC synchronization as some threads might be still running and trying to allocated in the scavenge zone.</summary>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>Through GC synchronization.</synchronization>
doc:	</routine>
*/

rt_shared void sc_stop(void)
{
	RT_GET_CONTEXT
	GC_THREAD_PROTECT(eif_synchronize_gc(rt_globals));
	gen_scavenge = GS_OFF;				/* Generation scavenging is off */
	eif_rt_xfree(sc_to.sc_arena);				/* This one is completely eif_free */
	explode_scavenge_zone(&sc_from);	/* While this one has to be exploded */
	st_reset (&memory_set);
		/* Reset values to their default value */
	memset (&sc_to, 0, sizeof(struct sc_zone));
	memset (&sc_from, 0, sizeof(struct sc_zone));
	GC_THREAD_PROTECT(eif_unsynchronize_gc(rt_globals));
}
#endif

/*
doc:	<routine name="eif_set" return_type="EIF_REFERENCE" export="private">
doc:		<summary>Set an Eiffel object for use: reset the zone with zeros, and try to record the object inside the moved set, if necessary. The function returns the address of the object (it may move if a GC cycle is raised).</summary>
doc:		<param name="object" type="EIF_REFERENCE">Object to setup.</param>
doc:		<param name="dftype" type="uint32">Full dynamic type of object to setup.</param>
doc:		<param name="dtype" type="uint32">Dynamic type of object to setup.</param>
doc:		<return>New value of `object' as this routine can trigger a GC cycle</return>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>None required</synchronization>
doc:	</routine>
*/

rt_private EIF_REFERENCE eif_set(EIF_REFERENCE object, uint32 dftype, uint32 dtype)
{
	RT_GET_CONTEXT
	register3 union overhead *zone = HEADER(object);		/* Object's header */
	register4 void *(*init)(EIF_REFERENCE, EIF_REFERENCE);	/* The optional initialization */

	SIGBLOCK;					/* Critical section */
	memset (object, 0, zone->ov_size & B_SIZE);		/* All set with zeros */

#ifdef EIF_TID 
#ifdef EIF_THREADS
    zone->ovs_tid = eif_thr_id; /* tid from eif_thr_context */
#else
    zone->ovs_tid = NULL; /* In non-MT-mode, it is NULL by convention */
#endif  /* EIF_THREADS */
#endif  /* EIF_TID */

	zone->ov_size &= ~B_C;		/* Object is an Eiffel one */
	zone->ov_flags = dftype;		/* Set dynamic type */

#ifdef ISE_GC
	if (dftype & EO_NEW) {					/* New object outside scavenge zone */
		object = add_to_stack (object, &moved_set);
	}
	if (Disp_rout(dtype)) {
			/* Special marking of MEMORY object allocated in scavenge zone */
		if (!(dftype & EO_NEW)) {
			object = add_to_stack (object, &memory_set);
		}
		zone->ov_flags |= EO_DISP;
	}
#endif

	/* If the object has an initialization routine, call it now. This routine
	 * is in charge of setting some other flags like EO_COMP and initializing
	 * of expanded inter-references.
	 */


	init = (void *(*) (EIF_REFERENCE, EIF_REFERENCE)) XCreate(dtype);
	if (init) {
		EIF_GET_CONTEXT
		DISCARD_BREAKPOINTS
		RT_GC_PROTECT(object);
		(init)(object, object);
		RT_GC_WEAN(object);
		UNDISCARD_BREAKPOINTS
	}

	SIGRESUME;					/* End of critical section */

#ifdef DEBUG
	dprintf(256)("eif_set: %d bytes for DT %d at 0x%lx%s\n",
		zone->ov_size & B_SIZE, dftype & EO_TYPE, object, dftype & EO_NEW ? " (new)" : "");
	flush;
#endif

	return object;
}

/*
doc:	<routine name="eif_spset" return_type="EIF_REFERENCE" export="private">
doc:		<summary>Set the special Eiffel object for use: reset the zone with zeros. If special object not allocated in scavenge zone, we also try to remember the object (has to be in the new generation outside scavenge zone). The dynamic type of the special object is left blank. It is up to the caller of spmalloc() to set a proper dynamic type. The function returns the location of the object (it may move if a GC cycle has been raised to remember the object).</summary>
doc:		<param name="object" type="EIF_REFERENCE">Special object to setup.</param>
doc:		<param name="in_scavenge" type="EIF_BOOLEAN">Is new special object in scavenge zone?</param>
doc:		<return>New value of `object' as this routine can trigger a GC cycle</return>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>None required</synchronization>
doc:	</routine>
*/

rt_private EIF_REFERENCE eif_spset(EIF_REFERENCE object, EIF_BOOLEAN in_scavenge)
{
	RT_GET_CONTEXT
	register3 union overhead *zone = HEADER(object);		/* Malloc info zone */

	SIGBLOCK;					/* Critical section */
	memset (object, 0, zone->ov_size & B_SIZE);		/* All set with zeros */

#ifdef EIF_TID 
#ifdef EIF_THREADS
    zone->ovs_tid = eif_thr_id; /* tid from eif_thr_context */
#else
    zone->ovs_tid = NULL; /* In non-MT-mode, it is NULL by convention */
#endif  /* EIF_THREADS */
#endif  /* EIF_TID */

	zone->ov_size &= ~B_C;				/* Object is an Eiffel one */

#ifdef ISE_GC
	if (in_scavenge == EIF_FALSE) {
		zone->ov_flags = EO_SPEC | EO_NEW;	/* Object is special and new */
		object = add_to_stack (object, &moved_set);
	} else
#endif
		zone->ov_flags = EO_SPEC;	/* Object is special */

	SIGRESUME;					/* End of critical section */

#ifdef DEBUG
	dprintf(256)("eif_spset: %d bytes special at 0x%lx\n", zone->ov_size & B_SIZE, object);
	flush;
#endif

	return object;
}

#ifdef ISE_GC

/*
doc:	<routine name="add_to_stack" return_type="EIF_REFERENCE" export="private">
doc:		<summary>Add `object' into `stk'.</summary>
doc:		<param name="object" type="EIF_REFERENCE">Object to add in `memory_set'.</param>
doc:		<param name="stk" type="struct stack *">Stack in which we wish to add `object'.</param>
doc:		<return>Location of `object' as it might have moved.</return>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>Through `eif_gc_set_mutex'.</synchronization>
doc:	</routine>
*/

rt_private EIF_REFERENCE add_to_stack (EIF_REFERENCE object, struct stack *stk)
{
		/* Need to discard breakpoint in case GC is called */
	GC_THREAD_PROTECT(EIF_GC_SET_MUTEX_LOCK);
	if (-1 == epush(stk, object)) {		/* Cannot record object */
		GC_THREAD_PROTECT(EIF_GC_SET_MUTEX_UNLOCK);
		urgent_plsc(&object);					/* Full collection */
		GC_THREAD_PROTECT(EIF_GC_SET_MUTEX_LOCK);
		if (-1 == epush(stk, object)) {	/* Still failed */
			GC_THREAD_PROTECT(EIF_GC_SET_MUTEX_UNLOCK);
			enomem(MTC_NOARG);							/* Critical exception */
		} else {
			GC_THREAD_PROTECT(EIF_GC_SET_MUTEX_UNLOCK);
		}
	} else {
		GC_THREAD_PROTECT(EIF_GC_SET_MUTEX_UNLOCK);
	}
	return object;
}

/*
doc:	<routine name="compute_hlist_index" return_type="int32" export="private">
doc:		<summary>Quickly compute the index in the hlist array where we have a chance to find the right block. The idea is to do a right logical shift until the register is zero. The number of shifts done is the base 2 logarithm of 'nbytes'.</summary>
doc:		<param name="size" type="int32">Size of block from which we want to find its associated index in free list.</param>
doc:		<return>Index of free list where block of size `size' will be found.</return>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>None required</synchronization>
doc:	</routine>
*/

rt_private int32 compute_hlist_index (int32 size)
{
	int32 i = HLIST_INDEX_LIMIT;
	int32 n = size;

		/* When we call this routine it means that `size' was bigger or equal to HLIST_SIZE_LIMIT */
	REQUIRE ("Not a precomputed index", size >= HLIST_SIZE_LIMIT);

	n >>= HLIST_DEFAULT_SHIFT;
	while (n >>= 1)
	  i++;
	return i;
}

#endif
/*
doc:</file>
*/
