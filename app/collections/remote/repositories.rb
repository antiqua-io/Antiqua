module Remote
  class Repositories
    attr_reader :auth_token , :options , :raw

    def initialize( *args , &block )
      @options    = Map Map.opts!( args )
      @auth_token = options.auth_token rescue args.shift
    end

    def all
      fetch
      JSON.parse raw
    end

    def fetch
      @raw ||= Faraday.get( "https://api.github.com/user/repos?access_token=#{ auth_token }&type=private" ).body
    end
  end
end
