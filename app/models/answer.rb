class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user
  validates :body, :question_id, :user_id, presence: true 
  validates :body, length: { minimum: 10 }

  default_scope -> { order(is_best: :desc).order(created_at: :asc) }

  def set_best
    transaction do
      question.answers.update_all is_best: false
      update!(is_best: true)
    end
  end  
end
