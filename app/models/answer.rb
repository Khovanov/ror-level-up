class Answer < ActiveRecord::Base
  validates :body, presence: true, length: { minimum: 10 }
end
