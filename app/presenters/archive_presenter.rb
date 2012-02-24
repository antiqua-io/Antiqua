class ArchivePresenter
  attr_accessor :aws_connection , :options , :target

  STATE_MAP = Map( {
    :initialized         => "Initialized",
    :creating_deploy_key => "Creating Deploy Key",
    :cloning             => "Cloning",
    :cleaning            => "Cleaning Up",
    :finished            => "Archived!",
    :tarring             => "Creating Tar Ball",
    :uploading           => "Uploading"
  } )

  def self.present( *args )
    presenter = new *args
    presenter.present
  end

  def initialize( *args )
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
      :created_at    => archive.created_at.strftime( "%b %d %Y %H:%M:%S" ),
      :download_url  => "#",
      :github_id     => archive.repository.github_id,
      :id            => archive.id_as_string,
      :pretty_state  => STATE_MAP[ archive.state ],
      :repository_id => archive.repository.id.to_s,
      :state         => archive.state
    }
  end
end

