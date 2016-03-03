require 'rails_helper'

RSpec.describe Subscription, type: :model do
  describe 'associations for ...' do
    it { should belong_to :user }
    it { should belong_to :question }
  end

  describe 'validates presence ...' do
    it { should validate_presence_of :user_id }
    it { should validate_presence_of :question_id }
  end

  describe 'subscribe for Question' do
    let(:user) { create :user }
    let(:question) { create :question }

    it 'subscribe' do
      question.subscribe(user)
      expect(question.subscribed?(user)).to be true
    end

    it 'unsubscribe' do
      question.unsubscribe(user)
      expect(question.subscribed?(user)).to be false
    end
  end
end
