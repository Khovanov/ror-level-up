class Question < ActiveRecord::Base
  validates :title, :body, presence: true, length: { minimum: 10 }
end
