class ArchiveWorker
  include GenericWorker
  attr_reader :archive,
              :archive_id,
              :options
  define_queue "archive"

  def initialize( *args , &block )
    @options    = Map Map.opts!( args )
    @archive_id = options.archive_id rescue args.shift or raise ArgumentError.new( "Missing option 'archive_id'!" )
  end

  def bootstrap!
    @archive = Archive.find archive_id
  end

  def create_archive
    bootstrap!
    p "Archiving!"
  end

  def perform
    create_archive
    archive.clean
  end
end
