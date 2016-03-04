module Subscribable
  extend ActiveSupport::Concern

  included do
    has_many :subscriptions, dependent: :destroy
  end

  def subscribe(user)
    subscription = subscriptions.find_or_initialize_by(user: user, question: self)
    subscription.subscribe
  end

  def unsubscribe(user)
    subscription = subscriptions.find_by(user: user, question: self)
    subscription.unsubscribe if subscription.present?
  end

  def subscribed?(user)
    subscriptions.find_by(user: user, question: self).present? 
  end
end
