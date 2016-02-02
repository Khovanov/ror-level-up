require_relative '../acceptance_helper'

feature 'Comment for the answer', %q(
  In order to comment the answer
  As an authorized user
  I want to be able comment answer
) do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer, question: question) }

  scenario 'Unauthenticated user can`t comment answer' do
    answer
    visit question_path(question)
    within '.answers' do
      expect(page).to_not have_content 'Add comment'
    end
  end

  describe 'Authenticated user' do
    before do 
      sign_in user 
      answer
      visit question_path(question)
    end

    scenario 'create valid comment', js: true do
      within '.answer-comments-form' do 
        fill_in 'Comment', with: 'Test answer comment'
        click_on 'Add comment'
      end
      within '.answers' do
        expect(page).to have_content 'Test answer comment'
      end
    end

    scenario 'try create invalid comment', js: true do
      within '.answer-comments-form' do 
        click_on 'Add comment'
      end
      within '.answers' do
        expect(page).to have_content "Body can't be blank"
      end
    end
  end
end
