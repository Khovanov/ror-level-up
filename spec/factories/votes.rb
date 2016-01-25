FactoryGirl.define do
  factory :vote_up_question, class: Vote  do
    association :votable, factory: :question
    user 
    value 1
  end

  factory :vote_up_answer, class: Vote  do
    association :votable, factory: :answer
    user 
    value 1
  end
end
