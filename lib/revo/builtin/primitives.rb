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
#    p [name, param, *other]
    closure = call(:lambda, param, *other)
    env[name.to_s] = closure
  elsif name.is_a? Symbol
    env[name.to_s] = other[0].eval(env)
  else
    raise 'Unknown operation for "define"'
  end
end

syntax(:lambda) do |params, *body|
  real_body = nil
  if body.length == 1
    real_body = body[0]
  elsif body.length == 0
    real_body = NULL
  else
    real_body = Cons[:begin, Cons.construct(body)]
  end
  closure = Closure.new(env, params, real_body)
end

syntax(:begin) do |*exprs|
  lastval = NULL
  exprs.each do |expr|
    lastval = env.eval(expr)
  end
  lastval
end

syntax(:debug) do |exp|
  ap exp
end
