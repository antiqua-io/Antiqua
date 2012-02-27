class ArchivesController < AuthenticatedController
  def create
    repository = Repository.find_or_create_by \
      :github_id      => params[ :github_repository_id ].to_i ,
      :github_name    => params[ :github_repository_name ],
      :github_ssh_url => params[ :github_repository_ssh_url ]
    repository.users << current_user unless repository.users.include? current_user
    archive = repository.archives.create! :user => current_user
    archive.queue
    presented_archive = ArchivePresenter.present :target => archive
    render :json => presented_archive , :status => 202
  end

  def tar_ball
    remote_archive_object = Remote::Archives.new.get "#{ params[ "id" ] }.tar.gz"
    redirect_to remote_archive_object.url( 5.minutes.from_now )
  end
end
