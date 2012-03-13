class GenericDelayedWorker
  include GenericWorker
  attr_reader :args,
              :delayed_method,
              :desired_klass,
              :instance,
              :klass_id,
              :options

  def self.queue
    "#{ ENV[ "APP_ENV" ] }_generic_delayed"
  end

  def initialize( *args , &block )
    @options        = Map.new Map.opts!( args )
    @desired_klass  = options.desired_klass  rescue args.shift or raise ArgumentError.new( "Missing option 'desired_klass'!" )
    @klass_id       = options.klass_id       rescue args.shift or raise ArgumentError.new( "Missing option 'klass_id'!" )
    @delayed_method = options.delayed_method rescue args.shift or raise ArgumentError.new( "Missing option 'delayed_method'!" )
    @args           = options.args           rescue args.shift or raise ArgumentError.new( "Missing option 'args'!" )
  end

  def find_and_execute
    find_instance
    instance.send delayed_method.to_sym , *args
  end

  def find_instance
    local_klass = ( !desired_klass.is_a? String ) ? desired_klass : desired_klass.constantize
    @instance = local_klass.find klass_id
  end

  def perform
    find_and_execute
  end
end
