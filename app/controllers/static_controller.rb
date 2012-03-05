class StaticController < ApplicationController
  caches_action :home , :layout => false
  def home; end
end
