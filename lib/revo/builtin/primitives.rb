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
    closure = call(:lambda, param, *other)
    env[name.to_s] = closure
  elsif name.is_a? Symbol
    env[name.to_s] = other[0].eval(env)
  else
    raise 'Unknown operation for "define"'
  end
end

syntax(:lambda) do |params, *body|
  Closure.new(env, params, autobegin(*body))
end

syntax(:begin) do |*exprs|
  lastval = NULL
  exprs.each do |expr|
    lastval = env.eval(expr)
  end
  lastval
end

define(:list) do |*vals|
  list(*vals)
end

syntax(:let) do |binding, *body|
  scope = Scope.new(env)
  binding.each do |bd|
    scope[bd.car.val.to_s] = Revo.eval(bd.cdr.car, env)
  end
  Revo.eval(DynamicClosure.new(scope, autobegin(*body)), nil)
end

syntax('define-syntax') do |name, rules|
  assert(name.is_a? Symbol)
  assert((rules.is_a? Cons) &&
         (rules.car.is_a? Symbol) && (rules.car.val == 'syntax-rules'))
  keywords = rules.cdr.car
  assert(keywords.all? {|x| x.is_a? Symbol })
  keywords = keywords.map(&:val)
  macro = Macro.new(name.val, keywords)
  rules.cdr.cdr.each do |rule|
    assert(rule.car.is_a? Cons)    # pattern
    assert(rule.car.car == name)
    macro.define_rule(rule.car.cdr, autobegin(*rule.cdr.to_a))
  end
  call(:define, name, quote(macro))
end

syntax(:debug) do |exp|
  ap exp
end
