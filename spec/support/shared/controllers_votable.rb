shared_examples_for "Controllers votable" do |object|

  let(:user) { create :user }
  let(:another_user) { create :user }
  let!(:votable) { create object.to_s.underscore.to_sym, user: user }
  let(:create_vote_up) do 
    create ('vote_up_' + object.to_s.underscore).to_sym, 
           votable: votable, 
           user: another_user  
  end

  let(:vote_up) do
    patch :vote_up, id: votable, format: :json
    votable.reload
  end
  let(:vote_down) do
    patch :vote_down, id: votable, format: :json
    votable.reload
  end
  let(:vote_cancel) do
    # create :vote_up_question, votable: votable, user: another_user
    create_vote_up
    patch :vote_cancel, id: votable, format: :json
    votable.reload
  end   

  describe "Vote for the #{object}" do
    describe 'PATCH #vote_up' do
      context 'when user unauthenticated' do
        it 'can`t vote up' do
          vote_up
          expect(votable.votes.rating).to_not eq 1
        end
      end

      context "author of #{object}" do
        before { login user }
        it 'can`t vote up' do
          vote_up
          expect(votable.votes.rating).to_not eq 1
        end
      end

      context 'when user try vote up' do
        before { login another_user }
        it 'change up rating' do
          vote_up
          expect(votable.votes.rating).to eq 1
        end

        it 'render template vote' do
          vote_up
          expect(response).to render_template :vote
        end
      end
    end

    describe 'PATCH #vote_down' do
      context 'when user unauthenticated' do
        it 'can`t vote down' do
          vote_down
          expect(votable.votes.rating).to_not eq -1
        end
      end

      context "author of #{object}" do
        before { login user }
        it 'can`t vote down' do
          vote_down
          expect(votable.votes.rating).to_not eq -1
        end
      end

      context 'when user try vote down' do
        before { login another_user }
        it 'change down rating' do
          vote_down
          expect(votable.votes.rating).to eq -1
        end

        it 'render template vote' do
          vote_down
          expect(response).to render_template :vote
        end
      end
    end

    describe 'PATCH #vote_cancel' do
      context 'when user unauthenticated' do
        it 'can`t cancel vote' do
          vote_cancel
          expect(votable.votes.rating).to_not eq 0
        end
      end

      context "author of #{object}" do
        before { login user }
        it 'can`t cancel vote' do
          vote_cancel
          expect(votable.votes.rating).to_not eq 0
        end
      end

      context 'when user try cancel' do
        before { login another_user }
        it 'change to 0 rating' do
          vote_cancel
          expect(votable.votes.rating).to eq 0
        end

        it 'render template vote' do
          vote_cancel
          expect(response).to render_template :vote
        end 
      end
    end
  end
end
