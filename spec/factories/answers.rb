FactoryGirl.define do
  sequence :body do |n|
    "My #{n} Answer length is more than 10 symbols"
  end

  factory :answer do
    question 
    body 
    user
  end

  factory :invalid_answer, class: 'Answer' do
    question nil
    body nil
    user nil
  end
end
