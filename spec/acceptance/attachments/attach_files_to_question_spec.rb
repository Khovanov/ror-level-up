require_relative '../acceptance_helper'

feature 'Add files to question', %q(
  In order to illustrate my question
  As an question's author
  I'd like to be able to attach files
) do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:attachment) { create :attachment, attachable: question }

  scenario 'Unauthenticated user try delete file' do
    attachment
    visit question_path(question)
    within '.question' do
      expect(page).to_not have_link 'Remove file'
    end
  end

  describe 'Author of question' do
    before { sign_in user }

    scenario 'add files when create question', js: true do
      visit new_question_path
      fill_in 'Title', with: 'Test title question'
      fill_in 'Body', with: 'Test body question'
      # attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
      # attach_file 'File', File.join(Rails.root, '/spec/spec_helper.rb')
      click_on 'Add file'
      click_on 'Add file'
      all('input[type="file"]')[0].set "#{Rails.root}/spec/spec_helper.rb"
      all('input[type="file"]')[1].set "#{Rails.root}/spec/rails_helper.rb"
      click_on 'Create Question'
      # expect(page).to have_link 'spec_helper.rb',
      # href: '/uploads/attachment/file/1/spec_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
      expect(page).to have_link 'rails_helper.rb'
    end

    scenario 'remove file when show question', js: true do
      attachment
      visit question_path(question)
      within '.question' do
        click_on 'Remove file', match: :first
      end
      expect(page).to_not have_link 'spec_helper.rb'
    end

    scenario 'add files when edit question', js: true do
      visit question_path(question)
      within '.question' do
        click_on 'Edit'
      end
      within '.edit_question' do
        click_on 'Add file'
        click_on 'Add file'
        all('input[type="file"]')[0].set "#{Rails.root}/spec/spec_helper.rb"
        all('input[type="file"]')[1].set "#{Rails.root}/spec/rails_helper.rb"
        click_on 'Edit Question'
      end
      expect(page).to have_link 'spec_helper.rb'
      expect(page).to have_link 'rails_helper.rb'
    end

    scenario 'remove file when edit question', js: true do
      attachment
      visit question_path(question)
      within '.question' do
        click_on 'Edit'
      end
      within '.edit_question' do
        click_on 'Remove file'
        click_on 'Edit Question'
      end
      expect(page).to_not have_link 'spec_helper.rb'
    end
  end

  describe 'Non author of question' do
    before { sign_in another_user }

    scenario 'dont sees link to remove file' do
      attachment
      visit question_path(question)
      within '.question' do
        expect(page).to_not have_link 'Remove file'
      end
    end
  end
end
