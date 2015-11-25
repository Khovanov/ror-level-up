require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe 'test associations' do
    it { should belong_to(:question) }
  end

  describe 'validates presence of body and question_id' do
    it { should validate_presence_of :body }
    it { should validate_presence_of :question_id }
  end

  describe 'validates length at least 10symb for body' do
    it { should validate_length_of(:body).is_at_least(10) }
  end
end
