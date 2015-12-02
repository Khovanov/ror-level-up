require 'rails_helper'

feature 'Create Question' , %q{
  In order to get answer from community
  As an authenticated user
  I want to be able to ask questions
} do

  given(:user) { create(:user) } #FactoryGirl.create

  scenario 'Authenticated user creates question'  do  
    sign_in(user)

    # visit root_path
    visit questions_path
    click_on 'Ask your question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Test text body'
    click_on 'Create'
    # save_and_open_page
    expect(page).to have_content 'Your question successfully created.'
    expect(page).to have_content 'Test question'
    expect(page).to have_content 'Test text body'
    # expect(current_path).to eq question_path(user.questions.last)
  end

  scenario 'Non-registered user creates question'  do
    visit questions_path
    click_on 'Ask your question'

    # save_and_open_page

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end