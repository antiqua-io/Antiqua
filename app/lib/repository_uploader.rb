class RepositoryUploader
  attr_reader :archive,
              :aws_uploader,
              :options,
              :repository

  def initialize( *args )
    @options    = Map Map.opts!( args )
    @archive    = options.archive    rescue args.shift or raise ArgumentError.new( "Missing option 'archive'!" )
    @repository = options.repository rescue args.shift or raise ArgumentError.new( "Missing option 'repository'!" )
  end

  def create_uploader!
    aws_connection = AwsConnection.instance
    directory      = aws_connection.directories.create :key => "antiqua-#{ ENV[ "APP_ENV" ] }-archives"
    @aws_uploader  = directory.files
  end

  def upload!
    create_uploader!
    aws_uploader.create \
      :key  => "#{ archive.id_as_string }.tar.gz",
      :body => File.open( "#{ Rails.root }/tmp/app/archives/#{ archive.id_as_string }/#{ repository.github_name }.tar.gz" )
  end
end
