class ArchivesController < AuthenticatedController
  def create
    repository = Repository.find_or_create_by \
      :github_id   => params[ :github_repository_id ] ,
      :github_name => params[ :github_repository_name ]
    repository.users << current_user unless repository.users.include? current_user
    archive = repository.archives.create! :user => current_user
    archive.queue
    archive_presenter = ArchivePresenter.new :target => archive
    render :json => archive_presenter.present , :status => 202
  end
end
