require_relative '../acceptance_helper'

feature 'Add files to answer', %q{
  In order to illustrate my answer
  As an answer's author
  I'd like to be able to attach files
} do

  given(:user) { create(:user) }  
  given(:another_user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create :answer, question: question, user: user }
  given(:attachment) { create :attachment, attachable: answer }

  scenario 'Unauthenticated user try delete file' do 
    attachment
    visit question_path(question)
    within '.answer' do
      expect(page).to_not have_link 'Remove file'
    end
  end

  describe 'Author of answer' do
    before { sign_in user }

    scenario 'add files when create answer', js: true do
      visit question_path(question) 
      fill_in 'Answer', with: 'My test answer'

      click_on 'Add file'
      click_on 'Add file'
      # attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
      all('input[type="file"]')[0].set "#{Rails.root}/spec/spec_helper.rb"
      all('input[type="file"]')[1].set "#{Rails.root}/spec/rails_helper.rb"
     
      click_on 'Create Answer'
      within '.answer' do
        expect(page).to have_link 'spec_helper.rb'
        expect(page).to have_link 'rails_helper.rb'
      end
    end

    scenario 'remove file when show answer', js: true  do
      attachment
      visit question_path(question)
      within '.answer' do   
        click_on 'Remove file', match: :first
      end
      expect(page).to_not have_link 'spec_helper.rb'
    end

    scenario 'add files when edit answer', js: true  do
      attachment
      visit question_path(question)
      within '.answer' do   
        click_on 'Edit'
      end
      within '.edit_answer' do
        click_on 'Add file'
        click_on 'Add file'
        all('input[type="file"]')[0].set "#{Rails.root}/spec/spec_helper.rb"
        all('input[type="file"]')[1].set "#{Rails.root}/spec/rails_helper.rb"
        click_on 'Save'
      end
      expect(page).to have_link 'spec_helper.rb'
      expect(page).to have_link 'rails_helper.rb'
    end

    scenario 'remove file when edit answer', js: true  do
      attachment
      visit question_path(question)
      within '.answer' do   
        click_on 'Edit'
      end
      within '.edit_answer' do
        click_on 'Remove file'
        click_on 'Save'
      end
      expect(page).to_not have_link 'spec_helper.rb'
    end
  end

  describe 'Non author of answer', js: true do
    before { sign_in another_user }

    scenario 'dont sees link remove file' do
      attachment
      visit question_path(question)
      within '.answer' do
        expect(page).to_not have_link 'Remove file'
      end
    end
  end
end