require 'rails_helper'

RSpec.describe Authorization, type: :model do
  describe 'associations for ...' do
    it { should belong_to :user }
  end

  describe 'validates presence of ...' do
    it { should validate_presence_of :user_id }
    it { should validate_presence_of :provider }
    it { should validate_presence_of :uid }
  end
end
