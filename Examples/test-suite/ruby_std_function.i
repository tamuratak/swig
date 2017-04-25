%module ruby_std_function

%include <rubygeneralfunctor.swg>

%template(FunctorIntInt) GeneralFunctor<int, int>;
%template(FunctorVoidInt) GeneralFunctor<void, int>;

%template(FunctorIntDouble) GeneralFunctor<int, double>;

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
