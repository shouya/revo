#

require_relative '../revo'
require 'ap'

include Revo

rt = Runtime.new
ap rt.eval(Parser.parse('(+ 1 2)'))
