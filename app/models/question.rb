class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  validates :title, :body, presence: true, length: { minimum: 10 }
end
