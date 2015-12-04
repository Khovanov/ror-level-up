require 'rails_helper'

feature 'Create answer', %q{
  In order to exchange my knowledge
  As an authenticated user
  I want to be able to create answers
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  scenario 'Authenticated user creates answer'  do  
    sign_in(user)

    # visit root_path
    visit question_path(question)
    fill_in 'Body', with: 'Answer text body'
    # save_and_open_page
    click_on 'Create Answer'

    expect(current_path).to eq question_path(question)
    within '.answers' do
      expect(page).to have_content 'Answer text body'
    end
  end

  scenario 'Non-registered user creates answer'  do  
    visit question_path(question)
    fill_in 'Body', with: 'Answer text body'
    # save_and_open_page
    click_on 'Create Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
    # expect(current_path).to eq question_path(question)
    # expect(page).to have_content 'Answer text body'
  end
end
