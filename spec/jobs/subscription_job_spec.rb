require 'rails_helper'

RSpec.describe SubscriptionJob, type: :job do

  context 'auto subscribe for author question' do
    let(:owner) { create :user }
    let(:question) { create :question, user: owner }
    let!(:answer) { create :answer, question: question }

    it 'run subcritption job after create answer' do
      expect(SubscriptionMailer).to receive(:question)
        .with(owner, answer)
        .and_call_original 
      SubscriptionJob.perform_now(answer)
    end
  end

  context 'for all subscribed users' do
    let!(:owner) { create :user }
    let(:question) { create :question, user: owner }
    let(:user) { create :user }
    let!(:subscription) { create :subscription, user: user, question: question }
    let!(:answer) { create :answer, question: question }

    it 'run subcritption job after create answer' do
      question.subscriptions.each do |subscription|
        expect(SubscriptionMailer).to receive(:question)
          .with(subscription.user, answer)
          .and_call_original  
      end
      SubscriptionJob.perform_now(answer)
    end
  end
end
