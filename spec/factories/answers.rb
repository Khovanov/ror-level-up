FactoryGirl.define do
  factory :answer do
    question nil
    body "My Answer length is more than 10 symbols"
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
  end
end
