json.count @votable.votes.count
json.rating @votable.votes.rating
json.present @votable.voted(current_user).present?