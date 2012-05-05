class Organization
  include DelayedExecution
  include Mongoid::Document
  include Mongoid::Timestamps

  # Embeds
  #
  embeds_one :subscription , :class_name => "Organization::Subscription"

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
  has_many                :repositories

  def self.find_by_name( name )
    where( :name => name ).first
  end

  def self.with_repositories_archiveable_by( user )
    any_of( { :owner_ids => user.id } , { :archivist_ids => user.id } )
  end

  def send_new_subscription_email
    OrganizationMailer.new_subscription_email( self ).deliver
  end

  def send_unsubscribe_email
    OrganizationMailer.unsubscribe_email( self ).deliver
  end

  def subscribe!( stripe_token , owner )
    sub = build_subscription
    sub.subscribe! stripe_token , owner
    self.is_subscribed = true
    save!
    delay_send_new_subscription_email
  end

  def subscribed?
    is_subscribed
  end

  def unsubscribe!
    subscription.unsubscribe! and subscription.destroy
    self.is_subscribed = false
    save!
    delay_send_unsubscribe_email
  end
end
