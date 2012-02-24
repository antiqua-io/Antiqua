module AwsConnection
  mattr_reader :connection_instance

  DEFAULT_OPTIONS = {
    :aws_access_key_id     => CONFIG.aws_access_key_id,
    :aws_secret_access_key => CONFIG.aws_secret_access_key,
    :provider              => "AWS"
  }

  def self.instance( *args )
    options = args.last.is_a?( Hash ) ? args.pop : {}
    @@connection_instance ||= Fog::Storage.new DEFAULT_OPTIONS.merge options
    connection_instance
  end
end
