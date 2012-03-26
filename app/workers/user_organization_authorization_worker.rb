class UserOrganizationAuthorizationWorker
  include GenericWorker
  attr_reader :args,
              :options,
              :organizations,
              :teams,
              :user,
              :user_id

  def self.queue
    "#{ ENV[ "APP_ENV" ] }_user_organization_authorization"
  end

  def initialize( *args )
    @options = Map.opts! args
    @user_id = options.user_id rescue args.shift or raise ArgumentError.new( "Missing options 'user_id'!" )
  end

  def authorize_user_organizations
    organizations.each do | organization |
      organization.owners     << user if is_user_owner?( organization )
      organization.archivists << user if is_user_archivist?( organization )
    end
  end

  def bootstrap!
    load_user!
    load_organizations!
    load_teams!
  end

  def is_user_archivist?( organization )
    is_user_team_member? organization , "Archivists"
  end

  def is_user_owner?( organization )
    is_user_team_member? organization , "Owners"
  end

  def is_user_team_member?( organization , team_name )
    organization_teams = teams[ organization ]
    referenced_team    = organization_teams.detect { | team | team[ "name" ] == team_name }
    referenced_team.present? and TeamMemberChecker.check( :team => referenced_team , :user => user)
  end

  def load_organizations!
    remote_organizations = Remote::Organizations.new( user.auth_token ).all
    organizations = []
    remote_organizations.each do | remote_organization |
      remote_organization = Map.new remote_organization
      organization = Organization.find_or_create_by :github_id => remote_organization.id
      organization.update_attributes! \
        :image_url  => remote_organization.avatar_url,
        :github_url => remote_organization.url,
        :name       => remote_organization.login
      organizations.push organization
    end
    @organizations = organizations
  end

  def load_teams!
    teams = {}
    organizations.each do | organization |
      remote_teams = Remote::Teams.new \
        :auth_token              => user.auth_token,
        :github_organization_url => organization.github_url
      teams[ organization ] = remote_teams.all
    end
    @teams = teams
  end

  def load_user!
    @user ||= User.find user_id
  end

  def perform
    bootstrap!
    authorize_user_organizations
    user.finish_permissions_build
  end
end
