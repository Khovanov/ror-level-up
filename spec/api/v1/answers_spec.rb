require 'rails_helper'

describe 'Answers API' do
  let(:question) { create(:question) }
  
  describe 'GET /index' do
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:answers) { create_list(:answer, 2, question: question) }
      let(:answer) { answers.first }
      before { do_request access_token: access_token.token }

      it 'returns 201 status code' do
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
    def do_request(options = {})
      get "/api/v1/questions/#{question.id}/answers/", { format: :json }.merge(options)
    end    
  end

  describe 'GET /show' do
    let(:answer) { create(:answer, question: question) }
    let!(:comment) { create(:comment_answer, commentable: answer) }
    let!(:attachment) { create(:attachment, :to_answer, attachable: answer) }

    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      before { do_request access_token: access_token.token }

      it 'returns 201 status code' do
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
    def do_request(options = {})
      get "/api/v1/questions/#{question.id}/answers/#{answer.id}", { format: :json }.merge(options)
    end 
  end

  describe 'POST /create' do
    it_behaves_like "API Authenticable" 

    context 'authorized' do
      let(:user) { create :user }
      let(:access_token) { create :access_token, resource_owner_id: user.id }
      let(:create_answer) do 
        do_request access_token: access_token.token,
                   answer: attributes_for(:answer)
      end
      let(:create_invalid_answer) do 
        do_request access_token: access_token.token,
                   answer: attributes_for(:invalid_answer) 
      end

      it 'returns 201 status code' do
        create_answer
        expect(response).to be_success
      end

      it 'saves new answer' do
        expect { create_answer }.to change(question.answers, :count).by(1)
      end

      it 'belongs to the user' do
        expect { create_answer }.to change(user.answers, :count).by(1)
      end

      context 'with invalid attributes' do
        it 'does not save the answer' do
          expect { create_invalid_answer }.to_not change(Answer, :count)
        end

        it 'returns unprocessable entity status' do
          create_invalid_answer
          expect(response.status).to eql 422
        end
      end
    end
    def do_request(options = {})
      post "/api/v1/questions/#{question.id}/answers/", { format: :json }.merge(options)
    end   
  end
end