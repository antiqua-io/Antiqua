module GlobalAlert
  ALERTS = Map.new( {
    "demo_warning" => "<strong>Warning!</strong> This is just a demo. Do NOT depend on any archives at this time. You can make as many archives as you want and you will NOT be charged."
  } )

  def []( id )
    fetch id
  end

  def fetch( id )
    ALERTS[ id ]
  end

  extend self
end
