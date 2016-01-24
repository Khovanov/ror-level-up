FactoryGirl.define do
  factory :vote_up, class: Vote  do
    association :votable, factory: :question
    user 
    value 1
  end
end
