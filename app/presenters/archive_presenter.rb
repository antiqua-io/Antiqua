class ArchivePresenter
  attr_accessor :options , :target

  def initialize( *args , &block )
    @options = Map Map.opts!( args )
    @target  = args.shift || options.target
  end

  def present
    return present_one if target.is_a? Mongoid::Document
    present_many
  end

  def present_many
    target.map { | archive | present_one archive }
  end

  def present_one( archive = nil )
    archive = archive || target
    {
      :id            => archive.id.to_s,
      :repository_id => archive.repository_id,
      :state         => archive.state
    }
  end
end

