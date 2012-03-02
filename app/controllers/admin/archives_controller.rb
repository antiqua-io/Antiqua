class Admin::ArchivesController < AdminController
  def index
    @archives = Archive.page( @page ).per @per_page
  end
end
