class User
  include DelayedExecution
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
  field :agreements               , :type => Hash
  field :auth_token               , :type => String
  field :confirmed_at             , :type => Time
  field :email                    , :type => String
  field :image_url                , :type => String
  field :is_admin                 , :type => Boolean , :default => false
  field :is_confirmed             , :type => Boolean , :default => false
  field :is_subscribed            , :type => Boolean , :default => false
  field :organization_permissions , :type => String
  field :uid                      , :type => Integer
  field :user_name                , :type => String

  # Indices
  #
  index :uid , :unique => true

  # Relations
  #
  has_many                :archives
  has_and_belongs_to_many :repositories

  state_machine :organization_permissions , :initial => :empty_permissions do
    state :building_permissions
    state :empty_permissions
    state :permissions_built

    event :build_permissions do
      transition :empty_permissions => :building_permissions
    end

    event :finish_permissions_build do
      transition :building_permissions => :permissions_built
    end

    event :rebuild_permissions do
      transition :permissions_built => :building_permissions
    end

    after_transition any => :building_permissions , :do => :enqueue_permissions_builder_worker
  end

  def admin?
    is_admin
  end

  def build_or_rebuild_org_permissions
    return rebuild_permissions if permissions_built?
    build_permissions
  end

  def confirm!
    self.confirmed_at = Time.now.utc
    self.is_confirmed = true
    save!
    delay_send_signup_email
  end

  def confirmed?
    is_confirmed
  end

  def enqueue_permissions_builder_worker
    Resque.enqueue UserOrganizationAuthorizationWorker , :user_id => id.to_s
  end

  def safe_update( attrs )
    attrs.each do | key , val |
      send( "#{ key }=".to_sym , val ) if SAFE_FIELDS.include? key.to_sym
    end
  end

  def send_signup_email
    UserMailer.signup_email( self ).deliver
  end

  def send_new_subscription_email
    UserMailer.new_subscription_email( self ).deliver
  end

  def send_unsubscribe_email
    UserMailer.unsubscribe_email( self ).deliver
  end

  def subscribe!( stripe_token )
    sub = build_subscription
    sub.subscribe! stripe_token
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
