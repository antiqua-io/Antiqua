require "mongoid"
require "resque"
require "state_machine"

class Archive
  include Mongoid::Document

  field :repo_id , :type => Integer
  field :state   , :type => String

  state_machine :initial => :initialized do
    state :initialized
    state :queued
    state :creating_deploy_key
    state :cloning
    state :archiving
    state :cleaning
    state :finished

    event :queue do
      transition :initialized => :queued
    end

    event :create_deploy_key do
      transition :queued => :creating_deploy_key
    end

    after_transition :on => :queue , :do => :create_deploy_key
    after_transition :on => :create_deploy_key , :do => :enqueue_deploy_key_worker
  end

  def enqueue_deploy_key_worker
    Resque.enqueue ArchiveDeployKeyWorker , :archive_id => id
  end
end
