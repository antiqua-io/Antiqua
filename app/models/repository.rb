require "mongoid"

class Repository
  include Mongoid::Document

  # Fields
  #
  field :github_id      , :type => String
  field :github_name    , :type => String
  field :github_ssh_url , :type => String

  # Relations
  #
  has_and_belongs_to_many :users
  has_many                :archives
end
