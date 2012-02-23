class ArchiveTarBallWorker
  include GenericWorker
  attr_reader :archive,
              :archive_id,
              :options,
              :repository,
              :tar_baller

  def self.queue
    "#{ ENV[ "APP_ENV" ] }_archive_tar_ball"
  end

  def initialize( *args , &block )
    @options    = Map Map.opts!( args )
    @archive_id = options.archive_id rescue args.shift or raise ArgumentError.new( "Missing option 'archive_id'!" )
  end

  def bootstrap!
    @archive    = Archive.find archive_id
    @repository = archive.repository
  end

  def create_tar_ball
    bootstrap!
    create_tar_baller!
    tar_baller.tar!
  end

  def create_tar_baller!
    @tar_baller = RepositoryTarBaller.new \
      :archive    => archive,
      :repository => repository
  end

  def perform
    create_tar_ball
    archive.upload
  end
end
