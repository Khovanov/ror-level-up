require 'rails_helper'

RSpec.describe SearchesController, type: :controller do
  describe 'SearchesController GET #index' do
    it 'ThinkingSphinx receives method .search for all' do
      expect(ThinkingSphinx).to receive(:search).with('query')
      get :index, query: 'query'
    end

    Search::SEARCH_OPTIONS.each do |options|
      it "ThinkingSphinx receives method .search for #{options}" do
        expect(options.singularize.constantize).to receive(:search).with('query')
        get :index, query: 'query', options: options
      end
    end
  end
end