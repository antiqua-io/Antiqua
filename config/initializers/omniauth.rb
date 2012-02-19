require "omniauth"
require "omniauth-github"
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github,
           CONFIG.github_token,
           CONFIG.github_secret,
           :scope => "repo"
end
