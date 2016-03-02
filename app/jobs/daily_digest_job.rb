class DailyDigestJob < ActiveJob::Base
  queue_as :default

  def perform
    return unless Question.yesterdays.present?
    User.find_each do |user|
      # DailyMailer.delay.digest(user)
      # DailyMailer.digest(user).deliver_now
      DailyMailer.digest(user).deliver_later
    end
  end
end
