class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachable, dependent: :destroy
  has_many :votes, as: :votable, dependent: :destroy
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

  def vote_up(user)
    vote = votes.find_or_create_by(user: user, votable: self)
    vote.vote_up
  end

  def vote_down(user)
    vote = votes.find_or_create_by(user: user, votable: self)
    vote.vote_down
  end

  def vote_cancel(user)
    vote = votes.find_by(user: user, votable: self)
    vote.vote_cancel if vote.present?
  end

  def voted(user)
    votes.find_by(user: user, votable: self)
  end
end
