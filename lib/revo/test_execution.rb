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
  (display vec)
  (vector-set! vec i i))



;(let loop ((vec (make-vector 5)) (i 0))
;  (if (= i 5) (begin vec) (begin (vector-set! vec i i) (loop (do "step" vec) (do "step" i (+ i 1))))))
