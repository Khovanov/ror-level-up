require_relative '../acceptance_helper'
require_relative '../sphinx_helper'

feature 'Search for all or any options', %q(
  Anybody to be able search all or any options
) do
  let(:testing_search) {"search#{Random::rand(100)}"}
  let!(:questions) { create_list :question, 2 }
  let!(:question) do 
    create :question, 
            title: "title for #{testing_search}", 
            body: "body for #{testing_search}" 
  end

  let!(:answers) { create_list :answer, 2, question: question}
  let!(:answer) do 
    create :answer,
            question: question, 
            body: "answer for #{testing_search}" 
  end

  let!(:comments) { create_list :comment_question, 2, commentable: question}
  let!(:comment) do 
    create :comment_question,
            commentable: question, 
            body: "comment for #{testing_search}" 
  end

  let!(:users) { create_list :user, 2}
  let!(:user) { create :user, email: "#{testing_search}@test.com"}

  before do
    # ThinkingSphinx::Test.init
    # ThinkingSphinx::Test.start
    # ThinkingSphinx::Test.index
    index
  end

  after do
    # ThinkingSphinx::Test.stop
  end


  Search::SEARCH_OPTIONS.each do |options|
    context "search for #{options}" do
      scenario 'with valid result', sphinx: true  do
        # ThinkingSphinx::Test.run do
        visit questions_path
        fill_in 'query', with: testing_search
        select(options, from: 'options')        
        click_on 'Search'
        expect(current_path).to eq searches_path
        expect(page).to have_content testing_search
        # end
      end

      scenario 'with invalid result', sphinx: true  do
        visit questions_path
        fill_in 'query', with: 'anythin'
        select(options, from: 'options')
        click_on 'Search'
        expect(current_path).to eq searches_path
        expect(page).to have_content 'No results'
      end

      scenario 'with empty query', sphinx: true  do
        visit questions_path
        fill_in 'query', with: nil
        select(options, from: 'options')
        click_on 'Search'
        expect(current_path).to eq questions_path
        expect(page).to have_content 'Invalid query'
      end
    end
  end
end
