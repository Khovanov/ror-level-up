FactoryGirl.define do
  factory :answer do
    question 
    body "My Answer length is more than 10 symbols"
    user
  end

  factory :invalid_answer, class: 'Answer' do
    question nil
    body nil
    user nil
  end
end
