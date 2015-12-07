require_relative '../acceptance_helper'

feature 'View Questions list' , %q{
  The user can view a list of questions
} do
  given!(:question) { create(:question) }

  scenario 'Any user can view a list of questions'  do  
    visit questions_path
    expect(page).to have_content question.title
  end
end
