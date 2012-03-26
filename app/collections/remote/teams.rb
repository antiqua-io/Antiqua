module Remote
  class Teams
    attr_reader :auth_token , :github_organization_url , :options , :raw

    def initialize( *args )
      @options                 = Map.opts! args
      @auth_token              = options.auth_token              rescue args.shift or raise ArgumentError.new( "Missing argument 'auth_token'!" )
      @github_organization_url = options.github_organization_url rescue args.shift or raise ArgumentError.new( "Missing argument 'github_organization_url'!" )
    end

    def all
      fetch
      JSON.parse raw
    end

    def fetch
      @raw ||= Faraday.get( "#{ github_organization_url }/teams?access_token=#{ auth_token }" ).body
    end
  end
end
