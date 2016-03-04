require_relative '../acceptance_helper'

feature 'Subscribe for Question', %q(
  As an authenticated user
  I want to be able to subscribe for question
) do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Unauthenticated user try subscribe for question' do
    visit question_path(question)
    within '.question' do
      expect(page).to_not have_link 'Subscribe'
      expect(page).to_not have_link 'Unsubscribe'
    end
  end

  describe 'Authenticated user' do
    context 'author of question' do
      before { sign_in user }

      scenario 'not sees link to subscribe/unsubscribe' do
        visit question_path(question)
        within '.question' do
          expect(page).to_not have_link 'Subscribe'
          expect(page).to_not have_link 'Unsubscribe'
        end
      end
    end

    context 'non author of question' do
      before { sign_in another_user }

      context 'if unsubscribed' do
        scenario 'sees link to subscribe', js: true do
          visit question_path(question)
          within '.question' do
            expect(page).to have_link 'Subscribe'
            expect(page).to_not have_link 'Unsubscribe'
          end
        end

        scenario 'try subscribe', js: true do
          visit question_path(question)
          within '.question' do
            click_on 'Subscribe'
            expect(page).to have_link 'Unsubscribe'
            expect(page).to_not have_link 'Subscribe'
          end
        end
      end

      context 'if subscribed' do
        before { create :subscription, question: question, user: another_user }

        scenario 'sees link to unsubscribe', js: true do
          visit question_path(question)
          within '.question' do
            expect(page).to have_link 'Unsubscribe'
            expect(page).to_not have_link 'Subscribe'
          end
        end

        scenario 'try unsubscribe', js: true do
          visit question_path(question)
          within '.question' do
            click_on 'Unsubscribe'
            expect(page).to have_link 'Subscribe'
            expect(page).to_not have_link 'Unsubscribe'
          end
        end        
      end
    end
  end
end
