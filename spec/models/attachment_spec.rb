require 'rails_helper'

describe Attachment do
  it { should belong_to :attachable }
end