class RepositoryTarBaller
  attr_reader :archive,
              :options,
              :repository,
              :tar_baller

  def initialize( *args )
    @options = Map Map.opts!( args )
    @archive    = options.archive    rescue args.shift or raise ArgumentError.new( "Missing option 'archive'!" )
    @repository = options.repository rescue args.shift or raise ArgumentError.new( "Missing option 'repository'!" )
  end

  def tar!
    system <<-COMMAND
      cd #{ Rails.root }/tmp/app/archives/#{ archive.id_as_string } && \
        tar -czf #{ repository.github_name }.tar.gz #{ repository.github_name }
    COMMAND
  end
end
