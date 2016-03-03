class SubscriptionJob < ActiveJob::Base
  queue_as :default

  def perform(answer)
    answer.question.subscriptions.find_each do |subscription|
      SubscriptionMailer.question(subscription.user, answer).deliver_later
    end
  end
end
