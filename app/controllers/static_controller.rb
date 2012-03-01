class StaticController < ApplicationController
  caches_action :home
  def home; end
end
