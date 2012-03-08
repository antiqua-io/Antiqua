class User
  include Mongoid::Document
  include Mongoid::Timestamps

  # Constants
  #
  SAFE_FIELDS = [ :agreements , :email ]

  # Embeds
  #
  embeds_one :subscription , :class_name => "User::Subscription"

  # Fields
  #
  field :agreements         , :type => Hash
  field :auth_token         , :type => String
  field :confirmed_at       , :type => Time
  field :email              , :type => String
  field :image_url          , :type => String
  field :is_admin           , :type => Boolean , :default => false
  field :is_confirmed       , :type => Boolean , :default => false
  field :is_subscribed      , :type => Boolean , :default => false
  field :uid                , :type => Integer
  field :user_name          , :type => String

  # Indices
  #
  index :uid , :unique => true

  # Relations
  #
  has_many                :archives
  has_and_belongs_to_many :repositories

  def admin?
    is_admin
  end

  def confirm!
    self.confirmed_at = Time.now.utc
    self.is_confirmed = true
    save!
  end

  def confirmed?
    is_confirmed
  end

  def safe_update( attrs )
    attrs.each do | key , val |
      send( "#{ key }=".to_sym , val ) if SAFE_FIELDS.include? key.to_sym
    end
  end

  def subscribe!( stripe_token )
    sub = build_subscription
    sub.subscribe! stripe_token
    self.is_subscribed = true
    save!
  end

  def subscribed?
    is_subscribed
  end

  def unsubscribe!
    subscription.unsubscribe! and subscription.destroy
    self.is_subscribed = false
    save!
  end
end
