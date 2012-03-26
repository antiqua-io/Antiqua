class Organization
  include Mongoid::Document
  include Mongoid::Timestamps

  # Fields
  #
  field :github_id  , :type => Integer
  field :github_url , :type => String
  field :image_url  , :type => String
  field :name       , :type => String

  # Indices
  #
  index :github_id , :unique => true

  # Relations
  #
  has_and_belongs_to_many :archivists , :class_name => "::User" , :inverse_of => nil
  has_and_belongs_to_many :owners     , :class_name => "::User" , :inverse_of => nil

  def self.with_repositories_archiveable_by( user )
    any_of( { :owner_ids => user.id } , { :archivist_ids => user.id } )
  end
end
