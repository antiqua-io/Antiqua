class Admin::UsersController < AdminController
  def index
    @users = User.page( @page ).per @per_page
  end
end
