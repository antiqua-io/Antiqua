class ArchiveCleaner
  attr_reader :archive,
              :github_client,
              :options,
              :repository,
              :user

  def initialize( *args )
    @options    = Map Map.opts!( args )
    @archive    = options.archive    rescue args.shift or raise ArgumentError.new( "Missing option 'archive'!" )
    @repository = options.repository rescue args.shift or raise ArgumentError.new( "Missing option 'repository'!" )
    @user       = options.user       rescue args.shift or raise ArgumentError.new( "Missing option 'user'!" )
  end

  def clean!
    system "rm -rf #{ Rails.root }/tmp/app/archives/#{ archive.id_as_string }"
    create_github_client!
    github_client.remove_deploy_key repository_identifier , archive.deploy_key.github_id
  end

  def create_github_client!
    @github_client ||= Octokit::Client.new :login => user.user_name , :oauth_token => user.auth_token
  end

  def repository_identifier
    "#{ repository_owner_name }/#{ repository.github_name }"
  end

  def repository_owner_name
    repository.organization.name rescue user.user_name
  end
end
