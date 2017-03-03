require "swig_assert"
require "cpp11_shared_ptr_const"

include Cpp11_shared_ptr_const

simple_assert_equal(1,           foo( Foo.new(1) ).get_m )
simple_assert_equal(7,     const_foo( Foo.new(7) ).get_m )
simple_assert_equal(7,       foo_vec( Foo.new(7) )[0].get_m )
simple_assert_equal(8, const_foo_vec( Foo.new(8) )[0].get_m )

const_vec = FooConstVector.new()
const_vec << Foo.new(3)

vec = FooVector.new()
vec << Foo.new(2)

begin from_const_foo_vec( [Foo.new(1)] ) rescue TypeError end
begin from_const_foo_vec( vec )          rescue TypeError end
begin from_foo_vec(const_vec)            rescue TypeError end

simple_assert_equal(3, from_const_foo_vec( const_vec    ) )
simple_assert_equal(2,       from_foo_vec( vec          ) )
simple_assert_equal(1,       from_foo_vec( [Foo.new(1)] ) )
