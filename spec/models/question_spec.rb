require 'rails_helper'

RSpec.describe Question, type: :model do

  # RSpec
  # it 'validates presence of title' do
  #   expect(Question.new(body: 'some body')).to_not be_valid
  # end

  # it 'validates presence of body' do
  #   expect(Question.new(title: 'some title')).to_not be_valid
  # end

  # shoulda-matchers

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should validate_length_of(:title).is_at_least(10) }
  it { should validate_length_of(:body).is_at_least(10) }

  it { should have_many :answers }
  it { should have_many(:answers).dependent(:destroy) }

end