class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy
  has_many :votes, as: :votable, dependent: :destroy
  belongs_to :user
  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  validates :title, :body, :user_id, presence: true
  validates :title, :body, length: { minimum: 10 }

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
