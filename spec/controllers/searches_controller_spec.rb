require 'rails_helper'

RSpec.describe SearchesController, type: :controller do
  describe 'SearchesController GET #index' do
    it 'Question receives method searsch' do
      expect(Question).to receive(:search).with('query')
      get :index, query: 'query'
    end
  end
end