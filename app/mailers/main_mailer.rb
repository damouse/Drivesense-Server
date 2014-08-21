class MainMailer < ActionMailer::Base
  default from: "admin@knowmydrive.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.main_mailer.group_invite_notification.subject
  #
  def group_invite_notification(user, group)
    @invitee = user
    @group = group.name

    mail to: @invitee.email
  end
end
