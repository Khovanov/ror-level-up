FactoryGirl.define do
  factory :comment_question, class: Comment  do
    association :commentable, factory: :question
    user 
    body 'test comment for question'

    trait :with_invalid_attr do
      body nil
    end
  end
end
