require 'rails_helper'

RSpec.describe Question, type: :model do
  describe 'associations for ...' do
    it { should belong_to(:user) }
    it { should have_many(:answers).dependent(:destroy) }
    it { should have_many(:attachments).dependent(:destroy) }
    it { should accept_nested_attributes_for :attachments }
  end

  describe 'validates presence of ...' do
    # expect(Question.new(body: 'some body')).to_not be_valid
    it { should validate_presence_of :title }
    it { should validate_presence_of :body }
    it { should validate_presence_of :user_id }
  end

  describe 'validates length of ...' do
    it { should validate_length_of(:title).is_at_least(10) }
    it { should validate_length_of(:body).is_at_least(10) }
  end
end