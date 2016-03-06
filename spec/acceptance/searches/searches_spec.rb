require_relative '../acceptance_helper'
require_relative '../sphinx_helper'

feature 'Search for all or any options', %q(
  Anybody to be able search all or any options
) do
  let!(:questions) { create_list :question, 2 }
  let!(:question) do 
    create :question, 
            title: 'title for testing search', 
            body: 'body for testing search' 
  end

  let!(:answers) { create_list :answer, 2, question: question}
  let!(:answer) do 
    create :answer,
            question: question, 
            body: 'testing answer search' 
  end

  let!(:comments) { create_list :comment_question, 2, commentable: question}
  let!(:comment) do 
    create :comment_question,
            commentable: question, 
            body: 'testing comment search' 
  end

  let!(:users) { create_list :user, 2}
  let!(:user) { create :user, email: 'test@test.com' }

  before do
    ThinkingSphinx::Test.index
    # index
  end

  context 'search for all' do
    scenario 'with valid result', sphinx: true  do
      visit questions_path
      fill_in 'query', with: 'testing search'
      click_on 'Search'
      expect(current_path).to eq searches_path
      expect(page).to have_content 'testing search'
    end

    scenario 'with invalid result', sphinx: true  do
      visit questions_path
      fill_in 'query', with: 'anythin'
      click_on 'Search'
      expect(current_path).to eq searches_path
      expect(page).to have_content 'No results'
    end

    scenario 'with empty query', sphinx: true  do
      visit questions_path
      fill_in 'query', with: nil
      click_on 'Search'
      expect(current_path).to eq questions_path
      expect(page).to have_content 'Invalid query'
    end
  end

  context 'search for Questions' do
    scenario 'with valid result', sphinx: true  do
      visit questions_path
      fill_in 'query', with: 'testing search'
      select('Questions', from: 'options')
      click_on 'Search'
      expect(current_path).to eq searches_path
      expect(page).to have_content 'testing search'
    end

    scenario 'with invalid result', sphinx: true  do
      visit questions_path
      fill_in 'query', with: 'anythin'
      select('Questions', from: 'options')
      click_on 'Search'
      expect(current_path).to eq searches_path
      expect(page).to have_content 'No results'
    end
  end

  context 'search for Answers' do
    scenario 'with valid result', sphinx: true  do
      visit questions_path
      fill_in 'query', with: 'testing answer search'
      select('Answers', from: 'options')
      click_on 'Search'
      expect(current_path).to eq searches_path
      expect(page).to have_content 'testing answer search'
    end

    scenario 'with invalid result', sphinx: true  do
      visit questions_path
      fill_in 'query', with: 'anythin'
      select('Answers', from: 'options')
      click_on 'Search'
      expect(current_path).to eq searches_path
      expect(page).to have_content 'No results'
    end
  end

  context 'search for Comments' do
    scenario 'with valid result', sphinx: true  do
      visit questions_path
      fill_in 'query', with: 'testing comment search'
      select('Comments', from: 'options')
      click_on 'Search'
      expect(current_path).to eq searches_path
      expect(page).to have_content 'testing comment search'
    end

    scenario 'with invalid result', sphinx: true  do
      visit questions_path
      fill_in 'query', with: 'anythin'
      select('Comments', from: 'options')
      click_on 'Search'
      expect(current_path).to eq searches_path
      expect(page).to have_content 'No results'
    end
  end

  context 'search for Users' do
    scenario 'with valid result', sphinx: true  do
      visit questions_path
      fill_in 'query', with: 'test@test.com'
      select('Users', from: 'options')
      click_on 'Search'
      expect(current_path).to eq searches_path
      expect(page).to have_content 'test@test.com'
    end

    scenario 'with invalid result', sphinx: true  do
      visit questions_path
      fill_in 'query', with: 'anythin'
      select('Users', from: 'options')
      click_on 'Search'
      expect(current_path).to eq searches_path
      expect(page).to have_content 'No results'
    end
  end

end
