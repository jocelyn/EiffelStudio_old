/*-----------------------------------------------------------
Implemented `IEnumClusterProp' Interface.
-----------------------------------------------------------*/

#ifndef __ECOM_EIFFELCOMCOMPILER_IENUMCLUSTERPROP_IMPL_PROXY_S_H__
#define __ECOM_EIFFELCOMCOMPILER_IENUMCLUSTERPROP_IMPL_PROXY_S_H__
#ifdef __cplusplus
extern "C" {


namespace ecom_EiffelComCompiler
{
class IEnumClusterProp_impl_proxy;
}

}
#endif

#include "eif_com.h"

#include "eif_eiffel.h"

#include "ecom_EiffelComCompiler_IEnumClusterProp_s.h"

#include "ecom_EiffelComCompiler_IEiffelClusterProperties_s.h"

#ifdef __cplusplus
extern "C" {
#endif

#ifdef __cplusplus
extern "C" {
namespace ecom_EiffelComCompiler
{
class IEnumClusterProp_impl_proxy
{
public:
	IEnumClusterProp_impl_proxy (IUnknown * a_pointer);
	virtual ~IEnumClusterProp_impl_proxy ();

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
	Go to next item in enumerator
	-----------------------------------------------------------*/
	void ccom_next(  /* [out] */ EIF_OBJECT pp_ieiffel_cluster_properties,  /* [out] */ EIF_OBJECT pul_fetched );


	/*-----------------------------------------------------------
	Skip `ulCount' items.
	-----------------------------------------------------------*/
	void ccom_skip(  /* [in] */ EIF_INTEGER ul_count );


	/*-----------------------------------------------------------
	Reset enumerator.
	-----------------------------------------------------------*/
	void ccom_reset();


	/*-----------------------------------------------------------
	Clone enumerator.
	-----------------------------------------------------------*/
	void ccom_clone1(  /* [out] */ EIF_OBJECT pp_ienum_cluster_prop );


	/*-----------------------------------------------------------
	Retrieve enumerators ith item at `ulIndex'.
	-----------------------------------------------------------*/
	void ccom_ith_item(  /* [in] */ EIF_INTEGER ul_index,  /* [out] */ EIF_OBJECT pp_ieiffel_cluster_properties );


	/*-----------------------------------------------------------
	Retrieve enumerator item count.
	-----------------------------------------------------------*/
	EIF_INTEGER ccom_count(  );


	/*-----------------------------------------------------------
	IUnknown interface
	-----------------------------------------------------------*/
	EIF_POINTER ccom_item();



protected:


private:
	/*-----------------------------------------------------------
	Interface pointer
	-----------------------------------------------------------*/
	ecom_EiffelComCompiler::IEnumClusterProp * p_IEnumClusterProp;


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
#include "ecom_grt_globals_ISE.h"


#endif