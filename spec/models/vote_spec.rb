require 'rails_helper'

RSpec.describe Vote, type: :model do
  describe 'associations for ...' do
    it { should belong_to :user }
    it { should belong_to :votable }
  end

  describe 'validates presence ...' do
    it { should validate_presence_of :value }
    it { should validate_presence_of :user_id }
  end

  describe 'voting for question' do
    let(:user) { create :user }
    let(:question) { create :question }

    it 'vote up' do
      question.vote_up(user)
      expect(question.votes.rating).to eq 1
    end

    it 'vote down' do
      question.vote_down(user)
      expect(question.votes.rating).to eq -1
    end

    it 'vote cancel' do
      question.vote_up(user)
      question.vote_cancel(user)
      expect(question.votes.rating).to eq 0
    end

    it 'can`t double vote' do
      question.vote_up(user)
      question.vote_up(user)
      expect(question.votes.rating).to eq 1
    end
  end

  describe 'voting for answer' do
    let(:user) { create :user }
    let(:answer) { create :answer }

    it 'vote up' do
      answer.vote_up(user)
      expect(answer.votes.rating).to eq 1
    end

    it 'vote down' do
      answer.vote_down(user)
      expect(answer.votes.rating).to eq -1
    end

    it 'vote cancel' do
      answer.vote_up(user)
      answer.vote_cancel(user)
      expect(answer.votes.rating).to eq 0
    end

    it 'can`t double vote' do
      answer.vote_up(user)
      answer.vote_up(user)
      expect(answer.votes.rating).to eq 1
    end
  end
end
