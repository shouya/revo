# -*- scheme -*-

require_relative '../revo'
require 'ap'

include Revo

rt = Runtime.new
ap rt.eval(Parser.parse(DATA.read))

__END__
(display "hello\x2aworld")
(newline)
(display "hello\046world")
(newline)
(display "hello\tworld\nhello\rhell world")
(newline)
