class User
  include Mongoid::Document
  include Mongoid::Timestamps

  # Fields
  #
  field :auth_token , :type => String
  field :image_url  , :type => String
  field :uid        , :type => Integer
  field :user_name  , :type => String

  # Indices
  #
  index :uid , :unique => true

  # Relations
  #
  has_many                :archives
  has_and_belongs_to_many :repositories
end
