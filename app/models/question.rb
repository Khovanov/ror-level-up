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
end
