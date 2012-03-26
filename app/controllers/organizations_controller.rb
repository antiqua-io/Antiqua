class OrganizationsController < AuthenticatedController
  def index
    @organizations = OrganizationsPresenter.present :organizations => load_organizations
    render :json => @organizations
  end
private
  def load_organizations
    Organization.with_repositories_archiveable_by current_user
  end
end
