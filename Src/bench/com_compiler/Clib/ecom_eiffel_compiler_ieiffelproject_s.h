/*-----------------------------------------------------------
Eiffel Project.  Help file: 
-----------------------------------------------------------*/

#ifndef __ECOM_EIFFEL_COMPILER_IEIFFELPROJECT_S_H__
#define __ECOM_EIFFEL_COMPILER_IEIFFELPROJECT_S_H__
#ifdef __cplusplus
extern "C" {


#ifndef __ecom_eiffel_compiler_IEiffelProject_FWD_DEFINED__
#define __ecom_eiffel_compiler_IEiffelProject_FWD_DEFINED__
namespace ecom_eiffel_compiler
{
class IEiffelProject;
}
#endif

}
#endif

#include "eif_com.h"

#include "eif_eiffel.h"

#ifdef __cplusplus
extern "C" {
#endif

#ifndef __ecom_eiffel_compiler_IEiffelCompiler_FWD_DEFINED__
#define __ecom_eiffel_compiler_IEiffelCompiler_FWD_DEFINED__
namespace ecom_eiffel_compiler
{
class IEiffelCompiler;
}
#endif



#ifndef __ecom_eiffel_compiler_IEiffelSystemBrowser_FWD_DEFINED__
#define __ecom_eiffel_compiler_IEiffelSystemBrowser_FWD_DEFINED__
namespace ecom_eiffel_compiler
{
class IEiffelSystemBrowser;
}
#endif



#ifndef __ecom_eiffel_compiler_IEiffelProjectProperties_FWD_DEFINED__
#define __ecom_eiffel_compiler_IEiffelProjectProperties_FWD_DEFINED__
namespace ecom_eiffel_compiler
{
class IEiffelProjectProperties;
}
#endif



#ifndef __ecom_eiffel_compiler_IEiffelCompletionInfo_FWD_DEFINED__
#define __ecom_eiffel_compiler_IEiffelCompletionInfo_FWD_DEFINED__
namespace ecom_eiffel_compiler
{
class IEiffelCompletionInfo;
}
#endif



#ifndef __ecom_eiffel_compiler_IEiffelHTMLDocGenerator_FWD_DEFINED__
#define __ecom_eiffel_compiler_IEiffelHTMLDocGenerator_FWD_DEFINED__
namespace ecom_eiffel_compiler
{
class IEiffelHTMLDocGenerator;
}
#endif



#ifdef __cplusplus
extern "C" {
#ifndef __ecom_eiffel_compiler_IEiffelProject_INTERFACE_DEFINED__
#define __ecom_eiffel_compiler_IEiffelProject_INTERFACE_DEFINED__
namespace ecom_eiffel_compiler
{
class IEiffelProject : public IUnknown
{
public:
	IEiffelProject () {};
	~IEiffelProject () {};

	/*-----------------------------------------------------------
	Retrieve project.
	-----------------------------------------------------------*/
	virtual STDMETHODIMP retrieve_project(  /* [in] */ BSTR a_project_file_name ) = 0;


	/*-----------------------------------------------------------
	Create new project.
	-----------------------------------------------------------*/
	virtual STDMETHODIMP create_project(  /* [in] */ BSTR an_ace_file_name, /* [in] */ BSTR project_directory_path ) = 0;


	/*-----------------------------------------------------------
	Full path to .epr file.
	-----------------------------------------------------------*/
	virtual STDMETHODIMP project_file_name(  /* [out, retval] */ BSTR * return_value ) = 0;


	/*-----------------------------------------------------------
	Full path to Ace file.
	-----------------------------------------------------------*/
	virtual STDMETHODIMP ace_file_name(  /* [out, retval] */ BSTR * return_value ) = 0;


	/*-----------------------------------------------------------
	Project directory.
	-----------------------------------------------------------*/
	virtual STDMETHODIMP project_directory(  /* [out, retval] */ BSTR * return_value ) = 0;


	/*-----------------------------------------------------------
	Is project valid?
	-----------------------------------------------------------*/
	virtual STDMETHODIMP valid_project(  /* [out, retval] */ VARIANT_BOOL * return_value ) = 0;


	/*-----------------------------------------------------------
	Last error message.
	-----------------------------------------------------------*/
	virtual STDMETHODIMP last_error_message(  /* [out, retval] */ BSTR * return_value ) = 0;


	/*-----------------------------------------------------------
	Compiler.
	-----------------------------------------------------------*/
	virtual STDMETHODIMP compiler(  /* [out, retval] */ ecom_eiffel_compiler::IEiffelCompiler * * return_value ) = 0;


	/*-----------------------------------------------------------
	Has system been compiled?
	-----------------------------------------------------------*/
	virtual STDMETHODIMP is_compiled(  /* [out, retval] */ VARIANT_BOOL * return_value ) = 0;


	/*-----------------------------------------------------------
	Has the project updated since last compilation?
	-----------------------------------------------------------*/
	virtual STDMETHODIMP project_has_updated(  /* [out, retval] */ VARIANT_BOOL * return_value ) = 0;


	/*-----------------------------------------------------------
	System Browser.
	-----------------------------------------------------------*/
	virtual STDMETHODIMP system_browser(  /* [out, retval] */ ecom_eiffel_compiler::IEiffelSystemBrowser * * return_value ) = 0;


	/*-----------------------------------------------------------
	Project Properties.
	-----------------------------------------------------------*/
	virtual STDMETHODIMP project_properties(  /* [out, retval] */ ecom_eiffel_compiler::IEiffelProjectProperties * * return_value ) = 0;


	/*-----------------------------------------------------------
	Completion information
	-----------------------------------------------------------*/
	virtual STDMETHODIMP completion_information(  /* [out, retval] */ ecom_eiffel_compiler::IEiffelCompletionInfo * * return_value ) = 0;


	/*-----------------------------------------------------------
	Help documentation generator
	-----------------------------------------------------------*/
	virtual STDMETHODIMP html_doc_generator(  /* [out, retval] */ ecom_eiffel_compiler::IEiffelHTMLDocGenerator * * return_value ) = 0;



protected:


private:


};
}
#endif
}
#endif

#ifdef __cplusplus
}
#endif

#endif