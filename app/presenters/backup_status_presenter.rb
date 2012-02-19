require "map"

class BackupStatusPresenter
  attr_reader :raw_status

  PRETTY_STATUS_NAMES = Map( {
    :initialized => "Initialized",
    :queued      => "Queued",
    :started     => "Working",
    :finished    => "Archived"
  } )

  def initialize( raw_status )
    @raw_status = raw_status
  end

  def status
    @status ||= STATUS_NAMES[ raw_status ]
  end
end
