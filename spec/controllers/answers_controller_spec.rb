require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
# describe AnswersController do
  let(:question) {create :question}
  # let(:answer) {create :answer, question: question}

  describe 'POST #create' do
    login_user
    context 'with valid attributes' do 
      it 'saves new answer in the database' do
        expect do 
          post :create, 
                answer: attributes_for(:answer),
                question_id: question 
        end.to change(question.answers, :count).by(1)
        # change(Answer, :count)
        # change { question.answers.count }
      end

      it 'checks that the Answer belongs to the User' do
        expect do 
           post :create, 
                answer: attributes_for(:answer),
                question_id: question 
        end.to change(@user.answers, :count).by(1)
      end

      it 'redirect to #show Question' do
        post :create, answer: attributes_for(:answer), question_id: question
        expect(response).to redirect_to question_path(question)
        # expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect do 
          post :create, 
                answer: attributes_for(:invalid_answer), 
                question_id: question 
        end.to_not change(Answer, :count)
      end

      it 'redirect to #show Question' do
        post :create, answer: attributes_for(:invalid_answer), question_id: question
        expect(response).to redirect_to question_path(question)
      end
    end
  end

  describe 'DELETE #destroy' do
    login_user
    before { @answer = create :answer, question: question, user: @user }

    it 'delete answer' do
      expect { delete :destroy, id: @answer, question_id: question }.to change(Answer, :count).by(-1)
    end

    it 'redirect to #show Question' do
      delete :destroy, id: @answer, question_id: question 
      expect(response).to redirect_to question_path(question)
    end
  end
end

