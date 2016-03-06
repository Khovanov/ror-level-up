require_relative '../acceptance_helper'
require_relative '../sphinx_helper'

feature 'Search for the question', %q(
  Any to be able search for the question
) do
  let!(:questions) { create_list :question, 2 }
  let!(:question) do 
    create :question, 
            title: 'title for testing search14', 
            body: 'body for testing search14' 
  end
  before do
    ThinkingSphinx::Test.index
    # index
  end

  scenario 'search with valid result', sphinx: true  do
    visit questions_path
    fill_in 'query', with: 'testing search14'
    click_on 'Search'
    expect(current_path).to eq searches_path
    expect(page).to have_content 'testing search14'
  end

  scenario 'search with invalid result', sphinx: true  do
    visit questions_path
    fill_in 'query', with: 'anythin'
    click_on 'Search'
    expect(current_path).to eq searches_path
    expect(page).to have_content 'No results'
  end

  scenario 'empty query', sphinx: true  do
    visit questions_path
    fill_in 'query', with: nil
    click_on 'Search'
    expect(current_path).to eq questions_path
    expect(page).to have_content 'Empty query'
  end

end
