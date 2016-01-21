require_relative '../acceptance_helper'

feature 'View Question and Answers', %q(
  The user can view question and a list of answers
) do
  given!(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 3, question: question) }

  scenario 'Any user can view question and a list of answers' do
    visit question_path(question)
    # save_and_open_page
    answers.each do |answer|
      expect(page).to have_content answer.body
    end
    # expect(page).to_not have_content 'No answers found.'
    # expect(page).to_not have_link 'Edit'
  end
end
