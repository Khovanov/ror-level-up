ThinkingSphinx::Index.define :user, with: :active_record do
  #fileds
  indexes email, as: :author, sortable: true

  # attributes
  has id, as: :user_id 
  has created_at, updated_at
end