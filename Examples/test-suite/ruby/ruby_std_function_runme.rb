require 'swig_assert'
require 'ruby_std_function'

include Ruby_std_function

f = Proc.new{|x| x }
f_proc = FunctorIntInt.new(f)
f_std  = FunctorIntInt.new(ret_std_func)
f_fptr = FunctorIntInt.new(Ret_n)
f = nil
GC.stress = true

swig_assert_equal_simple(3, f_proc.call(3))
swig_assert_equal_simple(4, f_std.call(4))
swig_assert_equal_simple(5, f_fptr.call(5))

g_proc = StdFuncIntInt.new(f_proc)
g_std  = StdFuncIntInt.new(f_proc.to_func)

swig_assert_equal_simple(6, f_proc.to_func.call(6))
swig_assert_equal_simple(7, g_proc.call(7))
swig_assert_equal_simple(8, g_std.call(8))
