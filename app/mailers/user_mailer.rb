class UserMailer < ActionMailer::Base
  default :from => "hello@antiqua.io"

  def new_subscription_email( user )
    @url  = url
    @user = user
    mail :to => user.email , :subject => "Thanks for subscribing to Antiqua.IO"
  end

  def signup_email( user )
    @url  = url
    @user = user
    mail :to => user.email , :subject => "Welcome to Antiqua.IO"
  end

  def unsubscribe_email( user )
    @url  = url
    @user = user
    mail :to => user.email , :subject => "We're Sorry to See You Go!"
  end

  def url
    "https://#{ CONFIG.sendgrid_domain }"
  end
end
