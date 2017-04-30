%module ruby_std_function

%include <rubygeneralfunctor.swg>
%include <std_vector.i>
%template() std::vector<int>;

%ruby_general_functor(FunctorIntInt, int, int);
%ruby_general_functor(FunctorVoidInt, void, int);
%ruby_general_functor(FunctorIntVec, int, std::vector<int>);
%ruby_general_functor_arg_void(FunctorIntVoid, int);

%std_function(FIntInt, int, int);
%std_function(FIntInt, int, int, int);

%{

  int ret_2(int i) {
    return 2;
  }

  std::function<int(int)> ret_std_func() {
    std::function<int(int)> f = ret_2;
    return f;
  }

%}

std::function<int(int)> ret_std_func();
