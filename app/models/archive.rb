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
    state :creating_deploy_key
    state :cloning
    state :cleaning
    state :finished
    state :tarring
    state :uploading

    event :clean do
      transition :uploading => :cleaning
    end

    event :create_local_clone do
      transition :creating_deploy_key => :cloning
    end

    event :finish do
      transition :cleaning => :finished
    end

    event :queue do
      transition :initialized => :creating_deploy_key
    end

    event :tar do
      transition :cloning => :tarring
    end

    event :upload do
      transition :tarring => :uploading
    end

    after_transition :on => :clean              , :do => :enqueue_clean_worker      # 5
    after_transition :on => :create_local_clone , :do => :enqueue_clone_worker      # 2
    after_transition :on => :queue              , :do => :enqueue_deploy_key_worker # 1
    after_transition :on => :tar                , :do => :enqueue_tar_ball_worker   # 3
    after_transition :on => :upload             , :do => :enqueue_upload_worker     # 4
  end

  def enqueue_clean_worker
    Resque.enqueue ArchiveCleanWorker , :archive_id => id_as_string
  end

  def enqueue_clone_worker
    Resque.enqueue ArchiveCloneWorker , :archive_id => id_as_string
  end

  def enqueue_deploy_key_worker
    Resque.enqueue ArchiveDeployKeyWorker , :archive_id => id_as_string
  end

  def enqueue_tar_ball_worker
    Resque.enqueue ArchiveTarBallWorker , :archive_id => id_as_string
  end

  def enqueue_upload_worker
    Resque.enqueue ArchiveUploadWorker , :archive_id => id_as_string
  end

  def generate_deploy_key!
    deploy_key.destroy if deploy_key.present?
    key = build_deploy_key
    key.generate!
    key
  end

  def id_as_string
    id.to_s
  end
end
