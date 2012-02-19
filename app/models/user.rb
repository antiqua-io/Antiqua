require "mongoid"

class User
  include Mongoid::Document

  # Fields
  #
  field :auth_token , :type => String
  field :uid        , :type => Integer

  # Indices
  #
  index :uid , :unique => true

  # Relations
  #
  has_many :repositories
end
