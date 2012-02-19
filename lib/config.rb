module CONFIG
  def self.method_missing( method , *args , &block )
    key = "CONFIG_#{ method.to_s.upcase }"
    val = ENV[ key ]
    return val if val
    super
  end
end

