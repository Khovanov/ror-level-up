require 'rails_helper'

describe 'Questions API' do
  describe 'GET /index' do
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      before { do_request access_token: access_token.token }

      it 'returns 201 status code' do
        expect(response).to be_success
      end

      it 'returns list of questions' do
        expect(response.body).to have_json_size(2).at_path("questions")
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("questions/0/#{attr}")
        end
      end

      it 'question object contains short_title' do
        expect(response.body).to be_json_eql(question.title.truncate(10).to_json).at_path("questions/0/short_title")
      end
    end
    def do_request(options = {})
      get '/api/v1/questions', { format: :json }.merge(options)
    end
  end

  describe 'GET /show' do
    let(:question) { create(:question) }
    let!(:comment) { create(:comment_question, commentable: question) }
    let!(:attachment) { create(:attachment, attachable: question) }

    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      before { do_request access_token: access_token.token }

      it 'returns 201 status code' do
        expect(response).to be_success
      end

      it 'contains question' do
        # https://github.com/rails-api/active_model_serializers/blob/master/docs/howto/outside_controller_use.md#serializing-a-resource
        # question_serializer = QuestionSerializer.new(question, adapter: :json)
        question_serializer = QuestionSerializer.new(question)
        expect(response.body).to be_json_eql(question_serializer.to_json)
      end

      context 'comments' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path("question/comments")
        end

        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("question/comments/0/#{attr}")
          end
        end
      end

      context 'attachments' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path("question/attachments")
        end

        %w(id url created_at updated_at).each do |attr|
          it "contains #{attr}" do
            attachment_serializer = AttachmentSerializer.new(attachment)           
            expect(response.body).to be_json_eql(attachment_serializer.send(attr.to_sym).to_json).at_path("question/attachments/0/#{attr}")
          end
        end
      end
    end
    def do_request(options = {})
      get "/api/v1/questions/#{question.id}", { format: :json }.merge(options)
    end
  end

  describe 'POST /create' do
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:user) { create :user }
      let(:access_token) { create :access_token, resource_owner_id: user.id }
      let(:create_question) do 
        do_request access_token: access_token.token, 
                   question: attributes_for(:question) 
      end
      let(:create_invalid_question) do 
        do_request access_token: access_token.token, 
                   question: attributes_for(:invalid_question) 
      end

      it 'returns 201 status code' do
        create_question
        expect(response).to be_success
      end

      it 'saves new question' do
        expect { create_question }.to change(Question, :count).by(1)
      end

      it 'belongs to the user' do
        expect { create_question }.to change(user.questions, :count).by(1)
      end

      context 'with invalid attributes' do
        it 'does not save the question' do
          expect { create_invalid_question }.to_not change(Question, :count)
        end

        it 'returns unprocessable entity status' do
          create_invalid_question
          expect(response.status).to eql 422
        end
      end
    end
    def do_request(options = {})
      post '/api/v1/questions', { format: :json }.merge(options)
    end
  end
end
