class RepositoriesController < AuthenticatedController
  before_filter :check_for_first_time_user

  def index
    @repos = RepositoryPresenter.present \
      :local_repos  => load_local_repositories,
      :remote_repos => load_remote_repositories,
      :user         => current_user,
      :params       => params

    respond_to do | format |
      format.html
      format.json { render :json => @repos }
    end
  end
private
  def check_for_first_time_user
    redirect_to user_path( current_user.user_name ) unless current_user.confirmed?
  end

  def load_local_repositories
    unless params[ :type ] == "remote"
      if params[ :org ].present? and org = Organization.with_repositories_archiveable_by( current_user ).find_by_name( params[ :org ] )
        repositories = Repository.for_organization( org ).for_user_with_archives current_user
      else
        repositories = Repository.without_organization.for_user_with_archives current_user
      end
      repositories
    else
      []
    end
  end

  def load_remote_repositories
    unless params[ :type ] == "local"
      org = if params[ :org ].present?
        Organization.with_repositories_archiveable_by( current_user ).find_by_name( params[ :org ] )
      else
        false
      end
      remote_repo_args = { :auth_token => session[ :auth_token ] }
      remote_repo_args.merge!( { :org => org } ) if org
      Remote::Repositories.new( remote_repo_args ).all
    else
      []
    end
  end
end
