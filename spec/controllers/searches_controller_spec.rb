require 'rails_helper'

RSpec.describe SearchesController, type: :controller do
  describe 'SearchesController GET #index' do
    it 'ThinkingSphinx receives method search' do
      expect(ThinkingSphinx).to receive(:search).with('query')
      get :index, query: 'query'
    end
  end
end