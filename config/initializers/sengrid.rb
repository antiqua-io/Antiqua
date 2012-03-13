ActionMailer::Base.smtp_settings = {
  :user_name            => CONFIG.sendgrid_user_name,
  :password             => CONFIG.sendgrid_password,
  :domain               => CONFIG.sendgrid_domain,
  :address              => "smtp.sendgrid.net",
  :port                 => 587,
  :authentication       => :plain,
  :enable_starttls_auto => true
}
