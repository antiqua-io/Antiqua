module GenericWorker
  def self.included( klass )
    klass.instance_eval &ClassMethods
    klass.class_eval    &InstanceMethods
  end

  ClassMethods = proc do
    def perform( *args , &block )
      worker = new *args , &block
      worker.perform
    end

    def define_queue( name )
      method_definition = proc do
        "#{ ENV[ "APP_ENV" ] }_#{ name }"
      end
      self.class.send :define_method , :queue , method_definition
    end
  end

  InstanceMethods = proc do
    def perform
      raise NotImplementedError.new "No method 'perform' defined for #{ self.class.name }"
    end
  end
end
