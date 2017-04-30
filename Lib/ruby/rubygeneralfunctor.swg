%include <rubystdcommon.swg>
%include <rubyfuncall.swg>

%{
#include <functional>
#include <stdexcept>
%}

%fragment("RubyGeneralFunctor", "header", fragment="StdTraits", fragment="RubyFuncall")
{

template<class R, class...Args>
  struct SwigRubyGeneralFunctor : swig::GC_VALUE {
  typedef std::function<R(Args...)> function_type;
  
  SwigRubyGeneralFunctor(VALUE obj = Qnil) : GC_VALUE(obj), _func(nullptr) {}
  SwigRubyGeneralFunctor(function_type f) : GC_VALUE(Qnil), _func(f) {}

  R operator()(const Args&... args) {
    if (_func) {
      return _func(args...);
    } else {
      VALUE res = swig::swig_rb_funcall(_obj, rb_intern("call"), sizeof...(Args), swig::from(args)...);
      return swig::ruby_funcall::as<R>(res);
    }
  }

  function_type to_function() {
    return *this;
  }

  function_type _func;
};

}
%fragment("RubyGeneralFunctor");

%define %ruby_general_functor_trais_fragment(T,...)
  %fragment(SWIG_Traits_frag(T));
  %ruby_general_functor_trais_fragment(__VA_ARGS__);
%enddef

template<class R, class Arg1>
struct SwigRubyGeneralFunctor {};

%define %ruby_general_functor(Name, R, ...)
template<>
struct SwigRubyGeneralFunctor<R, __VA_ARGS__> {
public:
  typedef std::function<R(__VA_ARGS__)> function_type;
  typedef R result_type;
  SwigRubyGeneralFunctor(VALUE obj = Qnil);
  SwigRubyGeneralFunctor(const function_type& f);
  R operator()(__VA_ARGS__);
  function_type to_function();
  %ruby_general_functor_trais_fragment(R, __VA_ARGS__);
};
%template(Name) SwigRubyGeneralFunctor<R, __VA_ARGS__>;
%enddef

%define %ruby_general_functor_arg_void(Name, R)
template<>
struct SwigRubyGeneralFunctor<R> {
public:
  typedef std::function<R()> function_type;
  typedef R result_type;
  SwigRubyGeneralFunctor(VALUE obj = Qnil);
  SwigRubyGeneralFunctor(const function_type& f);
  R operator()();
  function_type to_function();
  %ruby_general_functor_trais_fragment(R);
};
%template(Name) SwigRubyGeneralFunctor<R>;
%enddef
