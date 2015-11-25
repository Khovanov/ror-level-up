FactoryGirl.define do
  factory :question do
    title "MyTitle is to Long"
    body "MyText it more 10 symbols"
  end

  factory :invalid_question, class: 'Question' do
    title nil
    body nil
  end
end
