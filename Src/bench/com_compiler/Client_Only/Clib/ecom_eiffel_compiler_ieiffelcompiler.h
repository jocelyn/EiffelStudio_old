/*-----------------------------------------------------------
Eiffel Compiler. Eiffel language compiler library. Help file: 
-----------------------------------------------------------*/

#ifndef __ECOM_EIFFEL_COMPILER_IEIFFELCOMPILER_H__
#define __ECOM_EIFFEL_COMPILER_IEIFFELCOMPILER_H__
#ifdef __cplusplus
extern "C" {


#ifndef __ecom_eiffel_compiler_IEiffelCompiler_FWD_DEFINED__
#define __ecom_eiffel_compiler_IEiffelCompiler_FWD_DEFINED__
namespace ecom_eiffel_compiler
{
class IEiffelCompiler;
}
#endif

}
#endif

#include "eif_com.h"

#include "eif_eiffel.h"

#ifdef __cplusplus
extern "C" {
#endif

#ifdef __cplusplus
extern "C" {
#ifndef __ecom_eiffel_compiler_IEiffelCompiler_INTERFACE_DEFINED__
#define __ecom_eiffel_compiler_IEiffelCompiler_INTERFACE_DEFINED__
namespace ecom_eiffel_compiler
{
class IEiffelCompiler : public IDispatch
{
public:
	IEiffelCompiler () {};
	~IEiffelCompiler () {};

	/*-----------------------------------------------------------
	Compile.
	-----------------------------------------------------------*/
	virtual STDMETHODIMP compile( void ) = 0;


	/*-----------------------------------------------------------
	Finalize.
	-----------------------------------------------------------*/
	virtual STDMETHODIMP finalize( void ) = 0;


	/*-----------------------------------------------------------
	Precompile.
	-----------------------------------------------------------*/
	virtual STDMETHODIMP precompile( void ) = 0;


	/*-----------------------------------------------------------
	Compile with piped output.
	-----------------------------------------------------------*/
	virtual STDMETHODIMP compile_to_pipe( void ) = 0;


	/*-----------------------------------------------------------
	Finalize with piped output.
	-----------------------------------------------------------*/
	virtual STDMETHODIMP finalize_to_pipe( void ) = 0;


	/*-----------------------------------------------------------
	Precompile with piped output.
	-----------------------------------------------------------*/
	virtual STDMETHODIMP precompile_to_pipe( void ) = 0;


	/*-----------------------------------------------------------
	Was last compilation successful?
	-----------------------------------------------------------*/
	virtual STDMETHODIMP is_successful(  /* [out, retval] */ VARIANT_BOOL * return_value ) = 0;


	/*-----------------------------------------------------------
	Did last compile warrant a call to finish_freezing?
	-----------------------------------------------------------*/
	virtual STDMETHODIMP freezing_occurred(  /* [out, retval] */ VARIANT_BOOL * return_value ) = 0;


	/*-----------------------------------------------------------
	Compiler version.
	-----------------------------------------------------------*/
	virtual STDMETHODIMP compiler_version(  /* [out, retval] */ BSTR * return_value ) = 0;


	/*-----------------------------------------------------------
	Takes a path and expands it using the env vars.
	-----------------------------------------------------------*/
	virtual STDMETHODIMP expand_path(  /* [in] */ BSTR a_path, /* [out, retval] */ BSTR * return_value ) = 0;


	/*-----------------------------------------------------------
	Generate a cyrptographic key filename.
	-----------------------------------------------------------*/
	virtual STDMETHODIMP generate_msil_keyfile(  /* [in] */ BSTR filename ) = 0;


	/*-----------------------------------------------------------
	Eiffel Freeze command name
	-----------------------------------------------------------*/
	virtual STDMETHODIMP freeze_command_name(  /* [out, retval] */ BSTR * return_value ) = 0;


	/*-----------------------------------------------------------
	Eiffel Freeze command arguments
	-----------------------------------------------------------*/
	virtual STDMETHODIMP freeze_command_arguments(  /* [out, retval] */ BSTR * return_value ) = 0;


	/*-----------------------------------------------------------
	Is the compiler a trial version.
	-----------------------------------------------------------*/
	virtual STDMETHODIMP has_signable_generation(  /* [out, retval] */ VARIANT_BOOL * return_value ) = 0;


	/*-----------------------------------------------------------
	Remove file locks
	-----------------------------------------------------------*/
	virtual STDMETHODIMP remove_file_locks( void ) = 0;


	/*-----------------------------------------------------------
	Output pipe's name
	-----------------------------------------------------------*/
	virtual STDMETHODIMP output_pipe_name(  /* [out, retval] */ BSTR * return_value ) = 0;


	/*-----------------------------------------------------------
	Set output pipe's name
	-----------------------------------------------------------*/
	virtual STDMETHODIMP set_output_pipe_name(  /* [in] */ BSTR return_value ) = 0;


	/*-----------------------------------------------------------
	Is compiler output sent to pipe `output_pipe_name'
	-----------------------------------------------------------*/
	virtual STDMETHODIMP is_output_piped(  /* [out, retval] */ VARIANT_BOOL * return_value ) = 0;


	/*-----------------------------------------------------------
	Can product be run? (i.e. is it activated or was run less than 10 times)
	-----------------------------------------------------------*/
	virtual STDMETHODIMP can_run(  /* [out, retval] */ VARIANT_BOOL * return_value ) = 0;



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