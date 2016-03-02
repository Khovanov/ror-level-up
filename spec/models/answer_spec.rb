require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe 'associations for ...' do
    it { should belong_to :question }
    it { should belong_to :user }
    it { should have_many(:attachments).dependent(:destroy) }
    it { should accept_nested_attributes_for :attachments }
  end

  describe 'validates presence of ...' do
    it { should validate_presence_of :body }
    it { should validate_presence_of :question_id }
    it { should validate_presence_of :user_id }
  end

  describe 'validates length of ...' do
    it { should validate_length_of(:body).is_at_least(10) }
  end

  describe 'reputation' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    subject { build(:answer, user: user, question: question) }

    it_behaves_like 'calculates reputation'
  end
end
