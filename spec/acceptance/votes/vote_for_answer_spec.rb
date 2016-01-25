require_relative '../acceptance_helper'

feature 'Vote for the answer', %q(
  In order to vote for the answer
  As an authorized user
  I want to be able vote for the answer
) do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answer) { create(:answer, question: question, user: user) }
  given(:vote_up_answer) { create :vote_up_answer, votable: answer, user: another_user }

  scenario 'Unauthenticated user can`t vote for the answer' do
    answer
    visit question_path(question)
    within '.answers' do
      expect(page).to have_content 'Votes:0'
      expect(page).to have_content 'Rating:0'
      expect(page).to_not have_link 'Vote up'
      expect(page).to_not have_link 'Vote cancel'
      expect(page).to_not have_link 'Vote down'
    end
  end

  describe 'Author of answer' do
    before { sign_in user }

    scenario 'can`t vote for the own answer', js: true do
      answer
      visit question_path(question)
      within '.answers' do
        expect(page).to have_content 'Votes:0'
        expect(page).to have_content 'Rating:0'
        expect(page).to_not have_link 'Vote up'
        expect(page).to_not have_link 'Vote cancel'
        expect(page).to_not have_link 'Vote down'
      end
    end
  end

  describe 'Non author of answer' do
    before { sign_in another_user }

    scenario 'try vote up for the answer', js: true do
      answer
      visit question_path(question)
      within '.answers' do
        click_on 'Vote up'
        expect(page).to have_content 'Votes:1'
        expect(page).to have_content 'Rating:1'
        expect(page).to_not have_link 'Vote up'
        expect(page).to have_link 'Vote cancel'
        expect(page).to_not have_link 'Vote down'
      end
    end

    scenario 'try vote down for the answer', js: true do
      answer
      visit question_path(question)
      within '.answers' do
        click_on 'Vote down'
        expect(page).to have_content 'Votes:1'
        expect(page).to have_content 'Rating:-1'
        expect(page).to_not have_link 'Vote up'
        expect(page).to have_link 'Vote cancel'
        expect(page).to_not have_link 'Vote down'
      end
    end

    scenario 'try cancel vote', js: true do
      vote_up_answer
      visit question_path(question)
      within '.answers' do
        click_on 'Vote cancel'
        expect(page).to have_content 'Votes:0'
        expect(page).to have_content 'Rating:0'
        expect(page).to have_link 'Vote up'
        expect(page).to_not have_link 'Vote cancel'
        expect(page).to have_link 'Vote down'
      end
    end
  end
end
