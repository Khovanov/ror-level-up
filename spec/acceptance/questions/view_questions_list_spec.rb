require_relative '../acceptance_helper'

feature 'View Questions list' , %q{
  The user can view a list of questions
} do
  given!(:questions) { create_list(:question, 3) }
  scenario 'Any user can view a list of questions'  do  
    visit questions_path
    questions.each do |question| 
      expect(page).to have_content question.title
    end
  end
end
