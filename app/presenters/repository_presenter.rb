class RepositoryPresenter
  attr_reader :local_repos,
              :local_repos_with_archives,
              :options,
              :remote_repos

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
    @options      = Map.new Map.opts!( args )
    @local_repos  = options.local_repos  rescue []
    @remote_repos = options.remote_repos rescue []

    @local_repos_with_archives = []
  end

  def append_local_data( final )
    final.local = []
    local_repos.each do | local_repo |
      presented_local_repo = Map.new( {
        :archives    => ArchivePresenter.present( :target => local_repo.archives ),
        :github_id   => local_repo.github_id,
        :github_name => local_repo.github_name
      } )
      local_repos_with_archives.push presented_local_repo.github_id unless presented_local_repo.archives.empty?
      final.local.push presented_local_repo
    end
    final
  end

  def append_remote_data( final )
    final.remote = []
    remote_repos.each do | remote_repo |
      presented_remote_repo = Map.new
      REMOTE_FIELDS.each { | field | presented_remote_repo[ field ] = remote_repo[ field ] }
      if local_repos_with_archives.include? presented_remote_repo.id
        presented_remote_repo.has_archives = true
        presented_remote_repo.archive_btn_class = "btn-primary"
      else
        presented_remote_repo.has_archives = true
        presented_remote_repo.archive_btn_class = "btn-warning"
      end
      final.remote.push presented_remote_repo
    end
    final
  end

  def present
    final = Map.new
    final = append_local_data  final
    final = append_remote_data final
  end
end
