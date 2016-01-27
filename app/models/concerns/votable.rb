module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
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
