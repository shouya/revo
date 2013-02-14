#


define(:+) do |lhs, rhs|
  lhs + rhs
end

define(:display) do |value|
  puts value.to_s
end

syntax(:quote) do |whatever|
  whatever
end

syntax(:define) do |name, *other|
  if name.is_a? Cons and name.car.is_a? Symbol
    name, param = name.car, name.cdr
    closure = Closure.new(env, param, Cons[:begin, Cons.construct(other)])
    env[name.to_s] = closure
  elsif name.is_a? Symbol
    env[name.to_s] = other[0].eval(env)
  else
    raise 'Unknown operation for "define"'
  end
end

syntax(:begin) do |*exprs|
  lastval = NULL
  exprs.each do |expr|
    lastval = env.eval(expr)
  end
  lastval
end
