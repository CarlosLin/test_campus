class Favorite < ActiveRecord::Base
  belongs_to :favoritable, :polymorphic => true
  belongs_to :user, inverse_of: :favorites
  scope :posts, -> { where(favoritable_type: 'Post')}
  validates :user_id, uniqueness: {
    scope: [:favoritable_id, :favoritable_type],
    message: 'Only favorite an item once'
  }
end