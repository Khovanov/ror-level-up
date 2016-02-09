require_relative '../acceptance_helper'

feature 'Comment for the question', %q(
  In order to comment the question
  As an authorized user
  I want to be able comment question
) do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Unauthenticated user can`t comment question' do
    visit question_path(question)
    within '.question' do
      expect(page).to_not have_content 'Add comment'
    end
  end

  describe 'Authenticated user' do
    before { sign_in user }

    scenario 'create valid comment', js: true do
      visit question_path(question)
      within '.question' do
        fill_in 'Comment', with: 'Test question comment'
        click_on 'Add comment'
        expect(page).to have_content 'Test question comment'
      end
    end

    scenario 'try create invalid comment', js: true do
      visit question_path(question)
      within '.question' do
        click_on 'Add comment'
        expect(page).to have_content "body can't be blank"
      end
    end
  end
end
