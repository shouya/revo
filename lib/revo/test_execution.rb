#

require_relative '../revo'
require 'ap'

include Revo

rt = Runtime.new
ap rt.eval(Parser.parse(DATA.read))

__END__
(define-syntax swap
  (syntax-rules ()
    ((swap op1 op2)
     (let ((tmp op1))
       (set! op1 op2)
       (set! op2 tmp)))))

(define a 1)
(define b 2)
(swap a b)
(display a)
(newline)
(display b)
(newline)
