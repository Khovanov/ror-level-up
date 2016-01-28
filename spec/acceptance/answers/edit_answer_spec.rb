require_relative '../acceptance_helper'

feature 'Edit answer', %q(
  In order to fix mistake
  As an author of answer
  I'd like to be able to edit my answer
) do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given(:answer) { create :answer, question: question, user: user }
  given(:answer_another_user) { create(:answer, question: question) }

  scenario 'Unauthenticated user try edit answer'do
    answer
    visit question_path(question)
    within '.answers' do
      expect(page).to_not have_link 'Edit'
    end
  end

  describe 'Authenticated user' do
    before do
      sign_in(user)
    end

    scenario 'non author of answer not sees link to edit' do
      answer_another_user
      visit question_path(question)
      within '.answers' do
        expect(page).to_not have_link 'Edit'
      end
    end

    scenario 'author of answer sees link to edit' do
      answer
      visit question_path(question)
      within '.answers' do
        expect(page).to have_link 'Edit'
      end
    end

    scenario 'try edit answer with valid params', js: true do
      answer
      visit question_path(question)
      within '.answers' do
        click_on 'Edit'
        fill_in 'Answer', with: 'Edited answers'
        click_on 'Save'
        expect(page).to_not have_content answer.body
        expect(page).to have_content 'Edited answers'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'try edit answer with invalid params', js: true do
      answer
      visit question_path(question)
      within '.answers' do
        click_on 'Edit'
        fill_in 'Answer', with: nil
        click_on 'Save'
        expect(page).to have_content answer.body
        expect(page).to have_selector 'textarea'
      end
    end
  end
end
