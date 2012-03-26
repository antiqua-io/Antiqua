module Remote
  class Organizations
    attr_reader :auth_token , :options , :raw

    def initialize( *args , &block )
      @options    = Map.opts! args
      @auth_token = options.auth_token rescue args.shift or raise ArgumentError.new( "Missing argument 'auth_token'!" )
    end

    def all
      fetch
      JSON.parse raw
    end

    def fetch
      @raw ||= Faraday.get( "https://api.github.com/user/orgs?access_token=#{ auth_token }" ).body
    end
  end
end
