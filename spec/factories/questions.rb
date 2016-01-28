FactoryGirl.define do
  factory :question do
    title 'MyTitle is to Long'
    body 'MyText it more 10 symbols'
    user # association :author, factory: :user, last_name: "Writely"
  end

  factory :invalid_question, class: 'Question' do
    title nil
    body nil
    user nil
  end
end
