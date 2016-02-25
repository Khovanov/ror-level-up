require 'rails_helper'

describe 'Questions API' do
  describe 'GET /index' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/questions', format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get '/api/v1/questions', format: :json, access_token: '1234'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      # let!(:answer) { create(:answer, question: question) }

      before { get '/api/v1/questions', format: :json, access_token: access_token.token }

      it 'returns 200 status code' do
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
  end

  describe 'GET /show' do
    let(:question) { create(:question) }
    let!(:comment) { create(:comment_question, commentable: question) }
    let!(:attachment) { create(:attachment, attachable: question) }
    let(:question_url) { "/api/v1/questions/#{question.id}" }

    context 'unauthorized' do

      it 'returns 401 status if there is no access_token' do
        get question_url, format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get question_url, format: :json, access_token: '1234'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      before { get question_url, format: :json, access_token: access_token.token }

      it 'returns 200 status code' do
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
  end
end