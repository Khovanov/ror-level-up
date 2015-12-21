FactoryGirl.define do
  factory :attachment do
    file Rack::Test::UploadedFile.new(File.join(Rails.root, '/spec/spec_helper.rb'))
    # file { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'spec_helper.rb')) }
    association :attachable, factory: :question
  end

  factory :invalid_attachment , class: Attachment do
    file nil
    # file { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'spec_helper.rb')) }
    association :attachable, factory: :question
  end
end