module Remote
  class Repositories
    attr_reader :auth_token , :options , :org , :raw

    def initialize( *args , &block )
      @options    = Map Map.opts!( args )
      @auth_token = options.auth_token rescue args.shift or raise ArgumentError.new( "Missing option 'auth_token'!" )
      @org        = options.org        rescue args.shift or nil
    end

    def all
      fetch
      JSON.parse raw
    end

    def fetch
      @raw ||= Faraday.get( "#{ base_url }/repos?access_token=#{ auth_token }&type=private" ).body
    end

    def base_url
      org.github_url rescue "https://api.github.com/user"
    end
  end
end
