require 'rails_helper'

describe 'Answers API' do
  let(:question) { create(:question) }
  let(:answers_url) { "/api/v1/questions/#{question.id}/answers/" }  
  
  describe 'GET /index' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get answers_url, format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get answers_url, format: :json, access_token: '1234'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:answers) { create_list(:answer, 2, question: question) }
      let(:answer) { answers.first }

      before { get answers_url, format: :json, access_token: access_token.token }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      it 'returns list of answers' do
        expect(response.body).to have_json_size(2).at_path("answers")
      end

      %w(id body best created_at updated_at).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answers/0/#{attr}")
        end
      end
    end
  end

  describe 'GET /show' do
    let(:answer) { create(:answer, question: question) }
    let(:answer_url) { "/api/v1/questions/#{question.id}/answers/#{answer.id}" }
    let!(:comment) { create(:comment_answer, commentable: answer) }
    let!(:attachment) { create(:attachment, :to_answer, attachable: answer) }

    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get answer_url, format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get answer_url, format: :json, access_token: '1234'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      before { get answer_url, format: :json, access_token: access_token.token }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      it 'contains answer' do
        answer_serializer = AnswerSerializer.new(answer)
        expect(response.body).to be_json_eql(answer_serializer.to_json)
      end

      context 'comments' do
        it 'included in answer object' do
          expect(response.body).to have_json_size(1).at_path("answer/comments")
        end

        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("answer/comments/0/#{attr}")
          end
        end
      end

      context 'attachments' do
        it 'included in answer object' do
          expect(response.body).to have_json_size(1).at_path("answer/attachments")
        end

        %w(id url created_at updated_at).each do |attr|
          it "contains #{attr}" do
            attachment_serializer = AttachmentSerializer.new(attachment)           
            expect(response.body).to be_json_eql(attachment_serializer.send(attr.to_sym).to_json).at_path("answer/attachments/0/#{attr}")
          end
        end
      end
    end
  end
end