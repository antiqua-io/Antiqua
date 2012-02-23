class ArchiveCloneWorker
  include GenericWorker
  attr_reader :archive,
              :archive_id,
              :cloner,
              :options,
              :repository

  def self.queue
    "#{ ENV[ "APP_ENV" ] }_archive_clone"
  end

  def initialize( *args , &block )
    @options    = Map Map.opts!( args )
    @archive_id = options.archive_id rescue args.shift or raise ArgumentError.new( "Missing option 'archive_id'!" )
  end

  def bootstrap!
    @archive    = Archive.find archive_id
    @repository = archive.repository
  end

  def clone
    bootstrap!
    create_cloner!
    cloner.clone!
  end

  def create_cloner!
    @cloner = RepositoryCloner.new \
      :archive    => archive,
      :repository => repository
  end

  def perform
    clone
    archive.tar
  end
end
