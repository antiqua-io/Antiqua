class ArchiveUploadWorker
  include GenericWorker
  attr_reader :archive,
              :archive_id,
              :options,
              :repository,
              :uploader

  def self.queue
    "#{ ENV[ "APP_ENV" ] }_archive_upload"
  end

  def initialize( *args , &block )
    @options    = Map Map.opts!( args )
    @archive_id = options.archive_id rescue args.shift or raise ArgumentError.new( "Missing option 'archive_id'!" )
  end

  def bootstrap!
    @archive    = Archive.find archive_id
    @repository = archive.repository
  end

  def create_upload
    bootstrap!
    create_uploader!
    uploader.upload!
  end

  def create_uploader!
    @uploader = RepositoryUploader.new \
      :archive    => archive,
      :repository => repository
  end

  def perform
    create_upload
    archive.clean
  end
end
