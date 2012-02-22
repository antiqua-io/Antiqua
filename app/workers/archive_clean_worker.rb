class ArchiveCleanWorker
  include GenericWorker
  attr_reader :archive,
              :archive_id,
              :options
  define_queue "archive_clean"

  def initialize( *args , &block )
    @options    = Map Map.opts!( args )
    @archive_id = options.archive_id rescue args.shift or raise ArgumentError.new( "Missing option 'archive_id'!" )
  end

  def bootstrap!
    @archive = Archive.find archive_id
  end

  def clean
    bootstrap!
    p "Cleaning!"
  end

  def perform
    clean
    archive.finish
  end
end
