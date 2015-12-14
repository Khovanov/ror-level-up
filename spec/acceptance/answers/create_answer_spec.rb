require_relative '../acceptance_helper'

feature 'Create answer', %q{
  In order to exchange my knowledge
  As an authenticated user
  I want to be able to create answers
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  scenario 'Unauthenticated user try creates answer'  do  
    visit question_path(question)
    fill_in 'Body', with: 'Answer text body'
    # save_and_open_page
    click_on 'Create Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
    expect(page).to_not have_content 'Answer text body'
  end

  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
      # visit root_path
      # save_and_open_page
    end

    scenario 'try creates valid answer', js: true do  
      fill_in 'Body', with: 'Answer text body'
      click_on 'Create Answer'

      expect(current_path).to eq question_path(question)
      within '.answers' do
        expect(page).to have_content 'Answer text body'
      end
    end

    scenario 'try creates invalid answer', js: true do  
      click_on 'Create Answer'

      expect(page).to have_content "Body can't be blank"
    end
  end
end
