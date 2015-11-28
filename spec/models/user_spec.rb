require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validates presence of email and password' do
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }
  end
end
