require "mongoid"

class Repository
  include Mongoid::Document

  belongs_to :user
  embeds_one :backup

  field :github_id , :type => String
end
