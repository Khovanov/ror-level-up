require "rails_helper"

RSpec.describe SubscriptionMailer, type: :mailer do
  describe "question" do
    let!(:user) { create :user }
    let(:question) { create :question, user: user }
    let!(:answer) { create :answer, question: question }

    let(:mail) { SubscriptionMailer.question user, answer}

    it "renders the headers" do
      expect(mail.subject).to eq("New Answer")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["robot@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match(answer.body)
    end
  end
end
