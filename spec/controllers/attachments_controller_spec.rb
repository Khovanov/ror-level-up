require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create :user }
  let(:another_user) { create :user }
  let(:question) { create :question, user: user }
  let(:answer) { create :answer, question: question, user: user }

  describe 'DELETE #destroy' do
    context 'with questions' do
      let(:attachment) { create :attachment, attachable: question }
      let(:destroy_attachment) { delete :destroy, id: attachment, format: :js }

      before { attachment }

      it 'unauthenticated user' do
        expect { destroy_attachment }.to_not change(Attachment, :count)
      end

      it 'user`s attachment' do
        login user
        expect { destroy_attachment }.to change(Attachment, :count).by(-1)
      end

      it 'render template' do
        login user
        destroy_attachment
        expect(response).to render_template :destroy
      end

      it 'attachment another user`s' do
        login another_user
        expect { destroy_attachment }.to_not change(Attachment, :count)
      end
    end

    context 'with answers' do
      let(:attachment) { create :attachment, attachable: answer }
      let(:destroy_attachment) { delete :destroy, id: attachment, format: :js }

      before { attachment }

      it 'unauthenticated user' do
        expect { destroy_attachment }.to_not change(Attachment, :count)
      end

      it 'user`s attachment' do
        login user
        expect { destroy_attachment }.to change(Attachment, :count).by(-1)
      end

      it 'render template' do
        login user
        destroy_attachment
        expect(response).to render_template :destroy
      end

      it 'attachment another user`s' do
        login another_user
        expect { destroy_attachment }.to_not change(Attachment, :count)
      end
    end
  end
end
