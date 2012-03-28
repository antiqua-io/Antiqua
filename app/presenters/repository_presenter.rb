class RepositoryPresenter
  attr_reader :local_repos,
              :local_repos_with_archives,
              :options,
              :params,
              :remote_repos,
              :user

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
    @options      = Map.opts! args
    @local_repos  = options.local_repos  rescue args.shift || []
    @remote_repos = options.remote_repos rescue args.shift || []
    @user         = options.user         rescue args.shift || nil
    @params       = options.params       rescue args.shift || Map.new

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

  def append_org_data( final )
    if user.present? && user.permissions_built?
      final.render_user_orgs = true
      final.orgs = []
      Organization.with_repositories_archiveable_by( user ).each do | org |
        presented_org = Map.new
        presented_org.name      = org.name
        presented_org.image_url = org.image_url
        final.orgs.push presented_org
      end
    else
      final.render_user_orgs = false
    end
    final
  end

  def append_org_context_data( final )
    if params[ "org" ] and org = final.orgs.detect { | o | o.name == params[ "org" ] }
      final.org_context = org
      final.org_context_is_org = true
    else
      final.org_context = Map.new :image_url => user.image_url , :name => user.user_name
      final.org_context_is_org = false
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
    final = append_local_data       final
    final = append_remote_data      final
    final = append_org_data         final
    final = append_org_context_data final
  end
end
