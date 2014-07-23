class MainMailer < ActionMailer::Base
  default from: "admin@knowmydrive.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.main_mailer.group_invite_notification.subject
  #
  def group_invite_notification(invitee_id)
    @invitee = User.find(invitee_id)
    @group = Group.find(@invitee.invitation_id).name

    mail to: @invitee.email
  end
end
