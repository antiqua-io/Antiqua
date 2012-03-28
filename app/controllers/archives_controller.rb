class ArchivesController < AuthenticatedController
  before_filter :verify_user_subscription , :only => :create

  def create
    org_name = ( !params[ :github_repository_org ].empty? ) ? params[ :github_repository_org ] : false
    @has_org_context = !!org_name
    authorize_user_for_org! org_name if @has_org_context
    repository = Repository.find_or_create_by \
      :github_id      => params[ :github_repository_id ].to_i,
      :github_name    => params[ :github_repository_name ],
      :github_ssh_url => params[ :github_repository_ssh_url ]
    repository.users << current_user unless repository.users.include? current_user
    repository.organization = @org if @has_org_context
    archive = repository.archives.create! :user => current_user
    archive.queue
    repository.save!
    presented_archive = ArchivePresenter.present :target => archive
    render :json => presented_archive , :status => 202
  end

  def tar_ball
    remote_archive_object = Remote::Archives.new.get "#{ params[ "id" ] }.tar.gz"
    redirect_to remote_archive_object.url( 5.minutes.from_now )
  end
private
  def authorize_user_for_org!( org_name )
    @org = Organization.with_repositories_archiveable_by( current_user ).find_by_name( org_name )
    render( :json => { "error" => "unauthorized_organization" } , :status => 403 ) unless @org
  end

  def user_allowed?
    current_user.subscribed? || current_user.archives.count < 1
  end

  def verify_user_subscription
    render( :json => { "error" => "needs_subscription" , "user_name" => current_user.user_name } , :status => 403 ) unless user_allowed?
  end
end
