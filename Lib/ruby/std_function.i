%include <rubygeneralfunctor.swg>

%{
#include <functional>
%}

template<class R, class Arg1>
class std::function {};

%define %call_traits_frag(Type, ...)
  %fragment(SWIG_Traits_frag(Type));
  %call_traits_frag(__VA_ARGS__);
%enddef

%define %std_function(Name, R, ...)
template<>
class std::function<R(__VA_ARGS__)> {
public:
  typedef R result_type;
  R operator()(__VA_ARGS__);
  %call_traits_frag(R, __VA_ARGS__);
    %extend{
      std::function(const std::function& f) {
        auto ret = new std::function<R(__VA_ARGS__)>(f);
        return ret;
      }

      std::function(VALUE obj) {
        auto ret = new std::function<R(__VA_ARGS__)>(SwigRubyGeneralFunctor< R , __VA_ARGS__ >(obj));
        return ret;
      }
    }
};
%template(Name) std::function<R(__VA_ARGS__)>;
%enddef

%define %std_function_arg_void(Name, R)
template<>
class std::function<R()> {
public:
  typedef R result_type;
  R operator()();
  %call_traits_frag(R);
  %extend{
    std::function(const std::function& f) {
      auto ret = new std::function<R(__VA_ARGS__)>(f);
      return ret;
    }

    std::function(VALUE obj) {
      auto ret = new std::function<R()>(SwigRubyGeneralFunctor< R >(obj));
      return ret;
    }
  }
};
%template(Name) std::function<R()>;
%enddef
