require 'rails_helper'

RSpec.describe Question, type: :model do
  describe 'test associations' do
    it { should have_many :answers }
    it { should have_many(:answers).dependent(:destroy) }
  end

  describe 'validates presence of title and body' do
    # expect(Question.new(body: 'some body')).to_not be_valid
    it { should validate_presence_of :title }
    it { should validate_presence_of :body }
  end

  describe 'validates length at least 10symb for title and body' do
    it { should validate_length_of(:title).is_at_least(10) }
    it { should validate_length_of(:body).is_at_least(10) }
  end
end