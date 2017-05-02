%include <std_common.i>
 //%fragment("StdTraits");
%include <std_vector.i>
%template(StdVectorInt) std::vector<int>;

%{
#include <tuple>
%}

template<typename A>
class std::tuple {};

%define %ruby_std_tuple_getitem_case(Num)
  case Num:
    return swig::from(std::get<Num>(*$self));
%enddef

%define %ruby_std_tuple_setitem_case(Num, val, ...)
  case Num:
    std::get<Num>(*$self) = swig::as<std::tuple_element<Num, std::tuple<__VA_ARGS__>>::type>(val);
    break;
%enddef

%define %std_tuple_2(Name, ...)
template<>
class std::tuple<__VA_ARGS__> {
public:
  tuple(__VA_ARGS__);
  %extend {
    VALUE __getitem__(int i) {
      switch(i) {
        %ruby_std_tuple_getitem_case(0)
        %ruby_std_tuple_getitem_case(1)
      }
      return Qnil;
    }

    void __setitem__(int i, VALUE v) {
      switch(i) {
        %ruby_std_tuple_setitem_case(0, v, __VA_ARGS__)
        %ruby_std_tuple_setitem_case(1, v, __VA_ARGS__)
      }
    }
  }
};
%template(Name) std::tuple<__VA_ARGS__>;
%enddef
