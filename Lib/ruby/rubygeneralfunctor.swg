%include <rubystdcommon.swg>
%include <rubyfuncall.swg>

%{
#include <functional>
#include <stdexcept>
%}

%fragment("RubyGeneralFunctor", "header", fragment="StdTraits", fragment="RubyFuncall")
{

template<class R, class...Args>
  struct GeneralFunctor : swig::GC_VALUE {
  typedef std::function<R(Args...)> function_type;
  
  GeneralFunctor(VALUE obj = Qnil) : GC_VALUE(obj), _func(nullptr) {}
  GeneralFunctor(function_type f) : GC_VALUE(Qnil), _func(f) {}

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

%define %trais_fragment(T,...)
  %fragment(SWIG_Traits_frag(T));
  %trais_fragment(__VA_ARGS__);
%enddef

template<class R, class Arg1=void, class Arg2=void, class Arg3=void, class Arg4=void, class Arg5=void, class Arg6=void, class Arg7=void, class Arg8=void, class Arg9=void>
struct GeneralFunctor : swig::GC_VALUE {
  typedef std::function<R(Arg1,Arg2,Arg3,Arg4,Arg5,Arg6,Arg7,Arg8,Arg9)> function_type;
  GeneralFunctor(VALUE obj = Qnil);
  GeneralFunctor(const function_type& f);
  R operator()(const Arg1&, const Arg2&, const Arg3&, const Arg4&, const Arg5&, const Arg6&, const Arg7&, const Arg8&, const Arg9&);
  function_type to_function();
  %trais_fragment(R, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, Arg9);
};

template<class R, class Arg1, class Arg2, class Arg3, class Arg4, class Arg5, class Arg6, class Arg7, class Arg8>
struct GeneralFunctor<R, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, void> : swig::GC_VALUE {
  typedef std::function<R(Arg1,Arg2,Arg3,Arg4,Arg5,Arg6,Arg7,Arg8)> function_type;
  GeneralFunctor(VALUE obj = Qnil);
  GeneralFunctor(const function_type& f);
  R operator()(const Arg1&, const Arg2&, const Arg3&, const Arg4&, const Arg5&, const Arg6&, const Arg7&, const Arg8&);
  function_type to_function();
  %trais_fragment(R, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8);
};

template<class R, class Arg1, class Arg2, class Arg3, class Arg4, class Arg5, class Arg6, class Arg7>
struct GeneralFunctor<R, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, void, void> : swig::GC_VALUE {
  typedef std::function<R(Arg1,Arg2,Arg3,Arg4,Arg5,Arg6,Arg7)> function_type;
  GeneralFunctor(VALUE obj = Qnil);
  GeneralFunctor(const function_type& f);
  R operator()(const Arg1&, const Arg2&, const Arg3&, const Arg4&, const Arg5&, const Arg6&, const Arg7&);
  function_type to_function();
  %trais_fragment(R, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7);
};

template<class R, class Arg1, class Arg2, class Arg3, class Arg4, class Arg5, class Arg6>
struct GeneralFunctor<R, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, void, void, void> : swig::GC_VALUE {
  typedef std::function<R(Arg1,Arg2,Arg3,Arg4,Arg5,Arg6)> function_type;
  GeneralFunctor(VALUE obj = Qnil);
  GeneralFunctor(const function_type& f);
  R operator()(const Arg1&, const Arg2&, const Arg3&, const Arg4&, const Arg5&, const Arg6&);
  function_type to_function();
  %trais_fragment(R, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6);
};

template<class R, class Arg1, class Arg2, class Arg3, class Arg4, class Arg5>
struct GeneralFunctor<R, Arg1, Arg2, Arg3, Arg4, Arg5, void, void, void, void> : swig::GC_VALUE {
  typedef std::function<R(Arg1,Arg2,Arg3,Arg4,Arg5)> function_type;
  GeneralFunctor(VALUE obj = Qnil);
  GeneralFunctor(const function_type& f);
  R operator()(const Arg1&, const Arg2&, const Arg3&, const Arg4&, const Arg5&);
  function_type to_function();
  %trais_fragment(R, Arg1, Arg2, Arg3, Arg4, Arg5);
};

template<class R, class Arg1, class Arg2, class Arg3, class Arg4>
struct GeneralFunctor<R, Arg1, Arg2, Arg3, Arg4, void, void, void, void, void> : swig::GC_VALUE {
  typedef std::function<R(Arg1,Arg2,Arg3,Arg4)> function_type;
  GeneralFunctor(VALUE obj = Qnil);
  GeneralFunctor(const function_type& f);
  R operator()(const Arg1&, const Arg2&, const Arg3&, const Arg4&);
  function_type to_function();
  %trais_fragment(R, Arg1, Arg2, Arg3, Arg4);
};

template<class R, class Arg1, class Arg2, class Arg3>
struct GeneralFunctor<R, Arg1, Arg2, Arg3, void, void, void, void, void, void> : swig::GC_VALUE {
  typedef std::function<R(Arg1,Arg2,Arg3)> function_type;
  GeneralFunctor(VALUE obj = Qnil);
  GeneralFunctor(const function_type& f);
  R operator()(const Arg1&, const Arg2&, const Arg3&);
  function_type to_function();
  %trais_fragment(R, Arg1, Arg2, Arg3);
};

template<class R, class Arg1, class Arg2>
struct GeneralFunctor<R, Arg1, Arg2, void, void, void, void, void, void, void> : swig::GC_VALUE {
  typedef std::function<R(Arg1,Arg2)> function_type;
  GeneralFunctor(VALUE obj = Qnil);
  GeneralFunctor(const function_type& f);
  R operator()(const Arg1&, const Arg2&);
  function_type to_function();
  %trais_fragment(R, Arg1, Arg2);
};

template<class R, class Arg1>
struct GeneralFunctor<R, Arg1, void, void, void, void, void, void, void, void> : swig::GC_VALUE {
  typedef std::function<R(Arg1)> function_type;
  GeneralFunctor(VALUE obj = Qnil);
  GeneralFunctor(const function_type& f);
  R operator()(const Arg1& a1);
  function_type to_function();
  %trais_fragment(R, Arg1);
};

template<class R>
struct GeneralFunctor<R, void, void, void, void, void, void, void, void, void> : swig::GC_VALUE {
  typedef std::function<R()> function_type;
  GeneralFunctor(VALUE obj = Qnil);
  GeneralFunctor(const function_type& f);
  R operator()();
  std::function<R(void)> to_function();
  %trais_fragment(R);
};

