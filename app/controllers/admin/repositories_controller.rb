class Admin::RepositoriesController < AdminController
  def index
    @repositories = Repository.includes( :archives ).page( @page ).per @per_page
  end
end
