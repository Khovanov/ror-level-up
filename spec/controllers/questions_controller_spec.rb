require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create :user }
  let(:question) {create :question, user: user}
  let(:question_another_user) { create :question }

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

    it 'assigns new answer for question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end
    
    it 'renders show view'do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do 
    login_user
    before {get :new}

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'builds new attachment for question' do
      expect(assigns(:question).attachments.first).to be_a_new(Attachment)
    end

    it 'renders new view' do 
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    login_user
    before {get :edit, id: question }

    it 'assigns the requested question to @question' do 
      expect(assigns(:question)).to eq question
    end 

    it 'renders edit view' do 
      expect(response).to render_template :edit
    end   
  end

  describe 'POST #create' do
    let(:post_create_question) do 
      post :create, 
            question: attributes_for(:question) 
    end
    let(:post_create_invalid_question) do 
      post :create, 
            question: attributes_for(:invalid_question) 
    end
    context 'when user unauthenticated' do
      it 'does not save the question' do
        expect { post_create_question }.to_not change(Question, :count)
      end
    end

    context 'with valid attributes' do 
      login_user

      it 'saves new question in the database' do
        # post :create, question: {title: 'some title', body: 'some body'}
        # post :create, question: FactoryGirl.attributes_for(:question)
        # count = Question.count
        # post :create, question: attributes_for(:question)
        # expect(Question.count).to eq count + 1
        expect { post_create_question }.to change(Question, :count).by(1)
      end

      it 'checks that the question belongs to the user' do
        expect { post_create_question }.to change(user.questions, :count).by(1)
      end

      it 'redirect to show view' do
        post_create_question
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      login_user      
      it 'does not save the question' do
        expect { post_create_invalid_question }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post_create_invalid_question
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    let(:patch_update_question_attr) do
      patch :update, 
            id: question, 
            question: attributes_for(:question),
            format: :js
    end
    let(:patch_update_question_body) do
      patch :update, 
            id: question, 
            question: { title: 'some test title', body: 'some test body'},
            format: :js    
    end

    context 'when user unauthenticated' do
      it 'not change question attributes' do
        patch_update_question_body
        question.reload
        expect(question.title).to_not eq 'some test title'
        expect(question.body).to_not eq 'some test body'
      end
    end

    context 'when user try edit his question' do 
      login_user

      it 'assigns the requested question to @question' do 
        patch_update_question_attr
        expect(assigns(:question)).to eq question
      end 

      it 'change question attributes' do
        patch_update_question_body
        question.reload
        expect(question.title).to eq 'some test title'
        expect(question.body).to eq 'some test body'
      end

      it 'render to the updated question' do
        patch_update_question_attr 
        expect(response).to render_template :update
      end
    end

    context 'when user try edit question another user' do
      login_user
      before do
        patch :update, 
              id: question_another_user, 
              question: { title: 'some test title', body: 'some test body'},
              format: :js 
      end

      it 'not change question attributes' do
        question_another_user.reload
        expect(question_another_user.title).to_not eq 'some test title'
        expect(question_another_user.body).to_not eq 'some test body'
      end
    end

    context 'with invalid attributes' do
      login_user
      before do
        patch :update, 
              id: question, 
              question: { title: nil, body: nil},
              format: :js
      end

      it 'not change question attributes' do
        question.reload
        expect(question.title).to_not eq nil
        expect(question.body).to_not eq nil     
      end

      it 'render template update' do
        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:delete_destroy_question) do
      delete :destroy, 
              id: question
    end
    before {question; question_another_user}

    context 'when user unauthenticated' do
      it 'does not delete question' do
        expect { delete_destroy_question }.to_not change(Question, :count)
      end
    end

    context 'when user try delete his question' do 
      login_user
      it 'delete question' do
        expect { delete_destroy_question }.to change(Question, :count).by(-1)
      end

      it 'redirect to index view' do
        delete_destroy_question
        expect(response).to redirect_to questions_path
      end
    end

    context 'when user try delete question another user' do
      login_user
      it 'does not delete question' do
        expect do
          delete :destroy, 
                  id: question_another_user 
        end.to_not change(Question, :count)
      end
    end
  end
end

