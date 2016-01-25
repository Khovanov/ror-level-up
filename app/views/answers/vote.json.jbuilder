json.count @answer.votes.count
json.rating @answer.votes.rating
json.present @answer.voted(current_user).present?