require_relative '../acceptance_helper'

feature 'Edit Question', %q(
  In order to get answer from community
  As an authenticated user
  I want to be able to edit question
) do
  given(:user) { create(:user) }
  given(:question) { create :question, user: user }
  given(:question_another_user) { create(:question) }

  scenario 'Unauthenticated user try edit question' do
    visit question_path(question)
    within '.question' do
      expect(page).to_not have_link 'Edit'
    end
  end

  describe 'Authenticated user' do
    before { sign_in user }

    scenario 'non author of question not sees link to edit' do
      visit question_path(question_another_user)
      within '.question' do
        expect(page).to_not have_link 'Edit'
      end
    end

    scenario 'author of question sees link to edit' do
      visit question_path(question)
      within '.question' do
        expect(page).to have_link 'Edit'
      end
    end

    scenario 'try to edit question with valid params', js: true do
      visit question_path(question)
      within '.question' do
        click_on 'Edit'
        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'Test text body'
        click_on 'Edit Question'
        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body
        expect(page).to have_content 'Test question'
        expect(page).to have_content 'Test text body'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'try to edit question with invalid params', js: true do
      visit question_path(question)
      within '.question' do
        click_on 'Edit'
        fill_in 'Title', with: nil
        fill_in 'Body', with: nil
        click_on 'Edit Question'
        expect(page).to have_content "Title can't be blank"
        expect(page).to have_content "Body can't be blank"
      end
    end
  end
end
