class RepositoriesController < AuthenticatedController
  def index
    @repos = RepositoryPresenter.present \
      :remote_repos => Remote::Repositories.new( :auth_token => session[ :auth_token ] ).all,
      :repos        => current_user.repositories
  end
end
