class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  has_many :attachments
  belongs_to :user
  accepts_nested_attributes_for :attachments

  validates :title, :body, :user_id, presence: true 
  validates :title, :body, length: { minimum: 10 }
end
