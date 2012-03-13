module DelayedExecution
  def __delay__( *args )
    Resque.enqueue GenericDelayedWorker , *args
  end

  def is_delayable?( method )
    delayable_regex  = /^delay_/
    attempting_delay = !!( method =~ delayable_regex )
    method           = method.to_s.sub( delayable_regex , '' ).to_sym
    is_delayable     = respond_to? method
    [ attempting_delay , is_delayable , method ]
  end

  def method_missing( method , *args , &block )
    attempting_delay , is_delayable , delayed_method = is_delayable? method
    return super unless attempting_delay && is_delayable
    raise ArgumentError.new( "Unable to delay methods w/ blocks!" ) if block.present?
    __delay__ \
      :desired_klass  => self.class.to_s,
      :klass_id       => self.id.to_s,
      :delayed_method => delayed_method,
      :args           => args
  end
end
