%module ruby_std_function

%include <std_function.i>
%include <std_vector.i>
%template() std::vector<int>;

%ruby_general_functor(FunctorIntInt, int, int);
%ruby_general_functor(FunctorVoidInt, void, int);
%ruby_general_functor(FunctorIntVec, int, std::vector<int>);
%ruby_general_functor_arg_void(FunctorIntVoid, int);

%std_function(StdFuncIntInt, int, int);
%std_function(StdFuncIntIntInt, int, int, int);

%{

  int ret_2(int i) {
    return 2;
  }

  int ret_n(int n) {
    return n;
  }

  std::function<int(int)> ret_std_func() {
    std::function<int(int)> f = ret_n;
    return f;
  }

  template<typename F>
  int call_f_with_const_1(F f) {
    const int i_ = 1;
    return f(i_);
  }

  template<typename F>
  int call_f_with_rvalue_1(F f) {
    return f(1);
  }

%}

%constant int ret_n(int i);
std::function<int(int)> ret_std_func();
int call_f_with_const_1(SwigRubyGeneralFunctor<int, int>);
int call_f_with_rvalue_1(SwigRubyGeneralFunctor<int, int>);
