module Remote
  class Archives
    cattr_reader :connection , :directory

    def self.initialize!
      @@connection ||= AwsConnection.instance
      @@directory  ||= connection.directories.get "antiqua-#{ ENV[ "APP_ENV" ] }-archives"
    end

    def initialize( *args )
      initialize!
    end

    def get( file )
      self.class.directory.files.get file
    end

    def initialize!
      self.class.initialize!
    end
  end
end
