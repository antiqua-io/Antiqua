class Repository
  include Mongoid::Document
  include Mongoid::Timestamps

  # Fields
  #
  field :github_id      , :type => Integer
  field :github_name    , :type => String
  field :github_ssh_url , :type => String

  # Relations
  #
  belongs_to              :organization
  has_and_belongs_to_many :users
  has_many                :archives

  def self.for_organization( organization )
    where :organization_id => organization.id
  end

  def self.for_user_with_archives( user )
    where( :_id.in => user.repository_ids ).includes :archives
  end

  def self.without_organization
    where :organization_id => nil
  end
end
