/*-----------------------------------------------------------
Implemented `IEiffelSystemClusters' Interface.
-----------------------------------------------------------*/

#ifndef __ECOM_EIFFEL_COMPILER_IEIFFELSYSTEMCLUSTERS_IMPL_PROXY_H__
#define __ECOM_EIFFEL_COMPILER_IEIFFELSYSTEMCLUSTERS_IMPL_PROXY_H__
#ifdef __cplusplus
extern "C" {


namespace ecom_eiffel_compiler
{
class IEiffelSystemClusters_impl_proxy;
}

}
#endif

#include "eif_com.h"

#include "eif_eiffel.h"

#include "ecom_eiffel_compiler_IEiffelSystemClusters.h"

#include "ecom_eiffel_compiler_IEnumClusterProp.h"

#include "ecom_eiffel_compiler_IEiffelClusterProperties.h"

#ifdef __cplusplus
extern "C" {
#endif

#ifdef __cplusplus
extern "C" {
namespace ecom_eiffel_compiler
{
class IEiffelSystemClusters_impl_proxy
{
public:
	IEiffelSystemClusters_impl_proxy (IUnknown * a_pointer);
	virtual ~IEiffelSystemClusters_impl_proxy ();

	/*-----------------------------------------------------------
	Last error code
	-----------------------------------------------------------*/
	EIF_INTEGER ccom_last_error_code();


	/*-----------------------------------------------------------
	Last source of exception
	-----------------------------------------------------------*/
	EIF_REFERENCE ccom_last_source_of_exception();


	/*-----------------------------------------------------------
	Last error description
	-----------------------------------------------------------*/
	EIF_REFERENCE ccom_last_error_description();


	/*-----------------------------------------------------------
	Last error help file
	-----------------------------------------------------------*/
	EIF_REFERENCE ccom_last_error_help_file();


	/*-----------------------------------------------------------
	Cluster tree.
	-----------------------------------------------------------*/
	EIF_REFERENCE ccom_cluster_tree(  );


	/*-----------------------------------------------------------
	Cluster in a flat form.
	-----------------------------------------------------------*/
	EIF_REFERENCE ccom_flat_clusters(  );


	/*-----------------------------------------------------------
	Save changes.
	-----------------------------------------------------------*/
	void ccom_store();


	/*-----------------------------------------------------------
	Add a cluster to the project.
	-----------------------------------------------------------*/
	void ccom_add_cluster(  /* [in] */ EIF_OBJECT cluster_name,  /* [in] */ EIF_OBJECT parent_name,  /* [in] */ EIF_OBJECT cluster_path );


	/*-----------------------------------------------------------
	Remove a cluster from the project.
	-----------------------------------------------------------*/
	void ccom_remove_cluster(  /* [in] */ EIF_OBJECT cluster_name );


	/*-----------------------------------------------------------
	Cluster properties.
	-----------------------------------------------------------*/
	EIF_REFERENCE ccom_cluster_properties(  /* [in] */ EIF_OBJECT cluster_name );


	/*-----------------------------------------------------------
	Cluster properties.
	-----------------------------------------------------------*/
	EIF_REFERENCE ccom_cluster_properties_by_id(  /* [in] */ EIF_INTEGER cluster_id );


	/*-----------------------------------------------------------
	Change cluster name.
	-----------------------------------------------------------*/
	void ccom_change_cluster_name(  /* [in] */ EIF_OBJECT a_name,  /* [in] */ EIF_OBJECT a_new_name );


	/*-----------------------------------------------------------
	Checks to see if a cluster name is valid
	-----------------------------------------------------------*/
	EIF_BOOLEAN ccom_is_valid_name(  /* [in] */ EIF_OBJECT cluster_name );


	/*-----------------------------------------------------------
	Retrieves a clusters full name from its name
	-----------------------------------------------------------*/
	EIF_REFERENCE ccom_get_cluster_fullname(  /* [in] */ EIF_OBJECT cluster_name );


	/*-----------------------------------------------------------
	IUnknown interface
	-----------------------------------------------------------*/
	EIF_POINTER ccom_item();



protected:


private:
	/*-----------------------------------------------------------
	Interface pointer
	-----------------------------------------------------------*/
	ecom_eiffel_compiler::IEiffelSystemClusters * p_IEiffelSystemClusters;


	/*-----------------------------------------------------------
	Default IUnknown interface pointer
	-----------------------------------------------------------*/
	IUnknown * p_unknown;


	/*-----------------------------------------------------------
	Exception information
	-----------------------------------------------------------*/
	EXCEPINFO * excepinfo;




};
}
}
#endif

#ifdef __cplusplus
}
#endif
#include "ecom_grt_globals_ISE_c.h"


#endif