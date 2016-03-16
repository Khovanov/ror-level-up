class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :votable, polymorphic: true, touch: true

  validates :value, :user_id, presence: true

  def vote_up
    update(value: 1)
  end

  def vote_down
    update(value: -1)
  end

  def vote_cancel
    destroy
  end

  def self.rating
    sum(:value)
  end
end
