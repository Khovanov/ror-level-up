class Question < ActiveRecord::Base
  include Votable
  include Commentable
  include Subscribable

  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy
  belongs_to :user
  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true
  after_create :subscribe_owner

  scope :yesterdays, -> { where(created_at: Date.yesterday..Date.today) }

  validates :title, :body, :user_id, presence: true
  validates :title, :body, length: { minimum: 10 }

  def channel_path
    "/questions/#{id}/comments"
  end 

  after_create :update_reputation

  private

  def update_reputation
    CalculateReputationJob.perform_later(self)
  end

  def subscribe_owner
    subscribe(self.user)
  end
end
