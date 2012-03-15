class ArchiveMailer < ActionMailer::Base
  default :from => "hello@antiqua.io"

  def archive_created_email( archive )
    @archive     = archive
    @repository  = archive.repository
    @tarball_url = tarball_url archive
    @url         = url
    @user        = archive.user
    mail :to => @user.email , :subject => "Your archive is ready!"
  end

  def tarball_url( archive )
    "https://#{ CONFIG.sendgrid_domain }/archives/#{ archive.id_as_string }/tar_ball"
  end

  def url
    "https://#{ CONFIG.sendgrid_domain }"
  end
end
