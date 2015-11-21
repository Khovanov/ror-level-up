require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  describe 'GET #index' do 
    let(:questions) {create_list(:question, 2)}
    
    before do 
      # @questions = FactoryGirl.create_list(:question, 2)
      # @questions = create_list(:question, 2)
      get :index
    end

    it 'poulates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do 
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do 
    let(:question) {create(:question)}

    before {get :show, id: question } # question.id

    it 'assigns the requested question to @question' do 
      expect(assigns(:question)).to eq question
    end
    it 'renders show view'do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do 
    before {get :new}

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do 
      expect(response).to render_template :new
    end
    
  end
end

