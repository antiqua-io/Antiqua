class StaticController < ApplicationController
  caches_action :contact          , :layout => false
  caches_action :home             , :layout => false
  caches_action :privacy_policy   , :layout => false
  caches_action :terms_of_service , :layout => false
  def contact; end
  def home; end
  def privacy_policy; end
  def terms_of_service; end
end
