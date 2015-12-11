require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
# describe AnswersController do
  let(:user) { create :user }
  let(:question) { create :question, user: user }
  let(:question_another_user) { create :question }
  let(:answer) { create :answer, question: question, user: user }
  let(:answer_another_user) { create(:answer, question: question)  }
  let(:answer_another_question) { create(:answer, question: question_another_user)  }
   
  describe 'POST #create' do
    let(:post_create_answer) do 
      post :create,
            answer: attributes_for(:answer), 
            question_id: question, 
            format: :js  
    end
    let(:post_create_invalid_answer) do 
      post :create, 
            answer: attributes_for(:invalid_answer), 
            question_id: question, 
            format: :js 
    end

    context 'when user unauthenticated' do
      it 'does not save the answer' do
        expect { post_create_answer }.to_not change(Answer, :count)
      end
    end

    context 'with valid attributes' do 
      login_user

      it 'saves new answer in the database' do
        expect { post_create_answer }.to change(question.answers, :count).by(1)
        # change(Answer, :count)
        # change { question.answers.count }
      end

      it 'checks that the answer belongs to the user' do
        expect { post_create_answer }.to change(user.answers, :count).by(1)
      end

      it 'render create template' do
        post_create_answer
        # expect(response).to redirect_to question_path(question)
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      login_user      
      it 'does not save the answer' do
        expect { post_create_invalid_answer }.to_not change(Answer, :count)
      end

      it 'render create template' do
        post_create_invalid_answer 
        # expect(response).to redirect_to question_path(question)
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    let(:patch_update_answer_attr) do
      patch :update, 
            id: answer, 
            question_id: question, 
            answer: attributes_for(:answer), 
            format: :js
    end
    let(:patch_update_answer_body) do
      patch :update, 
            id: answer, 
            question_id: question, 
            answer: { body: 'updated answer body' }, 
            format: :js      
    end

    context 'when user unauthenticated' do
      it 'not change answer attributes' do
        patch_update_answer_body
        answer.reload
        expect(answer.body).to_not eq 'updated answer body'
      end
    end
    
    context 'when user try edit his answer' do 
      login_user
      
      it 'assigns the requested answer to @answer' do
        patch_update_answer_attr 
        expect(assigns(:answer)).to eq answer
      end 

      it 'assigns the question' do
        patch_update_answer_attr 
        expect(assigns(:question)).to eq question
      end 

      it 'change answer attributes' do
        patch_update_answer_body
        answer.reload
        expect(answer.body).to eq 'updated answer body'
      end

      it 'render to the updated answer' do
        patch_update_answer_attr
        expect(response).to render_template :update
      end
    end

    context 'when user try edit answer another user' do
      login_user
      before do
        patch :update, 
              id: answer_another_user, 
              question_id: question, 
              answer: {body: 'updated answer body'}, 
              format: :js
      end

      it 'not change answer attributes' do
        answer_another_user.reload
        expect(answer_another_user.body).to_not eq 'updated answer body'
      end

      it 'redirect to #show question' do
        # expect(response).to redirect_to question_path(question)
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      login_user
      before do
        patch :update, 
              id: answer, 
              question_id: question, 
              answer: {body: nil}, 
              format: :js
      end            
      it 'not change answer attributes' do
        answer.reload
        expect(answer.body).to_not eq nil
      end     

      it 'render updated template' do
        expect(response).to render_template :update
      end
    end
  end

  describe 'PATCH #set_best' do
    let(:patch_set_best_answer) do
      patch :set_best, 
            id: answer, 
            question_id: question, 
            format: :js
    end

    context 'when user unauthenticated' do
      it 'not set best answer' do
        expect do
          patch_set_best_answer
          answer.reload
        end.to_not change(answer, :is_best)
      end
    end
    
    context 'when author question try set best answer' do 
      login_user
      before { patch_set_best_answer }
      
      it 'set best answer' do
        answer.reload
        expect(answer.is_best).to eq true
      end

      it 'render template set_best answer' do
        expect(response).to render_template :set_best
      end
    end

    context 'when non author question try set best answer' do
      login_user
      
      it 'not set best answer' do
        expect do
          patch :set_best, 
                id: answer_another_question, 
                question_id: question_another_user, 
                format: :js
          answer_another_question.reload
        end.to_not change(answer_another_question, :is_best)
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:delete_destroy_answer) do
      delete :destroy, 
              id: answer, 
              question_id: question,
              format: :js
    end
    before {answer; answer_another_user}
    
    context 'when user unauthenticated' do
      it 'does not delete answer' do
        expect { delete_destroy_answer }.to_not change(Answer, :count)
      end
    end

    context 'when user try delete his answer' do 
      login_user
      it 'delete answer' do
        expect { delete_destroy_answer }.to change(Answer, :count).by(-1)
      end

      it 'render destroy template' do
        delete_destroy_answer
        expect(response).to render_template :destroy
      end
    end

    context 'when user try delete answer another user' do
      login_user
      it 'does not delete answer' do
        expect do
          delete :destroy, 
                  id: answer_another_user, 
                  question_id: question,
                  format: :js 
        end.to_not change(Answer, :count)
      end
    end    
  end
end