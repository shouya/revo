#

require_relative '../revo'
require 'ap'

include Revo

rt = Runtime.new
rt.eval(Parser.parse(DATA.read))

__END__
(let ((mylove 'you))
  (display (list 'I 'love mylove)))
