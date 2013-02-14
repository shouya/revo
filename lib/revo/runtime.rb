#

require 'forwardable'

require_relative 'scope'
require_relative 'parser.tab'

module Revo

  class Runtime
    attr_accessor :top_level, :user_scope

    extend Forwardable
    def_delegators :@user_scope, :define, :syntax, :eval, :[]

    BUILTIN_LIBRARIES = %w[primitives.rb]
    BUILTIN_LIBRARIES_PATH = File.expand_path('../builtin', __FILE__)

    def initialize
      @top_level = Scope.new(nil)
      @user_scope = Scope.new(@top_level)

      BUILTIN_LIBRARIES
        .map {|x| File.join(BUILTIN_LIBRARIES_PATH, x)}
        .each do |lib|

        if File.extname(lib) == '.rb'
          @top_level.instance_eval(File.read(lib))
        elsif File.extname(lib) == '.rv'
          code = Parser.parse(File.read(lib))
          @top_level.eval(code)
        else
          warn "Unrecognized file type: \"#{lib}\""
        end
      end
    end

  end

end
