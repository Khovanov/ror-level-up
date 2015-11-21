require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) {create(:question)}
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

  describe 'GET #edit' do
    before {get :edit, id: question }

    it 'assigns the requested question to @question' do 
      expect(assigns(:question)).to eq question
    end 

    it 'renders edit view' do 
      expect(response).to render_template :edit
    end   
  end

  describe 'POST #create' do
    context 'with valid attributes' do 
      it 'saves new question in the database' do
        # post :create, question: {title: 'some title', body: 'some body'}
        # post :create, question: FactoryGirl.attributes_for(:question)
        # count = Question.count
        # post :create, question: attributes_for(:question)
        # expect(Question.count).to eq count + 1
        expect { post :create, question: attributes_for(:question) }.to change(Question, :count).by(1)
      end
      it 'redirect to show view' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, question: attributes_for(:invalid_question) }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, question: attributes_for(:invalid_question)
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'assigns the requested question to @question' do 
        patch :update, id: question, question: attributes_for(:question)
        expect(assigns(:question)).to eq question
      end 

      it 'change question attributes' do
        patch :update, id: question, question: { title: 'some test title', body: 'some test body'}
        question.reload
        expect(question.title).to eq 'some test title'
        expect(question.body).to eq 'some test body'
      end

      it 'redirect to the updated question' do
        patch :update, id: question, question: attributes_for(:question) 
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      before {patch :update, id: question, question: { title: 'some test title', body: nil}}
      it 'does not change question attributes' do
        question.reload
        expect(question.title).to eq 'MyTitle is to Long'
        expect(question.body).to eq 'MyText it more 10 symbols'     
      end

      it 're-render edit view' do
        expect(response).to render_template :edit
      end
    end
  end
end

