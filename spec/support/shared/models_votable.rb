shared_examples_for "Models votable" do |object|
  describe "voting for #{object}" do
    let(:user) { create :user }
    let!(:votable) { create object.to_s.underscore.to_sym }

    it 'vote up' do
      votable.vote_up(user)
      expect(votable.votes.rating).to eq 1
    end

    it 'vote down' do
      votable.vote_down(user)
      expect(votable.votes.rating).to eq -1
    end

    it 'vote cancel' do
      votable.vote_up(user)
      votable.vote_cancel(user)
      expect(votable.votes.rating).to eq 0
    end

    it 'can`t double vote' do
      votable.vote_up(user)
      votable.vote_up(user)
      expect(votable.votes.rating).to eq 1
    end
  end
end
