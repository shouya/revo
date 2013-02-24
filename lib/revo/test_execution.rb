# -*- scheme -*-

require_relative '../revo'
require 'ap'

include Revo

rt = Runtime.new
ap rt.eval(Parser.parse(DATA.read))

__END__

(define (plus . rest)
  (apply + rest))
(define plus-curry
  (curry plus 3))
(plus 3 5)
((plus-curry 1 2) 4)
