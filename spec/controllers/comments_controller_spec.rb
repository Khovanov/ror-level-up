require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create :user }
  let(:question) { create :question }
  let(:answer) { create :answer, question: question }

  describe 'POST #create' do
    context 'with questions' do
      let(:create_comment) do
        post :create,
             comment: attributes_for(:comment_question),
             # commentable: question,
             commentable: 'questions', question_id: question,
             format: :json
      end
      let(:create_invalid_comment) do
        post :create,
             comment: attributes_for(:comment_question, :with_invalid_attr),
             # commentable: question,
             commentable: 'questions', question_id: question,
             format: :json
      end

      it 'unauthenticated user' do
        expect { create_comment }.to_not change(Comment, :count)
      end

      it 'valid attributes' do
        login user
        expect { create_comment }.to change(question.comments, :count).by(1)
      end

      it 'invalid attributes' do
        login user
        expect { create_invalid_comment }.to_not change(Comment, :count)
      end

      it 'respond with content type json' do
        login user
        create_comment
        # expect(response.content_type).to eq "text/html"
        expect(response.content_type).to eq "application/json"
      end

      it 'returns a 200 OK status' do
        login user
        create_comment
        # expect(response.status).to eq(200)
        # expect(response).to have_http_status(200)
        # expect(response).to have_http_status(:ok)
        expect(response).to have_http_status(:success)
      end

      it 'render template' do
        login user
        create_comment
        expect(response).to render_template :create
      end
    end
    context 'with answers' do
      let(:create_comment) do
        post :create,
             comment: attributes_for(:comment_answer),
             # commentable: answer,
             commentable: 'answers', 
             question_id: question,
             answer_id: answer,
             format: :json
      end
      let(:create_invalid_comment) do
        post :create,
             comment: attributes_for(:comment_answer, :with_invalid_attr),
             # commentable: answer,
             commentable: 'answers', 
             question_id: question,
             answer_id: answer,
             format: :json
      end

      it 'unauthenticated user' do
        expect { create_comment }.to_not change(Comment, :count)
      end

      it 'valid attributes' do
        login user
        expect { create_comment }.to change(answer.comments, :count).by(1)
      end

      it 'invalid attributes' do
        login user
        expect { create_invalid_comment }.to_not change(Comment, :count)
      end

      it 'respond with content type json' do
        login user
        create_comment
        # expect(response.content_type).to eq "text/html"
        expect(response.content_type).to eq "application/json"
      end

      it 'returns a 200 OK status' do
        login user
        create_comment
        # expect(response.status).to eq(200)
        # expect(response).to have_http_status(200)
        # expect(response).to have_http_status(:ok)
        expect(response).to have_http_status(:success)
      end

      it 'render template' do
        login user
        create_comment
        expect(response).to render_template :create
      end
    end    
  end
end
