class Subscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :question, touch: true

  validates :question_id, :user_id, presence: true

  def subscribe
    save
  end

  def unsubscribe
    destroy
  end
end
