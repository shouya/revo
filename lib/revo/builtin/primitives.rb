#


define(:+) do |lhs, rhs|
  lhs + rhs
end

define(:display) do |value|
  print value.to_s
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
    env[name.to_s] = Revo.eval(other[0], env)
  else
    raise 'Unknown operation for "define"'
  end
end

syntax(:set!) do |name, val|
  assert(name.is_a? Symbol)
  env.set!(name.val, Revo.eval(val, env))
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

syntax(:if) do |cond, true_part, false_part|
  Revo.eval(Revo.is_true?(Revo.eval(cond, env)) ? true_part : false_part, env)
end

define(:list) do |*vals|
  list(*vals)
end

define(:cons) do |car, cdr|
  cons(car, cdr)
end

define(:car) do |cons|
  cons.car
end
define(:cdr) do |cons|
  cons.cdr
end

=begin
syntax(:let) do |binding, *body|
  scope = Scope.new(env)
  binding.each do |bd|
    scope[bd.car.val.to_s] = Revo.eval(bd.cdr.car, env)
  end
  Revo.eval(DynamicClosure.new(scope, autobegin(*body)), nil)
end
=end
syntax('define-syntax') do |name, rules|
  assert(name.is_a? Symbol)
  assert((rules.is_a? Cons) &&
         (rules.car.is_a? Symbol) && (rules.car.val == 'syntax-rules'))
  keywords = rules.cdr.car
  assert(keywords.all? {|x| x.is_a? Symbol })
  keywords = keywords.map(&:val)
  macro = Macro.new(env, name.val, keywords, runtime.options[:hygienic_macro])
  rules.cdr.cdr.each do |rule|
    assert(rule.car.is_a? Cons)    # pattern
    assert(rule.car.car == name)
    macro.define_rule(rule.car.cdr, autobegin(*rule.cdr.to_a))
  end
  call(:define, name, quote(macro))
end

define(:debug) do |exp|
  require 'ap'
  ap exp
end

define(:exit) { exit }
define(:eval) do |expr|
  Revo.eval(expr, env)
end

# TODO: env.load
define(:load) do |expr|
end

define(:error) do |message|
  raise "Revo: #{message}"
end

define(:eqv?) do |op1, op2|
  ((op1.is_a? Revo::Character or op1.is_a? Revo::Symbol) and (op1 == op2)) or
    op1.equal?(op2)
end
define_alias(:eq?, :eqv?)

define(:equal?) do |op1, op2|
  op1 == op2
end

# The following functions are directly from (with a little modification)
#+the Heist project:
#+ https://github.com/jcoglan/heist/blob/master/lib/heist/builtin/primitives.rb
define('>') do |*args|
  result = true
  args.inject { |former, latter| result = false unless former > latter }
  result
end
define('>=') do |*args|
  result = true
  args.inject { |former, latter| result = false unless former >= latter }
  result
end
define('<') do |*args|
  result = true
  args.inject { |former, latter| result = false unless former < latter }
  result
end
define('<=') do |*args|
  result = true
  args.inject { |former, latter| result = false unless former <= latter }
  result
end

define('complex?') do |value|
  Complex === value || call('real?', value)
end

define('real?') do |value|
  Float === value || call('rational?', value)
end

define('rational?') do |value|
  Rational === value || call('integer?', value)
end

define('integer?') do |value|
  Integer === value
end

define('char?') do |value|
  Character === value
end

define('string?') do |value|
  String === value
end

define('symbol?') do |value|
  Symbol === value or Identifier === value
end

define('procedure?') do |value|
  Function === value
end

define('pair?') do |value|
  Cons === value and value.pair?
end

define('vector?') do |value|
  Vector === value
end
define('+') do |*args|
  args.any? { |arg| String === arg } ?
  args.inject("") { |str, arg| str + arg.to_s } :
    args.inject(0)  { |sum, arg| sum + arg }
end
define('-') do |op1, op2|
  op2.nil? ? 0 - op1 : op1 - op2
end

define('*') do |*args|
  args.inject(1) { |prod, arg| prod * arg }
end

# Returns the first argument divided by the second, or the reciprocal of the
# first if only one argument is given
define('/') do |op1, op2|
  op2.nil? ? Revo.divide(1, op1) : Revo.divide(op1, op2)
end

# Returns the numerator of a number
define('numerator') do |value|
  Rational === value ? value.numerator : value
end

# Returns the denominator of a number
define('denominator') do |value|
  Rational === value ? value.denominator : 1
end

%w[floor ceil truncate round].each do |symbol|
  define(symbol) do |number|
    number.__send__(symbol)
  end
end

%w[exp log sin cos tan asin acos sqrt].each do |symbol|
  define(symbol) do |number|
    Math.__send__(symbol, number)
  end
end

define('atan') do |op1, op2|
  op2.nil? ? Math.atan(op1) : Math.atan2(op1, op2)
end

# Returns the result of raising the first argument to the power of the second
define('expt') do |op1, op2|
  op1 ** op2
end

# Returns a new complex number with the given real and imaginary parts
define('make-rectangular') do |real, imag|
  Complex(real, imag)
end

# Returns the real part of a number
define('real-part') do |value|
  Complex === value ? value.real : value
end

# Returns the imaginary part of a number, which is zero unless the number is not
# real
define('imag-part') do |value|
  Complex === value ? value.imag : 0
end

# Returns a random number in the range 0...max
define('random') do |max|
  rand(max)
end

# Casts a number to a string
define('number->string') do |number, radix|
  number.to_s(radix || 10)

end
# Casts a string to a number
define('string->number') do |string, radix|
  radix.nil? ? string.to_f : string.to_i(radix)
end


# Mutators for car/cdr fields
define('set-car!') do |cons, value|
  cons.car = value
end
define('set-cdr!') do |cons, value|
  cons.cdr = value
end

#-------------------------------------------------------------------------------

# Symbol functions

# Returns a new string by casting the given symbol to a string
define('symbol->string') do |symbol|
  symbol.to_s
end

# Returns the symbol whose name is the given string
define('string->symbol') do |string|
  Identifier.new(string)
end

#-------------------------------------------------------------------------------

# Character functions

# Returns true iff the two characters are equal
define('char=?') do |op1, op2|
  Character === op1 and op1 == op2
end

define('char<?') do |op1, op2|
  Character === op1 and Character === op2 and op1 < op2
end

define('char>?') do |op1, op2|
  Character === op1 and Character === op2 and op1 > op2
end

define('char<=?') do |op1, op2|
  Character === op1 and Character === op2 and op1 <= op2
end

define('char>=?') do |op1, op2|
  Character === op1 and Character === op2 and op1 >= op2
end

# Returns a new character from an ASCII code
define('integer->char') do |code|
  Character.new(code.chr)
end

# Returns the ASCII code for a character
define('char->integer') do |char|
  char.char_code
end

#-------------------------------------------------------------------------------

# String functions

# Returns a new string of the given size, filled with the given character. If no
# character is given, a space is used.
define('make-string') do |size, char|
  char = " " if char.nil?
  char.to_s * size
end

# Returns the length of the string
define('string-length') do |string|
  string.length
end

# Returns the kth character in the string
define('string-ref') do |string, k|
  size = string.length
  raise "Cannot access index #{k} in string \"#{string}\"" if k >= size
  char = string[k]
  char = char.chr if Numeric === char
  Character.new(char)
end

# Sets the kth character in string equal to char
define('string-set!') do |string, k, char|
  size = string.length
  raise "Cannot access index #{k} in string \"#{string}\"" if k >= size
  string[k] = char.to_s
  string
end

#-------------------------------------------------------------------------------

# Vector functions

# Returns a new vector of the given size, filled with the given filler value
# (this defaults to the NULL list
define('make-vector') do |size, fill|
  fill = NULL if fill.nil?
  Vector.new(size, fill)
end

# Returns the length of the vector
define('vector-length') do |vector|
  vector.size
end

# Returns the kth element of a vector
define('vector-ref') do |vector, k|
  size = vector.size
  raise "Cannot access index #{k} of vector of length #{size}" if k >= size
  vector[k]
end

# Sets the kth element of a vector to object
define('vector-set!') do |vector, k, object|
  size = vector.size
  raise "Cannot modify index #{k} of vector of length #{size}" if k >= size
  vector[k] = object
end

define('list->vector') do |list|
  Vector.new(list.to_a)
end

#-------------------------------------------------------------------------------

# Control features

# Calls a function using a list for the arguments
# TODO take multiple argument values instead of a single list
define('apply') do |function, list|
  function.apply(env, list.to_a)
end


# -------------------- debugging features ------------------
define('debug-scope') do |val|
  require 'ap'
  tmp = env
  while tmp
    puts "---------scope: #{tmp.object_id}---------"
    ap tmp.symbols unless tmp.symbols.length > 30
    tmp = tmp.parent
  end
  puts '--------end-of-scope--------'

  val
end

# ------- currying --------
define('curry') do |val, *force_arity|
  arity = nil
  arity = force_arity.first if force_arity.length > 0
  arity ||= val.arity

  val.force_curry(arity)
end
