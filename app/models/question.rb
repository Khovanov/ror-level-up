class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  belongs_to :user
  validates :title, :body, :user_id, presence: true 
  validates :title, :body, length: { minimum: 10 }
end
