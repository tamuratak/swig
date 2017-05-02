%include <std_common.i>
 //%fragment("StdTraits");
%include <std_vector.i>
%template(StdVectorInt) std::vector<int>;

%{
#include <tuple>
#include <utility>
%}

%fragment("StdTupleTraits","header",fragment="StdTraits")
{

namespace swig {
  template <class... T>
  struct traits_asval<std::tuple<T...> > {
    typedef std::tuple<T...> value_type;

    template<size_t... I>
    static std::vector<int> asval_impl(VALUE obj, std::tuple<T...> *val, std::index_sequence<I...>) {
      if (val) {
        return { swig::asval((VALUE)rb_ary_entry(obj,I), &(std::get<I>(*val)))... };
      } else {
        std::tuple<T*...> t((T*)(nullptr)...);
        return { swig::asval((VALUE)rb_ary_entry(obj,I), std::get<I>(t))... };
      }
    }

    static int asval(VALUE obj, std::tuple<T...> *val) {
      if ( TYPE(obj) == T_ARRAY ) {
        if (RARRAY_LEN(obj) == sizeof...(T)) {
          auto ret = asval_impl(obj, val, std::make_index_sequence<sizeof...(T)>());
          for( auto e : ret ) {
            if (!SWIG_IsOK(e)) return e;
          }
          return SWIG_OK;
        }
        return SWIG_ERROR;
      } else {
        value_type *p;
        swig_type_info *descriptor = swig::type_info<value_type>();
        int res = descriptor ? SWIG_ConvertPtr(obj, (void **)&p, descriptor, 0) : SWIG_ERROR;
        if (SWIG_IsOK(res) && val)  *val = *p;
        return res;
      }
    }
  };

  template <class... T>
  struct traits_asptr<std::tuple<T...> >  {
    typedef std::tuple<T...> value_type;
    static int asptr(VALUE obj, std::tuple<T...> **val) {
      if ( TYPE(obj) == T_ARRAY ) {
        if (RARRAY_LEN(obj) == sizeof...(T)) {
          value_type *vp = nullptr;
          value_type v;
          if (val) vp = &v;
          auto ret = asval_impl(obj, vp, std::make_index_sequence<sizeof...(T)>());
          for( auto e : ret ) {
            if (!SWIG_IsOK(e)) return e;
          }
          if (val) *val = new value_type(v);
          return SWIG_OK;
        }
        return SWIG_ERROR;
      } else {
        value_type *p;
        swig_type_info *descriptor = swig::type_info<value_type>();
        int res = descriptor ? SWIG_ConvertPtr(obj, (void **)&p, descriptor, 0) : SWIG_ERROR;
        if (SWIG_IsOK(res) && val)  *val = p;
        return res;
      }
    }
  };

  template <class... T>
  struct traits_from<std::tuple<T...> > {
    typedef std::tuple<T...> value_type;

    template<size_t... I>
    static std::vector<VALUE> from_impl(const std::tuple<T...>& val, std::index_sequence<I...>) {
      return { swig::from(std::get<I>(val))... };
    }

    static VALUE from(const std::tuple<T...>& val) {
      VALUE obj = rb_ary_new2(sizeof...(T));
      auto vec = from_impl(val, std::make_index_sequence<sizeof...(T)>());
      for(int i=0; i < sizeof...(T); i++) {
        rb_ary_push(obj, vec[i]);
      }
      return obj;
    }
  };
};
}

%fragment("StdTupleTraits");

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
