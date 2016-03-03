class SubscriptionMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.subscription_mailer.question.subject
  #
  def question(user, answer)
    @greeting = "Hi #{user.email}"
    @answer = answer
    mail to: user.email, subject: "New Answer"
  end
end
