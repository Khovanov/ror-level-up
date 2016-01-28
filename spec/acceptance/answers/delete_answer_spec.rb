require_relative '../acceptance_helper'

feature 'Delete answer', %q(
  In order to fix mistake
  As an author of answer
  I'd like to be able to delete my answer
) do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given(:answer) { create :answer, question: question, user: user }
  given(:answer_another_user) { create(:answer, question: question) }

  scenario 'Unauthenticated user try delete answer'do
    answer
    visit question_path(question)
    within '.answers' do
      expect(page).to_not have_link 'Delete'
    end
  end

  describe 'Authenticated user' do
    before do
      sign_in(user)
    end

    scenario 'non author of answer not sees link to delete' do
      answer_another_user
      visit question_path(question)
      within '.answers' do
        expect(page).to_not have_link 'Delete'
      end
    end

    scenario 'author of answer sees link to delete' do
      answer
      visit question_path(question)
      within '.answers' do
        expect(page).to have_link 'Delete'
      end
    end

    scenario 'author of answer try to delete his answer', js: true do
      answer
      visit question_path(question)
      within '.answers' do
        click_on 'Delete'
        expect(page).to_not have_content answer.body
      end
    end
  end
end
