require "active_support/core_ext/array/extract_options"
require "map"

class GitTag
  attr_accessor :options

  def initialize( *args , &block )
    @options = Map args.extract_options!
  end
end

