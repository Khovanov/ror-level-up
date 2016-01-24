json.count @question.votes.count
json.rating @question.votes.rating
json.present @question.voted(current_user).present?