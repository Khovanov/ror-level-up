class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachable, dependent: :destroy
  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  validates :body, :question_id, :user_id, presence: true
  validates :body, length: { minimum: 10 }

  default_scope -> { order(best: :desc).order(created_at: :asc) }

  def best!
    transaction do
      question.answers.update_all best: false
      update!(best: true)
    end
  end
end
