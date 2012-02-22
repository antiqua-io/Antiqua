class Archive
  include Mongoid::Document

  # Embeds
  #
  embeds_one :deploy_key , :class_name => "Archive::DeployKey"

  # Fields
  #
  field :state , :type => String

  # Relations
  #
  belongs_to :repository
  belongs_to :user

  state_machine :initial => :initialized do
    state :initialized
    state :queued
    state :creating_deploy_key
    state :cloning
    state :archiving
    state :cleaning
    state :finished

    event :queue do
      transition :initialized => :creating_deploy_key
    end

    after_transition :on => :queue , :do => :enqueue_deploy_key_worker
  end

  def enqueue_deploy_key_worker
    Resque.enqueue ArchiveDeployKeyWorker , :archive_id => id
  end

  def generate_deploy_key!
    deploy_key.destroy if deploy_key.present?
    key = build_deploy_key
    key.generate!
    key
  end
end
