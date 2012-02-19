require "map"

class ArchiveDeployKeyWorker
  include       GenericWorker
  attr_accessor :archive_id , :options
  define_queue  "archive_deploy_key"

  def initialize( *args , &block )
    @options    = Map Map.opts!( args )
    @archive_id = options.archive_id rescue args.shift or raise ArgumentError.new( "Missing option 'archive_id'!" )
  end

  def create_deploy_key
    p "hi"
  end

  def perform
    create_deploy_key
  end
end
