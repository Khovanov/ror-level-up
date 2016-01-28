require 'rails_helper'

RSpec.describe Attachment, type: :model do
  describe 'associations for ...' do
    it { should belong_to :attachable }
  end

  describe 'validates presence ...' do
    # it { should validate_presence_of :file }
    it 'validate presence of file' do
      expect { create(:invalid_attachment) }.to raise_error(StandardError)
      # expect { create(:invalid_attachment) }.to raise_error(Module::DelegationError)
    end
  end
end
