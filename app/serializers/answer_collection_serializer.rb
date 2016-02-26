class AnswerCollectionSerializer < ActiveModel::Serializer
  attributes :id, :body, :best, :created_at, :updated_at 
end