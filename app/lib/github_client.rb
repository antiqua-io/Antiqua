class GithubClient
  attr_reader :oauth_token , :options , :login

  API_URI = "https://api.github.com"

  def initialize( *args )
    @options     = Map Map.opts!( args )
    @login       = options.login       rescue args.shift or raise ArgumentError.new( "Missing argument 'login'!" )
    @oauth_token = options.oauth_token rescue args.shift or raise ArgumentError.new( "Missing argument 'oauth_token'!" )
  end

  def add_deploy_key( *args )
    options         = Map Map.opts!( args )
    repository_name = options.repository rescue args.shift or raise ArgumentError.new( "Missing argument 'repository_name'!" )
    title           = options.title      rescue args.shift or raise ArgumentError.new( "Missing argument 'title'!" )
    key             = options.key        rescue args.shift or raise ArgumentError.new( "Missing argument 'key'!" )
    response        = post "/repos/#{ login }/#{ repository_name }/keys" , { :key => key , :title => title }
    JSON.parse response.body
  end

private

  def post( path , data , headers = {} )
    headers.merge!( {
      "Authorization" => "token #{ oauth_token }",
      "Content-Type"  => "application/json"
    } )
    connection = Faraday::Connection.new :url => API_URI
    connection.post do | request |
      request.headers.merge! headers
      request.url            path
      request.body           = JSON.generate( data )
    end
  end
end
