require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do

  let(:user) { create :user }
  let(:question) { create :question, user: user }
  let(:question_another_user) { create :question }
  let(:answer) { create :answer, question: question, user: user }
  let(:answer_another_user) { create(:answer, question: question)  }
  # let(:answer_another_question) { create(:answer, question: question_another_user)  }

  let(:attachment_to_question) do 
    create :attachment, 
            attachable: question, 
            file: Rack::Test::UploadedFile.new(File.join(Rails.root, '/spec/spec_helper.rb'))
  end

  let(:attachment_to_question_another_user) do 
    create :attachment, 
            attachable: question_another_user, 
            file: Rack::Test::UploadedFile.new(File.join(Rails.root, '/spec/spec_helper.rb'))
  end

  let(:attachment_to_answer) do 
    create :attachment, 
            attachable: answer, 
            file: Rack::Test::UploadedFile.new(File.join(Rails.root, '/spec/spec_helper.rb'))
  end

  let(:attachment_to_answer_another_user) do 
    create :attachment, 
            attachable: answer_another_user, 
            file: Rack::Test::UploadedFile.new(File.join(Rails.root, '/spec/spec_helper.rb'))
  end

  describe 'DELETE #destroy' do
    let(:delete_destroy_attachment_q) do
      delete :destroy, 
              id: attachment_to_question,
              format: :js  
    end
    let(:delete_destroy_attachment_a) do
      delete :destroy, 
              id: attachment_to_answer,
              format: :js  
    end

    before do 
      attachment_to_answer
      attachment_to_answer_another_user
      attachment_to_question
      attachment_to_question_another_user
    end
    
    context 'when user unauthenticated' do
      it 'does not delete attachment' do
        expect { delete_destroy_attachment_q }.to_not change(Attachment, :count)
        expect { delete_destroy_attachment_a }.to_not change(Attachment, :count)
      end
    end

    context 'when user try delete his attachment' do 
      login_user
      it 'delete attachment' do
        expect { delete_destroy_attachment_q }.to change(Attachment, :count).by(-1)
        expect { delete_destroy_attachment_a }.to change(Attachment, :count).by(-1)
      end

      it 'render destroy template' do
        delete_destroy_attachment_a
        expect(response).to render_template :destroy

        delete_destroy_attachment_q
        expect(response).to render_template :destroy
      end
    end

    context 'when user try delete attachment another user' do
      login_user

      it 'does not delete attachment' do
        expect do
          delete :destroy, 
                  id: attachment_to_question_another_user,
                  format: :js  
        end.to_not change(Attachment, :count)

        expect do
          delete :destroy, 
                  id: attachment_to_answer_another_user,
                  format: :js  
        end.to_not change(Attachment, :count)
      end
    end    
  end
end