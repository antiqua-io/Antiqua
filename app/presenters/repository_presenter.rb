class RepositoryPresenter
  attr_reader :final , :options , :remote_repos , :repos

  REMOTE_FIELDS = [
    "description",
    "html_url",
    "id",
    "name",
    "ssh_url"
  ]

  def self.present( *args )
    presenter = new *args
    presenter.present
  end

  def initialize( *args )
    @options      = Map Map.opts!( args )
    @remote_repos = options.remote_repos rescue []
    @repos        = options.repos        rescue []
  end

  def mix_app_local_data( final )
    final.each do | repo |
      local_repo = repos.detect { | r | r.github_id == repo[ "id" ] }
      if local_repo
        archives = ArchivePresenter.present( :target => local_repo.archives )
      else
        archives = []
      end
      repo[ "archives" ] = archives
    end
    final
  end

  def present
    @final = []
    @final = trim_remote_data @final
    @final = mix_app_local_data @final
    @final.map { | r | Map r }
  end

  def trim_remote_data( final )
    remote_repos.each do | r |
      new_r = {}
      REMOTE_FIELDS.each { | f | new_r[ f ] = r[ f ] }
      final.push new_r
    end
    final
  end
end
