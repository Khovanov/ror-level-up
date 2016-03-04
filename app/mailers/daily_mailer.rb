class DailyMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.daily_mailer.digest.subject
  #
  def digest(user)
    @greeting = "Hi #{user.email}"
    # @questions = Question.all
    @questions = Question.yesterdays
    mail to: user.email, subject: "Questions digest"
  end
end
