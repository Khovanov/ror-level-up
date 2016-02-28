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

  it_behaves_like "Models votable", Question
  it_behaves_like "Models votable", Answer
end
