class UsersController < AuthenticatedController
  before_filter :require_not_confirmed , :only => :show
  before_filter :require_same_user     , :only => :update

  def account
  end

  def show
    load_email!
  end

  def update
    current_user.safe_update params[ "user" ]
    params[ "user" ][ "_confirm" ] == "true" ? current_user.confirm! : current_user.save!
    redirect_to repositories_path
  end
private
  def load_email!
    @email = session[ :email ] || ""
  end

  def require_not_confirmed
    redirect_to repositories_path if current_user.confirmed?
  end

  def require_same_user
    same_user = current_user.user_name == params[ :id ]
    redirect_to root_path unless same_user
  end
end
