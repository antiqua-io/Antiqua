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

  def create_aws_connection!
    @aws_connection ||= Fog::Storage.new \
                          :aws_access_key_id     => CONFIG.aws_access_key_id,
                          :aws_secret_access_key => CONFIG.aws_secret_access_key,
                          :provider              => "AWS"
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
    if archive.finished?
      create_aws_connection!
      remote_archive_object = aws_connection.directories.get( "antiqua-#{ ENV[ "APP_ENV" ] }-archives" ).files.get( "#{ archive.id_as_string }.tar.gz" )
      download_url = remote_archive_object.url 30.minutes.from_now
    else
      download_url = "#"
    end
    {
      :download_url  => download_url,
      :github_id     => archive.repository.github_id,
      :id            => archive.id_as_string,
      :pretty_state  => STATE_MAP[ archive.state ],
      :repository_id => archive.repository.id.to_s,
      :state         => archive.state
    }
  end
end

