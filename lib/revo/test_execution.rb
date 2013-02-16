# -*- scheme -*-

require_relative '../revo'
require 'ap'

include Revo

rt = Runtime.new
ap rt.eval(Parser.parse(DATA.read))

__END__

;(define (foo-1) '())
;(debug-scope 0)

; (define global 1)

;(define trans-table (map
;                     (lambda (n)
;                       ((lambda (carry line)
;                          (for-each (lambda (x) (debug-scope 0))
;                                    '(0)))))
;                     '(0)))

; (define odm one-digit-multiply)
(do ((vec (make-vector 5))
     (i 0 (+ i 1)))
    ((= i 5) vec)
  (vector-set! vec i i))
