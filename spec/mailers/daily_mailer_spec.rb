require "rails_helper"

RSpec.describe DailyMailer, type: :mailer do
  describe "digest" do
    let!(:user) { create :user }
    let!(:question) { create :question, created_at: Time.current.yesterday }
    let(:mail) { DailyMailer.digest user }

    it "renders the headers" do
      expect(mail.subject).to eq("Questions digest")
      # expect(mail.subject).to eq("#{Time.now.strftime('%d/%m/%Y')} QnA daily digest")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["robot@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match(question.title)
    end
  end
end
