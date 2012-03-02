class AdminController < AuthenticatedController
  before_filter :require_admin
  before_filter :set_pagination_values
private
  def require_admin
    redirect_to root_path unless current_user.admin?
  end

  def set_pagination_values
    raw_page     = params[ :page ]
    raw_per_page = params[ :per_page ]
    @page        = ( raw_page && !raw_page.empty? ) ? raw_page.to_i : 1
    @per_page    = ( raw_per_page && !raw_per_page.empty? ) ? raw_per_page.to_i : 50
  end
end
