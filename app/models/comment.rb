class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :commentable, polymorphic: true, touch: true

  validates :body, :user_id, presence: true
  default_scope -> { order(created_at: :asc) }
end
