class Question < ActiveRecord::Base
  include Votable
  include Commentable

  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy
  belongs_to :user
  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true


  validates :title, :body, :user_id, presence: true
  validates :title, :body, length: { minimum: 10 }

  def channel_path
    "/questions/#{id}/comments"
  end 

  after_create :update_reputation

  protected

  def update_reputation
    self.delay.calculate_reputation
    # self.calculate_reputation
  end

  def calculate_reputation
    reputation = Reputation.calculate(self)
    # self.user.update(reputation: reputation)
  end  
end
