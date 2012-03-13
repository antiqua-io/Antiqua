resque_config = YAML.load_file "#{ Rails.root }/config/resque.yml"
Resque.redis = resque_config[ Rails.env ] || resque_config[ "default" ]
