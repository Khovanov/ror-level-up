require_relative '../acceptance_helper'

feature 'Set best answer', %q{
  In order to set the best answer
  As an author of the question
  I'd like to set the best answer
} do

  given(:user) { create(:user) }  
  given(:question) { create :question, user: user }
  given(:answer) { create(:answer, question: question)  }
  given(:answers) { create_list(:answer, 3, question: question)  }

  given(:question_another_user) { create :question }
  given(:answer_another_question) { create(:answer, question: question_another_user)  }

  scenario 'Unauthenticated user try set best answer' do
    answer
    visit question_path(question)
    within '.answers' do
      expect(page).to_not have_link 'Best answer'
    end 
  end     

  describe 'Authenticated user' do
    before do
      sign_in(user)
    end

    scenario 'non author of question not sees link set best' do
      answer_another_question
      visit question_path(question_another_user)
      within '.answers' do
        expect(page).to_not have_link 'Best answer'
      end       
    end

    scenario 'author of question sees link set best' do
      answer
      visit question_path(question)
      within '.answers' do
        expect(page).to have_link 'Best answer'
      end        
    end

    scenario 'author of question set the best answer', js: true do
      answer
      visit question_path(question)
      click_on 'Best answer'
      within '.answers' do
        expect(page).to have_content 'The best answer'
        expect(page).to_not have_link 'Best answer'
      end        
    end

    scenario 'best answer is first in the list', js: true do
      answers
      visit question_path(question)
      page.all('a', text: 'Best answer').first.click
      page.all('a', text: 'Best answer').last.click
      # Capybara.default_max_wait_time = 10
      expect(page.all('div.answer').first).to have_content 'The best answer'
    end

    scenario 'best answer is only one', js: true do
      answers
      visit question_path(question)
      page.all('a', text: 'Best answer').first.click
      # update .answers by AJAX
      page.all('a', text: 'Best answer').last.click
      # update .answers by AJAX
      expect(page).to have_content('The best answer', count: 1)
    end
  end
end
