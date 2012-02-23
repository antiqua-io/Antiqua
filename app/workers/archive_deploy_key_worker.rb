class ArchiveDeployKeyWorker
  include GenericWorker
  attr_reader :archive,
              :archive_id,
              :github_client,
              :options,
              :repository,
              :user

  def self.queue
    "#{ ENV[ "APP_ENV" ] }_archive_deploy_key"
  end

  def initialize( *args , &block )
    @options    = Map Map.opts!( args )
    @archive_id = options.archive_id rescue args.shift or raise ArgumentError.new( "Missing option 'archive_id'!" )
  end

  def bootstrap!
    @archive    = Archive.find archive_id
    @repository = archive.repository
    @user       = archive.user
  end

  def create_deploy_key
    bootstrap!
    generate_deploy_key!
    create_github_client!
    github_key_data = github_client.add_deploy_key repository_identifier , archive.deploy_key.name , archive.deploy_key.public_key
    persist_github_key_data! github_key_data
  end

  def create_github_client!
    @github_client ||= Octokit::Client.new :login => user.user_name , :oauth_token => user.auth_token
  end

  def generate_deploy_key!
    archive.generate_deploy_key!
  end

  def perform
    create_deploy_key
    archive.create_local_clone
  end

  def persist_github_key_data!( github_key_data )
    archive.deploy_key.github_id  = github_key_data[ "id" ]
    archive.deploy_key.github_url = github_key_data[ "url" ]
    archive.deploy_key.save!
  end

  def repository_identifier
    "#{ user.user_name }/#{ repository.github_name }"
  end
end
