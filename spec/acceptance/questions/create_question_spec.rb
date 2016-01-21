require_relative '../acceptance_helper'

feature 'Create Question', %q(
  In order to get answer from community
  As an authenticated user
  I want to be able to ask questions
) do
  given(:user) { create(:user) } # FactoryGirl.create

  scenario 'Unauthenticated user try creates question' do
    visit questions_path
    click_on 'Ask your question'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  describe 'Authenticated user' do
    before do
      sign_in user
      visit questions_path
    end

    scenario 'try creates valid question' do
      # visit root_path
      click_on 'Ask your question'
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'Test text body'
      click_on 'Create'
      # save_and_open_page
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'Test text body'
      # expect(current_path).to eq question_path(user.questions.last)
    end

    scenario 'try creates invalid question' do
      click_on 'Ask your question'
      fill_in 'Title', with: nil
      fill_in 'Body', with: nil
      click_on 'Create'
      expect(page).to have_content "Title can't be blank"
      expect(page).to have_content "Body can't be blank"
    end
  end
end
