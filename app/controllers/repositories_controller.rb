class RepositoriesController < AuthenticatedController
  before_filter :check_for_first_time_user

  def index
    @repos = RepositoryPresenter.present \
      :remote_repos => Remote::Repositories.new( :auth_token => session[ :auth_token ] ).all,
      :repos        => current_user.repositories
    respond_to do | format |
      format.html
      format.json { render :json => @repos }
    end
  end
private
  def check_for_first_time_user
    redirect_to user_path( current_user.user_name ) unless current_user.confirmed?
  end
end
