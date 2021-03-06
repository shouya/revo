#

require 'forwardable'

require_relative 'scope'
require_relative 'parser.tab'

module Revo

  class Runtime
    attr_accessor :top_level, :user_scope

    extend Forwardable
    def_delegators :@user_scope, :define, :syntax, :eval, :exec, :[]

#    BUILTIN_LIBRARIES = %w[primitives.rb] # Safe mode
    BUILTIN_LIBRARIES = %w[primitives.rb syntax.rv stdlib.rv]
    BUILTIN_LIBRARIES_PATH = File.expand_path('../builtin', __FILE__)

    DEFAULT_OPTIONS = {
      :hygienic_macro => true
    }.freeze

    def initialize(options = {})
      @top_level = Scope.new(nil)
      @top_level.runtime = self
      @user_scope = Scope.new(@top_level)

      @options = DEFAULT_OPTIONS.merge options
      tmp, @options[:hygienic_macro] = @options[:hygienic_macro], false

      BUILTIN_LIBRARIES
        .map {|x| File.join(BUILTIN_LIBRARIES_PATH, x)}
        .each do |lib|

        if File.extname(lib) == '.rb'
          @top_level.instance_eval(File.read(lib), lib)
        elsif File.extname(lib) == '.rv'
          code = Parser.parse(File.read(lib))
          @top_level.eval(code)
        else
          warn "Unrecognized file type: \"#{lib}\""
        end
      end

      @options[:hygienic_macro] = tmp
    end

    def options
      @options || DEFAULT_OPTIONS
    end

  end

end
