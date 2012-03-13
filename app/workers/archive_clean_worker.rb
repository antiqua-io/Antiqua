class ArchiveCleanWorker
  include GenericWorker
  attr_reader :archive,
              :archive_id,
              :cleaner,
              :options,
              :repository,
              :user

  def self.queue
    "#{ ENV[ "APP_ENV" ] }_archive_clean"
  end

  def initialize( *args , &block )
    @options    = Map Map.opts!( args )
    @archive_id = options.archive_id rescue args.shift or raise ArgumentError.new( "Missing option 'archive_id'!" )
  end

  def bootstrap!
    @archive    = Archive.find archive_id
    @repository = archive.repository
    @user       = archive.user
  end

  def clean
    bootstrap!
    create_cleaner!
    cleaner.clean!
  end

  def create_cleaner!
    @cleaner = ArchiveCleaner.new \
      :archive    => archive,
      :repository => repository,
      :user       => user
  end

  def perform
    clean
    archive.finish
    archive.delay_send_archive_created_email
  end
end
