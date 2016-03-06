ThinkingSphinx::Index.define :comment, with: :active_record do
  #fileds
  indexes body
  indexes user.email, as: :author, sortable: true
  
  # attributes
  has user_id, created_at, updated_at
end