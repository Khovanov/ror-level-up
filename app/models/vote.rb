class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :value, :user_id, presence: true

  def vote_up
    self.value = 1
    save
  end

  def vote_down
    self.value = -1
    save
  end

  def vote_cancel
    destroy
  end

  def self.rating
    sum(:value)
  end
end
