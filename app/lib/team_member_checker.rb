class TeamMemberChecker
  attr_reader :options , :response , :team , :user

  def self.check( *args )
    checker = new *args
    checker.is_member?
  end

  def initialize( *args )
    @options = Map.opts! args
    @team = options.team rescue args.shift or raise ArgumentError.new( "Missing option 'team'!" )
    @user = options.user rescue args.shift or raise ArgumentError.new( "Missing option 'user'!" )
  end

  def check!
    @response ||= Faraday.get "#{ team[ "url" ] }/members/#{ user.user_name }?access_token=#{ user.auth_token }"
  end

  def is_member?
    check!
    response.success?
  end
end
