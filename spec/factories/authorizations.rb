FactoryGirl.define do
  factory :authorization do
    user 
    provider "provider"
    uid "123456"
  end
end
