%module cpp11_shared_ptr_const

%{

#include <memory>
#include <vector>

class Foo
{
public:
  Foo(int i) : m(i) {}
  int get_m() const { return m;}
  int m;
};

std::shared_ptr<Foo> foo(Foo v) {
  return std::shared_ptr<Foo>(new Foo(v));
}

std::shared_ptr<const Foo> const_foo(Foo v) {
  return std::shared_ptr<const Foo>(new Foo(v));
}

std::vector<std::shared_ptr<Foo> > foo_vec(Foo v) {
    std::vector<std::shared_ptr<Foo> > result;
    result.push_back( std::shared_ptr<Foo>(new Foo(v)) );
    return result;
}

std::vector<std::shared_ptr<const Foo> > const_foo_vec(Foo v) {
  std::vector<std::shared_ptr<const Foo> > result;
  result.push_back( std::shared_ptr<Foo>(new Foo(v)) );
  return result;
}

int from_const_foo_vec(const std::vector<std::shared_ptr<const Foo> >& v) {
  if (v.size() > 0) {
    return (*v[0]).get_m();
  } else {
    return -1;
  }
}

int from_foo_vec(const std::vector<std::shared_ptr<Foo> >& v) {
  if (v.size() > 0) {
    return (*v[0]).get_m();
  } else {
    return -1;
  }
}

%}

%include <std_shared_ptr.i>
%include <std_vector.i>

%shared_ptr(Foo);

%template (FooVector) std::vector<std::shared_ptr<Foo> >;
%template (FooConstVector) std::vector<std::shared_ptr<Foo const> >;

std::shared_ptr<Foo> foo(Foo v);
std::shared_ptr<const Foo> const_foo(Foo v);
std::vector<std::shared_ptr<Foo> > foo_vec(Foo v) const;
std::vector<std::shared_ptr<const Foo> > const_foo_vec(Foo v) const;
int from_const_foo_vec(const std::vector<std::shared_ptr<const Foo> >& v);
int from_foo_vec(const std::vector<std::shared_ptr<Foo> >& v);

class Foo
{
public:
  Foo(int i);
  int get_m();
  int m;
};
