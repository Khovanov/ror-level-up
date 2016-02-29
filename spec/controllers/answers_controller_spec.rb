require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  # describe AnswersController do
  let(:user) { create :user }
  let(:another_user) { create :user }
  let(:question) { create :question, user: user }
  let(:answer) { create :answer, question: question, user: user }

  it_behaves_like "Controllers votable", Answer 

  describe 'POST #create' do
    let(:subject) do
      post :create,
           answer: attributes_for(:answer),
           question_id: question,
           format: :js
    end
    let(:create_invalid_answer) do
      post :create,
           answer: attributes_for(:invalid_answer),
           question_id: question,
           format: :js
    end

    context 'when user unauthenticated' do
      it 'does not save the answer' do
        expect { subject }.to_not change(Answer, :count)
      end
    end

    context 'with valid attributes' do
      before { login user }

      it 'saves new answer in the database' do
        expect { subject }.to change(question.answers, :count).by(1)
        # change(Answer, :count)
        # change { question.answers.count }
      end

      it 'checks that the answer belongs to the user' do
        expect { subject }.to change(user.answers, :count).by(1)
      end

      it 'render create template' do
        subject
        # expect(response).to redirect_to question_path(question)
        expect(response).to render_template :create
      end

      it_behaves_like "Publishable" do
        let(:channel) { "/questions/#{question.id}/answers" }
      end     
    end

    context 'with invalid attributes' do
      before { login user }
      it 'does not save the answer' do
        expect { create_invalid_answer }.to_not change(Answer, :count)
      end

      it 'render create template' do
        create_invalid_answer
        # expect(response).to redirect_to question_path(question)
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    let(:update_answer_attr) do
      patch :update,
            id: answer,
            question_id: question,
            answer: attributes_for(:answer),
            format: :js
    end
    let(:update_answer_body) do
      patch :update,
            id: answer,
            question_id: question,
            answer: { body: 'updated answer body' },
            format: :js
    end

    context 'when user unauthenticated' do
      it 'not change answer attributes' do
        update_answer_body
        answer.reload
        expect(answer.body).to_not eq 'updated answer body'
      end
    end

    context 'when user try edit his answer' do
      before { login user }

      it 'assigns the requested answer to @answer' do
        update_answer_attr
        expect(assigns(:answer)).to eq answer
      end

      it 'assigns the question' do
        update_answer_attr
        expect(assigns(:question)).to eq question
      end

      it 'change answer attributes' do
        update_answer_body
        answer.reload
        expect(answer.body).to eq 'updated answer body'
      end

      it 'render to the updated answer' do
        update_answer_attr
        expect(response).to render_template :update
      end
    end

    context 'when user try edit answer another user' do
      before do
        login another_user
        update_answer_body
      end

      it 'not change answer attributes' do
        answer.reload
        expect(answer.body).to_not eq 'updated answer body'
      end
    end

    context 'with invalid attributes' do
      before { login user }
      before do
        patch :update,
              id: answer,
              question_id: question,
              answer: { body: nil },
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

  describe 'PATCH #best' do
    let(:best_answer) do
      patch :best,
            id: answer,
            question_id: question,
            format: :js
    end

    context 'when user unauthenticated' do
      it 'not set best answer' do
        expect do
          best_answer
          answer.reload
        end.to_not change(answer, :best)
      end
    end

    context 'when author question try set best answer' do
      before do
        login user
        best_answer
      end

      it 'set best answer' do
        answer.reload
        expect(answer.best?).to eq true
      end

      it 'render template best answer' do
        expect(response).to render_template :best
      end
    end

    context 'when non author question try set best answer' do
      before { login another_user }

      it 'not set best answer' do
        expect do
          best_answer
          answer.reload
        end.to_not change(answer, :best)
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:destroy_answer) do
      delete :destroy,
             id: answer,
             question_id: question,
             format: :js
    end
    before { answer }

    context 'when user unauthenticated' do
      it 'does not delete answer' do
        expect { destroy_answer }.to_not change(Answer, :count)
      end
    end

    context 'when user try delete his answer' do
      before { login user }

      it 'delete answer' do
        expect { destroy_answer }.to change(Answer, :count).by(-1)
      end

      it 'render destroy template' do
        destroy_answer
        expect(response).to render_template :destroy
      end
    end

    context 'when user try delete answer another user' do
      before { login another_user }
      it 'does not delete answer' do
        expect { destroy_answer }.to_not change(Answer, :count)
      end
    end
  end
end
