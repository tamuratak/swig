%include <std_common.i>

%fragment("RubyFuncall", "header", fragment="StdTraits")
{

#include <functional>
#include <stdexcept>

extern "C" VALUE swig_rb_funcall_caller(VALUE);

namespace swig {

  class ruby_funcaller_tag {
  public:
    ruby_funcaller_tag(int i) : state(i) {}
    int state;
  };


  struct ruby_funcaller {
    ruby_funcaller(VALUE obj, ID m, std::vector<VALUE> & v) : recv(obj), mid(m), args(v) {}

    VALUE call_impl() { 
      VALUE a = rb_ary_new_from_values(args.size(), args.data());
      return rb_apply(recv, mid, a);
    }

    VALUE call() {
      int state = 0;
      VALUE res = rb_protect(swig_rb_funcall_caller, (VALUE) this, &state);
      if (state) {
        throw ruby_funcaller_tag(state);
      }
      return res;
    }

    template<class R>
    static R as(VALUE res) {
      try {
        return swig::as< R >(res, true);
      }
      catch (const std::invalid_argument &e) {
        std::string s = std::string( swig::traits< R >::type_name() ) + std::string(" type expected");
        throw std::runtime_error(s);
      }
    }

    VALUE recv;
    ID mid;
    std::vector<VALUE> args;
  };
  template<> void ruby_funcaller::as<void>(VALUE res) {}

  VALUE swig_rb_funcall(VALUE recv, ID mid, int n, ...) {
    std::vector<VALUE> v(n);
    va_list args;
    va_start(args, n);
    for(int i = 0; i < n; i++) {
      v[i] = va_arg(args, VALUE);
    }
    va_end(args);
    ruby_funcaller f(recv, mid, v);
    return f.call();
  }
};

extern "C" VALUE swug_rb_funcall_caller(VALUE proc) {
  swig::ruby_funcaller *f = (swig::ruby_funcaller*) proc;
  return f->call_impl();
}

}
%fragment("RubyFuncall");
