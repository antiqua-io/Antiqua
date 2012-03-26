class RepositoriesController < AuthenticatedController
  before_filter :check_for_first_time_user

  def index
    @repos = RepositoryPresenter.present \
      :local_repos  => load_local_repositories,
      :remote_repos => load_remote_repositories

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
    ( params[ :type ] == "remote" ) ? [] : Repository.for_user_with_archives( current_user )
  end

  def load_remote_repositories
    ( params[ :type ] == "local" ) ? [] : Remote::Repositories.new( :auth_token => session[ :auth_token ] ).all
  end
end
