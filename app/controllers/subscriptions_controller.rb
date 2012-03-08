class SubscriptionsController < AuthenticatedController
  before_filter :require_same_user , :only => :update

  def create
    current_user.subscribe! params[ "stripe_token" ]
    redirect_to account_user_path( current_user.user_name ) , :notice => "You have successfully subscribed to Antiqua!"
  end

  def destroy
    current_user.unsubscribe!
    redirect_to account_user_path( current_user.user_name ) , :notice => "You have successfully unsubscribed from Antiqua!"
  end
private
  def require_same_user
    same_user = current_user.user_name == params[ :id ]
    redirect_to root_path unless same_user
  end
end
