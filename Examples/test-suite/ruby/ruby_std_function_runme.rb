require "ruby_std_function"

include Ruby_std_function

f = Proc.new{|x| x }
f_proc = FunctorIntInt.new(f)
f_std = FunctorIntInt.new(ret_std_func)

