require "active_support/core_ext/array/extract_options"
require "map"

class BackupPresenter
  attr_accessor :options , :target

  def initialize( *args , &block )
    @options = Map args.extract_options!
    @target  = args.shift || options.target
  end

  def present
    return present_one if target.is_a? Mongoid::Document
    present_many
  end

  def present_many
    target.map { | backup | present_one backup }
  end

  def present_one( backup = nil )
    backup = backup || target
    {
      :id      => backup.id.to_s,
      :repo_id => backup.repo_id,
      :state   => backup.state
    }
  end
end

