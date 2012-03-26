class OrganizationsPresenter
  attr_reader :options , :organizations

  def self.present( *args )
    presenter = new *args
    presenter.present
  end

  def initialize( *args )
    @options = Map.opts! args
    @organizations = options.organizations rescue args.shift or raise ArgumentError.new( "Missing argument 'organizations'!" )
  end

  def present
    organizations
  end
end
