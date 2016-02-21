require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:another_user) { create :user }
    let(:question) { create(:question, user: user) }
    let(:question_another_user) { create(:question, user: another_user) }
    let(:answer) { create(:answer, question: question, user: user) }
    let(:answer_another_user) { create(:answer, question: question, user: another_user) }
    let(:answer_question_another_user) { create(:answer, question: question_another_user, user: user) }
    let(:attachment) { create(:attachment, attachable: question) }
    let(:attachment_question_another_user) { create(:attachment, attachable: question_another_user) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :update, question }
    it { should be_able_to :destroy, question }
    it { should_not be_able_to :update, question_another_user }
    it { should_not be_able_to :destroy, question_another_user }

    it { should be_able_to :create, Answer }
    it { should be_able_to :update, answer }
    it { should be_able_to :destroy, answer }
    it { should_not be_able_to :update, answer_another_user }
    it { should_not be_able_to :destroy, answer_another_user }

    it { should be_able_to :create, Comment }

    it { should be_able_to :best, answer }
    it { should_not be_able_to :best, answer_question_another_user }

    it { should be_able_to :vote, question_another_user }
    it { should_not be_able_to :vote, question }

    it { should be_able_to :vote, answer_another_user }
    it { should_not be_able_to :vote, answer }

    it { should be_able_to :destroy, attachment }
    it { should_not be_able_to :destroy, attachment_question_another_user }
  end
end