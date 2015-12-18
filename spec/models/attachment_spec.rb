require 'rails_helper'

RSpec.describe Attachment, type: :model do
  describe 'associations for ...' do
    it { should belong_to :attachable }
  end

  describe 'validates presence of ...' do
    it { should validate_presence_of :file }  
  end
end